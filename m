Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B9B3A2E39;
	Sat, 12 Sep 2026 20:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243403; cv=none; b=CFXlfJRMewt+X0rlwJJCoCE1s3PJSTIq87cLqtTyP/dnNa7psKByP/oGpUNKCb7rZsssTJKLFVn9yEvFk138OTMLebQ3PP9yEn7nzzOD7QY6vERE3+Vb1yi+OcQC+qqgqgSANjCBBG+IVF1Axc5WOkhXjaZx7UaAum06FPxAs4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243403; c=relaxed/simple;
	bh=hjDqTcbH565rHwHPHtxTXJFV1ikHcmXPk7I9NmTjQKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ljaBHEduEKEWHkmzohp6tdvEPfAPSTDz2wDYo2B6tAKJ6rQuGyWe3lXP2locPxt/XZG8wXNUZuAUX2xxLJObuh0C1F1eze1Q5n0TQQx0Y/Xe/ymfD/UTJZ19A1d1fdpviMJHObG+zWZ3+tat0FZMxsbGjYima5ZE/jawye7o6Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P5vmbDQ6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P5vmbDQ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EB031F000FF;
	Sat, 12 Sep 2026 20:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243401;
	bh=hdyI3S7Hr40Mr7hw0FlJ7RJyrmaSrwjEZrJSW8dfhzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P5vmbDQ6dDgj+tsf9V5IW4ygGPCOJAnlAHZBjd1/n4Stem7A7tfiEpRyx0JX6XGEa
	 zKBcvfqtBFLWMj+NXGshc2KVkO44+u51GoVPm645KOO38CBDn3QsohYHdjivnBs4as
	 hRfgb5QKh0XA0+YXh+EWBUyJnOSbv33c8tHfMhfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrik Grimler <henrik.grimler@axis.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 700/798] power: supply: bq27xxx: bq27z561: fix invalid AverageEnergy address
Date: Sat, 12 Sep 2026 09:05:28 +0200
Message-ID: <20260912065533.137801100@linuxfoundation.org>
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

From: Henrik Grimler <henrik.grimler@axis.com>

[ Upstream commit 2da28b059e0ddcd2e1956eeae383246207965573 ]

bq27z561 currently uses the AveragePower reg, 0x22, for reading both
AveragePower and AvailableEnergy. The technical reference manual does
not mention AvailableEnergy, and it does not make sense to read a
cumulative, always positive, property like AvailableEnergy from a rate
property like AveragePower. Set REG_AE as invalid to fix it.

Fixes: 6f24ff97e323 ("power: supply: bq27xxx_battery: Add the BQ27Z561 Battery monitor")
Signed-off-by: Henrik Grimler <henrik.grimler@axis.com>
Link: https://patch.msgid.link/20260811-bq27z746-v1-5-3a4fa38205cc@axis.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq27xxx_battery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/bq27xxx_battery.c b/drivers/power/supply/bq27xxx_battery.c
index fe4ea314c5bba..f6cad6fb75a9c 100644
--- a/drivers/power/supply/bq27xxx_battery.c
+++ b/drivers/power/supply/bq27xxx_battery.c
@@ -488,7 +488,7 @@ static u8
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



