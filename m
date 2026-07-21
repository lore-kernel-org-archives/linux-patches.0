Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E2147125D;
	Tue, 21 Jul 2026 18:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657937; cv=none; b=OtgMEvcfj3O6Z/q4H7vqWOLnzeWE8Z4DMaIoh51ApBKX26I1BXPcsbJ2xClolSM+x4E1IpKromkO13zbpD5BzmZshtuBLaq5IxpinQeqB7R3CHyNXTVdNo1j4Xdbfd9xU8o0qN6YMgjTd+NZGafbwnE8OcH6YlQ2yF2Gyf9HwF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657937; c=relaxed/simple;
	bh=lqebI1kouVcDHTNwKAihV+K+y/XJz2FP3Q4Y/kT+cZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZtlJNqkmsh9CJK5w/fHLxhAYwjvvMSKnT1WICVQwEL1Kpa1mbA1ImGQGKCj1G1O/o/ksVksb/6zQ7kwUFUjadE2ImpiSrsoZGWEUHol1nshs4laTllsdB3M2lddwNgwUGmSkLT1wBNimXdSQuNKf0/c1SfkMjR9go+ZSc+8iU58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nw2Krr4x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nw2Krr4x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB0B1F000E9;
	Tue, 21 Jul 2026 18:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657936;
	bh=XzG/nUzWlusncFAQmhCK5J/YX+LaM8CtnGjMS4UpdEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nw2Krr4x4kx5QWnyG2MyX/XmZwcptEqCT1Yu6j4J/AcXA/2SI7iWwFpoBZfM8pWET
	 4UaZ5vqF2f+eppLwgi/1/pbhd4zf+D4iNGj7UjY7nsqdLOZ7NFnkvJEU1dlT0dqkfc
	 MgfY0btxZWoMjDgRtgY7+ZtCJaPAE5OuB0yyp7B0=
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
Subject: [PATCH 6.18 0954/1611] net: pse-pd: scope pse_control regulator handle to kref lifetime
Date: Tue, 21 Jul 2026 17:17:50 +0200
Message-ID: <20260721152536.850921451@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index af354483d19102..539094d628563c 100644
--- a/drivers/net/pse-pd/pse_core.c
+++ b/drivers/net/pse-pd/pse_core.c
@@ -1362,7 +1362,7 @@ static void __pse_control_release(struct kref *kref)
 
 	if (psec->pcdev->pi[psec->id].admin_state_enabled)
 		regulator_disable(psec->ps);
-	devm_regulator_put(psec->ps);
+	regulator_put(psec->ps);
 
 	module_put(psec->pcdev->owner);
 
@@ -1431,8 +1431,8 @@ pse_control_get_internal(struct pse_controller_dev *pcdev, unsigned int index,
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



