Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A133AC17;
	Sat, 12 Sep 2026 15:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225449; cv=none; b=qiJaNFbeBF4ewTbg6CMWj+QgE5H7IS9zrFN+EgqAObzicKOL3Ox6po9j8i8+RXti+hXs8xTi4Zc+G+u9FjFkZkQ8brVqSK5I8gU31WxmB/vCRQgDS6XKdc7OoUeSbY8tMwFDaS6e3bV1oadCELpIUfbtlOkf1MlfFT5iN209dtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225449; c=relaxed/simple;
	bh=RLKexzABgHJZlPQ+YfjOXypy+H3f602JoWXLfIPeEvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EKs7Xm3PcvH65RnLb/0ucht49pf29jpadvc+9UDmeSHfdgPJLQhWqUQyOSBpaJiCpBwW7wFkhkg8f0CRNMEW/Ifl6VZC409AGP13lxa+a0POC4xTk8LfgyAw6fRrSRgbxCG9Gp8XEsy9gFd8o0RTC+Et8Uk1JdZCKNPF4/85IqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t/9nQetI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t/9nQetI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 233221F000FF;
	Sat, 12 Sep 2026 15:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225448;
	bh=F+IzhnyHf6OczihYXpe2Oe9l5MEMQ/G/PGJTFoR/G8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t/9nQetIOK/7imYrLJMREVJ39knEAFy+/fuugTsJrKKH3oO9StuauvKMsRZPgJywt
	 VluLXXKn8ryXTxu+wns3D9brMbyu/uxaJoQm2SXhZMn+Ps9TAD0ttIeUWjTaoi9QG+
	 W/JrxNcOG7N0KqIy/UfPixOPv6kiIIhCeHekmmlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrik Grimler <henrik.grimler@axis.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1200/1424] power: supply: bq27xxx: bq27z561: fix invalid AverageEnergy address
Date: Sat, 12 Sep 2026 09:00:32 +0200
Message-ID: <20260912065634.160168767@linuxfoundation.org>
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
index 07e61697613ab..77c80901910c3 100644
--- a/drivers/power/supply/bq27xxx_battery.c
+++ b/drivers/power/supply/bq27xxx_battery.c
@@ -489,7 +489,7 @@ static u8
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



