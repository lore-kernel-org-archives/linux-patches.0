Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3C71C5799;
	Sat, 12 Sep 2026 15:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225439; cv=none; b=FDOvNculhQC05K2oEJdoTEW/FhvVanleCVv2E77RPLUYHwQ0E+nODsnf04jpMLKd5qgBEcS7LTiy/yr27vgl9Z7ENELakXtKeqdn71BNuuWoqNsgfajLo0qGUI7hOLOZIAi7sVJclmM2pER7AGM7dE3ptNThmfVmFGzi0B13QcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225439; c=relaxed/simple;
	bh=Lch6Vu+yIG9/bvfW+D+WmO/acf8xJZu0Zp4WDK11ARA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HNoPotI+A8h9WRl6fuC1b5Z4RUHNEAaSXH6XechFt7icYrzQE8Ow1f/ntXQ6UqwnjImvmNDCZXgkKesDs2E1gi34lDvYuuCjQs0yJJCFe49igY10Su37biOm8U+8qIkk49WLsTxxwIulStBMKzHdVjXXaEBrRJbG9xhxwC6ofi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MiHKiHRa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MiHKiHRa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 654211F000FF;
	Sat, 12 Sep 2026 15:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225438;
	bh=nUDkO3yQzZCjJixJRe76jmC+GJN5zw5c7pm2jt+5w94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MiHKiHRaj8yLSsdYLqY2iVSpENzdYVLop6LDsGkCJaHmQ4Bmunbxf46Iug0Rljpdm
	 CdeTHqVp8vLF8rkKGAITK87UJeZqUwFi+BIEWjTM3arrViApuYuBuaqodQ7D2drUOS
	 OmC9IpwvsFbMaIwnmIhJWV56wBjHBuBJWqiWKKN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrik Grimler <henrik.grimler@axis.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1199/1424] power: supply: bq27xxx: bq28z610: fix invalid AverageEnergy address
Date: Sat, 12 Sep 2026 09:00:31 +0200
Message-ID: <20260912065634.138342576@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b6eadd6ec87f9..07e61697613ab 100644
--- a/drivers/power/supply/bq27xxx_battery.c
+++ b/drivers/power/supply/bq27xxx_battery.c
@@ -510,7 +510,7 @@ static u8
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



