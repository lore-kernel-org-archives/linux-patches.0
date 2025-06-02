Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB22222591;
	Mon,  2 Jun 2025 15:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877036; cv=none; b=G+s3xMxl1YrOlNPsHb49AqGavVYr2Dm91XmAGTEiR0uZ9oY7/+qgqHnJJPP4lEdInRZVetL6c0nn00bXRtOaCKQ0ZAUqV62WUmsn0UvriYD2r58UY1Y+72E2mr+7K9nDctA+aJIXO3A53LzeG5vdCkG51OFO/fSTLhAryeBpYFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877036; c=relaxed/simple;
	bh=c2WgL4sZ9WB8oJg0QyzRlxvmmvdBotDIpJ8yXXjKIc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IITaVrtS/+kSXP8GUtkKiAUTSL1QRWGC7uXOHZ4MxQe85/CTP/rGTxcn8yavjrMO3TAGSq88KOFNP0nDPcpVp/OPRxNb184q+wTSqC8qbD0fPOnpHcFD3inUgmSOqcJIVNjuO6OEahdhWAxkIQOmVo951wJrx0uQOX+BnAg7dGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZqkikEqr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZqkikEqr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4CAC4CEEB;
	Mon,  2 Jun 2025 15:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877036;
	bh=c2WgL4sZ9WB8oJg0QyzRlxvmmvdBotDIpJ8yXXjKIc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZqkikEqrry7xVLD08mVN5N/uB0BXRNlcKBXQhQ18ctrZ0F3NaEhJ0G1HUSYnoD+ou
	 Y3t1etqn7WFWFbgDlHLI/KW2wlaifyMnef5Pzn4LtUxrwPTVesvIe/5XFhZdavns88
	 ahi84fY8j88Plonz3t5NvLFhQ093Fmm7H7ai56O0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 152/325] wifi: rtw89: fw: propagate error code from rtw89_h2c_tx()
Date: Mon,  2 Jun 2025 15:47:08 +0200
Message-ID: <20250602134325.990606982@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1d57a8c5e97df..0f022a5192ac6 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -373,7 +373,6 @@ static int __rtw89_fw_download_hdr(struct rtw89_dev *rtwdev, const u8 *fw, u32 l
 	ret = rtw89_h2c_tx(rtwdev, skb, false);
 	if (ret) {
 		rtw89_err(rtwdev, "failed to send h2c\n");
-		ret = -1;
 		goto fail;
 	}
 
@@ -434,7 +433,6 @@ static int __rtw89_fw_download_main(struct rtw89_dev *rtwdev,
 		ret = rtw89_h2c_tx(rtwdev, skb, true);
 		if (ret) {
 			rtw89_err(rtwdev, "failed to send h2c\n");
-			ret = -1;
 			goto fail;
 		}
 
-- 
2.39.5



