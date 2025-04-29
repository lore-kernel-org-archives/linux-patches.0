Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145A021ABC6;
	Tue, 29 Apr 2025 18:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949642; cv=none; b=GwbcTRTYVJCQ5rQL2jBsvVQ0qEXek/LaONoOUhxodppoAyBR8BzfGcsUQbzEXA53qJQiCTPkMaZXf3AMt9/db8aa3lAk5Hd9gdIpdTDX4pF1ClnvoGR1eNkwzCN+K+kJTl7vS6ADW7UcmAlJXXHBiMaZ11AGwVQA6P0EsLeC61o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949642; c=relaxed/simple;
	bh=oI4l/EmtIpc+R5f9Xxc9sJr97uf/dI4NtY/K9amO+Mg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uKA/MC/twDV6bV6G5Auv4fSkjPq+Q6FqtJ60axzO8cDe4tjnJQDBIiAFgybGiA+9q2CjMdYOeO3xZ/YJOxtQlr1w44sG6zDBKCh58dt//I4Zmj0GD3o5HwbqdUHoT2u/c24d1b/axxMMKUGbXNPxDm0X0RI7qLhf1TpeoS75w20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vkvTIqpk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vkvTIqpk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5D3C4CEE3;
	Tue, 29 Apr 2025 18:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949642;
	bh=oI4l/EmtIpc+R5f9Xxc9sJr97uf/dI4NtY/K9amO+Mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vkvTIqpkjp2SjxrKH0O9+/WdY71T7YYTTVNIvlNS/QT8qLq75MxsHPf/SqcgTi+08
	 BtED4MaZgFelKWf0bpxQH0A+dDAjG3c6mReH4nODU7ed7s+FRU5Hhsp8LKaIpme2JF
	 7G4bqlu7taEbNtlHUCzIZEZitaFFPcU8NV/iXdWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Klaus Kudielka <klaus.kudielka@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 010/167] net: dsa: mv88e6xxx: dont dispose of Global2 IRQ mappings from mdiobus code
Date: Tue, 29 Apr 2025 18:41:58 +0200
Message-ID: <20250429161052.167736830@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit b1a2de9ccfe63b50e493ebb57b85beb5785200c7 ]

irq_find_mapping() does not need irq_dispose_mapping(), only
irq_create_mapping() does.

Calling irq_dispose_mapping() from mv88e6xxx_g2_irq_mdio_free() and from
the error path of mv88e6xxx_g2_irq_mdio_setup() effectively means that
the mdiobus logic (for internal PHY interrupts) is disposing of a
hwirq->virq mapping which it is not responsible of (but instead, the
function pair mv88e6xxx_g2_irq_setup() + mv88e6xxx_g2_irq_free() is).

With the current code structure, this isn't such a huge problem, because
mv88e6xxx_g2_irq_mdio_free() is called relatively close to the real
owner of the IRQ mappings:

mv88e6xxx_remove()
-> mv88e6xxx_unregister_switch()
-> mv88e6xxx_mdios_unregister()
   -> mv88e6xxx_g2_irq_mdio_free()
-> mv88e6xxx_g2_irq_free()

and the switch isn't 'live' in any way such that it would be able of
generating interrupts at this point (mv88e6xxx_unregister_switch() has
been called).

However, there is a desire to split mv88e6xxx_mdios_unregister() and
mv88e6xxx_g2_irq_free() such that mv88e6xxx_mdios_unregister() only gets
called from mv88e6xxx_teardown(). This is much more problematic, as can
be seen below.

In a cross-chip scenario (say 3 switches d0032004.mdio-mii:10,
d0032004.mdio-mii:11 and d0032004.mdio-mii:12 which form a single DSA
tree), it is possible to unbind the device driver from a single switch
(say d0032004.mdio-mii:10).

When that happens, mv88e6xxx_remove() will be called for just that one
switch, and this will call mv88e6xxx_unregister_switch() which will tear
down the entire tree (calling mv88e6xxx_teardown() for all 3 switches).

Assuming mv88e6xxx_mdios_unregister() was moved to mv88e6xxx_teardown(),
at this stage, all 3 switches will have called irq_dispose_mapping() on
their mdiobus virqs.

When we bind again the device driver to d0032004.mdio-mii:10,
mv88e6xxx_probe() is called for it, which calls dsa_register_switch().
The DSA tree is now complete again, and mv88e6xxx_setup() is called for
all 3 switches.

Also assuming that mv88e6xxx_mdios_register() is moved to
mv88e6xxx_setup() (the 2 assumptions go together), at this point,
d0032004.mdio-mii:11 and d0032004.mdio-mii:12 don't have an IRQ mapping
for the internal PHYs anymore, as they've disposed of it in
mv88e6xxx_teardown(). Whereas switch d0032004.mdio-mii:10 has re-created
it, because its code path comes from mv88e6xxx_probe().

Simply put, this change prepares the driver to handle the movement of
mv88e6xxx_mdios_register() to mv88e6xxx_setup() for cross-chip DSA trees.

Also, the code being deleted was partially wrong anyway (in a way which
may have hidden this other issue). mv88e6xxx_g2_irq_mdio_setup()
populates bus->irq[] starting with offset chip->info->phy_base_addr, but
the teardown path doesn't apply that offset too. So it disposes of virq
0 for phy = [ 0, phy_base_addr ).

All switch families have phy_base_addr = 0, except for MV88E6141 and
MV88E6341 which have it as 0x10. I guess those families would have
happened to work by mistake in cross-chip scenarios too.

I'm deleting the body of mv88e6xxx_g2_irq_mdio_free() but leaving its
call sites and prototype in place. This is because, if we ever need to
add back some teardown procedure in the future, it will be perhaps
error-prone to deduce the proper call sites again. Whereas like this,
no extra code should get generated, it shouldn't bother anybody.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Klaus Kudielka <klaus.kudielka@gmail.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 52fdc41c3278 ("net: dsa: mv88e6xxx: fix internal PHYs for 6320 family")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/global2.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/global2.c b/drivers/net/dsa/mv88e6xxx/global2.c
index ac302a935ce69..79954e580c335 100644
--- a/drivers/net/dsa/mv88e6xxx/global2.c
+++ b/drivers/net/dsa/mv88e6xxx/global2.c
@@ -1184,31 +1184,19 @@ int mv88e6xxx_g2_irq_setup(struct mv88e6xxx_chip *chip)
 int mv88e6xxx_g2_irq_mdio_setup(struct mv88e6xxx_chip *chip,
 				struct mii_bus *bus)
 {
-	int phy, irq, err, err_phy;
+	int phy, irq;
 
 	for (phy = 0; phy < chip->info->num_internal_phys; phy++) {
 		irq = irq_find_mapping(chip->g2_irq.domain, phy);
-		if (irq < 0) {
-			err = irq;
-			goto out;
-		}
+		if (irq < 0)
+			return irq;
+
 		bus->irq[chip->info->phy_base_addr + phy] = irq;
 	}
 	return 0;
-out:
-	err_phy = phy;
-
-	for (phy = 0; phy < err_phy; phy++)
-		irq_dispose_mapping(bus->irq[phy]);
-
-	return err;
 }
 
 void mv88e6xxx_g2_irq_mdio_free(struct mv88e6xxx_chip *chip,
 				struct mii_bus *bus)
 {
-	int phy;
-
-	for (phy = 0; phy < chip->info->num_internal_phys; phy++)
-		irq_dispose_mapping(bus->irq[phy]);
 }
-- 
2.39.5



