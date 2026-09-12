Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D59423A72;
	Sat, 12 Sep 2026 12:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217686; cv=none; b=ET4h6ycsG5FqkX7b4WXXiDwS0cVOtADj48DQXxJCt2nxef+vxxC8hMhkZIT5SZwZLZbSGgnlF2H1aeZDtfysPgCz8aQzvvLfN+IgRky0IG+d2zCTYuyRz6bvEowaKJRuYtJvwy6v+copSnC54z+T9DmdZ7E1o7M2SljYbNLdzpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217686; c=relaxed/simple;
	bh=kFszH02Crno45c2L+DE/Q6dOIxqF8lloj9hj12BkcxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DfnQDqCmPajDjJOPl4BYXSzXsA+/MbIiRs/gdLg7wmfVLpVqSO+4SY1c5bIx+DF9zC+4cv9rWheLpgvMoFixtLPTeaWotPmeW3N+flVp+vvk3NbFP4VxF9D5RVpjx+sQZ8xerLOWSTmLPom9jygqTvVgbibgUa3Y+QNpDNIjhcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i++ZHJoB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i++ZHJoB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4F251F000FF;
	Sat, 12 Sep 2026 12:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217685;
	bh=YXQDsciz9T4nFEJhD4q+Mfb0bVgQZH5GCQHNaTwh4tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i++ZHJoB9wDcm/lXihumMPf7P2hD2bWgPOhQRjPD3PG4QYLQ8usiWejdSOTaOKysQ
	 +1a5qmLt/x5Kz8kAfphHOGUE4f4Z7LH2xC36H7ernV53Gb63lXr+Try7VrnTGmAJvF
	 OpaPBLwT6D7cbYGlgg0ZJLjAEO4OgjGdvziHv9G4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0973/1376] Bluetooth: btusb: QCA: Fix populating devcoredump fields on unenabled devices
Date: Sat, 12 Sep 2026 08:56:39 +0200
Message-ID: <20260912065629.253365598@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index 662c9651cc9db..941f2968bced1 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -3570,8 +3570,10 @@ static int btusb_setup_qca(struct hci_dev *hdev)
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



