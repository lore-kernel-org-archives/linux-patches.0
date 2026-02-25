Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44AF2C17A0;
	Wed, 25 Feb 2026 06:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002598; cv=none; b=ZpasqzDXhoHC+x3+hj5iO+uLfwmuSLxY9Y15kk653e8cKzK5DE8eW6djqfxDb2FBJ2oJrEezwVz5BuI9kmbZu3KZBwZl7zzKuteKFuJSciTdsHxYy4OGUVEqpElDU1kVTLy8QQ/r4+40QuJPw3KmGINMjHKxHVNsmGkcXyIbJfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002598; c=relaxed/simple;
	bh=NTPF+SCv7IwTPXKIpTukm7ts0VMM0Puf8lwyP+fVYDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e6nkhQU8NkIAceJxx39t56J/SVH0tU8UfWj7eywE+uhphWK2Xn19Fz/vu2shJYA7ivdNecTxMRCZZ0UYaMqb+EAYMsgi10CIg69rnxnJCZ+JPiFoFsg6qJSiOgH41qdx63EZDdv6Mm56xigbfz8pYjYJ/fjursaxqrS2cWe+gMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xxduVSHR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xxduVSHR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F19C116D0;
	Wed, 25 Feb 2026 06:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002598;
	bh=NTPF+SCv7IwTPXKIpTukm7ts0VMM0Puf8lwyP+fVYDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xxduVSHRBx00WcGAj61eoT/NJy8DrSU/m1jwcnH/x0cNieqoJbHeBEsiJ3wNfyLC+
	 EQRYUhOdZcZMt4ufTNC1HrdHm+/KwYNfY6slStKH/6m2syD2fbAGtmf/pWCeqDUrsa
	 hkQav9VPdMHEdvRz9WscQ2RapSAKfdg7aw4VUTwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waqar Hameed <waqar.hameed@axis.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 345/641] power: supply: act8945a: Fix use-after-free in power_supply_changed()
Date: Tue, 24 Feb 2026 17:21:11 -0800
Message-ID: <20260225012357.018844638@linuxfoundation.org>
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



