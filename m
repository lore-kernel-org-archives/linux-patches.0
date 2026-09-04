Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29BED3A5445;
	Fri,  4 Sep 2026 05:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501343; cv=none; b=ZMaMWy0QA3AKK/GhUzQDDm0I1gkxAXNmk4dYeiUMD+LHztEXJNkKGRH49bw9Bxuw2VjE8LO0W8LUwiLrMado6AUaPep6E+3SuvcvDvugLNsWr5k9+TaRMmY7lVJd7NJsITZDBMMFgzPcSxPDqAb4gFNkK2UXrRB+iN1NwRH3vQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501343; c=relaxed/simple;
	bh=DXSeXrhFp1SBZW6B9XedrMXxAjPudvRVNvP95W6g7Bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ub3uuxI4LI93G125nI89jl7YgPl3Fi3xVZbujEbW45cHtvp6r3x1v686VyfpD9WJSFLSyAKERAsp88ZwrXMX0rYpM9eF+FL5N8OQGFEOLPeiVabz2Hhg3XUWJrgTADvLMlJ+WRIPGj8U2SHI+zISfkK1JJZSx/JWkycFxe9fFeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sW/77w0h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sW/77w0h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 831A41F00A3D;
	Fri,  4 Sep 2026 05:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501342;
	bh=yHpH2t/kS5DycaVGBR+b+yzLUllNV5m4/fELuabb6o8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sW/77w0hlTlwl7XTyFIzwcHyxEMm7uR2be50ngcbMX5+BOImPNWFlgyeZzX0O3Api
	 fzpf0Xk7IngpSCxTtp18vRKxkV+07GLCredY5cGTtQQ7BasUuH/FKTIM8i78PM6N8t
	 ETSmpi52jLnqPexDzbZy241SczIdvKE1R6RYuXnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 349/552] hwmon: (max6621) fix negative temperature offset and crit readings
Date: Fri,  4 Sep 2026 06:58:26 +0200
Message-ID: <20260904045758.160777596@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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


