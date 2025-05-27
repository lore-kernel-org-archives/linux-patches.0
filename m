Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976BD2110E;
	Tue, 27 May 2025 17:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366516; cv=none; b=WFfd8fOU8VBO0ZeZ595y87THXXw076z+FMjFLjXXuDbtTTEIeV0FmDYmp/7Rt/k5D4xqh97tIyhX8e0kEOGWldlQ7X5foN8Ny2OWl3Td/pvEv5z6hDm50WqyLreCPsw1ZU6Ylun1J/nXbS+T9Mx8EvqMvtupbtmCfeobTuckF0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366516; c=relaxed/simple;
	bh=+LyXhCPgMpDHI524xrLYxABYeF7CkIEwP54EJDsKS54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B89gNkWF7mAB/K7LSi98mA5gqL8jJvI1st66MGa4aFfGYHn/IS+D0fl4Pj5RxPZxTpenULZQ6TrHEv6u5/TPrlntsd697A3U3TbhdB8I0/2A8c/2YqXN7eTx/2/F620FVxvg6t5/Ru7IJ7+2z8H3NgzkI/DpecP3k5VFf6nSfNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zSM22X/v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zSM22X/v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F9FC4CEE9;
	Tue, 27 May 2025 17:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366516;
	bh=+LyXhCPgMpDHI524xrLYxABYeF7CkIEwP54EJDsKS54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zSM22X/vKm9vwOlOtySRa/xFhe0vE3MhJcUwce0UAo67DA/EL0Q8oGgrPT8P1wakF
	 E/wg8ht+kBSuvUpbBr9s6lrf0O3wE7bB9MVyUVzWCjrF5jdb8czVi3ozU+ETbA5hnP
	 eQipnWzHj7+yNGHzdW52peeEd//YXW0OYYk18uQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChunHao Lin <hau@realtek.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 094/783] r8169: disable RTL8126 ZRX-DC timeout
Date: Tue, 27 May 2025 18:18:11 +0200
Message-ID: <20250527162516.967396797@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 5a5eba49c6515..4ead966727734 100644
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
@@ -3822,6 +3848,7 @@ static void rtl_hw_start_8125d(struct rtl8169_private *tp)
 
 static void rtl_hw_start_8126a(struct rtl8169_private *tp)
 {
+	rtl_disable_zrxdc_timeout(tp);
 	rtl_set_def_aspm_entry_latency(tp);
 	rtl_hw_start_8125_common(tp);
 }
-- 
2.39.5



