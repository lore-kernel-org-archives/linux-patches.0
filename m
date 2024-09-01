Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD077184536;
	Sun,  1 Sep 2024 16:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209083; cv=none; b=NzCmNSoD7+DAnYD1O9SRZzFK+TY3eMUuKw6XsFoHFpn7HoNWkqFiRq9Y87pScWnMLx1zOMbIRqmjbjVIJ/byQXSCGrhYp3Cett3qwlHCNPWCKZIZv0LAUUU8UEFJs/ZzptMLYSOI7NmZczdWWj9MeyAmOU623xEqBRwp5aqx3Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209083; c=relaxed/simple;
	bh=HY3TNvcvns5LkXs+E/kss6hjgY7YvLiKee+xiidC+Uc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WgkDZWhSiohPaG6V6x4M9F8viEbvBlMOYswIcdMMuC2FqVeHs4AyjXQsGyiX3bx62y2hRdema/dd+vjJL/QEwvmbGcAEmQHLckeLQOzwAYquhNxcgGgUifZf3NPMliepb+3wCdsblgBm5cM9QoY9mpy9B9M92v8YhIqvXD89ykM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W3Pord0X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W3Pord0X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45EEFC4CEC3;
	Sun,  1 Sep 2024 16:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209083;
	bh=HY3TNvcvns5LkXs+E/kss6hjgY7YvLiKee+xiidC+Uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W3Pord0XZronu10XDoZGX+V98Bmaz8h/Fx0iqGfODtUwv/RAG+3UJ0LN6q4+4SkdE
	 //ZHIhxJFdtHsDCzlh9ulmk8a8Ba0g9cxceNWGS6GTSY0exTg0dTXVRcWTEWkfShIX
	 cHq/VFzee8zBFDeMNSkS+c6vYkA7bS8M+oi8d/f8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 087/134] net: dsa: mv88e6xxx: global1_atu: Add helper for get next
Date: Sun,  1 Sep 2024 18:17:13 +0200
Message-ID: <20240901160813.376332202@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Lunn <andrew@lunn.ch>

[ Upstream commit c5f299d592617847124900d75e5765cb0368ffae ]

When retrieving the ATU statistics, and ATU get next has to be
performed to trigger the ATU to collect the statistics. Export a
helper from global1_atu to perform this.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 528876d867a2 ("net: dsa: mv88e6xxx: Fix out-of-bound access")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/global1.h     |  1 +
 drivers/net/dsa/mv88e6xxx/global1_atu.c |  5 +++++
 drivers/net/dsa/mv88e6xxx/global2.c     | 11 ++---------
 drivers/net/dsa/mv88e6xxx/global2.h     |  2 +-
 4 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/global1.h b/drivers/net/dsa/mv88e6xxx/global1.h
index 0ae96a1e919b6..dc44e197817a8 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.h
+++ b/drivers/net/dsa/mv88e6xxx/global1.h
@@ -339,5 +339,6 @@ int mv88e6390_g1_vtu_loadpurge(struct mv88e6xxx_chip *chip,
 int mv88e6xxx_g1_vtu_flush(struct mv88e6xxx_chip *chip);
 int mv88e6xxx_g1_vtu_prob_irq_setup(struct mv88e6xxx_chip *chip);
 void mv88e6xxx_g1_vtu_prob_irq_free(struct mv88e6xxx_chip *chip);
+int mv88e6xxx_g1_atu_get_next(struct mv88e6xxx_chip *chip, u16 fid);
 
 #endif /* _MV88E6XXX_GLOBAL1_H */
diff --git a/drivers/net/dsa/mv88e6xxx/global1_atu.c b/drivers/net/dsa/mv88e6xxx/global1_atu.c
index 792a96ef418ff..d655a96f27f0a 100644
--- a/drivers/net/dsa/mv88e6xxx/global1_atu.c
+++ b/drivers/net/dsa/mv88e6xxx/global1_atu.c
@@ -122,6 +122,11 @@ static int mv88e6xxx_g1_atu_op(struct mv88e6xxx_chip *chip, u16 fid, u16 op)
 	return mv88e6xxx_g1_atu_op_wait(chip);
 }
 
+int mv88e6xxx_g1_atu_get_next(struct mv88e6xxx_chip *chip, u16 fid)
+{
+	return mv88e6xxx_g1_atu_op(chip, fid, MV88E6XXX_G1_ATU_OP_GET_NEXT_DB);
+}
+
 /* Offset 0x0C: ATU Data Register */
 
 static int mv88e6xxx_g1_atu_data_read(struct mv88e6xxx_chip *chip,
diff --git a/drivers/net/dsa/mv88e6xxx/global2.c b/drivers/net/dsa/mv88e6xxx/global2.c
index 6059c244373c8..4d4bd4a162815 100644
--- a/drivers/net/dsa/mv88e6xxx/global2.c
+++ b/drivers/net/dsa/mv88e6xxx/global2.c
@@ -288,16 +288,9 @@ int mv88e6xxx_g2_atu_stats_set(struct mv88e6xxx_chip *chip, u16 kind, u16 bin)
 				  kind | bin);
 }
 
-int mv88e6xxx_g2_atu_stats_get(struct mv88e6xxx_chip *chip)
+int mv88e6xxx_g2_atu_stats_get(struct mv88e6xxx_chip *chip, u16 *stats)
 {
-	int err;
-	u16 val;
-
-	err = mv88e6xxx_g2_read(chip, MV88E6XXX_G2_ATU_STATS, &val);
-	if (err)
-		return err;
-
-	return val & MV88E6XXX_G2_ATU_STATS_MASK;
+	return mv88e6xxx_g2_read(chip, MV88E6XXX_G2_ATU_STATS, stats);
 }
 
 /* Offset 0x0F: Priority Override Table */
diff --git a/drivers/net/dsa/mv88e6xxx/global2.h b/drivers/net/dsa/mv88e6xxx/global2.h
index 0e0ecf78f5ea7..a0cc40e7c2508 100644
--- a/drivers/net/dsa/mv88e6xxx/global2.h
+++ b/drivers/net/dsa/mv88e6xxx/global2.h
@@ -364,7 +364,7 @@ extern const struct mv88e6xxx_gpio_ops mv88e6352_gpio_ops;
 int mv88e6xxx_g2_scratch_gpio_set_smi(struct mv88e6xxx_chip *chip,
 				      bool external);
 int mv88e6xxx_g2_atu_stats_set(struct mv88e6xxx_chip *chip, u16 kind, u16 bin);
-int mv88e6xxx_g2_atu_stats_get(struct mv88e6xxx_chip *chip);
+int mv88e6xxx_g2_atu_stats_get(struct mv88e6xxx_chip *chip, u16 *stats);
 
 #else /* !CONFIG_NET_DSA_MV88E6XXX_GLOBAL2 */
 
-- 
2.43.0



