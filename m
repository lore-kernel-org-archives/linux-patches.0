Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE15322DB7;
	Tue, 21 Jul 2026 17:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653405; cv=none; b=KVqK4erih8N6wZxRqEuoQ2/hgNoqm0uW35137WkEfMIuR1UiU4l7zJaMhiTyCCtIzqx5QxAS1B7LvwTzpYCCZidUI5MKDYXjaS3I2vvQRa4P6pEAi5uM2CjiXHyLKkGgwis5C9Qs5WLS7HVS5pJZrmbdIWKpcuyB5Ww+hdR2mlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653405; c=relaxed/simple;
	bh=HaN18AsEZcgrfz2IXiD+c0b7nZOnRhrcLWlT2zc8F0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HPaGno8aNtKoXxKcP5od6wlq/d53U0xVMcEb58yInNZC8K2mde/LfPjpgP1RlA4QwyZXkV8jz4pHGRr2aawUinvOMXuZjwN4LCOP4XWHSUBX6TVaMueskAjfqPmmKQ5+nvJzwZk/QHTrjXTRpnWLsEqNEDzqgZ29B0fM7PVMFcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=imFj7n5e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="imFj7n5e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F8091F000E9;
	Tue, 21 Jul 2026 17:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653404;
	bh=xNe/xdeDCk7DX4YODLt57tR8igOsj6arwZL19Ji3fDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=imFj7n5eZ02loJSWmrGs/vSQhum8cxK7bRdZczBGUSvoNjNrawIEQGNQpesydZ3wb
	 53V6vdFhSpw851iKJKsGIP5flhv7XYLWOGV2M9Lx3IUB1jzNZh1t7z54ym6fPLKnm2
	 4KavMeZycNVxha5kRkNG4tJTgtFJeCjlBbzZqmM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Corey Leavitt <corey@leavitt.info>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Carlo Szelinsky <github@szelinsky.de>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1314/2077] net: pse-pd: scope pse_control regulator handle to kref lifetime
Date: Tue, 21 Jul 2026 17:16:27 +0200
Message-ID: <20260721152623.814032249@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Corey Leavitt <corey@leavitt.info>

[ Upstream commit 16759757c4d28e958fd5a5a1fe0f86828872f28d ]

__pse_control_release() drops psec->ps via devm_regulator_put(), which
only succeeds if the devres entry added by the matching
devm_regulator_get_exclusive() is still present on pcdev->dev at the
time the pse_control's kref hits zero.

That assumption does not hold when the controller is unbound while a
pse_control still has consumers: pcdev->dev's devres list is released
LIFO, so every per-attach regulator-GET devres runs (and
regulator_put()s the underlying regulator) before
pse_controller_unregister() itself is invoked. Any later
pse_control_put() from that unbind path then reads psec->ps as a
dangling pointer inside devm_regulator_put() and WARNs at
drivers/regulator/devres.c:232 (devres_release() fails to find the
already-released match).

The pse_control's consumer handle is logically scoped to the
pse_control's refcount, not to pcdev->dev's devres lifetime. Switch to
the plain regulator_get_exclusive() / regulator_put() pair so the
regulator put in __pse_control_release() no longer depends on the
controller's devres still being present. No change to the
regulator-framework-visible refcount or lifetime of the underlying
regulator: a single get paired with a single put. The existing
devm_regulator_register() for the per-PI rails is unchanged (those ARE
correctly scoped to the controller's lifetime).

This addresses only the regulator handle. The same unbind-while-held
scenario also leaves __pse_control_release() reading psec->pcdev->pi[]
and psec->pcdev->owner after pse_controller_unregister() has freed
pcdev->pi, because the controller does not drain its outstanding
pse_control references on unregister. That wider pse_control vs
pcdev lifetime problem pre-dates this change and is addressed by the
PSE controller notifier series, which drains phydev->psec on
PSE_UNREGISTERED before pcdev->pi is freed.

Link: https://lore.kernel.org/netdev/20260620112440.1734404-1-github@szelinsky.de/
Fixes: d83e13761d5b ("net: pse-pd: Use regulator framework within PSE framework")
Signed-off-by: Corey Leavitt <corey@leavitt.info>
Acked-by: Kory Maincent <kory.maincent@bootlin.com>
Signed-off-by: Carlo Szelinsky <github@szelinsky.de>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260624204017.2752934-1-github@szelinsky.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/pse-pd/pse_core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/pse-pd/pse_core.c b/drivers/net/pse-pd/pse_core.c
index 69dbdbde9d71a7..a5e6d7b26b9fd7 100644
--- a/drivers/net/pse-pd/pse_core.c
+++ b/drivers/net/pse-pd/pse_core.c
@@ -1367,7 +1367,7 @@ static void __pse_control_release(struct kref *kref)
 
 	if (psec->pcdev->pi[psec->id].admin_state_enabled)
 		regulator_disable(psec->ps);
-	devm_regulator_put(psec->ps);
+	regulator_put(psec->ps);
 
 	module_put(psec->pcdev->owner);
 
@@ -1436,8 +1436,8 @@ pse_control_get_internal(struct pse_controller_dev *pcdev, unsigned int index,
 		goto free_psec;
 
 	pcdev->pi[index].admin_state_enabled = ret;
-	psec->ps = devm_regulator_get_exclusive(pcdev->dev,
-						rdev_get_name(pcdev->pi[index].rdev));
+	psec->ps = regulator_get_exclusive(pcdev->dev,
+					   rdev_get_name(pcdev->pi[index].rdev));
 	if (IS_ERR(psec->ps)) {
 		ret = PTR_ERR(psec->ps);
 		goto put_module;
-- 
2.53.0



