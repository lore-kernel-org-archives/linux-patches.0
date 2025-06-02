Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8AD922A4EB;
	Mon,  2 Jun 2025 14:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876296; cv=none; b=MR788JrqV8VFW5OSzo31FpNuAZ/HDKiLg/EXuUlbn8rvOa+Kd8a50AFSdtslhioauY0rc5U4k0vRseLZGcdLBHyQ1JnrtCSDYa1YMPWCaNi9EV/8FtAe3EKwroS9bFQYWR9k81EiH0drxbXw8s/vScxAnienCE1vS+PFz++jLiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876296; c=relaxed/simple;
	bh=AzHCPYd5ALImSLTbhOXK/sf77X85noEBPA35vxJgifE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H8TdgX9gx2AKqMsPOvgKu5z30QZwUM2RngwFQ2/38gubjayIF9NNJZI1GACvCDSWvJwICKx/6QAPse9/g2dnZq2kQu/ZNg+bCV7cjlhywiE6M6jqpqbQAGP5P+nkLttRS2XjNQphvyVRb63m7u4JHI2qx9IaziA2bplPWKM6fPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rjwrrd0O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rjwrrd0O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48FE2C4CEEB;
	Mon,  2 Jun 2025 14:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876295;
	bh=AzHCPYd5ALImSLTbhOXK/sf77X85noEBPA35vxJgifE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rjwrrd0OnIIkgnogHBXoLPkU7kOE4fJR9oKonOQWW2zro70AIw8gCP3QMqESJBkkH
	 DzlZORN951MDUS0PFYTofn8mCqdEqyWTp5hRfaUCOV4W/PTwzsDBegRcJv7gZPUEvX
	 ZbevgfR5KxBb1YlcURIkxCQzAnLBGJvI9O1HcGgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 133/207] wifi: rtw88: Fix download_firmware_validate() for RTL8814AU
Date: Mon,  2 Jun 2025 15:48:25 +0200
Message-ID: <20250602134303.930419181@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c0fb1e446245f..3e5bd64bc09c0 100644
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



