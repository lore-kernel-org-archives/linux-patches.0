Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2AE220F07C;
	Mon,  2 Jun 2025 14:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873701; cv=none; b=d1YHaAcE9wlBEd/gvjdMBa+OAYoxIU6iMmon0NULos3zgwCn3PjuRXFEYiYatqPhpV8hlb+Tri7clKz9ptkoxbMG8xwqEM7/CviSoPV6zZxemmNLGdD+FdPKEdbrEzcpV2tXOrcwtmlMiQPPOGkmaBwv67uN5DC3ntlnZfwknhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873701; c=relaxed/simple;
	bh=0LtPjYdaK8BVHT57+FAhSH+uAASwLvzjtVVdE4J3dhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RIowSeZSwuZ4PmoWNzu+uepKFhI/+NDL5nG8LDhlVgRkoZ8mscnlv1ZQL5K1Qud0IHfQQg/VRCe3hWPdiRhzToIs0d+qsv+zvOFQFSRhWxBw+bpwbv6WTvdGgaMzKDn8rJahYn3adnvHZ+T0yFqMD9SLclQWiX8sMSvNhJCAkvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gW1T5Fx+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gW1T5Fx+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40871C4CEEB;
	Mon,  2 Jun 2025 14:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873701;
	bh=0LtPjYdaK8BVHT57+FAhSH+uAASwLvzjtVVdE4J3dhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gW1T5Fx+8w+JssgDj+zp1LorfLN9PYG7/5ReS3+37ey+IrXp+lUb11Ifa7fLWUS3/
	 lWYRkdpmTVWh5RE7bT+VXFDFqTCmKGgJz7vsxzgwzI3dSQtTxVrsgtoEtA14Xl4uXx
	 Oyi9in5/or5Px38cIbjUQGE4Mz2z8xanqD0EDmO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 206/444] wifi: rtw89: fw: propagate error code from rtw89_h2c_tx()
Date: Mon,  2 Jun 2025 15:44:30 +0200
Message-ID: <20250602134349.265793272@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 56e1acaa0f80620b8e2c3410db35b4b975782b0a ]

The error code should be propagated to callers during downloading firmware
header and body. Remove unnecessary assignment of -1.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250217064308.43559-4-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/fw.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index a8e2efae6e526..89b0a7970508e 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -755,7 +755,6 @@ static int __rtw89_fw_download_hdr(struct rtw89_dev *rtwdev, const u8 *fw, u32 l
 	ret = rtw89_h2c_tx(rtwdev, skb, false);
 	if (ret) {
 		rtw89_err(rtwdev, "failed to send h2c\n");
-		ret = -1;
 		goto fail;
 	}
 
@@ -816,7 +815,6 @@ static int __rtw89_fw_download_main(struct rtw89_dev *rtwdev,
 		ret = rtw89_h2c_tx(rtwdev, skb, true);
 		if (ret) {
 			rtw89_err(rtwdev, "failed to send h2c\n");
-			ret = -1;
 			goto fail;
 		}
 
-- 
2.39.5



