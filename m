Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77ED8311C07;
	Fri,  7 Aug 2026 14:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113898; cv=none; b=CLcszEZkVB0v9nzOHWQxxH/bfyVesj5czghFV68+Qf/CrQGlMzcVt13p33ufi476K8SWNvlBZIGyPr3DQmzOBSUU9jq36Oj4Q3O/SiDJoLgyGqARoCrTDcDA/ZlOuNHZBrkrZEWGBpI8sS787enehju1sGugzoXSJ/ikdy6cyM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113898; c=relaxed/simple;
	bh=o/UGe4CSwtdnzRQry2mGlAHW7LcfFSoIASWCV0Cg1SQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PuIMfIuX9H+XALNV005rpYuuarNXWSEIP3tdUzhAHXcqAUleuZP5VAu19BacvHiWJy2AAbD6f98zBjRSZNXS07lHj8quae38Wrki83n0it6yBiT16FYE5aMjo03sHH9wAG3HWRQ2nA7l2dl4ddDkwqq1c+Ypas3e0Ud6FyBEmlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F2fndR6h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F2fndR6h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B6D11F00A3D;
	Fri,  7 Aug 2026 14:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113888;
	bh=oX7axwZhS3aDTbmWxy3zbfg796Sg0o774lUd987uAL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F2fndR6h5glI6kIG97wpyh6/k18i6HZ0zccp3mp/DIN52zclgWEoDyrq6FGj5gidA
	 43oJLZB36kp/CUUffBU9af5gPEQZ5MTU/b/AG8N+BJrysmm9jv4adfXGSR6qzn51HT
	 /hEtTvvCTitbHQiAogTbhF7KDdA3t/8Q7SLHeqQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 068/337] hwmon: (ltc4282) Fix reading the minimum alarm voltage
Date: Fri,  7 Aug 2026 16:34:31 +0200
Message-ID: <20260807143419.986775831@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 00feb1cce93dab948a299b69753d99c681d45a0b ]

Coverity reports an out-of-bounds access when reading the minimum alarm
voltage for the VGPIO channel. Add the missing return statement to fix
the problem.

Fixes: cbc29538dbf7 ("hwmon: Add driver for LTC4282")
Cc: Nuno Sa <nuno.sa@analog.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ltc4282.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/ltc4282.c b/drivers/hwmon/ltc4282.c
index d98c57918ce33..e1c0d02b564b7 100644
--- a/drivers/hwmon/ltc4282.c
+++ b/drivers/hwmon/ltc4282.c
@@ -382,8 +382,8 @@ static int ltc4282_read_in(struct ltc4282_state *st, u32 attr, long *val,
 						   channel, val);
 	case hwmon_in_min_alarm:
 		if (channel == LTC4282_CHAN_VGPIO)
-			ltc4282_read_alarm(st, LTC4282_ADC_ALERT_LOG,
-					   LTC4282_GPIO_ALARM_L_MASK, val);
+			return ltc4282_read_alarm(st, LTC4282_ADC_ALERT_LOG,
+						  LTC4282_GPIO_ALARM_L_MASK, val);
 
 		return ltc4282_vdd_source_read_alm(st,
 						   LTC4282_VSOURCE_ALARM_L_MASK,
-- 
2.53.0



