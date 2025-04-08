Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101AB26B2D2;
	Tue,  8 Apr 2025 12:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114733; cv=none; b=C36VGMwsZa8GVMrQu6c0yR94+V/Qc30V13RfJpPEo3ErEmtMR19zcgEVSRqhITywnHElckiFSdtQjmKq5ZMkEGW8O/5mrdgpf0azZkQN8uzKoMm1kchUHitCz0r5Q8b/6lemwqcciZD1EmF58rFxU4u7CUGn57wF9WRWHsWe4EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114733; c=relaxed/simple;
	bh=4YS1wNDACdKNS9YZUR0lnzEDbs6Mb8kojZwXYb1xHhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z0Lf23UsgdXw2Hs3nluAq5JBRn0rZpqZsWAjfdiRmg8W8s/X9BoSW15+iQGodqVXilsKRzFK81yBmXwFwHy+zQEUWM08UuZNGLC0GWq9N+nl1Pw8q6mzpZXcZQw9n391ncpdR54jbk9bqlPxPpsSsEUbSGebwXP+F7pAIgMLL8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tRyaM1IP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tRyaM1IP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9178FC4CEE5;
	Tue,  8 Apr 2025 12:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114732;
	bh=4YS1wNDACdKNS9YZUR0lnzEDbs6Mb8kojZwXYb1xHhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tRyaM1IPuZU9lPtiJ0H5IwDNEzRk3wov8zvoRtOZwHaleOdGkFunBBYbQO688CYou
	 6u0OZ/DOaghfzHLhUIyNWCWihtRRQ6Ocw+4qdVH12iQKdNyV5VyzXYR8zqCn3lEzzP
	 3MVAeKCzBHf+cAvxDmii9toaj+rKDAI9bG5r/mDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Sicelo A. Mhlongo" <absicsz@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 166/499] power: supply: bq27xxx_battery: do not update cached flags prematurely
Date: Tue,  8 Apr 2025 12:46:18 +0200
Message-ID: <20250408104855.322374950@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sicelo A. Mhlongo <absicsz@gmail.com>

[ Upstream commit 45291874a762dbb12a619dc2efaf84598859007a ]

Commit 243f8ffc883a1 ("power: supply: bq27xxx_battery: Notify also about
status changes") intended to notify userspace when the status changes,
based on the flags register. However, the cached state is updated too
early, before the flags are tested for any changes. Remove the premature
update.

Fixes: 243f8ffc883a1 ("power: supply: bq27xxx_battery: Notify also about status changes")
Signed-off-by: Sicelo A. Mhlongo <absicsz@gmail.com>
Link: https://lore.kernel.org/r/20241125152945.47937-1-absicsz@gmail.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq27xxx_battery.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/power/supply/bq27xxx_battery.c b/drivers/power/supply/bq27xxx_battery.c
index 40c5ac7a11188..b2c65fe43d5cb 100644
--- a/drivers/power/supply/bq27xxx_battery.c
+++ b/drivers/power/supply/bq27xxx_battery.c
@@ -1913,7 +1913,6 @@ static void bq27xxx_battery_update_unlocked(struct bq27xxx_device_info *di)
 		cache.flags = -1; /* read error */
 	if (cache.flags >= 0) {
 		cache.capacity = bq27xxx_battery_read_soc(di);
-		di->cache.flags = cache.flags;
 
 		/*
 		 * On gauges with signed current reporting the current must be
-- 
2.39.5



