Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993F12F617C;
	Sat, 12 Sep 2026 19:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241385; cv=none; b=Jkex912wC2oyepr+BeWUOu6X/57gWlm9AQZKD2aXz8yjCiG/f3eWpB76ZVMOLgH5CWaIQ8Z/+VNj8ffnO7pMpQ55WoTYOlJFYFKptr2LObPLIWOV9IIP0kMbp/+jkm9EF6rBgDuiGP4pneBlCu333pba4nb/XB6zfCsz5F3F2Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241385; c=relaxed/simple;
	bh=QGWL/8h+qS77+3beIe721a5QomtFbXIAhFlErx/EJss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iKjXmNIkVntHQ2ARhJyeMLSuZMmK+3VncbmuIRvIIHP/KOytrv14M8Tzlyk510albH2tJl0s1E6uvWYrj6EyJou6NSHjN2s4hV/cH2JbLgcgBvvvMmz+lmMaBQCrwjPSyj5eBL2XnoCPwPD7eBeXsEnZBnmHLnhR8D9Lh4iXKik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=noEOLCwj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="noEOLCwj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53CED1F00898;
	Sat, 12 Sep 2026 19:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241384;
	bh=jqouWTnxIpEaVZ4jWxV2CHHhjtlA8hGb/Dw0y0WQM4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=noEOLCwjTL9vR8SFspdis2yuXry5Aft9PIKFSQ9AIVazgdtxg7zs5RkVehoqnmlLe
	 xb82rD2gM441r4IxlPTI0sCm/VXMqeUmL3aJoqAjj2FZRo2KeUYqbThAKidPsaCES2
	 eniiHxRNs30xHan8azj1X7AOA2exh1eXpEUV//mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.10 125/798] hwmon: (max6621) fix temperature clamp range
Date: Sat, 12 Sep 2026 08:55:53 +0200
Message-ID: <20260912065519.839521143@linuxfoundation.org>
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

commit 24fbeb83d9b750a36da42cb835a154d80fd3d495 upstream.

MAX6621_TEMP_INPUT_MIN and MAX6621_TEMP_INPUT_MAX are used to clamp the
writable offset and critical thresholds. They are defined as -127000 and
128000.

The driver decodes the temperature through an s8 and its own comment in
max6621_read() documents an 8-bit two's complement value, whose range is
-128 to +127 degrees C. The current limits therefore reject the valid
-128 degrees C and accept +128 degrees C, which does not fit the 8-bit
range.

Correct the limits to -128000 and 127000.

Fixes: 92b64580f14b ("hwmon: (max6621) Add support for Maxim MAX6621 temperature sensor")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4
Signed-off-by: Cong Nguyen <congnt264@gmail.com>
Link: https://lore.kernel.org/r/9d3a4f1895a47794bb359a2a32fb1ccd6a15812c.1786334038.git.congnt264@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/max6621.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/hwmon/max6621.c
+++ b/drivers/hwmon/max6621.c
@@ -17,8 +17,8 @@
 
 #define MAX6621_DRV_NAME		"max6621"
 #define MAX6621_TEMP_INPUT_REG_NUM	9
-#define MAX6621_TEMP_INPUT_MIN		-127000
-#define MAX6621_TEMP_INPUT_MAX		128000
+#define MAX6621_TEMP_INPUT_MIN		-128000
+#define MAX6621_TEMP_INPUT_MAX		127000
 #define MAX6621_TEMP_ALERT_CHAN_SHIFT	1
 
 #define MAX6621_TEMP_S0D0_REG		0x00


