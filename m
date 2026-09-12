Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CDCC3DD51A;
	Sat, 12 Sep 2026 15:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227338; cv=none; b=HCryD+shK0jdh4OZS81Sxmsp0C6X+78XjOA9AMXCIBYQF4jy96HhNeWGrADXmdnmzpgtGrYhCkLrf+MM/EdX8V4U1G93CZKvP8NnkAgf66m128QznNIYP30rwlKF/woMgzur2Xrrgcil+fGmKD0SjMWnTy+63uq/DP000ky9GhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227338; c=relaxed/simple;
	bh=yrTpQ567AQJwXRmffR8dcXfkujfpyfniRfFGNfQ/Zio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D2prbv9xumIMCuven+Wz4bmRsL0GkCvFMPRrokrcHUgCCvx6i2XlnjWfdv/vyo0BLZsM7rqlVBb42FhZ8BSgcKs2M1WRyfV9uvSDbiSR985u8BsYPFkgqPGoJA9XZ9nzW6jlM8RNht0kyPlReuFrpBEltoG7sRDPGKj0gh9p/0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FU0dtKK4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FU0dtKK4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 848551F00893;
	Sat, 12 Sep 2026 15:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227337;
	bh=4J74ptzsUjQjqh3DdYcHnQMbuy0adE+AGrgAFttcql4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FU0dtKK4ZB+51EM8uQpTkHs4nccnCu/iWmn069ouN3wRxomzu1XNUjeodXkJV18bx
	 ewuun+Eolmbw9lJh9HfnpMSEX5XkZGizWHlcmXJ8NMTIMGesVFALeQskQOW4sDkAK2
	 B6Tk0LiqUy/zs1e/IBG3cTErS+v9UiAiXVPkIdIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.1 0161/1191] hwmon: (max6621) fix negative temperature offset and crit readings
Date: Sat, 12 Sep 2026 08:48:09 +0200
Message-ID: <20260912065551.829189088@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Nguyen <congnt264@gmail.com>

commit acc52bd431e2d8698fae8d82a74ac45d79b62e0a upstream.

max6621_read() reads the CONFIG2 offset and the critical alert threshold
registers into a u32 and scales them without sign extension:

	/* offset */ *val = (regval >> MAX6621_REG_TEMP_SHIFT) * 1000L;
	/* crit   */ *val = regval * 1000L;

Both attributes are writable and their write paths clamp to a negative
minimum and encode negative values, so a value written as negative is read
back as a large positive number. For example, writing a -10 degrees C
offset stores max6621_temp_mc2reg(-10000) = (-10 << 6) = 0xfd80; the read
then computes 0xfd80 >> 6 = 1014 -> 1014000 instead of -10000.

Cast the register value to s16 before scaling so the read preserves the
sign the write path encodes. The temperature input path already uses an s8
intermediate and is left unchanged.

Fixes: 92b64580f14b ("hwmon: (max6621) Add support for Maxim MAX6621 temperature sensor")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4
Signed-off-by: Cong Nguyen <congnt264@gmail.com>
Link: https://lore.kernel.org/r/ad0baddbd6163cf73545c8e9273258136718585c.1786334038.git.congnt264@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/max6621.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/hwmon/max6621.c
+++ b/drivers/hwmon/max6621.c
@@ -239,7 +239,7 @@ max6621_read(struct device *dev, enum hw
 			if (ret)
 				return ret;
 
-			*val = (regval >> MAX6621_REG_TEMP_SHIFT) *
+			*val = ((s16)regval >> MAX6621_REG_TEMP_SHIFT) *
 			       1000L;
 
 			break;
@@ -254,7 +254,7 @@ max6621_read(struct device *dev, enum hw
 			if (ret)
 				return ret;
 
-			*val = regval * 1000L;
+			*val = (s16)regval * 1000L;
 
 			break;
 		case hwmon_temp_crit_alarm:


