Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508DC24DCF6;
	Mon, 13 Apr 2026 16:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096643; cv=none; b=gxLLXcADEeSOqB+jAhAq1Z/70/EkqtPcVi0UhfslmIZsSBBPr9UtK+H9ElOqiYuVFM6ci3UHdqmT3cES4anQ1EY8BwfKne0G5+QDSePiIHwNSWa6cjzu/AfGj0k7t9Zr9BWXfkIu7AGAG4rEPzMNmiMc5NCMuHlF13cLTrR4jjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096643; c=relaxed/simple;
	bh=tu6opv2WOhV6rWZv6WnOlg2CgXmhp5xNoL2rBI2K5Jo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l0d59eY10IlPdKOSVZfq86kEA3pFXSBUMEwX5UPvjBbd8rwWlm88Y1g5LOsnSWYq8k3JtRXTZMkfgUbszSeYm5QTypKimuavrH/wosXIUXRpv/jvJUWerhqV7H4wcZBlAaw7PgsBkCN8jsG6/kIVNlF2hMGyS/ia3yT18LXULYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pP+3ujVB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pP+3ujVB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD7BEC2BCB0;
	Mon, 13 Apr 2026 16:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096643;
	bh=tu6opv2WOhV6rWZv6WnOlg2CgXmhp5xNoL2rBI2K5Jo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pP+3ujVBM6Z4iFsdEO5jwdpi9iIWGvgBJp7kIE/22TUeNxRFzyXfjyazWdFdw5xkX
	 yLpTh1jHMp6Rr5iPrHbPvw9kNX8rTDWRpbehx658eEbfRoaKKsG9L0iCaTPURAliu/
	 XRR/7qVGLOzWFCn+jh7dPZMsH5VBANrrPSKO5q5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonius <antonius@bluedragonsec.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 83/83] net: skb: fix cross-cache free of KFENCE-allocated skb head
Date: Mon, 13 Apr 2026 18:00:51 +0200
Message-ID: <20260413155734.087006692@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.019638460@linuxfoundation.org>
References: <20260413155731.019638460@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@linux.dev>

commit 0f42e3f4fe2a58394e37241d02d9ca6ab7b7d516 upstream.

SKB_SMALL_HEAD_CACHE_SIZE is intentionally set to a non-power-of-2
value (e.g. 704 on x86_64) to avoid collisions with generic kmalloc
bucket sizes. This ensures that skb_kfree_head() can reliably use
skb_end_offset to distinguish skb heads allocated from
skb_small_head_cache vs. generic kmalloc caches.

However, when KFENCE is enabled, kfence_ksize() returns the exact
requested allocation size instead of the slab bucket size. If a caller
(e.g. bpf_test_init) allocates skb head data via kzalloc() and the
requested size happens to equal SKB_SMALL_HEAD_CACHE_SIZE, then
slab_build_skb() -> ksize() returns that exact value. After subtracting
skb_shared_info overhead, skb_end_offset ends up matching
SKB_SMALL_HEAD_HEADROOM, causing skb_kfree_head() to incorrectly free
the object to skb_small_head_cache instead of back to the original
kmalloc cache, resulting in a slab cross-cache free:

  kmem_cache_free(skbuff_small_head): Wrong slab cache. Expected
  skbuff_small_head but got kmalloc-1k

Fix this by always calling kfree(head) in skb_kfree_head(). This keeps
the free path generic and avoids allocator-specific misclassification
for KFENCE objects.

Fixes: bf9f1baa279f ("net: add dedicated kmem_cache for typical/small skb->head")
Reported-by: Antonius <antonius@bluedragonsec.com>
Closes: https://lore.kernel.org/netdev/CAK8a0jxC5L5N7hq-DT2_NhUyjBxrPocoiDazzsBk4TGgT1r4-A@mail.gmail.com/
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260403014517.142550-1-jiayuan.chen@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skbuff.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1042,10 +1042,7 @@ static int skb_pp_frag_ref(struct sk_buf
 
 static void skb_kfree_head(void *head, unsigned int end_offset)
 {
-	if (end_offset == SKB_SMALL_HEAD_HEADROOM)
-		kmem_cache_free(net_hotdata.skb_small_head_cache, head);
-	else
-		kfree(head);
+	kfree(head);
 }
 
 static void skb_free_head(struct sk_buff *skb)


