Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476E426A0C5;
	Tue,  8 Apr 2025 12:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116056; cv=none; b=Sve/ZV42pPM2YNKNsdZuQhopWWfLCph4ItU+TzrIQP0tMhpZMAL1VIJAOnNE32zq3cxmR63yYpYqwH9j83Cp+4et37B7HntsYLwRZoseLZqfIQWTrd3yG2gTjEJuH69p8uHWNjDTpViOABOPrVzOya5ho8Zq7z5bSuCtlyb75qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116056; c=relaxed/simple;
	bh=UHsaAW78Reuq/KECGLYgISmF5/v5itDG2UdM9+T1OF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m4M+6lqaiWa4ybPWTHfobFRNO8FLorQlfo0XMYbifnPx4h1mVkXnOo/rLtRRH6TUNM1+5vrlW8Kdqe4mkdW/Egd7BhZI+K2xFX1+VG+Z9V/vfIiU9TQ/82OU+d74bO2JvkGVOwrzBmHK5xIvZtGoOUdaNJhd9gns1Ix9a5vHrKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sqRVY/T1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sqRVY/T1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB834C4CEE5;
	Tue,  8 Apr 2025 12:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116056;
	bh=UHsaAW78Reuq/KECGLYgISmF5/v5itDG2UdM9+T1OF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sqRVY/T1geuSEN2zAeeT/8wT06ylpJ6cm3d0NTFWJPh5YX/nw/vFprQ2jsSLMofDT
	 PBZLtZO3gmVv+glKMVI7xqUdO8IsWtU67yXRLZkbS8hEHlzgAMMDLRRbNnliXeUODQ
	 A5xkGUHy/z4m7syt42feCJs8hq5eZjqUL1uQiYoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Oberhollenzer <david.oberhollenzer@sigma-star.at>,
	Vladimir Oltean <olteanv@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 164/204] net: dsa: mv88e6xxx: propperly shutdown PPU re-enable timer on destroy
Date: Tue,  8 Apr 2025 12:51:34 +0200
Message-ID: <20250408104825.129336237@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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
index af0565c3a364c..b485176e53cd1 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -7199,13 +7199,13 @@ static int mv88e6xxx_probe(struct mdio_device *mdiodev)
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
 
@@ -7224,7 +7224,7 @@ static int mv88e6xxx_probe(struct mdio_device *mdiodev)
 	mv88e6xxx_reg_unlock(chip);
 
 	if (err)
-		goto out;
+		goto out_phy;
 
 	if (chip->info->g2_irqs > 0) {
 		err = mv88e6xxx_g2_irq_setup(chip);
@@ -7264,6 +7264,8 @@ static int mv88e6xxx_probe(struct mdio_device *mdiodev)
 		mv88e6xxx_g1_irq_free(chip);
 	else
 		mv88e6xxx_irq_poll_free(chip);
+out_phy:
+	mv88e6xxx_phy_destroy(chip);
 out:
 	if (pdata)
 		dev_put(pdata->netdev);
@@ -7286,7 +7288,6 @@ static void mv88e6xxx_remove(struct mdio_device *mdiodev)
 		mv88e6xxx_ptp_free(chip);
 	}
 
-	mv88e6xxx_phy_destroy(chip);
 	mv88e6xxx_unregister_switch(chip);
 	mv88e6xxx_mdios_unregister(chip);
 
@@ -7300,6 +7301,8 @@ static void mv88e6xxx_remove(struct mdio_device *mdiodev)
 		mv88e6xxx_g1_irq_free(chip);
 	else
 		mv88e6xxx_irq_poll_free(chip);
+
+	mv88e6xxx_phy_destroy(chip);
 }
 
 static void mv88e6xxx_shutdown(struct mdio_device *mdiodev)
diff --git a/drivers/net/dsa/mv88e6xxx/phy.c b/drivers/net/dsa/mv88e6xxx/phy.c
index 252b5b3a3efef..d2104bd346ea2 100644
--- a/drivers/net/dsa/mv88e6xxx/phy.c
+++ b/drivers/net/dsa/mv88e6xxx/phy.c
@@ -197,7 +197,10 @@ static void mv88e6xxx_phy_ppu_state_init(struct mv88e6xxx_chip *chip)
 
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



