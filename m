Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1BB52D73B5;
	Mon, 13 Apr 2026 16:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096560; cv=none; b=f8vRTXr5OgjpyK3zhLQ7P8havruZL9X8mAvfQceuSmBb1IA0w5kt3qCTwYGusa9HuJluF49we+q6C3vMY6DpPnRfq3jy1dKE4cPkYpLuauXDnVlz3R+pnvYsbOM3J0KcZLRFE42Yh0PcQV0+QkOomkQ4MdB1EwdwdkymNCAxHNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096560; c=relaxed/simple;
	bh=gzIwaGXZqAl4tZQRkTsP8DcfHo6Oa6Gw2KWmFGXhHDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QXGWcdgN5S9hjo8uYgYEMInecgI6WyX9nU8o7IUozAKmGBKNSoAjaiUqZjdgkZY1fSxEX39mqDRFIgPA9nAUQvIJ2aiUuu1yM9C0n54Wn20BOzEb5yFst3gw8hGSYffT1MlhozwN9DveVNTiU86KAjHkYYCVaI5/oyRdiR5b49k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xs4DvH5k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xs4DvH5k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14331C2BCB0;
	Mon, 13 Apr 2026 16:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096560;
	bh=gzIwaGXZqAl4tZQRkTsP8DcfHo6Oa6Gw2KWmFGXhHDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xs4DvH5kNR0f7xthqiZJ1JHYayh84PrsWhj+Q+LKf090CWc90jg1dQdwlB/PSZILm
	 D8BnuHlBw6xMK/HqCs9iZ9FUVZX6cc2sU7A4pnub+lEueudyOeDSwzzP0a4ulTuO34
	 4PBSwCsbf8LHt03ELHfmRIPOD4L/XOcI4LXIoUwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.18 59/83] net: lan966x: fix page_pool error handling in lan966x_fdma_rx_alloc_page_pool()
Date: Mon, 13 Apr 2026 18:00:27 +0200
Message-ID: <20260413155733.216046637@linuxfoundation.org>
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

commit 3fd0da4fd8851a7e62d009b7db6c4a05b092bc19 upstream.

page_pool_create() can return an ERR_PTR on failure. The return value
is used unconditionally in the loop that follows, passing the error
pointer through xdp_rxq_info_reg_mem_model() into page_pool_use_xdp_mem(),
which dereferences it, causing a kernel oops.

Add an IS_ERR check after page_pool_create() to return early on failure.

Fixes: 11871aba1974 ("net: lan96x: Use page_pool API")
Cc: stable@vger.kernel.org
Signed-off-by: David Carlier <devnexen@gmail.com>
Link: https://patch.msgid.link/20260405055241.35767-2-devnexen@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -91,6 +91,8 @@ static int lan966x_fdma_rx_alloc_page_po
 		pp_params.dma_dir = DMA_BIDIRECTIONAL;
 
 	rx->page_pool = page_pool_create(&pp_params);
+	if (unlikely(IS_ERR(rx->page_pool)))
+		return PTR_ERR(rx->page_pool);
 
 	for (int i = 0; i < lan966x->num_phys_ports; ++i) {
 		struct lan966x_port *port;


