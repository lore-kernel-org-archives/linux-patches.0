Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B111FB3;
	Tue, 27 May 2025 17:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368046; cv=none; b=mjcEMqLbrHazvaNmHTCVMHQZS8YWU4ssJ1sKerwQOvxYGqVYgcTQ3Ej1xjZrutOUOccX5AhT7bW8DQo6ZkWzxVLmYMMLc7endkBQ/J1UokGIUXqTphikCP8AHx+ru+34+/4dvQuyULn/7ZfqBKJ4pqo+mB0pGijDKg+u9Dyft5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368046; c=relaxed/simple;
	bh=D07Mb0/VuBeSBVFeS44qto7e5WdtHkutwiT5Yk5eiYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R9IyyfjBeL2clJGa8Naee6CX22jPy26nLFz2qYfdLJCDuOxkZYchLLZtxJU0RltCQbUcFhOLKcKjMdagpjwmB3ZxKCJM8hLJEerN+pW+ktq6gu8hy+AFfj6bRmtyKKZ4rILg9Js9wRkWPZrA73w9qyD28ybQheowietlwQ8s5ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z8+NhKX3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z8+NhKX3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ADF7C4CEE9;
	Tue, 27 May 2025 17:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368046;
	bh=D07Mb0/VuBeSBVFeS44qto7e5WdtHkutwiT5Yk5eiYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z8+NhKX31mLv+r0HYk4b9m86p2X7kqjAky+/C046Xj3+MULed32YiB1PGlxGmwFGW
	 ApaEbWEK1Z/DvmtdjdcCxHijPqtBgPAmHI/ZpsIyiDpLs2PXVKN2yqkkR0GRQ6NOUH
	 qSEks4JGPuoO499N/s6TQqXicFXRKH06t9oRZy0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 541/783] wifi: rtw88: Fix download_firmware_validate() for RTL8814AU
Date: Tue, 27 May 2025 18:25:38 +0200
Message-ID: <20250527162535.190244166@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index e438405fba566..209b6fc08a73e 100644
--- a/drivers/net/wireless/realtek/rtw88/reg.h
+++ b/drivers/net/wireless/realtek/rtw88/reg.h
@@ -130,6 +130,7 @@
 #define BIT_SHIFT_ROM_PGE	16
 #define BIT_FW_INIT_RDY		BIT(15)
 #define BIT_FW_DW_RDY		BIT(14)
+#define BIT_CPU_CLK_SEL		(BIT(12) | BIT(13))
 #define BIT_RPWM_TOGGLE		BIT(7)
 #define BIT_RAM_DL_SEL		BIT(7)	/* legacy only */
 #define BIT_DMEM_CHKSUM_OK	BIT(6)
@@ -147,7 +148,7 @@
 				 BIT_CHECK_SUM_OK)
 #define FW_READY_LEGACY		(BIT_MCUFWDL_RDY | BIT_FWDL_CHK_RPT |	       \
 				 BIT_WINTINI_RDY | BIT_RAM_DL_SEL)
-#define FW_READY_MASK		0xffff
+#define FW_READY_MASK		(0xffff & ~BIT_CPU_CLK_SEL)
 
 #define REG_MCU_TST_CFG		0x84
 #define VAL_FW_TRIGGER		0x1
-- 
2.39.5



