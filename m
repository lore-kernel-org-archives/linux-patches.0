Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39EC2676CF;
	Tue,  8 Apr 2025 12:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115237; cv=none; b=XaoA92MA+1WQM2wcHAvNuibw3nhAQyK2rr45jcOfo3VDJ0N6XBpNlci62O+Qyg1wuz5K22Z3UW5D63yLkSKqn2+fmDEd1x28yMc0goh/EH+ZTg51mweKqfXwiJMx9Qm1HblIt2hzBcDSvg21pC5JNZbgjXnr30RJB8Ep0vKrxRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115237; c=relaxed/simple;
	bh=tRGyMxBAxDmj9YYBhnpDdZnvyi7jihiRsb+t69g3UkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aplvheprMVhWeT90lfV6t+QuPx5GO1aE6KcfUfyLdOzNfDt/f+iWcsChi5PCsQjxU0Oe19hTPfTpDm3Z9zyVX76mh7rgmimBsv3WAa8uWo6X0ZgbIXft7NqulHSf9jGqtoMtpYK89UVrc3sUUtEyT2UnYXZIgj9pxg404TQ6Big=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HT0EA2JT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HT0EA2JT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FAE2C4CEE5;
	Tue,  8 Apr 2025 12:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115237;
	bh=tRGyMxBAxDmj9YYBhnpDdZnvyi7jihiRsb+t69g3UkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HT0EA2JTfwWOJvE9+XsshDBVDk5Duh0gb7rb8wSjnMsqkqDdqObjarxzieWpo1qoH
	 MmfRssJHfwUWyBZaQae5ZtCsYypEQEE+v5RDJdIxC/Hzxxo0BEgCOZ9nyYjXkOPtp7
	 UmU5EvQlODqSWPl9NZVJdHAPDStxNq2mmGMED83I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Oberhollenzer <david.oberhollenzer@sigma-star.at>,
	Vladimir Oltean <olteanv@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 400/499] net: dsa: mv88e6xxx: propperly shutdown PPU re-enable timer on destroy
Date: Tue,  8 Apr 2025 12:50:12 +0200
Message-ID: <20250408104901.200801302@linuxfoundation.org>
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

From: David Oberhollenzer <david.oberhollenzer@sigma-star.at>

[ Upstream commit a58d882841a0750da3c482cd3d82432b1c7edb77 ]

The mv88e6xxx has an internal PPU that polls PHY state. If we want to
access the internal PHYs, we need to disable the PPU first. Because
that is a slow operation, a 10ms timer is used to re-enable it,
canceled with every access, so bulk operations effectively only
disable it once and re-enable it some 10ms after the last access.

If a PHY is accessed and then the mv88e6xxx module is removed before
the 10ms are up, the PPU re-enable ends up accessing a dangling pointer.

This especially affects probing during bootup. The MDIO bus and PHY
registration may succeed, but registration with the DSA framework
may fail later on (e.g. because the CPU port depends on another,
very slow device that isn't done probing yet, returning -EPROBE_DEFER).
In this case, probe() fails, but the MDIO subsystem may already have
accessed the MIDO bus or PHYs, arming the timer.

This is fixed as follows:
 - If probe fails after mv88e6xxx_phy_init(), make sure we also call
   mv88e6xxx_phy_destroy() before returning
 - In mv88e6xxx_remove(), make sure we do the teardown in the correct
   order, calling mv88e6xxx_phy_destroy() after unregistering the
   switch device.
 - In mv88e6xxx_phy_destroy(), destroy both the timer and the work item
   that the timer might schedule, synchronously waiting in case one of
   the callbacks already fired and destroying the timer first, before
   waiting for the work item.
 - Access to the PPU is guarded by a mutex, the worker acquires it
   with a mutex_trylock(), not proceeding with the expensive shutdown
   if that fails. We grab the mutex in mv88e6xxx_phy_destroy() to make
   sure the slow PPU shutdown is already done or won't even enter, when
   we wait for the work item.

Fixes: 2e5f032095ff ("dsa: add support for the Marvell 88E6131 switch chip")
Signed-off-by: David Oberhollenzer <david.oberhollenzer@sigma-star.at>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://patch.msgid.link/20250401135705.92760-1-david.oberhollenzer@sigma-star.at
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 11 +++++++----
 drivers/net/dsa/mv88e6xxx/phy.c  |  3 +++
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index d6e8398c07608..99279b7198765 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -7304,13 +7304,13 @@ static int mv88e6xxx_probe(struct mdio_device *mdiodev)
 	err = mv88e6xxx_switch_reset(chip);
 	mv88e6xxx_reg_unlock(chip);
 	if (err)
-		goto out;
+		goto out_phy;
 
 	if (np) {
 		chip->irq = of_irq_get(np, 0);
 		if (chip->irq == -EPROBE_DEFER) {
 			err = chip->irq;
-			goto out;
+			goto out_phy;
 		}
 	}
 
@@ -7329,7 +7329,7 @@ static int mv88e6xxx_probe(struct mdio_device *mdiodev)
 	mv88e6xxx_reg_unlock(chip);
 
 	if (err)
-		goto out;
+		goto out_phy;
 
 	if (chip->info->g2_irqs > 0) {
 		err = mv88e6xxx_g2_irq_setup(chip);
@@ -7363,6 +7363,8 @@ static int mv88e6xxx_probe(struct mdio_device *mdiodev)
 		mv88e6xxx_g1_irq_free(chip);
 	else
 		mv88e6xxx_irq_poll_free(chip);
+out_phy:
+	mv88e6xxx_phy_destroy(chip);
 out:
 	if (pdata)
 		dev_put(pdata->netdev);
@@ -7385,7 +7387,6 @@ static void mv88e6xxx_remove(struct mdio_device *mdiodev)
 		mv88e6xxx_ptp_free(chip);
 	}
 
-	mv88e6xxx_phy_destroy(chip);
 	mv88e6xxx_unregister_switch(chip);
 
 	mv88e6xxx_g1_vtu_prob_irq_free(chip);
@@ -7398,6 +7399,8 @@ static void mv88e6xxx_remove(struct mdio_device *mdiodev)
 		mv88e6xxx_g1_irq_free(chip);
 	else
 		mv88e6xxx_irq_poll_free(chip);
+
+	mv88e6xxx_phy_destroy(chip);
 }
 
 static void mv88e6xxx_shutdown(struct mdio_device *mdiodev)
diff --git a/drivers/net/dsa/mv88e6xxx/phy.c b/drivers/net/dsa/mv88e6xxx/phy.c
index 8bb88b3d900db..ee9e5d7e52770 100644
--- a/drivers/net/dsa/mv88e6xxx/phy.c
+++ b/drivers/net/dsa/mv88e6xxx/phy.c
@@ -229,7 +229,10 @@ static void mv88e6xxx_phy_ppu_state_init(struct mv88e6xxx_chip *chip)
 
 static void mv88e6xxx_phy_ppu_state_destroy(struct mv88e6xxx_chip *chip)
 {
+	mutex_lock(&chip->ppu_mutex);
 	del_timer_sync(&chip->ppu_timer);
+	cancel_work_sync(&chip->ppu_work);
+	mutex_unlock(&chip->ppu_mutex);
 }
 
 int mv88e6185_phy_ppu_read(struct mv88e6xxx_chip *chip, struct mii_bus *bus,
-- 
2.39.5



