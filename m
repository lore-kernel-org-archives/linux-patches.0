Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2B430499A;
	Thu,  2 Jul 2026 17:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011660; cv=none; b=r/fHKJPEDjnQ4s3dZDW5yiF4sMXMez30xFkoGhZQnvDAgBphue7eV+QKN4/URMMha/qWWZrgUWSftY+KHA5SqXPPfNBGhst9YA68D4dINFS1W9s2/Gq5SqSa3zF5YcIg1ksaNgR4qtUk6yVvBdWeXfdTLtKzWBxwSKPbIf+38HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011660; c=relaxed/simple;
	bh=qvf1wIiCdhHZAZAzwbhBVqFxu8wHl9jYiaJp2QZSm8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VcCPqkhGoxCfvrQpYt/KoRVQ2+hYEemOEeznIs38uXQ7tvUxCVk7iLQlWHKlFeNvSA5yyUaml5lI4RS7b7oTpj/wLMs+ewa2kA6F8uh2RtZZZTHUWNuDFhH3dq32ODb67o174BtKAQOhwYlOapYU5p8N4xMBtbW946OlZD+hPI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r2QSBrFe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r2QSBrFe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92761F000E9;
	Thu,  2 Jul 2026 17:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011659;
	bh=T9fgoC0wk7o7vkSRGkNlhOKNpRy/vQM8o4Ge6oSQyQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r2QSBrFeVP+D3Ar/OuLSJ8AYlSuPiVlq/IMPw/XEox09+NgKazrZZjgAMrR8v8ZPT
	 spNfQCN8s11BAuxJ0Uw9u3V6Nsa7TcE8JUISdNXFSNctf2BWz7hww1nViPDvLMi8WE
	 BGDdayHWSaaoW+nZ/hfRtk5GutX/kob03xL50NJc=
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
Subject: [PATCH 7.1 083/120] blk-cgroup: fix UAF in __blkcg_rstat_flush()
Date: Thu,  2 Jul 2026 18:21:19 +0200
Message-ID: <20260702155114.678798512@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.964534952@linuxfoundation.org>
References: <20260702155112.964534952@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


