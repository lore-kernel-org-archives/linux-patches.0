Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26AC2FE560;
	Tue, 12 Aug 2025 17:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020660; cv=none; b=Q1Bwy6SC5DELBS81o32BNRFu5B1+TcwMtLkTA/bYwMV4+4TKQhABd3Ka21RkFg5Fx2gQiW7NO20xQqQOA3nHMoDnk96EHYqXpGOaDmeAZXfDxgkdDNIyvjyUOgIcjD4AOx3hFfxMf4fESaK0qlRoikxdab/H4QDVqNATFyAzwQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020660; c=relaxed/simple;
	bh=xDQYv72VHvARUg3xYrakhXjl2LIF6EwUCUk6LEYN0AU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KjTr1D6TwFouVJ3pOvgYjmMB2bl0pXv9gFPr2lmgIadPz4nyczbE9mzZvRKWpuYEWiCV1DBFf1JIKp9TephVMUMuDNKt3e6QDrP6C0oTnkEVMrgzCOCtbbKjjZ8VREcrYncuaRUpFK3rvUgmyEFzzbA7qPtHXXLW8Pbh6TF6pyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r2yydyes; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r2yydyes"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27719C4CEF0;
	Tue, 12 Aug 2025 17:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020660;
	bh=xDQYv72VHvARUg3xYrakhXjl2LIF6EwUCUk6LEYN0AU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r2yydyesel4BchiIpy/HDU/7RGVfUrH2eEEkWm3BadOClK1RiljxC63Mu58ixskAt
	 FlAP9uusULSqq+5llzZi/ftltY68Zc1NOLyhxTWXH/De7XxPO4efDtskrZhNexwD6k
	 chLS4ZAJLxA5RZRjaU/CXpDCh+aOhRoTrOJyDdpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 146/253] power: supply: cpcap-charger: Fix null check for power_supply_get_by_name
Date: Tue, 12 Aug 2025 19:28:54 +0200
Message-ID: <20250812172954.916632938@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Han <hanchunchao@inspur.com>

[ Upstream commit d9fa3aae08f99493e67fb79413c0e95d30fca5e9 ]

In the cpcap_usb_detect() function, the power_supply_get_by_name()
function may return `NULL` instead of an error pointer.
To prevent potential null pointer dereferences, Added a null check.

Fixes: eab4e6d953c1 ("power: supply: cpcap-charger: get the battery inserted infomation from cpcap-battery")
Signed-off-by: Charles Han <hanchunchao@inspur.com>
Link: https://lore.kernel.org/r/20250519024741.5846-1-hanchunchao@inspur.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/cpcap-charger.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/power/supply/cpcap-charger.c b/drivers/power/supply/cpcap-charger.c
index be9764541d52..05a3f4b208a4 100644
--- a/drivers/power/supply/cpcap-charger.c
+++ b/drivers/power/supply/cpcap-charger.c
@@ -689,9 +689,8 @@ static void cpcap_usb_detect(struct work_struct *work)
 		struct power_supply *battery;
 
 		battery = power_supply_get_by_name("battery");
-		if (IS_ERR_OR_NULL(battery)) {
-			dev_err(ddata->dev, "battery power_supply not available %li\n",
-					PTR_ERR(battery));
+		if (!battery) {
+			dev_err(ddata->dev, "battery power_supply not available\n");
 			return;
 		}
 
-- 
2.39.5



