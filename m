Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38AAC43D501;
	Tue, 21 Jul 2026 22:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671993; cv=none; b=CiAhrxsLsWb16Q+rVR919icYUE8UG3ksm+IuVb8ZpQWc1Z+4PGExU1ndZ6khrWcia6C4VH5d+7m3+S+OCWFjwaa6sKZN+qLIypyAOjrNSKUg3PYs1NEEx9J76y4dkOVIoxx2C8FtkDOFvMdFNDTjgKIIXxdbR97fzU8XYzOT1q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671993; c=relaxed/simple;
	bh=q1x9K4wb2TotbuXCqSPdzldFRS1Ied0tn1ZIKWGp9ms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mHj/BWrzLNR6PgmEG5AeW7wfUq7F8cGv7sABngu0HeqFB7JtwDuLME5sQTplE53j3+kmX7P6mmtL7WRDllwuypQ0oBUZ3Ji6+KUEhsEjH56ZKmxChOND0l3oCgfrKA1lDhV0ix9LWsWXuGTR7nbRgZ6Kap0vCIVEIyoBWrxH1Og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TdWcSZc/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TdWcSZc/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CD541F000E9;
	Tue, 21 Jul 2026 22:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671992;
	bh=YQ7uRp/xKyTrPRbhy3j7XJ7YydL+Z1QlauM63R76XKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TdWcSZc/MyUlneulkQGqH2FfDKuPwqGt/3aAvbB9tcP63mLFyViQJfuICIpjhSR5j
	 +ctzFp3PwWuG6iD3DQRwGwOyXCVVwFpSXH1qWhhXyKJk1zqgzEu7XmJklgCn/4aALR
	 4UsEmfvlNHSrRia9sAobXqgvlc6ZqsW7hZ7frt0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoni Pokusinski <apokusinski01@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 457/843] rtc: abx80x: fix the RTC_VL_CLR clearing all status flags
Date: Tue, 21 Jul 2026 17:21:32 +0200
Message-ID: <20260721152416.311772944@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 651270e5f1e66d..fa5f51d7f527a3 100644
--- a/drivers/rtc/rtc-abx80x.c
+++ b/drivers/rtc/rtc-abx80x.c
@@ -533,7 +533,8 @@ static int abx80x_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
 
 		status &= ~ABX8XX_STATUS_BLF;
 
-		tmp = i2c_smbus_write_byte_data(client, ABX8XX_REG_STATUS, 0);
+		tmp = i2c_smbus_write_byte_data(client, ABX8XX_REG_STATUS,
+						status);
 		if (tmp < 0)
 			return tmp;
 
-- 
2.53.0



