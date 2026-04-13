Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1EF26E718;
	Mon, 13 Apr 2026 16:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096351; cv=none; b=oOls4VnCUBbePFVQqugrHsgSHgUQMS64WXGSHvgyEIpIC3jFlSGH4XR3hdtEX8IF4y14TJjMg1+EwvkVI6yw6FAauJvFItoMvSvQu31yGZfWHNwQaBuogO9PV8dZUJiFXM1SzpAhK8ETe1ArdL1dcJqGL8+O3pB8kfJQqEz5BXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096351; c=relaxed/simple;
	bh=8SrE+l6xom784F+6MAgxWz4Jbuh/AQnuj9IqD1ZTofc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X1iu+DJwitJ+HnnSdFVUbe3VS2b8E9xwq3BJoKbcOhYXixlIySFNweD2MCY3/uUqTYjf315jDfjg5fYN0mZlRANpoMwgTPGon3D7q02fF+03yITnugViN8R6DiqxSyWqOAO6abY8/s8qx7N/YOFr/E1fECZjF2/NqBI/9TScmO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZIrnZwCe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZIrnZwCe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A03C2BCAF;
	Mon, 13 Apr 2026 16:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096351;
	bh=8SrE+l6xom784F+6MAgxWz4Jbuh/AQnuj9IqD1ZTofc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZIrnZwCebLN1j+7Q99MupC8xmZU304Hnqq6r0aBgp0R3FphueB82cjUC8pLdpLS02
	 FcDMBQ89e5Ab1dczTPv5tTBF0kHg/XFczJVwkO9H4gUAH6jfdxoa8HKuKwQnGtjl5o
	 5dAS+oe8PCmUxf3bFimxmnFYggE6w5cPBsRcKGAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.19 63/86] net: lan966x: fix page pool leak in error paths
Date: Mon, 13 Apr 2026 18:00:10 +0200
Message-ID: <20260413155733.909664036@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.568515178@linuxfoundation.org>
References: <20260413155731.568515178@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
 


