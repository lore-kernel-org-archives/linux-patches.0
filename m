Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26289446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:37:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D55FC433C8;
	Sun, 13 Aug 2023 21:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962640;
	bh=KtcwlFMFaj+TPiyKEqABQ2x+QI0PA31MUkUfKp2shs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uXaPDifN8I4XWwySlj0Pw/3VqZA92KpAH7CwsI0CSmtkV4Ym2IIyZOn1xqafammYu
	 o5CPz+YfgPH9Dfw55yMRKaCM5oWv3qFVDi13jUNURag5+Z+GACCCR3WceSyFnxxdeX
	 CdDAyuSQR4z8GW6RgDh9kKNxocWCnYqsJBulzWYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 103/149] net: tls: avoid discarding data on record close
Date: Sun, 13 Aug 2023 23:19:08 +0200
Message-ID: <20230813211721.858859233@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211718.757428827@linuxfoundation.org>
References: <20230813211718.757428827@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jakub Kicinski <kuba@kernel.org>

commit 6b47808f223c70ff564f9b363446d2a5fa1e05b2 upstream.

TLS records end with a 16B tag. For TLS device offload we only
need to make space for this tag in the stream, the device will
generate and replace it with the actual calculated tag.

Long time ago the code would just re-reference the head frag
which mostly worked but was suboptimal because it prevented TCP
from combining the record into a single skb frag. I'm not sure
if it was correct as the first frag may be shorter than the tag.

The commit under fixes tried to replace that with using the page
frag and if the allocation failed rolling back the data, if record
was long enough. It achieves better fragment coalescing but is
also buggy.

We don't roll back the iterator, so unless we're at the end of
send we'll skip the data we designated as tag and start the
next record as if the rollback never happened.
There's also the possibility that the record was constructed
with MSG_MORE and the data came from a different syscall and
we already told the user space that we "got it".

Allocate a single dummy page and use it as fallback.

Found by code inspection, and proven by forcing allocation
failures.

Fixes: e7b159a48ba6 ("net/tls: remove the record tail optimization")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tls/tls_device.c |   64 ++++++++++++++++++++++++++-------------------------
 1 file changed, 33 insertions(+), 31 deletions(-)

--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -52,6 +52,8 @@ static LIST_HEAD(tls_device_list);
 static LIST_HEAD(tls_device_down_list);
 static DEFINE_SPINLOCK(tls_device_lock);
 
+static struct page *dummy_page;
+
 static void tls_device_free_ctx(struct tls_context *ctx)
 {
 	if (ctx->tx_conf == TLS_HW) {
@@ -313,36 +315,33 @@ static int tls_push_record(struct sock *
 	return tls_push_sg(sk, ctx, offload_ctx->sg_tx_data, 0, flags);
 }
 
-static int tls_device_record_close(struct sock *sk,
-				   struct tls_context *ctx,
-				   struct tls_record_info *record,
-				   struct page_frag *pfrag,
-				   unsigned char record_type)
+static void tls_device_record_close(struct sock *sk,
+				    struct tls_context *ctx,
+				    struct tls_record_info *record,
+				    struct page_frag *pfrag,
+				    unsigned char record_type)
 {
 	struct tls_prot_info *prot = &ctx->prot_info;
-	int ret;
+	struct page_frag dummy_tag_frag;
 
 	/* append tag
 	 * device will fill in the tag, we just need to append a placeholder
 	 * use socket memory to improve coalescing (re-using a single buffer
 	 * increases frag count)
-	 * if we can't allocate memory now, steal some back from data
+	 * if we can't allocate memory now use the dummy page
 	 */
-	if (likely(skb_page_frag_refill(prot->tag_size, pfrag,
-					sk->sk_allocation))) {
-		ret = 0;
-		tls_append_frag(record, pfrag, prot->tag_size);
-	} else {
-		ret = prot->tag_size;
-		if (record->len <= prot->overhead_size)
-			return -ENOMEM;
+	if (unlikely(pfrag->size - pfrag->offset < prot->tag_size) &&
+	    !skb_page_frag_refill(prot->tag_size, pfrag, sk->sk_allocation)) {
+		dummy_tag_frag.page = dummy_page;
+		dummy_tag_frag.offset = 0;
+		pfrag = &dummy_tag_frag;
 	}
+	tls_append_frag(record, pfrag, prot->tag_size);
 
 	/* fill prepend */
 	tls_fill_prepend(ctx, skb_frag_address(&record->frags[0]),
 			 record->len - prot->overhead_size,
 			 record_type);
-	return ret;
 }
 
 static int tls_create_new_record(struct tls_offload_context_tx *offload_ctx,
@@ -535,18 +534,8 @@ last_record:
 
 		if (done || record->len >= max_open_record_len ||
 		    (record->num_frags >= MAX_SKB_FRAGS - 1)) {
-			rc = tls_device_record_close(sk, tls_ctx, record,
-						     pfrag, record_type);
-			if (rc) {
-				if (rc > 0) {
-					size += rc;
-				} else {
-					size = orig_size;
-					destroy_record(record);
-					ctx->open_record = NULL;
-					break;
-				}
-			}
+			tls_device_record_close(sk, tls_ctx, record,
+						pfrag, record_type);
 
 			rc = tls_push_record(sk,
 					     tls_ctx,
@@ -1466,14 +1455,26 @@ int __init tls_device_init(void)
 {
 	int err;
 
-	destruct_wq = alloc_workqueue("ktls_device_destruct", 0, 0);
-	if (!destruct_wq)
+	dummy_page = alloc_page(GFP_KERNEL);
+	if (!dummy_page)
 		return -ENOMEM;
 
+	destruct_wq = alloc_workqueue("ktls_device_destruct", 0, 0);
+	if (!destruct_wq) {
+		err = -ENOMEM;
+		goto err_free_dummy;
+	}
+
 	err = register_netdevice_notifier(&tls_dev_notifier);
 	if (err)
-		destroy_workqueue(destruct_wq);
+		goto err_destroy_wq;
 
+	return 0;
+
+err_destroy_wq:
+	destroy_workqueue(destruct_wq);
+err_free_dummy:
+	put_page(dummy_page);
 	return err;
 }
 
@@ -1482,4 +1483,5 @@ void __exit tls_device_cleanup(void)
 	unregister_netdevice_notifier(&tls_dev_notifier);
 	destroy_workqueue(destruct_wq);
 	clean_acked_data_flush();
+	put_page(dummy_page);
 }


