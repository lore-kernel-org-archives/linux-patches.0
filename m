Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF9B2253F2;
	Mon,  2 Jun 2025 15:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877162; cv=none; b=c+ajzWaxsQ8UguQRrswFyIC0MIo3bdICv12p7R6u7qa0pF+EcbfUYhCiQ7toP+UUMjR6dRDhWib/WedoupbwrwVmz0cC/lYEh4iIbV5f2dN1MuhdgbVsm6MdjuH9rHfBYYMiD4euOptqhYTwMpCXPzvzjChpI+21lXaf5CLqXmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877162; c=relaxed/simple;
	bh=X4+6Nu9Ki3wqYglwS56/jms0+ZRwChlgR+Lb/1aJWpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I3SSqOwGcNKXVSk0TKrEAYyeEwmTQTERa/DornHwMSpPKG3d5eMG5gMxbduOh3Rcv4zUhc/Q4adGbpbbLjYmRXv093oEdbfQ+RxqrtRCJ74yNUQtDNJkpnsJI3atylrtPbdtT5ThDdLvOMj0ov3v/LJZnU6eCXpadkwJn+Yfaa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lqsNRoPe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lqsNRoPe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ECBAC4CEEB;
	Mon,  2 Jun 2025 15:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877162;
	bh=X4+6Nu9Ki3wqYglwS56/jms0+ZRwChlgR+Lb/1aJWpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lqsNRoPeIA28XPHl30lvd8TWWUyNdnADQV3UNpOFFqQ4PWZTTEAzxHCYA7N43C9vR
	 i1Q071PtJkEczO30GBLJIXudogOeSAe+1BJTse2c3GNkxTzi3a/ImIR8He7HNOomXS
	 jSBdKYqIFVzxGV9Q8wegmyD2DZSkfe6Bc3yQbBVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 191/325] wifi: rtw88: Fix download_firmware_validate() for RTL8814AU
Date: Mon,  2 Jun 2025 15:47:47 +0200
Message-ID: <20250602134327.567540137@linuxfoundation.org>
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

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

[ Upstream commit 9e8243025cc06abc975c876dffda052073207ab3 ]

After the firmware is uploaded, download_firmware_validate() checks some
bits in REG_MCUFW_CTRL to see if everything went okay. The
RTL8814AU power on sequence sets bits 13 and 12 to 2, which this
function does not expect, so it thinks the firmware upload failed.

Make download_firmware_validate() ignore bits 13 and 12.

Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/049d2887-22fc-47b7-9e59-62627cb525f8@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/reg.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/reg.h b/drivers/net/wireless/realtek/rtw88/reg.h
index 03bd8dc53f72a..08628ba3419da 100644
--- a/drivers/net/wireless/realtek/rtw88/reg.h
+++ b/drivers/net/wireless/realtek/rtw88/reg.h
@@ -107,6 +107,7 @@
 #define BIT_SHIFT_ROM_PGE	16
 #define BIT_FW_INIT_RDY		BIT(15)
 #define BIT_FW_DW_RDY		BIT(14)
+#define BIT_CPU_CLK_SEL		(BIT(12) | BIT(13))
 #define BIT_RPWM_TOGGLE		BIT(7)
 #define BIT_RAM_DL_SEL		BIT(7)	/* legacy only */
 #define BIT_DMEM_CHKSUM_OK	BIT(6)
@@ -124,7 +125,7 @@
 				 BIT_CHECK_SUM_OK)
 #define FW_READY_LEGACY		(BIT_MCUFWDL_RDY | BIT_FWDL_CHK_RPT |	       \
 				 BIT_WINTINI_RDY | BIT_RAM_DL_SEL)
-#define FW_READY_MASK		0xffff
+#define FW_READY_MASK		(0xffff & ~BIT_CPU_CLK_SEL)
 
 #define REG_MCU_TST_CFG		0x84
 #define VAL_FW_TRIGGER		0x1
-- 
2.39.5



