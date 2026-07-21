Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7703546D2A4;
	Tue, 21 Jul 2026 17:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654800; cv=none; b=WYzP/7KfEIaZqeTglPM+gDqG3xacI+T+Ep+SdKzc0TWRVo/4N7v9i1IvpyP0SrlAUMVK7lUD6fjfAGEI2f4DmceXBUHPtdFLzctLuPwgMVq1Y5oz44HnrWdlDtWzKC/NNAl9r0Nb/UskNwmET3D50nS7O6j2VzqsHYh7Fm3EX+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654800; c=relaxed/simple;
	bh=HgqKKrJthBDvwPOs2mjYKZu0xtJF02ujBOiBhzDgzBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XiVlxHhtah8uEn2b0ZiphYrwecbR2ww2exyw1UkYxqgh1O712Waq5SUFYQwEtYX4SUA45vkFaP4pZWYkbFl7f6uz2NwofFn3hczhjZ5onDO6gp5qCVj9GUgeXpg0j5XBByVZnTyDjDLrtiu4wjMsqDcDswi0OYdDe9nio9SOVKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s7kPTDnS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s7kPTDnS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE4B01F000E9;
	Tue, 21 Jul 2026 17:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654799;
	bh=4M2u9/IhLAD5D2Y37looEVLyL44smv518x9xwiR8P0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s7kPTDnSRKIYe5yhz3BE+kW8XILT3MDtPAMZ1ws3/loWBjbs13PynFX1GJBMsoBJ0
	 B86FdX0qsuvADoRyXIeECyP/SgOHolTpYoKBVLD1JdBhlWIxBBnNUeEkBr5RxGvHDp
	 LS4VRFjTFZR3GiXpZ8chXtAsMd2MeYAyWl/tqbnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Waychison <mike@waychison.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.1 1840/2077] block: fix race in blk_time_get_ns() returning 0
Date: Tue, 21 Jul 2026 17:25:13 +0200
Message-ID: <20260721152636.137587988@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Waychison <mike@waychison.com>

commit 691b052139c94ee6640ac39e0b764dd3867897c0 upstream.

blk_time_get_ns() populates the per-plug cached timestamp and then
returns it by re-reading the field:

	if (!plug->cur_ktime) {
		plug->cur_ktime = ktime_get_ns();
		current->flags |= PF_BLOCK_TS;
	}
	return plug->cur_ktime;

This is problematic when the compiler emits the final
"return plug->cur_ktime" as a reload from memory, after PF_BLOCK_TS has
already been set.

Since the cached timestamp is now invalidated from finish_task_switch()
(fad156c2af22 "block: invalidate cached plug timestamp after task
switch"), a task preempted between setting PF_BLOCK_TS and that reload
has plug->cur_ktime zeroed by blk_plug_invalidate_ts() when it is
scheduled back in.  The reload then returns 0.

A 0 handed back here is stored as a start timestamp -- e.g.
blk_account_io_start() writes it to rq->start_time_ns -- and later
subtracted from "now".  blk_account_io_done() then adds (now - 0), i.e.
roughly the system uptime, to the per-group nsecs[] counters.  On an
otherwise idle, healthy device this appears as sudden ~uptime-sized jumps
in the diskstats time fields (write_ticks/discard_ticks/time_in_queue).

The solution is to be explicit in our reads and writes to this field
that is preemption volatile.  We also add a barrier() to ensure that any
setting of PF_BLOCK_TS is ordered to happen after the cur_ktime update.

This issue was discovered using AI-assisted kprobes looking for paths
that were leaking zeroed timestamps in a live system, based on the
observation that we were sometimes seeing uptime-sized jumps in kernel
exported counters. This was flagged by NodeDiskIOSaturation
prometheus alerts that started firing on all hosts post 7.1.3 kernel
upgrade, due to node-exporter now exporting a nonsensical
node_disk_io_time_weighted_seconds_total.

Fixes: fad156c2af22 ("block: invalidate cached plug timestamp after task switch")
Cc: stable@vger.kernel.org
Signed-off-by: Mike Waychison <mike@waychison.com>
Assisted-by: Claude:claude-opus-4.8
Link: https://patch.msgid.link/20260715192950.2488921-1-mike@waychison.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk.h |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/block/blk.h
+++ b/block/blk.h
@@ -689,6 +689,7 @@ static inline int req_ref_read(struct re
 static inline u64 blk_time_get_ns(void)
 {
 	struct blk_plug *plug = current->plug;
+	u64 now;
 
 	if (!plug || !in_task())
 		return ktime_get_ns();
@@ -697,12 +698,18 @@ static inline u64 blk_time_get_ns(void)
 	 * 0 could very well be a valid time, but rather than flag "this is
 	 * a valid timestamp" separately, just accept that we'll do an extra
 	 * ktime_get_ns() if we just happen to get 0 as the current time.
+	 *
+	 * cur_ktime can be zeroed by pre-emption the moment PF_BLOCK_TS is set.
 	 */
-	if (!plug->cur_ktime) {
-		plug->cur_ktime = ktime_get_ns();
+	now = READ_ONCE(plug->cur_ktime);
+	if (!now) {
+		now = ktime_get_ns();
+		WRITE_ONCE(plug->cur_ktime, now);
+		/* Ensure PF_BLOCK_TS is set after cur_ktime. */
+		barrier();
 		current->flags |= PF_BLOCK_TS;
 	}
-	return plug->cur_ktime;
+	return now;
 }
 
 static inline ktime_t blk_time_get(void)


