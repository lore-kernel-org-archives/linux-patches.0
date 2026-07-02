Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB251C695;
	Thu,  2 Jul 2026 16:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011358; cv=none; b=GIMIxrJSbYL9mqGDNeFYV9hR4uJFV/INuPDaxCTmQhgtEVxxf9G/x2y1L/CYeEoccjTtLsAeYkpvQcY1CKZyTXqtJDwVzwcTiJGuPfBoGy5ucZHH6vBkzS8sPzRxhc77OhbzfQdD+qonCnZ9Fr+o5yU+2p0EKTv5WM5KlYwKSb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011358; c=relaxed/simple;
	bh=PX21BupwuebTTbRrNoLrjHK7CJccT56U8H7BzJTV8DU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a3WURtV8mLGCLpnaT62lTcCaF6MUYA7KlE9zN3BO4oDCkQdsPf8wh9oGgUxbrWfAU4xQAMSvJfga4XLRPb7z9KHePVAlzcHwjsWIPPWdMmG2+SW+UElv/Ek5H+Mk6YXOaOTxpth5jxl2SITbMLWrEpbXaf+7RQgj2REQpq/297U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mroWlKUa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mroWlKUa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D0741F000E9;
	Thu,  2 Jul 2026 16:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011357;
	bh=PDei/COzb45h5sClDzU5gZsPWtKGDWhbCqO4H6mKSF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mroWlKUac19Jjyuf/foeoqhi2RGWXK9KPi4sartPL+dCzuJF3SRX4UKVR/KHvlRMs
	 maPYxA+4sLSS/rN7pzkFRPFCuQRek+kKLYyttXnUaqy6TWlsUQlCBJ+0tjTXd9Ab/g
	 00dz5JjnuDs+eB0iGj/b9IchEJSo2jM+zZR/jKvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Shin <jaeshin@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Waiman Long <longman@redhat.com>,
	coregee2000@gmail.com,
	Ming Lei <ming.lei@redhat.com>,
	"Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 077/108] blk-cgroup: fix UAF in __blkcg_rstat_flush()
Date: Thu,  2 Jul 2026 18:21:14 +0200
Message-ID: <20260702155113.708347927@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.110058792@linuxfoundation.org>
References: <20260702155112.110058792@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Koutný <mkoutny@suse.com>

commit 0ab5ee5a1badb58cbb2242617cb01a4972b1f2a2 upstream.

When multiple blkgs in the same blkcg are released concurrently,
a use-after-free can occur. The race happens when one blkg's
__blkcg_rstat_flush() removes another blkg's iostat entries via
llist_del_all(). The second blkg sees an empty list and proceeds
to free itself while the first is still iterating over its entries.

Move the flush from __blkg_release() (RCU callback) to blkg_release()
(before call_rcu). This ensures the RCU grace period waits for any
concurrent flush's rcu_read_lock() section to complete before freeing.

Cc: stable@vger.kernel.org
Cc: Jay Shin <jaeshin@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Fixes: 20cb1c2fb756 ("blk-cgroup: Flush stats before releasing blkcg_gq")
Reported-by: coregee2000@gmail.com
Closes: https://lore.kernel.org/linux-block/CAHPqNmwT9oRpem3J3erS_W0uSQND47LGGSBsNxP8E6uSUish1w@mail.gmail.com/
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Tested-by: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
Link: https://patch.msgid.link/20260205155425.342084-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-cgroup.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -164,20 +164,10 @@ static void blkg_free(struct blkcg_gq *b
 static void __blkg_release(struct rcu_head *rcu)
 {
 	struct blkcg_gq *blkg = container_of(rcu, struct blkcg_gq, rcu_head);
-	struct blkcg *blkcg = blkg->blkcg;
-	int cpu;
 
 #ifdef CONFIG_BLK_CGROUP_PUNT_BIO
 	WARN_ON(!bio_list_empty(&blkg->async_bios));
 #endif
-	/*
-	 * Flush all the non-empty percpu lockless lists before releasing
-	 * us, given these stat belongs to us.
-	 *
-	 * blkg_stat_lock is for serializing blkg stat update
-	 */
-	for_each_possible_cpu(cpu)
-		__blkcg_rstat_flush(blkcg, cpu);
 
 	/* release the blkcg and parent blkg refs this blkg has been holding */
 	css_put(&blkg->blkcg->css);
@@ -195,6 +185,17 @@ static void __blkg_release(struct rcu_he
 static void blkg_release(struct percpu_ref *ref)
 {
 	struct blkcg_gq *blkg = container_of(ref, struct blkcg_gq, refcnt);
+	struct blkcg *blkcg = blkg->blkcg;
+	int cpu;
+
+	/*
+	 * Flush all the non-empty percpu lockless lists before releasing
+	 * us, given these stat belongs to us.
+	 *
+	 * blkg_stat_lock is for serializing blkg stat update
+	 */
+	for_each_possible_cpu(cpu)
+		__blkcg_rstat_flush(blkcg, cpu);
 
 	call_rcu(&blkg->rcu_head, __blkg_release);
 }


