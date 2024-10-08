Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18BF91DED48;
	Tue,  8 Oct 2024 12:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391451; cv=none; b=JxhG9xRhGHXTTgM8bUkV5FAbL06vVwieZaN1rZ0tUBAjQf97RiThbnFOBFPt3KULkmeVZP71Kw4FbdTLm85j0X9aLAUW860PH4j/c37wUMCPPNJvmXFW3/qV8Sj/CM/c84N2MVUuFBEaTvLb6PKL5V/FDi5TcH8ra5lghXC20k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391451; c=relaxed/simple;
	bh=3h8idDvvSwdhk2A9PWCv3McY/VVEm3AUvQL+zWZwlG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f/OMUrlHAWw+CFgpAoPu3fr3Z3o5Y+tVHJyu5NhC9vanRufEATVjqXT/0LSprcEFtj3mxvsLk0MI6EX7RJb5SwjZSFNC5L4fJUH7svdEWcTdmoQVucDTkXkYC14pyPVyrjWtRzGiSNzQ0z9kh4h1Z7YUEairyayfFVCWrRRa/no=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nUnVvqJM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nUnVvqJM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E55C4CEC7;
	Tue,  8 Oct 2024 12:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391451;
	bh=3h8idDvvSwdhk2A9PWCv3McY/VVEm3AUvQL+zWZwlG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nUnVvqJMc4CxjkMw23D7n1ww1QqXw/Q34PeyUp7vSyGnvq3a8na0Lxl1Qkuim5C3W
	 LUrIzKriNQaFr3nNeE33drO22TLGQPEDy2HZyd68gV3+MJIbVDUEOFBOkMy+EAeLIT
	 b4lSVOeMbqsUuCbej30YWGdpZ5RGh87uLkOXp8bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 119/558] wifi: rtw89: 885xb: reset IDMEM mode to prevent download firmware failure
Date: Tue,  8 Oct 2024 14:02:29 +0200
Message-ID: <20241008115707.049409427@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 80fb81bb46a57daedd5decbcc253ea48428a254e ]

For different firmware type, it could change IDMEM mode, so reset it to
default to avoid encountering error for RTL8851B/RTL8852B/RTL8852BT
if that kind of firmware was downloaded before.

    rtw89_8851be 0000:02:00.0: Firmware version 0.29.41.3, cmd version 0, type 5
    rtw89_8851be 0000:02:00.0: Firmware version 0.29.41.3, cmd version 0, type 3
    rtw89_8851be 0000:02:00.0: MAC has already powered on
    rtw89_8851be 0000:02:00.0: fw security fail
    rtw89_8851be 0000:02:00.0: download firmware fail
    rtw89_8851be 0000:02:00.0: [ERR]fwdl 0x1E0 = 0x62
    rtw89_8851be 0000:02:00.0: [ERR]fwdl 0x83F2 = 0x8
    rtw89_8851be 0000:02:00.0: [ERR]fw PC = 0xb892f51c
    rtw89_8851be 0000:02:00.0: [ERR]fw PC = 0xb892f524
    rtw89_8851be 0000:02:00.0: [ERR]fw PC = 0xb892f51c
    rtw89_8851be 0000:02:00.0: [ERR]fw PC = 0xb892f500
    rtw89_8851be 0000:02:00.0: [ERR]fw PC = 0xb892f51c
    rtw89_8851be 0000:02:00.0: [ERR]fw PC = 0xb892f53c
    rtw89_8851be 0000:02:00.0: [ERR]fw PC = 0xb892f520
    rtw89_8851be 0000:02:00.0: [ERR]fw PC = 0xb892f520
    rtw89_8851be 0000:02:00.0: [ERR]fw PC = 0xb892f508
    rtw89_8851be 0000:02:00.0: [ERR]fw PC = 0xb892f534
    rtw89_8851be 0000:02:00.0: [ERR]fw PC = 0xb892f520
    rtw89_8851be 0000:02:00.0: [ERR]fw PC = 0xb892f534
    rtw89_8851be 0000:02:00.0: [ERR]fw PC = 0xb892f508
    rtw89_8851be 0000:02:00.0: [ERR]fw PC = 0xb892f53c
    rtw89_8851be 0000:02:00.0: [ERR]fw PC = 0xb892f524
    rtw89_8851be 0000:02:00.0: failed to setup chip information
    rtw89_8851be: probe of 0000:02:00.0 failed with error -16

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20240724052626.12774-4-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/mac.c b/drivers/net/wireless/realtek/rtw89/mac.c
index 9a4f23d83bf2a..5c07db4f471d6 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.c
+++ b/drivers/net/wireless/realtek/rtw89/mac.c
@@ -3788,7 +3788,7 @@ static int rtw89_mac_enable_cpu_ax(struct rtw89_dev *rtwdev, u8 boot_reason,
 
 	rtw89_write32(rtwdev, R_AX_WCPU_FW_CTRL, val);
 
-	if (rtwdev->chip->chip_id == RTL8852B)
+	if (rtw89_is_rtl885xb(rtwdev))
 		rtw89_write32_mask(rtwdev, R_AX_SEC_CTRL,
 				   B_AX_SEC_IDMEM_SIZE_CONFIG_MASK, 0x2);
 
-- 
2.43.0



