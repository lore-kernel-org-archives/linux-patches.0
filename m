Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E725A42669C;
	Sat, 12 Sep 2026 10:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210259; cv=none; b=JwSg/OysfYvTPKy1QdXML792+hAXaqovFAjXuK5ZDUBfRf23gs33+Q+09im9CPCggVdixzN1WRKHeKcsf69mQ+WhQhpIMszMfyFeaZYfv0+Gqdzryn8HQkRV607/FbyBOlQI6tlff1PiF+77MpBYjD8TXquDGPSSayJHvc5k8eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210259; c=relaxed/simple;
	bh=JRSdHGE3+SadZ1KphXpTPr5sWeoklVQuvD3E/mNrkC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MK3HNSV8lNsRcArJKvBUePGLnq6EHZvcOmOTW1urhWmdh1N+kMV0AMyhQhgNvtpvJjycCdxvTtxlRM9Y2sT5xBuw4oLVqE0ng7QWSPtLPqAemh1EFOOMj+EiAEvGRrS7AqyzBOPoWaQfyu7AJp4Kf6xY7C617DcMsS7ugFUIZvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RgDX0xuf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RgDX0xuf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03EEE1F000FF;
	Sat, 12 Sep 2026 10:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210257;
	bh=V9cT1wqNBpgzSRFuzDfir4vxm/DbltEmcRtt/meHfAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RgDX0xuf9X6clA9cILaR690j+ISuWs/i+JHnfF2BYp0JPzJGWvjffBr4nQYrkd+AF
	 3Xhia18k/ou63x3ddB9fvHpxEtReKKsUvgzD45XEJZQzd5N/a+me6nEBCqGgZVEcpT
	 tHVYM/qA+d7pecZFaLriTSMctF62g+Ih3ioDvSEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0989/1518] Bluetooth: btusb: QCA: Fix populating devcoredump fields on unenabled devices
Date: Sat, 12 Sep 2026 08:52:38 +0200
Message-ID: <20260912065645.830894866@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Zijun Hu <zijun.hu@oss.qualcomm.com>

[ Upstream commit 33c6a8d01889a84cc773c0c20c8323bce84af27d ]

Devcoredump is not enabled for ATH3012 or QCA_ROME, but they
unconditionally populate devcoredump fields in btusb_setup_qca().

Fix by populating devcoredump fields only when BTUSB_QCA_WCN6855 is
set, which marks the first generation of QCA BT SoCs for which
devcoredump is enabled.

Fixes: 20981ce2d5a5 ("Bluetooth: btusb: Add WCN6855 devcoredump support")
Signed-off-by: Zijun Hu <zijun.hu@oss.qualcomm.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 68480ed7043b9..68054ae289c23 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -3631,8 +3631,10 @@ static int btusb_setup_qca(struct hci_dev *hdev)
 	if (err)
 		return err;
 
-	btdata->qca_dump.fw_version = le32_to_cpu(ver.patch_version);
-	btdata->qca_dump.controller_id = le32_to_cpu(ver.rom_version);
+	if (btdata->match_id->driver_info & BTUSB_QCA_WCN6855) {
+		btdata->qca_dump.fw_version = le32_to_cpu(ver.patch_version);
+		btdata->qca_dump.controller_id = le32_to_cpu(ver.rom_version);
+	}
 
 	if (!(status & QCA_SYSCFG_UPDATED)) {
 		err = btusb_setup_qca_load_nvm(hdev, &ver, info);
-- 
2.53.0



