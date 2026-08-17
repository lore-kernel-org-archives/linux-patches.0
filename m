Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE74742AFAD;
	Mon, 17 Aug 2026 14:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978002; cv=none; b=TbR/bdibUdc7WexCrl3ETu/FSFgzj8g5tPlH1mfyA41vDBtrMPdj/nJZXXOPAPtbxc/c/63sUR40hZLQtzqoduiQU2uwIKUVgethhITObUMA8wDIYVeDkyX/J2+eVQ6ZtSkxzSliYSs52vaJVvf0zdTZtcNTEcJUEVtqGZXLEMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978002; c=relaxed/simple;
	bh=j/+Dpot+1PWBUD+kD42qMoGEu0+s4vjYNLX/pPYYe/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VACGCH+DnMaHm5CZ3Sw6CApciJTWh0z2yE7hZanezjpi4d5cLE+wmsoMkJ0czQYIraUcL0GEBhOtYjl4ER0HpQpiyoOiO3/LFPgKrbUb2gGeyaHVSGMqgHdQZSBcUvXN6UJWXR1JSnoki1hXeB82baXLUa/Q9c+A4l4XTFOcy/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=et85IsbP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="et85IsbP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 229D31F000E9;
	Mon, 17 Aug 2026 14:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978001;
	bh=AhJc+8CDpxCt36rduOT8WlG+/rkzYZVq7f6V7x1TGDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=et85IsbPu7C9YYTpkIOlvnGCzReW/eJb8jy/Viwt34lS6JPUY+lkd6HSHqn2+T+jq
	 dhDq79HYDPFtpdw9nHX74pZNOOqtavjedzOG9EZgS6jwCERaKM6zAwwws6ZN4NBb31
	 0/3P3Ku4f+LWro78GxF/OabAbt0RPms0/GJfuYH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Nuno Sa <nuno.sa@analog.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 066/181] hwmon: (ltc4282) Fix parsing adi,current-limit-sense-microvolt
Date: Mon, 17 Aug 2026 15:32:40 +0200
Message-ID: <20260817132538.034212066@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 335698fd7f60b6707b21fda725f97f35fa956b07 ]

ltc4282_parse_dt() evaluates the wrong variable when parsing the current
limit.

When the adi,current-limit-sense-microvolt property is parsed into
st->vsense_max, the subsequent switch statement evaluates the unrelated
val variable instead of st->vsense_max:

drivers/hwmon/ltc4282.c:ltc4282_parse_dt() {
    ...
        ret = device_property_read_u32(dev, "adi,current-limit-sense-microvolt",
                                       &st->vsense_max);
        if (!ret) {
                int reg_val;

                switch (val) {
                case 12500:
                        reg_val = 0;
                        break;
    ...
}

Because val holds a small integer representing vin_mode (from 0 to 3), it
never matches any of the valid current limit cases.

This causes it to always fall through to the default error case, return
-EINVAL, and aborts probe initialization for any device tree using this
property.

Validate st->vsense_max instead to fix the problem.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: cbc29538dbf7d ("hwmon: Add driver for LTC4282")
Cc: Nuno Sa <nuno.sa@analog.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ltc4282.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/ltc4282.c b/drivers/hwmon/ltc4282.c
index 0e7449db3158f..5f7ab813051c8 100644
--- a/drivers/hwmon/ltc4282.c
+++ b/drivers/hwmon/ltc4282.c
@@ -1425,7 +1425,7 @@ static int ltc4282_setup(struct ltc4282_state *st, struct device *dev)
 	if (!ret) {
 		int reg_val;
 
-		switch (val) {
+		switch (st->vsense_max) {
 		case 12500:
 			reg_val = 0;
 			break;
-- 
2.53.0



