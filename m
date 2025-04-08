Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BFA42698A0;
	Tue,  8 Apr 2025 11:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113527; cv=none; b=eSOm7OtaUMuvQo2CkBXQAf3hTp4/x3Dlvjr7GOzyA83nRMCYeDLeZC13wzeA0VFCrxdfN7pW/F6sN5a6qQ/dONVTxFTsJQReK1jXCtiFKFQPZN1DdE3PzTO9WXU0aYOV5N5jxPvrJH5uNE1A3OWbbeq9HVcEFs9NvjzGxXaxkqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113527; c=relaxed/simple;
	bh=WZZUCc8gWV7etO9TZZp6BJlC+Jvl4dxznHag4WGWaPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uIsNJ4Ug2rmc4qgfkuTSNAAVsfc8gn1mVXC9f3rNtJND/oZoJ2z7Fc00VSNASq3B2BL4rWPyGoejU4pQxEL/8NfHSx61ftYRPpz5IJDB4tPNQGVOENdb+630CHHxEIs74qlnVlodC+WkWgvhwKEJ2Ajrqv/Gum5kWZR5zj3T9t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ta+Dyx/h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ta+Dyx/h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B222C4CEE5;
	Tue,  8 Apr 2025 11:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113526;
	bh=WZZUCc8gWV7etO9TZZp6BJlC+Jvl4dxznHag4WGWaPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ta+Dyx/hK9rjvyB5vctC+hbmbffav8g8kjqqx88XOiPrV+Dl/ToUo/jOdVN2i+270
	 ZBa5R+qiKxbQXdzjLKEu//06bkeiCsYYnPMWz4wrsPYPS46EvQCCCzeKen/E7FSH5o
	 2/3/ZTcjrMlveH1aNC1dvjpYOIntAdnLscHo86rI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tasos Sahanidis <tasos@tasossah.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 190/268] hwmon: (nct6775-core) Fix out of bounds access for NCT679{8,9}
Date: Tue,  8 Apr 2025 12:50:01 +0200
Message-ID: <20250408104833.680491860@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

From: Tasos Sahanidis <tasos@tasossah.com>

[ Upstream commit 815f80ad20b63830949a77c816e35395d5d55144 ]

pwm_num is set to 7 for these chips, but NCT6776_REG_PWM_MODE and
NCT6776_PWM_MODE_MASK only contain 6 values.

Fix this by adding another 0 to the end of each array.

Signed-off-by: Tasos Sahanidis <tasos@tasossah.com>
Link: https://lore.kernel.org/r/20250312030832.106475-1-tasos@tasossah.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/nct6775-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/nct6775-core.c b/drivers/hwmon/nct6775-core.c
index 16f6b7ba2a5de..da4c3425d2d1d 100644
--- a/drivers/hwmon/nct6775-core.c
+++ b/drivers/hwmon/nct6775-core.c
@@ -273,8 +273,8 @@ static const s8 NCT6776_BEEP_BITS[NUM_BEEP_BITS] = {
 static const u16 NCT6776_REG_TOLERANCE_H[] = {
 	0x10c, 0x20c, 0x30c, 0x80c, 0x90c, 0xa0c, 0xb0c };
 
-static const u8 NCT6776_REG_PWM_MODE[] = { 0x04, 0, 0, 0, 0, 0 };
-static const u8 NCT6776_PWM_MODE_MASK[] = { 0x01, 0, 0, 0, 0, 0 };
+static const u8 NCT6776_REG_PWM_MODE[] = { 0x04, 0, 0, 0, 0, 0, 0 };
+static const u8 NCT6776_PWM_MODE_MASK[] = { 0x01, 0, 0, 0, 0, 0, 0 };
 
 static const u16 NCT6776_REG_FAN_MIN[] = {
 	0x63a, 0x63c, 0x63e, 0x640, 0x642, 0x64a, 0x64c };
-- 
2.39.5



