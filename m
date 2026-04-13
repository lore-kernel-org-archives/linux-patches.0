Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA7E272E6D;
	Mon, 13 Apr 2026 16:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096563; cv=none; b=J35KKm8rm065pf6WxvpxLgK6j7m2wRvKgo1bTYWysivkfMfSrIFJJYDtICyz+X26Uxii+uw7dgqrCKof675aeUyYAbpisHIjn64aMXBWR4GoayeX24s2ZFj3Mw7a80k1U6h5e9hS6AEqKd/yl2XGfuIhQGYX+1zhzZhIxlbjqgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096563; c=relaxed/simple;
	bh=xUz35ajplvainuSZMSA3VSQTL6Gd0i3B7VaRrrTR+ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HL4tXz32+0SPWrC9/snt82JDrlUxRS/uM568qC649yBUSSaiSpAG2OOFcoWKH6EBEYgrsdvJkl6B2Zx/AItT84vNKborsabaDtdSf8UGE4pF259kNE9pgL9qXqLooJl34qnNkjmTEd3qQ5+oMisU/aYQ44VGUNYwRt8mCqoW8aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lt8rcl2C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lt8rcl2C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ADE1C2BCB6;
	Mon, 13 Apr 2026 16:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096563;
	bh=xUz35ajplvainuSZMSA3VSQTL6Gd0i3B7VaRrrTR+ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lt8rcl2CrbD307nASqE9MsVq1iMJPMFVrykMo1WcX6rAR/w5ESxBjtJCileopcJWt
	 Q8CzKacbqwMF9GVImLHUWhTTgJ8+7Ljb5U9zakm3neOkRSjp7UDgF5siyeItx0hlyJ
	 9R9/b6BgkJ+wYwM+EbSCerUIQ96O8is/EoVkBxHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.18 60/83] net: lan966x: fix page pool leak in error paths
Date: Mon, 13 Apr 2026 18:00:28 +0200
Message-ID: <20260413155733.251988408@linuxfoundation.org>
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

From: David Carlier <devnexen@gmail.com>

commit 076344a6ad9d1308faaed1402fdcfdda68b604ab upstream.

lan966x_fdma_rx_alloc() creates a page pool but does not destroy it if
the subsequent fdma_alloc_coherent() call fails, leaking the pool.

Similarly, lan966x_fdma_init() frees the coherent DMA memory when
lan966x_fdma_tx_alloc() fails but does not destroy the page pool that
was successfully created by lan966x_fdma_rx_alloc(), leaking it.

Add the missing page_pool_destroy() calls in both error paths.

Fixes: 11871aba1974 ("net: lan96x: Use page_pool API")
Cc: stable@vger.kernel.org
Signed-off-by: David Carlier <devnexen@gmail.com>
Link: https://patch.msgid.link/20260405055241.35767-3-devnexen@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -119,8 +119,10 @@ static int lan966x_fdma_rx_alloc(struct
 		return PTR_ERR(rx->page_pool);
 
 	err = fdma_alloc_coherent(lan966x->dev, fdma);
-	if (err)
+	if (err) {
+		page_pool_destroy(rx->page_pool);
 		return err;
+	}
 
 	fdma_dcbs_init(fdma, FDMA_DCB_INFO_DATAL(fdma->db_size),
 		       FDMA_DCB_STATUS_INTR);
@@ -958,6 +960,7 @@ int lan966x_fdma_init(struct lan966x *la
 	err = lan966x_fdma_tx_alloc(&lan966x->tx);
 	if (err) {
 		fdma_free_coherent(lan966x->dev, &lan966x->rx.fdma);
+		page_pool_destroy(lan966x->rx.page_pool);
 		return err;
 	}
 


