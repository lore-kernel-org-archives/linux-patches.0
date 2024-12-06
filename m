Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54BB207E1E;
	Fri,  6 Dec 2024 15:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497870; cv=none; b=YuL4YlXWQ6VS4/eq8qiexW5jfEI+/dQTKwbK7h/JO0y3dhNGlBpKnJq4GDREeRKoXZoHN4DKxONgdkX5iSC588cwKoApf90U9wscNC3pW/Imq23i6Y2TsIur9GeJIyjOmmV6o4UcSm5zHqi6GYjpN+pCBPFJwth5hcWq+iy/GK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497870; c=relaxed/simple;
	bh=z8oJQnW5opS0eCIwdRX0A6d9qyXLXZOGgibMscyoCJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WrRdHwSoPcnyAM4CZum+hLM+v1pyJi+eyMZHD7IHqiojvO4QO09yX8XJQHify2OLF4XqF17185uxLEL68ohLtL/Dfd9SD1t/+o2gvCDwsREHYdqQ2gjaTDbia+VbB3YG5R/8maQi3jDpyPB9+1c5VRTP+4xLkixCUxyhrJbXLII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PFCS8G5r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PFCS8G5r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0279AC4AF51;
	Fri,  6 Dec 2024 15:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497870;
	bh=z8oJQnW5opS0eCIwdRX0A6d9qyXLXZOGgibMscyoCJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PFCS8G5r4I3TMFUhiOWWATM2kFLeLNH57to65/vo9tPm4P0/fSfKz4HUSAPH16A2c
	 NmKFtPKQnuR/6KBsFprnGiBykNvQDtxxvXZDzwfP71TEE90hM8LPGNVXYEM9wdkIYr
	 MajbL7FV5yKpgvYY7Aqd+jE39INgn9b4v7qaaWSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@maxima.ru>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 386/676] hwmon: (tps23861) Fix reporting of negative temperatures
Date: Fri,  6 Dec 2024 15:33:25 +0100
Message-ID: <20241206143708.422771356@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Murad Masimov <m.masimov@maxima.ru>

[ Upstream commit de2bf507fabba9c0c678cf5ed54beb546f5ca29a ]

Negative temperatures are reported as large positive temperatures
due to missing sign extension from unsigned int to long. Cast unsigned
raw register values to signed before performing the calculations
to fix the problem.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: fff7b8ab2255 ("hwmon: add Texas Instruments TPS23861 driver")
Signed-off-by: Murad Masimov <m.masimov@maxima.ru>
Message-ID: <20241121173604.2021-1-m.masimov@maxima.ru>
[groeck: Updated subject and description]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/tps23861.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/tps23861.c b/drivers/hwmon/tps23861.c
index d33ecbac00d6d..cea34fb9ba582 100644
--- a/drivers/hwmon/tps23861.c
+++ b/drivers/hwmon/tps23861.c
@@ -132,7 +132,7 @@ static int tps23861_read_temp(struct tps23861_data *data, long *val)
 	if (err < 0)
 		return err;
 
-	*val = (regval * TEMPERATURE_LSB) - 20000;
+	*val = ((long)regval * TEMPERATURE_LSB) - 20000;
 
 	return 0;
 }
-- 
2.43.0



