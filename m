Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BFA3BCD0A;
	Fri,  4 Sep 2026 05:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501374; cv=none; b=V3RBr0hLq4Z2qxbtUSALKh2tYIa8yVQzb4MXuPQVeiemIJ4aUV4kk338e9d6KYrz+LqWOjDHhFkB1EfLq8XHKM985SvKYO2S7D20yllTLpvewJ1T0vR++p0RM4vPGHZON2YoPS5PyF5MsLfmY3+8CXEx/IPdjXYqbP/SdEPTfsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501374; c=relaxed/simple;
	bh=Gz32rTMrtl5zTsoCX/kUW7SKUfKITmwKKHZlmq7P9VQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KnTPqTmgepsROmlQo9AJ8ddFXIqP60xlk7UTZwDK8KcIndTCIpEWQKm+KkjWyW06dA2BDTL3/oNG6zgD6KtaGMSQeR+y16ja9E68+N6aMhE3Y8dHR9FbqJF3oJrB1r0WaQzponIqQ+lxi7KmqX1bhNx4nqlykJM1+0A6LMnKJQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1rbYGPDT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1rbYGPDT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D761F00A3D;
	Fri,  4 Sep 2026 05:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501373;
	bh=69PnInnCVdY73lgcpVB6GR0CZwq+atmBNuPlsk/E7Q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1rbYGPDTcfcDYgc2IMKQwlOshcvoCeDLFe0Uh/QXxq3+V5o+RH/3rmI+wGk5GGOYP
	 0fpkTcog6UGFpe1pYL9mx3X7SDuODNOI2xyDDOSbbfEAKaqcPlcm2EgC1A4Dm19JKe
	 GNlWCBBGCb++bp2j6ZXNez6jvCJUXVlYqqFodyxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 350/552] hwmon: (max6621) fix temperature clamp range
Date: Fri,  4 Sep 2026 06:58:27 +0200
Message-ID: <20260904045758.182634813@linuxfoundation.org>
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


