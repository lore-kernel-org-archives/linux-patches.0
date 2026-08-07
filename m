Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7FD425F988;
	Fri,  7 Aug 2026 15:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116795; cv=none; b=G13b57/JrzoF2/g+knjxdIm9p67C9AqVOYFQJMJpuetR5waSS/dFF8IKGLKxoNAvNxI0IsQibmNuk15Qk0kfiL0q8peSVkMUipks4CpgrZgb05S9Yt4PqQ2PnPSaadLJRLPmIODXIDZor5lswtQDUsRUlBCk/ZKkPZ+YDZ2yNI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116795; c=relaxed/simple;
	bh=AeS4QXGjOSECvblbwtNsMVLV4ewWld7Fy9Mgg87pFyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CutuvqS7k3AnTPgP8nXN4DKm3PnUJIPUOiyj/Nqj9a8Ur+TIEtWlGK2pDV/nLxyJd/9Wpa0biVHUhCTb7/DOCfYLJ2VuN7MVzCh4gTr9Y6fYEscaK6SFv2PQJtEkF0lTCqKFnosWap3da3rGrYlpIJwht6wsBjkIXlsQ0kAgsE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YFOT4T5A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YFOT4T5A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1952E1F000E9;
	Fri,  7 Aug 2026 15:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116794;
	bh=8Yg7HOmy92AeaXIhmOPJMIgYLF51JacIW1TH38M6sg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YFOT4T5AFZ3FVYMupA8kPjSnhQ6wUXc/q/uijm+druyEM3+sZRXG0AxzVgFtAq/TG
	 CSgzTO3etLUOzvgDFDlTmyRL/MF4HjuMDUP1pSYbw4IhgUHoHwk384/hhOXER3ZP/y
	 sR6p4uTav+Ak3nVt1ahAiLUmxeAOhwZQ3CPPCBok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 093/438] hwmon: (ltc4282) Fix reading the minimum alarm voltage
Date: Fri,  7 Aug 2026 16:34:49 +0200
Message-ID: <20260807143429.974504419@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index b9084424160d6..bdbf370233d71 100644
--- a/drivers/hwmon/ltc4282.c
+++ b/drivers/hwmon/ltc4282.c
@@ -375,8 +375,8 @@ static int ltc4282_read_in(struct ltc4282_state *st, u32 attr, long *val,
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



