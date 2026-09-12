Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2FC37E2F3;
	Sat, 12 Sep 2026 19:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241380; cv=none; b=kbZc/dP/JwEsFQfsaoZiPS0HwvnE78N3zpzvrB4Bg3rUbYtK0lKvW3BevGHr3VDwJ4cj4Cd/1Otx64K8SGECru/343soXOqxgjH6RIJ4QNWO0hVl6vwvHWyeRLBkEgn1qp838+QUg/qKPcL5BmmdmmPHyuvDyzk0rAuEA87Kw8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241380; c=relaxed/simple;
	bh=KD+F4yqWvieh1WP9IVOeHo7U8YjJpsyYkVlXZR6ad5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DIOBisl1PkCkJZ7cPMq0h3XjpFvRPPFcDVcG8/Z47ptNeTU3KElP/OENqiFUkWEVivR3teK6HuwJvj4SduEZLK2Da7PKWSiQSFMk4FdJvAtM0INx1SwphNzOWvNGk5lu3Aoafp9D32Aj4jSRFBHqxJtrqUYsf/Hw7GXEOBqii5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bZDFPpIW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bZDFPpIW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B412C1F000FF;
	Sat, 12 Sep 2026 19:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241379;
	bh=1wB3r87ZRzuNOqtV9NxWGxI3pJONwaTRhDuYNv8mZR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bZDFPpIWWmDJ8gSxVsYkjYSCQ+bORi2FE5nhp0qQhR0Xa7k81FiKWyj9106VDmT7E
	 hHMHcEBnMuytWexY++vrb5+MCeIY563AMidfKVJkgSF1LSIBPAgZY+iIZNcEF4ZdGD
	 MelaDPAppY+0n4BxwJmFk+D2FC/hqlur2zc1pKGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.10 124/798] hwmon: (max6621) fix negative temperature offset and crit readings
Date: Sat, 12 Sep 2026 08:55:52 +0200
Message-ID: <20260912065519.817351677@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


