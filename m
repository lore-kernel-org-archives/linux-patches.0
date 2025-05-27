Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C00527FB0C;
	Tue, 27 May 2025 16:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364536; cv=none; b=sGLNWifKfFNAB3hxIhIOUd3ZuFMzesul++wv+dR0MUfefDF6Tx7O7wxDp/JxmXDazfMIfeI54jps0ZDCfza6t77t8/DVer+Uwi3tQbkjH7IYk7CuoV9rU1C0vsOadNij8+xM+VXv1rQxSJy6Rm5B1YlWdHl4NOwB+8NridGkWXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364536; c=relaxed/simple;
	bh=PEibiABggtoOSEIstvJ5xZawcfcbeMnpUYgSkMx8w7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K7m859ZfZ+GALhn+UGbHbJt+cuN6Ci5qGwOzA0zMzGfKclRc+/QnV532pWgUsaw/cJG2HyN/UL65kD5iX1ug05Q6Wzzx6TrGQW6rR3CXVsUBtPYP7e/ydbAbOMxPINZZkeV+2+8C1RrTBKF0JJs6h+y1Px7e23FeZVsgRX6acBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1dnJwOtf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1dnJwOtf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C9A0C4CEED;
	Tue, 27 May 2025 16:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364535;
	bh=PEibiABggtoOSEIstvJ5xZawcfcbeMnpUYgSkMx8w7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1dnJwOtfYldpVGsA7T3pjJHd1Xkx5VxEN2Kp70QXbDWUhr48+uRWOXvbbdMlojfWG
	 CXbZWhqM+Six65sWasnxpUQKhBB3+6ll1tzwcIxHYpaxSG7lPbYv8l9LpxM2uHV3Bc
	 DzcE8/l/wTvYGTNCQZOzX3z5a6arl2WxVaHTlWks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChunHao Lin <hau@realtek.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 088/626] r8169: disable RTL8126 ZRX-DC timeout
Date: Tue, 27 May 2025 18:19:41 +0200
Message-ID: <20250527162448.617457738@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: ChunHao Lin <hau@realtek.com>

[ Upstream commit b48688ea3c9ac8d5d910c6e91fb7f80d846581f0 ]

Disable it due to it dose not meet ZRX-DC specification. If it is enabled,
device will exit L1 substate every 100ms. Disable it for saving more power
in L1 substate.

Signed-off-by: ChunHao Lin <hau@realtek.com>
Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://patch.msgid.link/20250318083721.4127-3-hau@realtek.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 27 +++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 5ed2818bac257..3420b6cf8189f 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2850,6 +2850,32 @@ static u32 rtl_csi_read(struct rtl8169_private *tp, int addr)
 		RTL_R32(tp, CSIDR) : ~0;
 }
 
+static void rtl_disable_zrxdc_timeout(struct rtl8169_private *tp)
+{
+	struct pci_dev *pdev = tp->pci_dev;
+	u32 csi;
+	int rc;
+	u8 val;
+
+#define RTL_GEN3_RELATED_OFF	0x0890
+#define RTL_GEN3_ZRXDC_NONCOMPL	0x1
+	if (pdev->cfg_size > RTL_GEN3_RELATED_OFF) {
+		rc = pci_read_config_byte(pdev, RTL_GEN3_RELATED_OFF, &val);
+		if (rc == PCIBIOS_SUCCESSFUL) {
+			val &= ~RTL_GEN3_ZRXDC_NONCOMPL;
+			rc = pci_write_config_byte(pdev, RTL_GEN3_RELATED_OFF,
+						   val);
+			if (rc == PCIBIOS_SUCCESSFUL)
+				return;
+		}
+	}
+
+	netdev_notice_once(tp->dev,
+		"No native access to PCI extended config space, falling back to CSI\n");
+	csi = rtl_csi_read(tp, RTL_GEN3_RELATED_OFF);
+	rtl_csi_write(tp, RTL_GEN3_RELATED_OFF, csi & ~RTL_GEN3_ZRXDC_NONCOMPL);
+}
+
 static void rtl_set_aspm_entry_latency(struct rtl8169_private *tp, u8 val)
 {
 	struct pci_dev *pdev = tp->pci_dev;
@@ -3816,6 +3842,7 @@ static void rtl_hw_start_8125b(struct rtl8169_private *tp)
 
 static void rtl_hw_start_8126a(struct rtl8169_private *tp)
 {
+	rtl_disable_zrxdc_timeout(tp);
 	rtl_set_def_aspm_entry_latency(tp);
 	rtl_hw_start_8125_common(tp);
 }
-- 
2.39.5



