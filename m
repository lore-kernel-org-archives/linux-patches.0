Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E3725A2C9;
	Mon, 13 Apr 2026 16:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096774; cv=none; b=Ml7P5JRX/NfjlTAYh00nTpHLBuFExfhKh3we4PRaDLBaqzOcUB80MFSVuELHheA+VIFq7fwHhJsMG+osz/6JtP49YaZzSaiffsM8IM+t57BbmVqzb/9pStz1Bg74iGAD7tFjupGNm5uaocxnY1bvRZ1nnX8DA0tF5wW9GJufzv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096774; c=relaxed/simple;
	bh=i3k9XUAEssKLt59AcbjI9rRPuHUOy7SJUfjP8g86cQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oCHXB6E1sFeXfvKJHNQt4IRAg2lkpDgPpUInlYFWwDEEHqXFBDPYRUUJcbukhWeTwrhPG9ZshYZdUpY7M5v0jY5s+Gm387VM/1an1ANCji4vtOO48yiJayUFZSmZFTWAtHbNgQkH5Y6YQOQxBo9Eq+9DiRbOR67iivnJEyxcMX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yI4boHLY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yI4boHLY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AAFBC2BCAF;
	Mon, 13 Apr 2026 16:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096774;
	bh=i3k9XUAEssKLt59AcbjI9rRPuHUOy7SJUfjP8g86cQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yI4boHLYkOIFYSj5OSxdgABC1UFDGqfCDeJ/zuUE+lZMYG7gwybZ9DduwYoCUEjr+
	 J2W68wnLAHtJuqwuwiveM1BSy8J2Rl02Y2yPyTyLLMMeKkS4XM2yQmWkTA2m3w/VwS
	 HISOu4pijKCfMZO1lI8qFKpBicAPG0idDKdIE9bI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 58/70] net: lan966x: fix page_pool error handling in lan966x_fdma_rx_alloc_page_pool()
Date: Mon, 13 Apr 2026 18:00:53 +0200
Message-ID: <20260413155730.350368565@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155728.181580293@linuxfoundation.org>
References: <20260413155728.181580293@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


