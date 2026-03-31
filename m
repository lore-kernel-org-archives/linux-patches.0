Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166BD3A1E8C;
	Tue, 31 Mar 2026 16:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976197; cv=none; b=HnYJx+q3nshyP5mhDKedA99HPSzKXJy7PYKR1u01dBeoAuCrtH8bppE5t4ctaI3cOizbL1GFLxA2w75QKzN1QAYi+b3hejKu14BOKfFD0dKATVg2BGDu+f7eKGXpmbbaqM/8KcYaC9DAOOSQq+h0kllWxAwRxFj4qO+370Ha17k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976197; c=relaxed/simple;
	bh=0hM+QwDQfBeBvzLhII0JM863rir3AfM503QLlXVlbks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hN86uSuEWa0z3C+DPeyvDuFwHBBXUe7+PXQ1mOOXvBv20UAfp7LIYrTGBj/ox5fFHokW2tSn9ue9Ka3nGeZc1DOynQbuGlNEf0bL+8FK/oKp0Klzg1k3xbLql01k+noaeTxT19rdI20boQVMq/wGgJfHwdnIhm8S8iWo1AkGJis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mDEquyIY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mDEquyIY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FAE1C19423;
	Tue, 31 Mar 2026 16:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976197;
	bh=0hM+QwDQfBeBvzLhII0JM863rir3AfM503QLlXVlbks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mDEquyIYypzNdowJKYRsa0y+NnN6BUyvh0IIRcA3esA1vuMvAvNgXqVNc876OwP7v
	 jZv74XR6tAsRgp6T/KiNRA617Kh117e1b0ByKHMV4dw2EDRAhNCLXT0wx/N5BHVi5z
	 VUI9PEpCDYuU2dOyk6ri+D7yPNDSWOtTZ5DwTKBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 243/244] net: bcmasp: Fix network filter wake for asp-3.0
Date: Tue, 31 Mar 2026 18:23:13 +0200
Message-ID: <20260331161750.731994237@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

From: Justin Chen <justin.chen@broadcom.com>

commit bbb11b8d758d17a4ce34b8ed0b49de150568265b upstream.

We need to apply the tx_chan_offset to the netfilter cfg channel or the
output channel will be incorrect for asp-3.0 and newer.

Fixes: e9f31435ee7d ("net: bcmasp: Add support for asp-v3.0")
Signed-off-by: Justin Chen <justin.chen@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20260120192339.2031648-1-justin.chen@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/asp2/bcmasp.c |    5 +++--
 drivers/net/ethernet/broadcom/asp2/bcmasp.h |    1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/broadcom/asp2/bcmasp.c
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp.c
@@ -156,7 +156,7 @@ static void bcmasp_netfilt_hw_en_wake(st
 			  ASP_RX_FILTER_NET_OFFSET_L4(32),
 			  ASP_RX_FILTER_NET_OFFSET(nfilt->hw_index + 1));
 
-	rx_filter_core_wl(priv, ASP_RX_FILTER_NET_CFG_CH(nfilt->port + 8) |
+	rx_filter_core_wl(priv, ASP_RX_FILTER_NET_CFG_CH(nfilt->ch) |
 			  ASP_RX_FILTER_NET_CFG_EN |
 			  ASP_RX_FILTER_NET_CFG_L2_EN |
 			  ASP_RX_FILTER_NET_CFG_L3_EN |
@@ -166,7 +166,7 @@ static void bcmasp_netfilt_hw_en_wake(st
 			  ASP_RX_FILTER_NET_CFG_UMC(nfilt->port),
 			  ASP_RX_FILTER_NET_CFG(nfilt->hw_index));
 
-	rx_filter_core_wl(priv, ASP_RX_FILTER_NET_CFG_CH(nfilt->port + 8) |
+	rx_filter_core_wl(priv, ASP_RX_FILTER_NET_CFG_CH(nfilt->ch) |
 			  ASP_RX_FILTER_NET_CFG_EN |
 			  ASP_RX_FILTER_NET_CFG_L2_EN |
 			  ASP_RX_FILTER_NET_CFG_L3_EN |
@@ -714,6 +714,7 @@ struct bcmasp_net_filter *bcmasp_netfilt
 		nfilter = &priv->net_filters[open_index];
 		nfilter->claimed = true;
 		nfilter->port = intf->port;
+		nfilter->ch = intf->channel + priv->tx_chan_offset;
 		nfilter->hw_index = open_index;
 	}
 
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp.h
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp.h
@@ -348,6 +348,7 @@ struct bcmasp_net_filter {
 	bool				wake_filter;
 
 	int				port;
+	int				ch;
 	unsigned int			hw_index;
 };
 


