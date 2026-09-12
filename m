Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB8E47277D;
	Sat, 12 Sep 2026 11:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211119; cv=none; b=NGcXnbTN8ZduQLOTRRbcs+u0yVgROFGYoPiLGPbZDgiymwiYYuEfr+n6y8PTrXjWdhu2AHzH7yPyQlRIANOWZoC5Jaf199Th0Z+R6Pl02Rz2ZHRQOLT4goREJyN0XayJZON9Q2uFfOO9ndHH72dL4dzm8BUvlCarr9eFQ9NEBmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211119; c=relaxed/simple;
	bh=HD/yn477AAZFCHZcUMHnyQcIXBlui1sLtcyp+a6iqog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D5utK1y37/52YxprwYjZOnfBjYnhQkhL0QaifTgF4eDvpPXnZr2v7E0Flfu7h3EIQJbn8KvSTzOhL/PNv+Z+XJH8v4LVujhAC1D7kDByeZVXcHOW9DFpqKSxGD6Ghy1oItPLGt4j6lz6gTvXjVT+SZUhiQ3AOSncw/C2GsMQxzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mlit2hBj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mlit2hBj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 190831F000FF;
	Sat, 12 Sep 2026 11:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211118;
	bh=2NSmcb42Ppd3MXNZNMwa18KrrEDKCurUdH1hWs1FhVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mlit2hBj7e3bn87y2vqyIr3ynwfOn22CAUcNWYPP9lGI6fiwxUAyHtuZqe1YJQy0x
	 SH1NOHlHLkJzqcosUAGEgLO1IRjD1uvyLRO8rMy2fMp5ySYE8nStFEgTxbdPc9XeUX
	 ddb4OmZ79rtqUDfWRjtPzHp3+ovaxRfilvEyBlHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrik Grimler <henrik.grimler@axis.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1166/1518] power: supply: bq27xxx: bq28z610: fix invalid AverageEnergy address
Date: Sat, 12 Sep 2026 08:55:35 +0200
Message-ID: <20260912065649.840762763@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Henrik Grimler <henrik.grimler@axis.com>

[ Upstream commit e9387e9ab5121f330d313afb90430c02200f9782 ]

bq28z610 currently uses the AveragePower reg, 0x22, for reading both
AveragePower and AvailableEnergy. The technical reference manual does
not mention AvailableEnergy, and it does not make sense to read a
cumulative, always positive, property like AvailableEnergy from a rate
property like AveragePower. Set REG_AE as invalid to fix it.

Fixes: 707d678a5c7c ("power: supply: bq27xxx_battery: Add the BQ28z610 Battery monitor")
Signed-off-by: Henrik Grimler <henrik.grimler@axis.com>
Link: https://patch.msgid.link/20260811-bq27z746-v1-4-3a4fa38205cc@axis.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq27xxx_battery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/bq27xxx_battery.c b/drivers/power/supply/bq27xxx_battery.c
index e72a9d8399858..dab655a1cc20d 100644
--- a/drivers/power/supply/bq27xxx_battery.c
+++ b/drivers/power/supply/bq27xxx_battery.c
@@ -516,7 +516,7 @@ static u8
 		[BQ27XXX_REG_RC] = 0x10,
 		[BQ27XXX_REG_FCC] = 0x12,
 		[BQ27XXX_REG_CYCT] = 0x2a,
-		[BQ27XXX_REG_AE] = 0x22,
+		[BQ27XXX_REG_AE] = INVALID_REG_ADDR,
 		[BQ27XXX_REG_SOC] = 0x2c,
 		[BQ27XXX_REG_DCAP] = 0x3c,
 		[BQ27XXX_REG_AP] = 0x22,
-- 
2.53.0



