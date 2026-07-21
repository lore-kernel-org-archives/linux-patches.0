Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1BA2D8376;
	Tue, 21 Jul 2026 20:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666634; cv=none; b=dhZ1g4xISA4MZ2/L5q3rAYgFFL65sGUMpfK33/gaofAVP37jb1XMVGF68dJn+oJbo4Su9+n6CnNb0Ia7uHS7DNNCn+HGccEpIxMVehcM83klqmylSzuC0vn7laN/8AMKx8Buv7ULO0MNuWHTnc4tHOmdAMkFR6HT1uIwLR2hWS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666634; c=relaxed/simple;
	bh=BVMeZZBdkpHdIZMqulmbXPQ4uLwBwteQCx+3LJe85yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D5o1f9tyxK+REdQUDw3DtBUMv63gQruFdKzDVksoSMvLqniw2gmYzea72a5PyZvGwCG5IlSsntUKUNqWXF8SpICoWDuGkA/QSyF5zDgxa2BsSEn2FTYPwZaZD2s+KWbjBXiN4ri2Y7hlhlCPiK+L4WAhU2QrINmwKgqTCxEeefY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fOL0m0n2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fOL0m0n2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BF1A1F000E9;
	Tue, 21 Jul 2026 20:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666633;
	bh=12YLxuvTscbpNIFTNXdVfv/pQ4bGqslcAkPvXp4/f2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fOL0m0n2ba/lFIsSob48LgVq8/Tx2gApUFMm5AMaamEcVOzgrWmAezB5VoWo0H9Cw
	 O0wq4fudbbxDzIc9ZFBZRice3WRcWYjKPUrVRAduF6Prz7CppIDAMqRVWJqrlx8ic5
	 Gf6FMvn3tKmfRfyCiBHxegXE37dK61wzcsYSbUHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoni Pokusinski <apokusinski01@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0757/1266] rtc: abx80x: fix the RTC_VL_CLR clearing all status flags
Date: Tue, 21 Jul 2026 17:19:54 +0200
Message-ID: <20260721152458.807902604@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Antoni Pokusinski <apokusinski01@gmail.com>

[ Upstream commit 419719c514252a2dbb2e2976f564c83417dd6d0a ]

The RTC_VL_CLR ioctl intends to clear only the battery low flag (BLF),
however the current implementation writes 0 to the status register,
clearing all status bits.

Fix this by writing back the masked status value so that only BLF is
cleared, preserving other status flags.

Fixes: ffe1c5a2d427 ("rtc: abx80x: Implement RTC_VL_READ,CLR ioctls")
Signed-off-by: Antoni Pokusinski <apokusinski01@gmail.com>
Link: https://patch.msgid.link/20260415160610.127155-2-apokusinski01@gmail.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-abx80x.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-abx80x.c b/drivers/rtc/rtc-abx80x.c
index 5f3a3e60a19d09..862833519d7f4d 100644
--- a/drivers/rtc/rtc-abx80x.c
+++ b/drivers/rtc/rtc-abx80x.c
@@ -545,7 +545,8 @@ static int abx80x_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
 
 		status &= ~ABX8XX_STATUS_BLF;
 
-		tmp = i2c_smbus_write_byte_data(client, ABX8XX_REG_STATUS, 0);
+		tmp = i2c_smbus_write_byte_data(client, ABX8XX_REG_STATUS,
+						status);
 		if (tmp < 0)
 			return tmp;
 
-- 
2.53.0



