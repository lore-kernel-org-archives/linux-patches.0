Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77ABD29CE9;
	Tue, 21 Jul 2026 18:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657729; cv=none; b=I/OTlIWQ/3og0wf7iaTJW35nJLTt5fvXfk97phTTSkepNsFtN22S553IWELoLI9CHfWZJwSsBtwleVxZXeVeuvk4RkgQjra6G8U4rpWBqN1X6MRGn8Y2v17ZDXzBg0BE3Wesus/te7L761dIXyUrvoNtFT50Ee9HF9ECGdcMsf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657729; c=relaxed/simple;
	bh=zIdKFc0tS9M2F/FcXHj9MCFicFK51awMz522YF4W5u4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DQYBnv6lBwg8HdcgYveGt4toO+niEQXgxjqRpVCC6KbyqE8dD+aUdlDW/nThr5u+NYm94oIB2rg22NOGo2w/zRKijepZIJl9bdj+eDE5kLV/b4FKI6UPGJimVMtA5yesD0oSa+W9Viwc6TtM49IVkFNqpCgAuz6G7MmGH4QZqak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BupCz3G6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BupCz3G6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE6C91F000E9;
	Tue, 21 Jul 2026 18:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657728;
	bh=LasWYjUXUyINc29sBGyJGmZXv3/a9MoT0cXVi1Qms9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BupCz3G6ZC0kb6IIs1Vwd+7fiLscbhAlsOkVf4zSrsIjGUjJoUfHiJY5URtdIndSM
	 UCsCOgpyiAsBY2Dwx0mZoyXUaT0BLa/1GgiWoqFuXNt/1Xd2vihU9mICTBcF1FmmTt
	 dMv/AUtzxGCzRIoHDbAEohQaRv58LZN/oNsAhHlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoni Pokusinski <apokusinski01@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0874/1611] rtc: abx80x: fix the RTC_VL_CLR clearing all status flags
Date: Tue, 21 Jul 2026 17:16:30 +0200
Message-ID: <20260721152535.049891432@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



