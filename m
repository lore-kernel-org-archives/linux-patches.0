Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D4A14A81
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kcq0O5Eo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5FB0C433C9;
	Mon, 23 Oct 2023 11:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059115;
	bh=ly+FwnJsXK6aE7n0TagRNVBdQPqpMCoVSJrptp6pbiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kcq0O5EoZe3J715UhTyzbzXIeQFEUP1uA8d8JPrdbU873cOCnwiGFe/WLY3KkhoxC
	 xepp7qImfRU99KrW734G3BGfGtIlm6hCqV+VefnJiCv+Z9Y6QkDN72Fn6HAfO5VaHd
	 Sn+gFOAE0BuDyNxmsiOeFggI5qTqaj2WRdsRxwtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shailend Chand <shailend@google.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.5 069/241] gve: Do not fully free QPL pages on prefill errors
Date: Mon, 23 Oct 2023 12:54:15 +0200
Message-ID: <20231023104835.581440837@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shailend Chand <shailend@google.com>

commit 95535e37e8959f50e7aee365a5bdc9e5ed720443 upstream.

The prefill function should have only removed the page count bias it
added. Fully freeing the page will cause gve_free_queue_page_list to
free a page the driver no longer owns.

Fixes: 82fd151d38d9 ("gve: Reduce alloc and copy costs in the GQ rx path")
Signed-off-by: Shailend Chand <shailend@google.com>
Link: https://lore.kernel.org/r/20231014014121.2843922-1-shailend@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/google/gve/gve_rx.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index d1da7413dc4d..e84a066aa1a4 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -146,7 +146,7 @@ static int gve_prefill_rx_pages(struct gve_rx_ring *rx)
 		err = gve_rx_alloc_buffer(priv, &priv->pdev->dev, &rx->data.page_info[i],
 					  &rx->data.data_ring[i]);
 		if (err)
-			goto alloc_err;
+			goto alloc_err_rda;
 	}
 
 	if (!rx->data.raw_addressing) {
@@ -171,12 +171,26 @@ static int gve_prefill_rx_pages(struct gve_rx_ring *rx)
 	return slots;
 
 alloc_err_qpl:
+	/* Fully free the copy pool pages. */
 	while (j--) {
 		page_ref_sub(rx->qpl_copy_pool[j].page,
 			     rx->qpl_copy_pool[j].pagecnt_bias - 1);
 		put_page(rx->qpl_copy_pool[j].page);
 	}
-alloc_err:
+
+	/* Do not fully free QPL pages - only remove the bias added in this
+	 * function with gve_setup_rx_buffer.
+	 */
+	while (i--)
+		page_ref_sub(rx->data.page_info[i].page,
+			     rx->data.page_info[i].pagecnt_bias - 1);
+
+	gve_unassign_qpl(priv, rx->data.qpl->id);
+	rx->data.qpl = NULL;
+
+	return err;
+
+alloc_err_rda:
 	while (i--)
 		gve_rx_free_buffer(&priv->pdev->dev,
 				   &rx->data.page_info[i],
-- 
2.42.0



