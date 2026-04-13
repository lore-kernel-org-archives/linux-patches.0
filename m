Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7D75C9E;
	Mon, 13 Apr 2026 16:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096942; cv=none; b=ULg2EohipVXrSP9e5XI2l/tF5kE8lk35426gzC2gChjfZ1UwXNudHe0NTiFlIZ1JXIGLk2PdKrpY5PoVF8y2KGHfNvgzbP1tzF72UiO4QdAmRZXcbBFvBludfQiYgE+IG9i+v1L3x7rA8Zbb8v9umlHvpAyCaICG4ootF/8EcQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096942; c=relaxed/simple;
	bh=yKeLOJOvQvi1aOcHMDqjcvS8xSn3ntuNmA66vGuHw6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S6vcrdz54ebsDfLq4tZp9NzFGL3v9nL/gUgQtHtQvRrRIiS/iySAp5eIqdNt46oD5aIddnkgAFMjZipbWuUTVKcD8w7OtcEm5PmWnlUB1NyZRDUiWwlCO04AIN6CrQIlSmXaMUug9JPBryTSPXe9nmN6BwqgZmjpctQ1PuU+2to=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BuTt8AuE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BuTt8AuE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B4DDC2BCAF;
	Mon, 13 Apr 2026 16:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096941;
	bh=yKeLOJOvQvi1aOcHMDqjcvS8xSn3ntuNmA66vGuHw6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BuTt8AuEesJtBq5+M+Ld5Y0TB8HVoPoPW9DsWsgAtP1pcXrS0hqQs5SLDei0z3AgK
	 nbGYmLpgKzKXV+tCb+aA/lvPYDpJJMX6s0U50i5mIypckVvQk1l6qIu6/5caYX8bV6
	 tGQH0I5ayI4U9LL0p0LPyMFBf4dhLTjXRTnHCMBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 33/50] net: altera-tse: fix skb leak on DMA mapping error in tse_start_xmit()
Date: Mon, 13 Apr 2026 18:01:00 +0200
Message-ID: <20260413155725.750272435@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155724.497323914@linuxfoundation.org>
References: <20260413155724.497323914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

commit 6dede3967619b5944003227a5d09fdc21ed57d10 upstream.

When dma_map_single() fails in tse_start_xmit(), the function returns
NETDEV_TX_OK without freeing the skb. Since NETDEV_TX_OK tells the
stack the packet was consumed, the skb is never freed, leaking memory
on every DMA mapping failure.

Add dev_kfree_skb_any() before returning to properly free the skb.

Fixes: bbd2190ce96d ("Altera TSE: Add main and header file for Altera Ethernet Driver")
Cc: stable@vger.kernel.org
Signed-off-by: David Carlier <devnexen@gmail.com>
Link: https://patch.msgid.link/20260401211218.279185-1-devnexen@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/altera/altera_tse_main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -574,6 +574,7 @@ static netdev_tx_t tse_start_xmit(struct
 				  DMA_TO_DEVICE);
 	if (dma_mapping_error(priv->device, dma_addr)) {
 		netdev_err(priv->dev, "%s: DMA mapping error\n", __func__);
+		dev_kfree_skb_any(skb);
 		ret = NETDEV_TX_OK;
 		goto out;
 	}


