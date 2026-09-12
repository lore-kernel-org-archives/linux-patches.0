Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2843A9636;
	Sat, 12 Sep 2026 19:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240251; cv=none; b=Dc/Oou+toi3sQGlgEUvndBJ702V7c7gMk2aC3VOYrly7BedABdSn4EjceAMyG8XZlTmhIB3DoafQ8atLU6YGLW3nWsmodJ28KNJ66MWPUnn71E2odPD7s5Ts+rcm+3bjarBCWnCmdnOyAX5RoFL8MTUHpwHx0ku8lzZDE+J1iu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240251; c=relaxed/simple;
	bh=hhN3tx3v+dsHE9iThpJ9lGbHW38rTONLd2h38MgzQgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bAknM3ywuasuFKD5wP9CkTM7ZvpBKaAgsN6azrUVpqiqjqDIGyV/gTAUkVh2ZlCwekhXRn0ccAhGxOLoBCqRYab7kYBK1TbpCyIN0IB9uJnCqMN+vlM8EY1iYFijgaQe4k7GmgEx7lgrg4YvuDguilsAB2oo06hrUHtxtpnA9bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WnhYlheI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WnhYlheI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA321F000FF;
	Sat, 12 Sep 2026 19:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240250;
	bh=GvMdTVyL2haA3J3kSQi/8cY7fYjZjSvUEEO8umuDGI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WnhYlheIfmC8UcPLuDgIqlIUJfMLaFCAe/2jCoUjD2ACSnYqzwuRYNDIqlhysb/2W
	 r2SVrMKxfpYoi1Qag2V17Q1itEaT3LCoDsIAP7OKAhklV/sRm6G03Kxqdb1Z1cQnzz
	 BcgJWMDKR23KkSalMIOb/qTOX3RM2/N5VGVg42V4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrik Grimler <henrik.grimler@axis.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 813/935] power: supply: bq27xxx: bq28z610: fix invalid AverageEnergy address
Date: Sat, 12 Sep 2026 09:04:03 +0200
Message-ID: <20260912065545.484196962@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b365045c2ad8a..00c013b0a77b7 100644
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



