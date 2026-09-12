Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41924419318;
	Sat, 12 Sep 2026 08:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202517; cv=none; b=eZPl6CpCA6jm3A9qGnYWNrAcc9wTjEUDlsbEdEBmFDpTHaZcauQ1HzPElU+nz0d9F3Hex9Ml2zhjoA4R1fCLOYdqh6nyZ7hPBGdrWmC5cHv78ieyRsXExMHuYSQ638dVY5Fq0+iwHWCoIpkx9IMkI+3Rrfgb1iaFYSoLWkQwbNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202517; c=relaxed/simple;
	bh=qmXy9qR5rCEl+5UxRknoXj/yGHS0ND198gg/GMEq1Kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SPFnycibJpirOPsIt/uy4fGYC8wszPky6dgl4Ss2SeOmCkA6Ov9XnBPP2ilYcRNQyi2sN92OInpy35JkUNonmmB/gtnWbpmm3CIQN+I+dBN3ZZqqluI5D3/w2tVBWXp0uX5sNl7UkEi8nVY/F7kPFRX60FCEkJCJ1W6vDJE0U+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VgqHp3vi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VgqHp3vi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D46EF1F000FF;
	Sat, 12 Sep 2026 08:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202515;
	bh=ildsH3XHaaxJeoHkV+iRUMmYop7d7JAss3Nznge/HgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VgqHp3viMrYkVH/opdVkNpkI/JakPIB9xQ0f7gtyM+24jeca9tYEFQWh9W9Dr5JzY
	 3wutBzhdiPwSucx4/IcCCny2yXqOcKMzpOezcwztRYn4rHRuUpx10EjovGQQIUGyAx
	 3CJ1Fe/NnPeArV9mm7AcIIBce80RcRlqmiWPsyCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1218/1815] Bluetooth: btusb: QCA: Fix populating devcoredump fields on unenabled devices
Date: Sat, 12 Sep 2026 08:49:28 +0200
Message-ID: <20260912065717.599189872@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index df229e33bcd7b..a3d6d3194b15b 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -3708,8 +3708,10 @@ static int btusb_setup_qca(struct hci_dev *hdev)
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



