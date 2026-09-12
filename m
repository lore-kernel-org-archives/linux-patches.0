Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E43738398F;
	Sat, 12 Sep 2026 14:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225073; cv=none; b=trs8BRP3zVXijcbREXn4uDdPxN29A8YvecPnNcPTQqXflIQgPRsdkOZk5uLikahSncsGN6e5+EvCJ0DAX9Q4AzBRx//0cfT/hIDp7Hu35fulTpAU+AkOF41AyRaWxqZpCYZPLUqRMxQc6GT57q2zUakl6KQtIP3SN4HbEZxblSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225073; c=relaxed/simple;
	bh=KCRYyOYMPWy7smNIi0aNhAm6u6/DQB5Q1dXrRUyjDI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hS3tRSce77ZNKM1yhswxNFQNP7FUCSb4BNnkVj/NUk8tnlSt67qIg0ZjiGP05C6KBt3ngipHHmOZNmcJLHsx/5HVIQ+fPIEGMz65mPoeCKEQZRqM+VCBadZe76cMwbG0he0Gya3EpoQwBnxIGUn+lVkJhf1tQy1zz+i92x5Z2D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eDYNv7FM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eDYNv7FM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD7481F000FF;
	Sat, 12 Sep 2026 14:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225069;
	bh=sEWPhg89Cl75xIG7sMVGCwR1iDw3uXd9VVAojvQXx6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eDYNv7FMOFmFHj9aZL/wKHC4U+rx8YwJdCwQEAlZiFt8LeY2zxBNW82B3w/hG+BVe
	 eJ8JCVdvNV+WJlbNV/mHjF0y7fYHL0hKn/DJIIT52xyR+0L/7E9l3H1GlLXMdzf2i3
	 V0FQBSF5BBAJCARVILd2Feg8PS+2KhI+7jxvk+f4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1122/1424] Bluetooth: btusb: QCA: Fix populating devcoredump fields on unenabled devices
Date: Sat, 12 Sep 2026 08:59:14 +0200
Message-ID: <20260912065632.427864467@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index 69459a90126df..1edf8674dd108 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -3468,8 +3468,10 @@ static int btusb_setup_qca(struct hci_dev *hdev)
 	if (err < 0)
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



