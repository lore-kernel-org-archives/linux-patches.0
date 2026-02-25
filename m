Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8E91E2834;
	Wed, 25 Feb 2026 01:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983314; cv=none; b=Ki4xE4t4Wp67pvasDqk4mo5NrPWiXVd3U/glXaxVzaBtiwFep0zSHd3eE0SlpRPBIS3ko8JEv6CUbyrDNMV4LYjcO2TqP30dvU/UFh+9b2AzFcKugFQxVlb/ReJEAXgXH27PlOC5PwYVuINeszR96lobE1LKww8zoxzxFAESFxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983314; c=relaxed/simple;
	bh=mSU+mFbe821aqa/tnRJ7zbaYd5EgnFZyBQMSdcRekSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fKLm/2gYVTH1EYqhrurQmN7krvA58qujPFS2xBtYwnNJdqQ3JNDdGcVKYmH91++FQ5wbzRnp4T/YeL3p+igTxkuS9pSqoB+vYJB+4vNkbMQetPdssTtAyVNF1XdBvas8WhmGmy0k7R57MvSB4YjnXswB7MsxloCB0rXH35YRmo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=knpaZWaP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="knpaZWaP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BD7DC116D0;
	Wed, 25 Feb 2026 01:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983314;
	bh=mSU+mFbe821aqa/tnRJ7zbaYd5EgnFZyBQMSdcRekSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=knpaZWaPAvJo1UOgefxM3cfV54b2YmhksGKz0xQslKXQXv84CRmqZsyqEwRVCFigE
	 xR9DB9jMiIC2F/cnlEvM544z2SfxRo0Mf4qYpFw1UYbrIei4izv0CBjgUZOE8CZjCp
	 vKm3TewBFY1z0IZPAgv8x2rIf6xqA4g8G3CnJwMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waqar Hameed <waqar.hameed@axis.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 448/781] power: supply: act8945a: Fix use-after-free in power_supply_changed()
Date: Tue, 24 Feb 2026 17:19:17 -0800
Message-ID: <20260225012410.698383836@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waqar Hameed <waqar.hameed@axis.com>

[ Upstream commit 3291c51d4684d048dd2eb91b5b65fcfdaf72141f ]

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

Fixes: a09209acd6a8 ("power: supply: act8945a_charger: Add status change update support")
Signed-off-by: Waqar Hameed <waqar.hameed@axis.com>
Link: https://patch.msgid.link/bcf3a23b5187df0bba54a8c8fe09f8b8a0031dee.1766268280.git.waqar.hameed@axis.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/act8945a_charger.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/power/supply/act8945a_charger.c b/drivers/power/supply/act8945a_charger.c
index 3901a02f326a5..9dec4486b1439 100644
--- a/drivers/power/supply/act8945a_charger.c
+++ b/drivers/power/supply/act8945a_charger.c
@@ -597,14 +597,6 @@ static int act8945a_charger_probe(struct platform_device *pdev)
 		return irq ?: -ENXIO;
 	}
 
-	ret = devm_request_irq(&pdev->dev, irq, act8945a_status_changed,
-			       IRQF_TRIGGER_FALLING, "act8945a_interrupt",
-			       charger);
-	if (ret) {
-		dev_err(&pdev->dev, "failed to request nIRQ pin IRQ\n");
-		return ret;
-	}
-
 	charger->desc.name = "act8945a-charger";
 	charger->desc.get_property = act8945a_charger_get_property;
 	charger->desc.properties = act8945a_charger_props;
@@ -625,6 +617,14 @@ static int act8945a_charger_probe(struct platform_device *pdev)
 		return PTR_ERR(charger->psy);
 	}
 
+	ret = devm_request_irq(&pdev->dev, irq, act8945a_status_changed,
+			       IRQF_TRIGGER_FALLING, "act8945a_interrupt",
+			       charger);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to request nIRQ pin IRQ\n");
+		return ret;
+	}
+
 	platform_set_drvdata(pdev, charger);
 
 	INIT_WORK(&charger->work, act8945a_work);
-- 
2.51.0



