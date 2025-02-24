Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC83117C21C;
	Mon, 24 Feb 2025 14:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408862; cv=none; b=q9NrO/sEqAbSsxK0BYgVCIBBKWIa0Ck6p4ePN2dWJBOrxj8QBM5s86ZTZZd7JD4sDEF3bivtMMn0RInDCfEgN24aPF65O9heAVS+hAr7sw+DyOAFX04+rj1szYwMXTx7GgWdXzkqiHrpgK3K7KGufi+GH/UP756pJCFiLZQmLw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408862; c=relaxed/simple;
	bh=Bg135oZRcWJ+J1LCFxJ1COiIsg/PX5zj3vPSFihlPgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a+R3dJ0HHbxDah4HcIwEEmoF76avJ4/OcGpiaxYL2RxZ9HUGu3XK4DPiblUwB3n57SVqjc8eXUHIC1xUEmZcAcfXalLN8OnFh+4lSXizogkjgBydlEuRU+hGUdFIHxML2eN9iI7ZcaaMyuQGccBpTqpEM51WLbaiXKgRBMBN2u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kuv1z3Bc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kuv1z3Bc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15547C4CED6;
	Mon, 24 Feb 2025 14:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408862;
	bh=Bg135oZRcWJ+J1LCFxJ1COiIsg/PX5zj3vPSFihlPgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kuv1z3Bc75rZv3GCIAnpafzyLk3HxyN5YU64SZ/fKlhD/sDG9YOxcZfXXTEZBHfbS
	 qN2LVEParnvRRhBtuS57mi1w/OnRSgmrpHCGn24i9c15v0ULD1cbqAJyhHi2OagKAH
	 IK7RwL/4l1q6WkuyLms3XmUzhcmc2NOf8nIo6zyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Steev Klimaszewski <steev@kali.org>
Subject: [PATCH 6.13 008/138] Bluetooth: qca: Fix poor RF performance for WCN6855
Date: Mon, 24 Feb 2025 15:33:58 +0100
Message-ID: <20250224142604.782381853@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit a2fad248947d702ed3dcb52b8377c1a3ae201e44 ]

For WCN6855, board ID specific NVM needs to be downloaded once board ID
is available, but the default NVM is always downloaded currently.

The wrong NVM causes poor RF performance, and effects user experience
for several types of laptop with WCN6855 on the market.

Fix by downloading board ID specific NVM if board ID is available.

Fixes: 095327fede00 ("Bluetooth: hci_qca: Add support for QTI Bluetooth chip wcn6855")
Cc: stable@vger.kernel.org # 6.4
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Tested-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Steev Klimaszewski <steev@kali.org> #Thinkpad X13s
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btqca.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/bluetooth/btqca.c b/drivers/bluetooth/btqca.c
index 5cb1fd1a0c7b5..04d02c746ec0f 100644
--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -905,8 +905,9 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
 				 "qca/msnv%02x.bin", rom_ver);
 			break;
 		case QCA_WCN6855:
-			snprintf(config.fwname, sizeof(config.fwname),
-				 "qca/hpnv%02x.bin", rom_ver);
+			qca_read_fw_board_id(hdev, &boardid);
+			qca_get_nvm_name_by_board(config.fwname, sizeof(config.fwname),
+						  "hpnv", soc_type, ver, rom_ver, boardid);
 			break;
 		case QCA_WCN7850:
 			qca_get_nvm_name_by_board(config.fwname, sizeof(config.fwname),
-- 
2.39.5



