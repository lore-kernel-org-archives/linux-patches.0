Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066B8313E31
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301124; cv=none; b=iX6pZgSO9Ug+839y7YU8HlJI3Jhz7y2A1gIccq7qPyI2QYDimvJ59z59Aw1FtTa6pd38nVtpyrqYEE853CmC0y4bIK+Xjc0TLXswdgSZqDBS6FfeXF0PGgKQEiiEHn+wDdrQlqzcJ8QVQe+ondolNx9mD/dfgYyUXG7QKQULRnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301124; c=relaxed/simple;
	bh=90Yz9ETtEWWW3Qpkw68abLqTOi2Ea6wZqrj4jVy+bXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mXx9CENqEjA67XVF2tXaXvirBg/FRNQU47FFrddoHdEj84S/uGwoATK1s7ioT5h1Yw646knrF3J2yUpnX9v6khDEmDSF+JPmeJhYBqk6hurVsAUtjtgj4XF6EnY6vt4fZmW/w0kjPEa3sL/qU29puNBS2yHSBn704IxxHlyQSxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=on1zTgEH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="on1zTgEH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A34C116D0;
	Sat, 28 Feb 2026 17:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301123;
	bh=90Yz9ETtEWWW3Qpkw68abLqTOi2Ea6wZqrj4jVy+bXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=on1zTgEHXhPSkuU09M5nai/4fgg/j6Hsin1AhjVlP7bbbdyMlNClUYWLA8FTKiyf9
	 miM1lO0TCosrUC5oDvN6AhL2RYOSce8KJmTIKDIszfpYiC21+Qm4ERrYdmYqtlXoAH
	 X8bVq5eldk6vtZS32qnJSD3R7bQVh+HXPcXp18BgKjy0Y5JEN3iqBS/T5jGaECyl2P
	 TpaiyJGxBfpoOc84/GWPN3QMm2Y8tzl8v+ecOQOHlwXUKuqrdI3IRKTyuzQ0dLDBK/
	 tdSjlQ/yKlp4VrwFr0M7YfkT6Gok5ksmSyGZvkX0/fyY1VDgjJxph20BiD7L6Q65sx
	 thmbJn8Ys5dRg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Dian-Syuan Yang <dian_syuan0116@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 282/752] wifi: rtw89: pci: restore LDO setting after device resume
Date: Sat, 28 Feb 2026 12:39:53 -0500
Message-ID: <20260228174750.1542406-282-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Dian-Syuan Yang <dian_syuan0116@realtek.com>

[ Upstream commit af1e82232b988f8fc6d635c60609765e49221a64 ]

The LDO (Low Dropout Regulator) setting is missing after suspend/resume
in some platforms, and it will cause card loss. Therefore, reconfigure
this setting to avoid it.

Signed-off-by: Dian-Syuan Yang <dian_syuan0116@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260127085036.44060-6-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtw89/pci.c b/drivers/net/wireless/realtek/rtw89/pci.c
index f7be5e7e0a37c..6be1849b0c4d2 100644
--- a/drivers/net/wireless/realtek/rtw89/pci.c
+++ b/drivers/net/wireless/realtek/rtw89/pci.c
@@ -4591,6 +4591,7 @@ static int __maybe_unused rtw89_pci_resume(struct device *dev)
 		rtw89_write32_clr(rtwdev, R_AX_PCIE_PS_CTRL_V1,
 				  B_AX_SEL_REQ_ENTR_L1);
 	}
+	rtw89_pci_hci_ldo(rtwdev);
 	rtw89_pci_l2_hci_ldo(rtwdev);
 
 	rtw89_pci_basic_cfg(rtwdev, true);
-- 
2.51.0

