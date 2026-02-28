Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A6B39B946
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302590; cv=none; b=CII4S0PMiKDOEiUbgBOSriuTs3lvxvea8hq0v++hqLnbFDeBrEZSZFC22iIAZRY+tEMK4Y8u3C7gcF6wmA6Zng0dHKXkrsQWcaR6vZjcy6XdXzF/MCNJgj43h40ypnOHveyxNxd7NOu7Ox6i9WIAJcQQ/TI3NK19ty0NuSnv8bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302590; c=relaxed/simple;
	bh=ZJKzcHPEsMqkRsn90MNd0ksrabjR2eWS3XpKFvECCmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=awkauwFXpTbluh/uShTDkBbVF79ZWfhMXfByIjtr1qgUkP86JlpPNVft5lBXnDlQFRs7LjBUbKTnExEQxBZDTvZGSYos9Yi/vpb1lxMm07feXCmiDE1HUD/2enr2yF3D9lhCNEUHXAsg/iKSBomtVZVjPnB4G0HxLEw1vMp5hvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q87gs8gW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q87gs8gW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 577EBC19423;
	Sat, 28 Feb 2026 18:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302589;
	bh=ZJKzcHPEsMqkRsn90MNd0ksrabjR2eWS3XpKFvECCmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q87gs8gWXbPooa/kVv9rDOHgOV+giJ1LNmDHxLzHeel+eXyL/t0F6dpU4MI03Y7sx
	 TRoSoNDEHwH/BzxiLNVSqyRBn+LAMK3wUOstI4kkJFUJ0P4P/TTS6s2fasiQ8BqaLx
	 ujEvYyTXN3+VyoV/2vVXUxL1MAv3zhSfAhfITvFrWqle/Viae2tbLNQikxSLV/ojT8
	 1J8NY7IvCwDCAX96Qhh5l7BI/wSm/i30ZpSjLarDOjfAUm7ImdiIUzj7Oigy3V5VF5
	 3TxeYq+eF3qGNwOSRWawI+/WH7VplzG2kahay7nWzJNPlLXaguosH2fAwmY0fRtEw0
	 ve6Q1oUTNFzPA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Waqar Hameed <waqar.hameed@axis.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 100/164] power: supply: cpcap-battery: Fix use-after-free in power_supply_changed()
Date: Sat, 28 Feb 2026 13:13:59 -0500
Message-ID: <20260228181505.1600663-100-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index 8d62d4241da3d..053d376700447 100644
--- a/drivers/power/supply/cpcap-battery.c
+++ b/drivers/power/supply/cpcap-battery.c
@@ -1071,10 +1071,6 @@ static int cpcap_battery_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, ddata);
 
-	error = cpcap_battery_init_interrupts(pdev, ddata);
-	if (error)
-		return error;
-
 	error = cpcap_battery_init_iio(ddata);
 	if (error)
 		return error;
@@ -1091,6 +1087,10 @@ static int cpcap_battery_probe(struct platform_device *pdev)
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

