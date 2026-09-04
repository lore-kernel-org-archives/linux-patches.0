Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA594078C0;
	Fri,  4 Sep 2026 05:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499433; cv=none; b=JaPsZa/eJSz1Op6ZZCW4PTJdR6k1ROX3lPsGjUrrq2KIvDajr/eSmCM8soMU0LoDVOo5gskypFY5eHKtpEDeWkWxg6Rs5uJCfg4YO8MxsdHWj/U07KK5jXpE6nyhAZ9gUqXXNapu34mNJXhU/OIUZBzCLFMZtutADn/1yJMupVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499433; c=relaxed/simple;
	bh=Vl/FHaYr+enAnJRYHmGgIvFoSboC7tKoYyIxjzGzcpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CMdFfxaZ6WNT5+k3B8oS7CUiN1PLJFDqyvemQJDr380teeMnyF0uTsgN0NVrgjzzG0QnM6x+bM/8ZIhO3HiC19GCEYmGpqQsXmgMhvN5o/2pqa/siuSGKASY209MtFVu9qzBed5n4SsqNqdgD7CR3VXTo5hpbEiMIim1Ty1Idp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ksulceve; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ksulceve"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 673E01F00A3D;
	Fri,  4 Sep 2026 05:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499431;
	bh=BOCnLZ3YWR0gl9Az6PYD/rhVw7vD3KO/7Cowwo8LvBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KsulceveU2crHROJpK1RkfFmGyVR4nqfKZ53Bw+OKIpkQWHMs6du6UJZDFy6qwnKw
	 tnFlWKMDE0AiK9XifuwnObX5lbExt0KWQ3ZYqPPVEmCOWrZ4ahiTRdyvGtJ1jEi6xl
	 VL7rXS8PKN1E3bbWnS3xZqkwmIjr2wjUe35lhECU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 7.2 416/713] sched_ext: Dont BUG_ON a destroyed DSQ in process_deferred_reenq_users
Date: Fri,  4 Sep 2026 06:56:24 +0200
Message-ID: <20260904045813.155423787@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tao Cui <cuitao@kylinos.cn>

commit 8d8dd8ae89eaa78b37fc85528e926029f5facbdf upstream.

scx_bpf_dsq_reenq() queues a deferred reenq (dru) that runs from
run_deferred(), not ops.dispatch(). If the DSQ is destroyed before the dru
runs, process_deferred_reenq_users() sees dsq->id == SCX_DSQ_INVALID and
hits the BUG_ON. destroy_dsq() doesn't flush pending drus, so just skip.

tj: Read dsq->id once with READ_ONCE(). Reading it separately in the INVALID
    check and the BUG_ON would leave a window where destroy_dsq() can
    invalidate the id between the two reads and still trigger the BUG_ON.

Fixes: 84b1a0ea0b7c ("sched_ext: Implement scx_bpf_dsq_reenq() for user DSQs")
Cc: stable@vger.kernel.org # v7.1+
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext/ext.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -4431,7 +4431,7 @@ static void process_deferred_reenq_users
 
 	while (true) {
 		struct scx_dispatch_q *dsq;
-		u64 reenq_flags;
+		u64 dsq_id, reenq_flags;
 
 		scoped_guard (raw_spinlock, &rq->scx.deferred_reenq_lock) {
 			struct scx_deferred_reenq_user *dru =
@@ -4454,7 +4454,12 @@ static void process_deferred_reenq_users
 		/* see schedule_dsq_reenq() */
 		smp_mb();
 
-		BUG_ON(dsq->id & SCX_DSQ_FLAG_BUILTIN);
+		/* destroy_dsq() may have raced and invalidated @dsq, nothing to reenq */
+		dsq_id = READ_ONCE(dsq->id);
+		if (unlikely(dsq_id == SCX_DSQ_INVALID))
+			continue;
+
+		BUG_ON(dsq_id & SCX_DSQ_FLAG_BUILTIN);
 		reenq_user(rq, dsq, reenq_flags);
 	}
 }


