Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56D815E8B;
	Mon, 30 Dec 2024 15:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573966; cv=none; b=G7pXbg1SOIoIn0uEiFDyp1K0S0zKxOuyqwgY/HnEA5qxjRzpenrd+JE1/EihoRcJ62siIFz/UaaKBIz+fc9Qw2px6Y/dLRUwKJg41vAuIszSfD1VhSEIIGaC3V+ewK13v+RCX8Jl+lSVyokH5d66Ji9xC79NyZyv5TcyFBe0fUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573966; c=relaxed/simple;
	bh=MF9tPtawN0xvA5BfJhNoBZp95SwW6TVb2L7hVcaFGhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fPTwMZh6f9tf5B1qtzWgF+6epyMae7iFXQTCQ4WSEtQJBQS184xJK2ucy4uOiEk4OMBCh3+jh0G4SJZOFRa2Q7JySP06n7MYL1JBhoec35PWRedl2VNUBdOjWVhLlAkCpiDrPGeLAm2XmIN85vFvsgu43hYf8k6/zxZaL+zoJkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CTgAwBAk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CTgAwBAk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56924C4CED0;
	Mon, 30 Dec 2024 15:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573965;
	bh=MF9tPtawN0xvA5BfJhNoBZp95SwW6TVb2L7hVcaFGhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CTgAwBAkME+5D47LX1TVtUN8q4xESuZyl7ugU3kFHjvJGmf6zJ1lljJk7Lls2htWk
	 t+SxgSYOjC2Tkh7X1s80lZhfy+mBEcUWlZn3djnT3oXtJhH9bPA2QUWbBPj4UDtlIA
	 8bgV5TjkOvRW84TBTIaK7OiBt1abOhYt2ItwKYFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 86/86] block: avoid to reuse `hctx` not removed from cpuhp callback list
Date: Mon, 30 Dec 2024 16:43:34 +0100
Message-ID: <20241230154214.975982013@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

commit 85672ca9ceeaa1dcf2777a7048af5f4aee3fd02b upstream.

If the 'hctx' isn't removed from cpuhp callback list, we can't reuse it,
otherwise use-after-free may be triggered.

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202412172217.b906db7c-lkp@intel.com
Tested-by: kernel test robot <oliver.sang@intel.com>
Fixes: 22465bbac53c ("blk-mq: move cpuhp callback registering out of q->sysfs_lock")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20241218101617.3275704-3-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-mq.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4278,6 +4278,15 @@ struct gendisk *blk_mq_alloc_disk_for_qu
 }
 EXPORT_SYMBOL(blk_mq_alloc_disk_for_queue);
 
+/*
+ * Only hctx removed from cpuhp list can be reused
+ */
+static bool blk_mq_hctx_is_reusable(struct blk_mq_hw_ctx *hctx)
+{
+	return hlist_unhashed(&hctx->cpuhp_online) &&
+		hlist_unhashed(&hctx->cpuhp_dead);
+}
+
 static struct blk_mq_hw_ctx *blk_mq_alloc_and_init_hctx(
 		struct blk_mq_tag_set *set, struct request_queue *q,
 		int hctx_idx, int node)
@@ -4287,7 +4296,7 @@ static struct blk_mq_hw_ctx *blk_mq_allo
 	/* reuse dead hctx first */
 	spin_lock(&q->unused_hctx_lock);
 	list_for_each_entry(tmp, &q->unused_hctx_list, hctx_list) {
-		if (tmp->numa_node == node) {
+		if (tmp->numa_node == node && blk_mq_hctx_is_reusable(tmp)) {
 			hctx = tmp;
 			break;
 		}


