Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542BD442396;
	Fri,  7 Aug 2026 15:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114872; cv=none; b=vBacvxEH8hUmOJRRvwBK00fNH2Zom6orWcSd8EmWyN8k3WOcGSCpdpfBq0ifunfItmAftEwJPV2LCqaLpsJwoR5/Ho6RO2lOCiTqNglDK2/4lXdD9JkvF7wIwc89Y7wIXHQ2/qMZTUiFwxu0KZAGZ0CY+CxzgmZ2u0x/Eg5QHq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114872; c=relaxed/simple;
	bh=kmR328vifkrjIha7PKWT9QelVoF2f4RdXi3TZhQ1meU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VyC6X38hWOwsVuMoywcGBTF6PoF++MncFBeEoksIbCr9CL2T40Rt/zmLcxf8QUaENdbMh3lS4VVG/xCXwmv3HSo9HvZtzbgBZFKTfjpqSsTHrGWmtpRxoDw47zsQ78FiSPl+Pqwcww6dky5X0cxg2I9ObhsIS5Lq+N02RnZRL5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yRf6RHq4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yRf6RHq4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1D0E1F000E9;
	Fri,  7 Aug 2026 15:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114871;
	bh=7z7Dxqf8IsgYgQvc5FFgMIFhvj766CicZq/rVSE9hOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yRf6RHq4EMJCmasm9qMRUc4NLUeOaWpXsF03iVlbXV7Mg0NobJOCuofANM6OwKGYd
	 rjhoQTRbyjgltpJ87/Y8WXpwmDXVlFrh7lKYg9dwPLVjkMlR5U0j/mPPPlfI/4/gCY
	 0joyLJNZEXHW98l4eSX2vouuPDArmCTDpGgwoPl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 076/396] hwmon: (ltc4282) Fix reading the minimum alarm voltage
Date: Fri,  7 Aug 2026 16:33:56 +0200
Message-ID: <20260807143425.906842550@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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
index 58c2d3a624329..4000bcbc7353d 100644
--- a/drivers/hwmon/ltc4282.c
+++ b/drivers/hwmon/ltc4282.c
@@ -384,8 +384,8 @@ static int ltc4282_read_in(struct ltc4282_state *st, u32 attr, long *val,
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



