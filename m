Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608D21C68AE;
	Tue, 27 Aug 2024 15:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770802; cv=none; b=mOlicyJx6YYIft/UAOUgNH9zSuSCJNIZALKr+wpLncsOH+hjHJE1PwxuiVb6wPWCxY+/50TbgQkwQsBxyE4eRE4G1NRhd4FOhV1fRM+loZuglvEyamkEZFXfCkOe6sLiQs4kfwlCaJG2FLOmqwcq0gACUxN/y59juMNym/SYtDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770802; c=relaxed/simple;
	bh=ILXZ6vtbzym/ku9/4z6zx8Zx/xIc23BH8dBcq4x9zjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bykKPdUZviaslEJmoZKMscc3T750UOr08557EnBGakZMiyEvgYxUiL4DvC2GAnNW7K2UCIvSooU0yrjL71vK0855bKYwMMxcFylTxna9LAQyt+7PEv+mLPshBk+0Lbpul5TlgN8m2XMa00pHYtoOFZj6snQpfQY3e2PNycqilWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EBgmv2Ck; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EBgmv2Ck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C57D7C4AF1C;
	Tue, 27 Aug 2024 15:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770802;
	bh=ILXZ6vtbzym/ku9/4z6zx8Zx/xIc23BH8dBcq4x9zjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EBgmv2Ck+VJgJTYUavIzdZlPnfcCB1ZWTiA2TtfMSwzbtp4exp0bjHG9Yfilg5YB3
	 g5hyYOsVEqZy8mqYId5i+MbnRkh1ln++ChX417C/O4V2+Y9W7ssCppEeug+ACqCkfS
	 ZD8nyZsEI3SQv/ygtjDXNmdTPX3nBfDJ9EPxAolM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mengyuan Lou <mengyuanlou@net-swift.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 339/341] net: ngbe: Fix phy mode set to external phy
Date: Tue, 27 Aug 2024 16:39:30 +0200
Message-ID: <20240827143856.294333513@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: mengyuanlou <mengyuanlou@net-swift.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.c
@@ -215,10 +215,14 @@ int ngbe_phy_connect(struct wx *wx)
 {
 	int ret;
 
+	/* The MAC only has add the Tx delay and it can not be modified.
+	 * So just disable TX delay in PHY, and it is does not matter to
+	 * internal phy.
+	 */
 	ret = phy_connect_direct(wx->netdev,
 				 wx->phydev,
 				 ngbe_handle_link_change,
-				 PHY_INTERFACE_MODE_RGMII_ID);
+				 PHY_INTERFACE_MODE_RGMII_RXID);
 	if (ret) {
 		wx_err(wx, "PHY connect failed.\n");
 		return ret;


