Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6C62C3745;
	Mon, 27 Oct 2025 19:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592645; cv=none; b=duW0xhjOXdCOCI1M6m7Hd2B1XcbODgnbwi1XYB/T2MvY/QzXfffU94d5ZybydzcqXJcaIU3emQmXDgVMTbA9jrbkkwe9xF6FZvpcIAfGX3+sEH60Xd0FMWQzXV6njfKFA04Uex4YrvcVtHLwcnBBZJRV5LvS2l+UgFnU8cyFsz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592645; c=relaxed/simple;
	bh=SAWP7Em/a91+YdybyN8p8jPFERYCL2ZHbPNMqhr/X2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZpiQ9VtKjkj4E0TMBKHAc48t7vRZalLNqPRls639CZAlMIdqUnQ63hivd+h/qKHxdWZRgjVVrlXIq/I954Wa3qGDSvjXR334ECw4wZgUJagFl0NdElZkCaVKhtmffQDC87KEX7YaZvlIu6/x8UMz5IDC0904UAFOi5+cqvv7TLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WIbMH2zf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WIbMH2zf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34A86C4CEF1;
	Mon, 27 Oct 2025 19:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592645;
	bh=SAWP7Em/a91+YdybyN8p8jPFERYCL2ZHbPNMqhr/X2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WIbMH2zfQMRm0Mne/diGdOExcnn+sBeHBTdWtuCDaD1/++zdDwiCFwGMJLvQMa2zs
	 qGsfwGO4WNdtqlLTlH1TiPDYj9tINIKjDNM9TqSmoMakqIiMxQmHWm8rZp5ODB8Kv+
	 HJeAbxR4T8StIZRZcDPt2Ba/LOieCxjw6y6ZgRdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 43/84] net: stmmac: dwmac-rk: Fix disabling set_clock_selection
Date: Mon, 27 Oct 2025 19:36:32 +0100
Message-ID: <20251027183439.966096787@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183438.817309828@linuxfoundation.org>
References: <20251027183438.817309828@linuxfoundation.org>
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

From: Sebastian Reichel <sebastian.reichel@collabora.com>

commit 7f864458e9a6d2000b726d14b3d3a706ac92a3b0 upstream.

On all platforms set_clock_selection() writes to a GRF register. This
requires certain clocks running and thus should happen before the
clocks are disabled.

This has been noticed on RK3576 Sige5, which hangs during system suspend
when trying to suspend the second network interface. Note, that
suspending the first interface works, because the second device ensures
that the necessary clocks for the GRF are enabled.

Cc: stable@vger.kernel.org
Fixes: 2f2b60a0ec28 ("net: ethernet: stmmac: dwmac-rk: Add gmac support for rk3588")
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20251014-rockchip-network-clock-fix-v1-1-c257b4afdf75@collabora.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
@@ -1565,14 +1565,15 @@ static int gmac_clk_enable(struct rk_pri
 		}
 	} else {
 		if (bsp_priv->clk_enabled) {
+			if (bsp_priv->ops && bsp_priv->ops->set_clock_selection) {
+				bsp_priv->ops->set_clock_selection(bsp_priv,
+					      bsp_priv->clock_input, false);
+			}
+
 			clk_bulk_disable_unprepare(bsp_priv->num_clks,
 						   bsp_priv->clks);
 			clk_disable_unprepare(bsp_priv->clk_phy);
 
-			if (bsp_priv->ops && bsp_priv->ops->set_clock_selection)
-				bsp_priv->ops->set_clock_selection(bsp_priv,
-					      bsp_priv->clock_input, false);
-
 			bsp_priv->clk_enabled = false;
 		}
 	}


