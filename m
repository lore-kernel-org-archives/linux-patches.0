Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7421D07B5;
	Wed,  2 Oct 2024 14:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880480; cv=none; b=n0kythA0GF3ULtrFzORTKdoa6sD55k6OpEwG+Oljb9LdVAOTFl4HMhnwhOKDsssZJjv9eQPYFwFOL4c3ZX+KGiInaSDpoosIVdelsUMmF44M+bvQBzC5ZIrzNuA2XT1or0E3NjJSeW9i1LmblcBP9oDajj9S8jOW2Ue4V60EiYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880480; c=relaxed/simple;
	bh=7XvoIITYLlCJWaCjskALd19nq7m6PoAo168WQOWwPU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fBZLwVvGGZXnmSFCRzvqwtfUZ1kHFTmrxUMkpSAfKMka5YYzbdfVNxZk5em9PvQSHsZFLBzPPTDkR1An2UKQhPllR3yo3kwf/g2or/mibyNuExAwtwsvsskV0WjcOwfQjHMfRURVJ7iyLQSfsEeKHTBpdA4y6bM8CiL7ow1cgnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yaS1E7GZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yaS1E7GZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4376BC4CECE;
	Wed,  2 Oct 2024 14:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880480;
	bh=7XvoIITYLlCJWaCjskALd19nq7m6PoAo168WQOWwPU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yaS1E7GZ857RqIbpFYDGyW7Y06WlzbdN9LqjnRPVwzdOYCFAlSSrLIUf3hv5PI7kH
	 Ua27pdCggwRtBjqceIkFU/pqh1eYw4Up6pvQqdEsh/jXXMsFx6V3Y3jysCPIMZTbFK
	 yzZ4wPYWrz6g47T/SsxIaQzx4jqraTPbT+rPhH2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.6 431/538] wifi: rtw88: Fix USB/SDIO devices not transmitting beacons
Date: Wed,  2 Oct 2024 15:01:10 +0200
Message-ID: <20241002125809.451559140@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

commit faa2e484b393c56bc1243dca6676a70bc485f775 upstream.

All USB devices supported by rtw88 have the same problem: they don't
transmit beacons in AP mode. (Some?) SDIO devices are also affected.
The cause appears to be clearing BIT_EN_BCNQ_DL of REG_FWHW_TXQ_CTRL
before uploading the beacon reserved page, so don't clear the bit for
USB and SDIO devices.

Tested with RTL8811CU and RTL8723DU.

Cc: <stable@vger.kernel.org> # 6.6.x
Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/49de73b5-698f-4865-ab63-100e28dfc4a1@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw88/fw.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -1388,10 +1388,12 @@ int rtw_fw_write_data_rsvd_page(struct r
 	val |= BIT_ENSWBCN >> 8;
 	rtw_write8(rtwdev, REG_CR + 1, val);
 
-	val = rtw_read8(rtwdev, REG_FWHW_TXQ_CTRL + 2);
-	bckp[1] = val;
-	val &= ~(BIT_EN_BCNQ_DL >> 16);
-	rtw_write8(rtwdev, REG_FWHW_TXQ_CTRL + 2, val);
+	if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_PCIE) {
+		val = rtw_read8(rtwdev, REG_FWHW_TXQ_CTRL + 2);
+		bckp[1] = val;
+		val &= ~(BIT_EN_BCNQ_DL >> 16);
+		rtw_write8(rtwdev, REG_FWHW_TXQ_CTRL + 2, val);
+	}
 
 	ret = rtw_hci_write_data_rsvd_page(rtwdev, buf, size);
 	if (ret) {
@@ -1416,7 +1418,8 @@ restore:
 	rsvd_pg_head = rtwdev->fifo.rsvd_boundary;
 	rtw_write16(rtwdev, REG_FIFOPAGE_CTRL_2,
 		    rsvd_pg_head | BIT_BCN_VALID_V1);
-	rtw_write8(rtwdev, REG_FWHW_TXQ_CTRL + 2, bckp[1]);
+	if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_PCIE)
+		rtw_write8(rtwdev, REG_FWHW_TXQ_CTRL + 2, bckp[1]);
 	rtw_write8(rtwdev, REG_CR + 1, bckp[0]);
 
 	return ret;


