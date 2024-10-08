Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FFC5165F08;
	Tue,  8 Oct 2024 12:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389885; cv=none; b=SpvTviG2qYK/8gWdnVp9O2uEtnyygtP1jtxc3Z9Hv1bArgKuSByVSBYjHEHO9LZ/p6qhetqpMO3E3cMeFyxEJf/xQVS447dccpi5ix99iWdu/JDR28xiXgAHACY9Xt3mZNDDfgRed7avWL52sHvZL2bzeuePxlK4KPCwkodS2cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389885; c=relaxed/simple;
	bh=yoX/zKUxWT0aPRb0yOl2pnzvE3bU7mCwY5ZohbTdydk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QstmkTTlWkxP8vwVA49yob3hlipGrqDZqVEc7p8dRBQnsOEN7C7c+rk97/bfEx+rsVjVFuly6fOQ5StdFd+Vdp26F6ls0mWrgMyCwwtAs3UVdJeGOabxZZUzJAP+mctUyexNRHba3n+Xoj5J1rT40HppbLDH4OMAqGu1AC1vM6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wVvUOfF5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wVvUOfF5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9189EC4CEC7;
	Tue,  8 Oct 2024 12:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389885;
	bh=yoX/zKUxWT0aPRb0yOl2pnzvE3bU7mCwY5ZohbTdydk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wVvUOfF5a0drcmbovM8z1/akjfwzaeoUJdhlDPwbMUMHrXMHP5ij8+ujQuwPcHep6
	 9HNoaViW0hKqbX3wVZ01ZmLePfa/eaIk936VxG+6fQBkvCRHNehvTm/sfVgsP1klU3
	 Er6bG2hwKRBNpaK4KZMy4o/tE71R09Qchqi3RJ7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hilda Wu <hildawu@realtek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 094/482] Bluetooth: btrtl: Set msft ext address filter quirk for RTL8852B
Date: Tue,  8 Oct 2024 14:02:37 +0200
Message-ID: <20241008115652.010136542@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

From: Hilda Wu <hildawu@realtek.com>

[ Upstream commit 9a0570948c5def5c59e588dc0e009ed850a1f5a1 ]

For tracking multiple devices concurrently with a condition.
The patch enables the HCI_QUIRK_USE_MSFT_EXT_ADDRESS_FILTER quirk
on RTL8852B controller.

The quirk setting is based on commit 9e14606d8f38 ("Bluetooth: msft:
Extended monitor tracking by address filter")

With this setting, when a pattern monitor detects a device, this
feature issues an address monitor for tracking that device. Let the
original pattern monitor keep monitor new devices.

Signed-off-by: Hilda Wu <hildawu@realtek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btrtl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bluetooth/btrtl.c b/drivers/bluetooth/btrtl.c
index bfcb41a57655f..78b5d44558d73 100644
--- a/drivers/bluetooth/btrtl.c
+++ b/drivers/bluetooth/btrtl.c
@@ -1296,6 +1296,7 @@ void btrtl_set_quirks(struct hci_dev *hdev, struct btrtl_device_info *btrtl_dev)
 			btrealtek_set_flag(hdev, REALTEK_ALT6_CONTINUOUS_TX_CHIP);
 
 		if (btrtl_dev->project_id == CHIP_ID_8852A ||
+		    btrtl_dev->project_id == CHIP_ID_8852B ||
 		    btrtl_dev->project_id == CHIP_ID_8852C)
 			set_bit(HCI_QUIRK_USE_MSFT_EXT_ADDRESS_FILTER, &hdev->quirks);
 
-- 
2.43.0



