Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C873451CC
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301836; cv=none; b=W76sKMu1OPq2iq7S14fNLCMGyYUt5civJ9lCOS+22uGmxdGeUIm328NdgCkGGlJwKoU5vVclTN7QCE2O7Eu/qWyE4JV7+hLy8B2fbIcunPRs3nLdPwkd4A7xnOS1Bvp/Qk/Iere7txCtm7dtBww1EUnroh9nrjcS2YtrLNe2/Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301836; c=relaxed/simple;
	bh=wUSSkG/rF0Lq44GE5qdB0PK5pgd0eYdmFCRty3wapcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i0NRA70NFHToilZUmE/8zSv97xFu/7Wnab4YXX8Z50u7X60jFnU/TcbUcix/GrHlojpwpKs74T51sAq/fHFa8EtbkLR+QL4VGg3A3NZEeS5P+0YmkL4oiHaSvm4YCqMP8N1Z3uRPKmu4Cz9IgM3LUfq6V3JmuFFQHbiF2ZloHCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ajTZpU7G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ajTZpU7G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A5EC19423;
	Sat, 28 Feb 2026 18:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301836;
	bh=wUSSkG/rF0Lq44GE5qdB0PK5pgd0eYdmFCRty3wapcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ajTZpU7GYUs+Cxl2FTFCPgMp6VGfgeun0bo066FYLThqFJrppnfqavtBe7UM0Iftb
	 cjl17zX5Jy9DGdiAQyDGlkECD9JVOZQWMynZHfgIROQjwLhnRFskh43JO19kXjDpFl
	 iScjMWL5uNkvmUn94xD+dZpwpVYslYQPTl/EBFpLrgPwcWtxVnY8HiH/Rn8MMZjGsH
	 W4qjg+pHqGMk+9xNJ0LqSmoOG7O/moTWC8Aplp3Pce5mOiGbJ7gd6hMUU719ypRCgx
	 vDkEPcn2EKperX+qff+FjT1+zmVM1ttTM+zBRLxoWKUaywvLHXsmMMH+5LSOldy8Xi
	 zzxYr8O2KGqdA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Waqar Hameed <waqar.hameed@axis.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 254/385] power: supply: cpcap-battery: Fix use-after-free in power_supply_changed()
Date: Sat, 28 Feb 2026 12:57:56 -0500
Message-ID: <20260228180011.1568201-254-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Waqar Hameed <waqar.hameed@axis.com>

[ Upstream commit 642f33e34b969eedec334738fd5df95d2dc42742 ]

Using the `devm_` variant for requesting IRQ _before_ the `devm_`
variant for allocating/registering the `power_supply` handle, means that
the `power_supply` handle will be deallocated/unregistered _before_ the
interrupt handler (since `devm_` naturally deallocates in reverse
allocation order). This means that during removal, there is a race
condition where an interrupt can fire just _after_ the `power_supply`
handle has been freed, *but* just _before_ the corresponding
unregistration of the IRQ handler has run.

This will lead to the IRQ handler calling `power_supply_changed()` with
a freed `power_supply` handle. Which usually crashes the system or
otherwise silently corrupts the memory...

Note that there is a similar situation which can also happen during
`probe()`; the possibility of an interrupt firing _before_ registering
the `power_supply` handle. This would then lead to the nasty situation
of using the `power_supply` handle *uninitialized* in
`power_supply_changed()`.

Fix this racy use-after-free by making sure the IRQ is requested _after_
the registration of the `power_supply` handle.

Fixes: 874b2adbed12 ("power: supply: cpcap-battery: Add a battery driver")
Signed-off-by: Waqar Hameed <waqar.hameed@axis.com>
Link: https://patch.msgid.link/81db58d610c9a51a68184f856cd431a934cccee2.1766268280.git.waqar.hameed@axis.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/cpcap-battery.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/power/supply/cpcap-battery.c b/drivers/power/supply/cpcap-battery.c
index 30ec76cdf34b0..eaad9f53bb5cc 100644
--- a/drivers/power/supply/cpcap-battery.c
+++ b/drivers/power/supply/cpcap-battery.c
@@ -1122,10 +1122,6 @@ static int cpcap_battery_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, ddata);
 
-	error = cpcap_battery_init_interrupts(pdev, ddata);
-	if (error)
-		return error;
-
 	error = cpcap_battery_init_iio(ddata);
 	if (error)
 		return error;
@@ -1142,6 +1138,10 @@ static int cpcap_battery_probe(struct platform_device *pdev)
 		return error;
 	}
 
+	error = cpcap_battery_init_interrupts(pdev, ddata);
+	if (error)
+		return error;
+
 	atomic_set(&ddata->active, 1);
 
 	error = cpcap_battery_calibrate(ddata);
-- 
2.51.0

