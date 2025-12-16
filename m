Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61413313E13;
	Tue, 16 Dec 2025 11:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884261; cv=none; b=p2WbG9GHZNAtYtXcmEuL0Jl2J5Aw1pR191lJyDEy6FLGQb8OhzPEPZqk/6zlpy5zDemu/fz887pWOqwVQIe8nMILw13E/cefv6ctSmRMOV/8wAmzb0RJ1VxdxH+OW9VlLMe6PAy20A0DoqsPj3XdZ0ytctfqB2Ek32dLbckFSY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884261; c=relaxed/simple;
	bh=YOeAFGXyG+5MLfPUpXCCiTn7a1FyGIONDm+IDmacO1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QJOWb1Tv3/r7bjjZv9rATuvz+I3E2CjsqO+MPDGJz3bJeqv7RUgxUjBJKRPxonWlbXTy5nNGyXEW/PmiJohaUPRr2tozjktbZOUox9jbPdlzS24Zu5CSBwcbEN9nvqa4xTg/41UHFQXOAVRc2AfyfHRpGEmWEvog42rd3Dri628=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SAo8ZydB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SAo8ZydB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D604FC4CEF1;
	Tue, 16 Dec 2025 11:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884261;
	bh=YOeAFGXyG+5MLfPUpXCCiTn7a1FyGIONDm+IDmacO1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SAo8ZydB2/SI+Q1vd3T3EB5i4ORFkE9l30mQNLlUDhFvVb9z1JEhKvnw1185YSFSD
	 lGv9JGqjvrWtsV+1qGP8mOFdlYbUygTXRqspC/XjvYCpTtssB68g9gVFfp+GNkHsbM
	 9aXyFWsL8wV2efAEX0wj3tgStziTjcCtXbXAY+pY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 107/354] power: supply: rt9467: Prevent using uninitialized local variable in rt9467_set_value_from_ranges()
Date: Tue, 16 Dec 2025 12:11:14 +0100
Message-ID: <20251216111324.795971618@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Murad Masimov <m.masimov@mt-integration.ru>

[ Upstream commit 15aca30cc6c69806054b896a2ccf7577239cb878 ]

There is a typo in rt9467_set_value_from_ranges() that can cause leaving local
variable sel with an undefined value which is then used in regmap_field_write().

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 6f7f70e3a8dd ("power: supply: rt9467: Add Richtek RT9467 charger driver")
Signed-off-by: Murad Masimov <m.masimov@mt-integration.ru>
Link: https://patch.msgid.link/20251009145308.1830893-1-m.masimov@mt-integration.ru
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/rt9467-charger.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/rt9467-charger.c b/drivers/power/supply/rt9467-charger.c
index faa5de2857ea0..be65b0f517210 100644
--- a/drivers/power/supply/rt9467-charger.c
+++ b/drivers/power/supply/rt9467-charger.c
@@ -376,7 +376,7 @@ static int rt9467_set_value_from_ranges(struct rt9467_chg_data *data,
 	if (rsel == RT9467_RANGE_VMIVR) {
 		ret = linear_range_get_selector_high(range, value, &sel, &found);
 		if (ret)
-			value = range->max_sel;
+			sel = range->max_sel;
 	} else {
 		linear_range_get_selector_within(range, value, &sel);
 	}
-- 
2.51.0



