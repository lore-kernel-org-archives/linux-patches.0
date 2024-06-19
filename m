Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976D73C0B;
	Wed, 19 Jun 2024 13:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803833; cv=none; b=EMStdZeHIf3CBIHNoSF6596F0pKOjD/imZkYrMd+Ssx9OwTkU8WGATA8MNPXRg/THgTttYMhSoV1TzkmOow1yYacC+/tCYkeqmSKZp7kUdc8b+lDGT8wGn7R/Sgrpy0IVCajOtUEb8/jOhYMPU6kBLQ85nm22m/Kgk6jXVd1Pco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803833; c=relaxed/simple;
	bh=9NPh+mYbsEmt3G0cXVWEP+fiJgZLmpRkNYeeeLHA6Gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KrBY5XIKvcoYh1rSDKYziNFDal/v0xgBhsuOlxa5Qw7VVVzdPK/Axh2hPrKK7Sr2UKUqHAXvNa488D9EiEGADi2qgAM4/aVJVYDCNm5lcRs2jpUpSAviZmI7YabjcbWp+THGzWMcfqNLtr8xBZCZNtoyAforYNvUCKC9cxkPjYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yCxm5LJE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yCxm5LJE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B42D9C32786;
	Wed, 19 Jun 2024 13:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803831;
	bh=9NPh+mYbsEmt3G0cXVWEP+fiJgZLmpRkNYeeeLHA6Gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yCxm5LJElEUKcBkRECl38iuDfXg9eNscv0eU1slntyP9KQYF4EMeq0rkM+UfVfDAc
	 w8/Tjf8YnJglEoWQhhzZr4HNPDV8HBa6ucwdSh6KZVcoac810X0F8G089sVphkvrlg
	 t761Tzu/U36JoH32F/+FWjJyMtPwpbDLWmLwJrnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shailend Chand <shailend@google.com>,
	Ziwei Xiao <ziweixiao@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Praveen Kaligineedi <pkaligineedi@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 101/217] gve: Clear napi->skb before dev_kfree_skb_any()
Date: Wed, 19 Jun 2024 14:55:44 +0200
Message-ID: <20240619125600.587546845@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ziwei Xiao <ziweixiao@google.com>

commit 6f4d93b78ade0a4c2cafd587f7b429ce95abb02e upstream.

gve_rx_free_skb incorrectly leaves napi->skb referencing an skb after it
is freed with dev_kfree_skb_any(). This can result in a subsequent call
to napi_get_frags returning a dangling pointer.

Fix this by clearing napi->skb before the skb is freed.

Fixes: 9b8dd5e5ea48 ("gve: DQO: Add RX path")
Cc: stable@vger.kernel.org
Reported-by: Shailend Chand <shailend@google.com>
Signed-off-by: Ziwei Xiao <ziweixiao@google.com>
Reviewed-by: Harshitha Ramamurthy <hramamurthy@google.com>
Reviewed-by: Shailend Chand <shailend@google.com>
Reviewed-by: Praveen Kaligineedi <pkaligineedi@google.com>
Link: https://lore.kernel.org/r/20240612001654.923887-1-ziweixiao@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/google/gve/gve_rx_dqo.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/google/gve/gve_rx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
@@ -465,11 +465,13 @@ static void gve_rx_skb_hash(struct sk_bu
 	skb_set_hash(skb, le32_to_cpu(compl_desc->hash), hash_type);
 }
 
-static void gve_rx_free_skb(struct gve_rx_ring *rx)
+static void gve_rx_free_skb(struct napi_struct *napi, struct gve_rx_ring *rx)
 {
 	if (!rx->ctx.skb_head)
 		return;
 
+	if (rx->ctx.skb_head == napi->skb)
+		napi->skb = NULL;
 	dev_kfree_skb_any(rx->ctx.skb_head);
 	rx->ctx.skb_head = NULL;
 	rx->ctx.skb_tail = NULL;
@@ -693,7 +695,7 @@ int gve_rx_poll_dqo(struct gve_notify_bl
 
 		err = gve_rx_dqo(napi, rx, compl_desc, rx->q_num);
 		if (err < 0) {
-			gve_rx_free_skb(rx);
+			gve_rx_free_skb(napi, rx);
 			u64_stats_update_begin(&rx->statss);
 			if (err == -ENOMEM)
 				rx->rx_skb_alloc_fail++;
@@ -736,7 +738,7 @@ int gve_rx_poll_dqo(struct gve_notify_bl
 
 		/* gve_rx_complete_skb() will consume skb if successful */
 		if (gve_rx_complete_skb(rx, napi, compl_desc, feat) != 0) {
-			gve_rx_free_skb(rx);
+			gve_rx_free_skb(napi, rx);
 			u64_stats_update_begin(&rx->statss);
 			rx->rx_desc_err_dropped_pkt++;
 			u64_stats_update_end(&rx->statss);


