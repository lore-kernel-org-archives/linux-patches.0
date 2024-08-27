Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05AE11A072D;
	Tue, 27 Aug 2024 15:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771643; cv=none; b=m5ZK+YiwaUvpGBoaiIFpytL2pZbltKXtLYUnSJ05fBCbT49OnAiq2na6QkhCBFlwV9Glu6BvLlwjBKiXbwimyMk76SElHLoqcS8vUKiM/ni7zR44ZOezG/yPr0F7DvJRtHsvAnSRhXcESgulvSHjZwSX8EeRV1u7jHsofVZFIZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771643; c=relaxed/simple;
	bh=wBCXTima3kipZhmATW5sVfDiuyd9TzVCUYVaHE6P9UU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JtrGBGqMBuSmyNIIj7OHiTVxM3ImmXiV+etjD7G/HAOL4kndjjXs+1So3ZDNFpRvEGtIBr3PPOackkd0IEB4yQP+A1nFk6vM5YbjVVAN2oB9JNaWsnO1WhvUGsn2JfTl00NKuq+JRKDr4+O1W5t6mdrVgeulTkGB2OBcPSJb874=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1dNRSj6H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1dNRSj6H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED12C61064;
	Tue, 27 Aug 2024 15:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771642;
	bh=wBCXTima3kipZhmATW5sVfDiuyd9TzVCUYVaHE6P9UU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1dNRSj6HcPXWebvLnbL2gsXtubdeL4WLpMc/lqTCh/PoQ/a1nFkw/qrvr8gbHSRHc
	 2pYi5zZEHryv8JLIJx2Pd3z00Nzt8v6SXOe2X1Y1IvtX1Sf72wcqSjCGmUGRNorqem
	 HYUApB+nHcRR+BnE9ke2cgdcS70K/Ni9O3FTb3Cc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mengyuan Lou <mengyuanlou@net-swift.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.10 233/273] net: ngbe: Fix phy mode set to external phy
Date: Tue, 27 Aug 2024 16:39:17 +0200
Message-ID: <20240827143842.273154608@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mengyuan Lou <mengyuanlou@net-swift.com>

commit f2916c83d746eb99f50f42c15cf4c47c2ea5f3b3 upstream.

The MAC only has add the TX delay and it can not be modified.
MAC and PHY are both set the TX delay cause transmission problems.
So just disable TX delay in PHY, when use rgmii to attach to
external phy, set PHY_INTERFACE_MODE_RGMII_RXID to phy drivers.
And it is does not matter to internal phy.

Fixes: bc2426d74aa3 ("net: ngbe: convert phylib to phylink")
Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
Cc: stable@vger.kernel.org # 6.3+
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/E6759CF1387CF84C+20240820030425.93003-1-mengyuanlou@net-swift.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.c
@@ -124,8 +124,12 @@ static int ngbe_phylink_init(struct wx *
 				   MAC_SYM_PAUSE | MAC_ASYM_PAUSE;
 	config->mac_managed_pm = true;
 
-	phy_mode = PHY_INTERFACE_MODE_RGMII_ID;
-	__set_bit(PHY_INTERFACE_MODE_RGMII_ID, config->supported_interfaces);
+	/* The MAC only has add the Tx delay and it can not be modified.
+	 * So just disable TX delay in PHY, and it is does not matter to
+	 * internal phy.
+	 */
+	phy_mode = PHY_INTERFACE_MODE_RGMII_RXID;
+	__set_bit(PHY_INTERFACE_MODE_RGMII_RXID, config->supported_interfaces);
 
 	phylink = phylink_create(config, NULL, phy_mode, &ngbe_mac_ops);
 	if (IS_ERR(phylink))


