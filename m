Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF472C17A0;
	Wed, 25 Feb 2026 06:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002601; cv=none; b=PfXJRoGFxFt9/lm1yK4KuPgeBQ3kFbpcpJz/iKR59zMwbfvmdQRjj7Ep29tMRXEnPBbFDS3nPRDJndgopxS1+8eT/zxI7STByxpxNNBtLEzgM7hpobFCislwtmJEl7gE1ylO0oBd3EqCtXNvpGeNBEQ2MY96F39/u58BwjFrHKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002601; c=relaxed/simple;
	bh=7C2GQUlM+kaDxdEF/WPFy3AC6nfOlb8w28fCPRNM+LM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fshwD93o5oem1QhI988nJcOqjx7choShGSmedz1M4XfGvF1hrjDoF8GQuQxZ11nR6xJmGhlRV5NiwxePsa4h+l3FvpqUIzmAOFSlt8hx9LCDgwvSvTm+nf1DkHCU1u0lSqIDD7ihgKT/ZQXAgTJZFHoTj9p7AlKs4Ibyx793ySY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NrpdajVu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NrpdajVu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24093C116D0;
	Wed, 25 Feb 2026 06:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002601;
	bh=7C2GQUlM+kaDxdEF/WPFy3AC6nfOlb8w28fCPRNM+LM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NrpdajVuaosc0Gnpg93hA3pj7b10mH+PkCQ8+09CEzw30TTAGBGcfPbCJoHruhGFu
	 pv2ZgOLAidgDffWu4pzCYr9N6wIfyeg/+MNGNL+UKAcI0j/fDhnjbuNhXKt8mzz5WE
	 Q2w6a7mRgUytEqBLayuGYAh39lQABrj4F9T2PsA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waqar Hameed <waqar.hameed@axis.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 348/641] power: supply: cpcap-battery: Fix use-after-free in power_supply_changed()
Date: Tue, 24 Feb 2026 17:21:14 -0800
Message-ID: <20260225012357.083194065@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 8106d1edcbc26..507fdc1c866d5 100644
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



