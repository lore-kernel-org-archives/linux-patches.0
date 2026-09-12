Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A2B317145;
	Sat, 12 Sep 2026 15:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227343; cv=none; b=Wkze/Bs/RuoxiAAfzu0i/PEAYPx+PDf69U9ahHzUT/ZYWfJvR/MWKa1s5ZJYKCXxY2zOmihehDIVTvsSKnxC98nZybDEfV2zCwEBB7VzhBSBsat0vnuhvmtOdLgzV8MLtKAcqrwgtcn33zEe/xIOvbnqXHykVvZGkXOJxttQRQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227343; c=relaxed/simple;
	bh=A/X92JwwH3WfG8G4v9e6sjTx2VeJw8cEGFUDhx5t9lU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ijUn0EgWD4X9hvYskW332bb8eBbgy6R0iMlTgLuza4wDJVq8kOyrPoFrCsaVCx2K/AReVZfZTkb9Ewz3jbSfxMaRg/+qNltPOVn7/cHCd8WD/WwqhDtXtXokz6LUWvQbi0d3y4pJZW3GdVccmcuaVPC8UKH0LPBVD/X2EQgdgU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sc2n9/qP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sc2n9/qP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F39C1F000FF;
	Sat, 12 Sep 2026 15:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227342;
	bh=d7X1pJkp4F7R0jy+rXJwNt/LE2ufuHogn3PIGcJT+GM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sc2n9/qPu875ubc39h9pYnkcb+bXBL6T65Y01B1JkLmeW6z6qxsuN/QZyZSVrmcn1
	 LiF4/Ye5k5V5OiV/60cULjTlw1Exp/nDSHT7OJEx8pRe3MxcoamEDOw+szy9OxtQB8
	 idPorWZjmCoHQkYbDP2oCX8zHHWVOpJUdTc9sugc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.1 0162/1191] hwmon: (max6621) fix temperature clamp range
Date: Sat, 12 Sep 2026 08:48:10 +0200
Message-ID: <20260912065551.852664635@linuxfoundation.org>
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


