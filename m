Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0363624BC;
	Sat, 12 Sep 2026 09:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203715; cv=none; b=s65ypy0Y3ck7fXwSgLyWOrcfnyuVmWd0Dr+GcpA/lWFuAiozgOeleupi1h1HYWsuUtuTdw8sF2DigdWjJpTQiuqbHpQVir+/N2SFCy9/iYIlviuSlORD79/vK2xjBjegXVKZ9qziEJyCyUsdSWiY4KBOSkPAK4iqJMMsXepACMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203715; c=relaxed/simple;
	bh=Zew26fawzUerwHcv8N9tyRoJ13KOXiYEB3TlpTyuBbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qMFC46QIHbF0asagrKR3vVqo+BfITy9W8iL3U5wO9pR9z+EO4FCrCXWbFlSvDQuccFTqx2VzcQZIUYCQMJ5v+lvEXLXkJLN4ODm44jXTrahtjkX5yxK5pi/iJnG6iTf9zsPRco1qqm/iKxvFGLiudAICOQaJVLZKOOkP6MjXMWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uTEHSFPx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uTEHSFPx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3DD81F00893;
	Sat, 12 Sep 2026 09:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203714;
	bh=mbZzwi+uW1RnrEK2uW/CkTx2DCsjj53HRfZb0ds9elc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uTEHSFPxcsZ2689apRRQZflsSDkF/JgfgwHIZDUcOIUjYvVs48vziXjditgrBJxeY
	 lrbEdLBM9ISL3I2V/M6uDM+y0xVqpUPv+d2Ji00CKkTXx0HEsQqRojguZeSMUEaLsB
	 clsR5ypYcXYPSOKIAbZp2qCDh1bHv5lcEI2nm+0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrik Grimler <henrik.grimler@axis.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1421/1815] power: supply: bq27xxx: bq28z610: fix invalid AverageEnergy address
Date: Sat, 12 Sep 2026 08:52:51 +0200
Message-ID: <20260912065722.378298619@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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



