Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821AA38398F;
	Sat, 12 Sep 2026 16:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231425; cv=none; b=lkJnXDnuqOIyOwNDVQYcXb4nzXT3VVnMqUIqVatyaCouAmUNz+TBn4mvtZ40pU7o2wZRgfsmqz/Wv4uQ2hfihMA09b2u9dSUrtItg1VYux9VpdaD6ZZIHGFHTPH5FJbd3dEW2xJeQPum1a+OSTGJTZE/h4+pbaSu9qDy+++2KnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231425; c=relaxed/simple;
	bh=gO3u9lpHQmjrnmF4C2+oGwD4KNIIb5WEUNC1JBLz4c0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S47MeN6ICaCDKsOj4aXQyh5XM50t65KglPQjyvrdQwU33aGccD0++z19GQeb4LpaQE2B+0mRr2NfL9urKRafghOWaBgpGV3OUrT5oouzgiS2wLDi++a5biDk8aDBefgFy8q7nhdAfEcIIt2H0iUCo+oN73Iz3MyrMOAWYSORFZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yaRoaNzp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yaRoaNzp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85E6E1F000FF;
	Sat, 12 Sep 2026 16:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231424;
	bh=odi20FgdujVsojmA140cJMy/7CpGDT2AcK8iWvtnaFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yaRoaNzpvqMuh8vCuPRqmebQR2nTZIDCRyyxC6xIok2DU0hE7/hsqbi3JpeSJ921X
	 eZieGguq0OfpagsEQSj2br6X4mvGbZ5pURFFbs3sbxq8Rerq4d+sFvwsoBXNMyUUIx
	 qv2eRh0wJrjH5yZRYHMnJ7MZYZG4MVRpsfZBln4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrik Grimler <henrik.grimler@axis.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0995/1191] power: supply: bq27xxx: bq28z610: fix invalid AverageEnergy address
Date: Sat, 12 Sep 2026 09:02:03 +0200
Message-ID: <20260912065610.550122070@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c0e28c841293e..6b1c07c9cd4cc 100644
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



