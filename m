Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78FDE2B9C7;
	Sun,  1 Sep 2024 16:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208945; cv=none; b=FoULIFOfYXPWrvDjVir+w/loNqTozYEHmSsnYz2Ib54UTPUzn2DsaAI5JW4OQHL/tKKscR2406XDl2Lr1dAcq7A8uxRUhwSJrT4FK1fSOluxwVJKvMMQJk5rSGPTdEwSy5zYP+HGrIOy1yXcVQp94P0g051S8/4vl7yGkTiYeH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208945; c=relaxed/simple;
	bh=5/46+tbBwBHlScR87AujN2gd6qfwqF3Iv2/MlaYkhiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pq6KZyDdmjzrmMT8ulnnGCNXqg4/dgSUCGVnSn8WzT3XxnWVyqD4U8n09cyYdKOi+NOXuQJ3fXx4fKnCve80w8+mXmi78RdDyEY6qBOoexnpHSLDLAcccD3JZ+ARznCds8/w5/UX0zZLIt8cMr325Mh2HUIsWE0Sr7hRuPHqcCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y4Pp1ffX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y4Pp1ffX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E354AC4CEC3;
	Sun,  1 Sep 2024 16:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208945;
	bh=5/46+tbBwBHlScR87AujN2gd6qfwqF3Iv2/MlaYkhiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y4Pp1ffXb89zRK0xWr/2r/85nY9tUssZZAdMTmPlOnb4wUlBWTOrHDEoSlMEUDEJ/
	 hp7oqNdKRygXbovZIFRFcRevzGKwOOoRvHc0EHgZlFoUKyInzg2lrUG8cc2Tok7cAS
	 H1QKs3UxUy1Kh0GgqF5C4IeSxr5zeiuzhFIgYtMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 086/134] net: dsa: mv88e6xxx: global2: Expose ATU stats register
Date: Sun,  1 Sep 2024 18:17:12 +0200
Message-ID: <20240901160813.338967040@linuxfoundation.org>
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

[ Upstream commit 6239a386e784aed13c3ead54c3992ebcb0512d5f ]

Add helpers to set/get the ATU statistics register.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 528876d867a2 ("net: dsa: mv88e6xxx: Fix out-of-bound access")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/global2.c | 20 ++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/global2.h | 24 +++++++++++++++++++++++-
 2 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/global2.c b/drivers/net/dsa/mv88e6xxx/global2.c
index 7674b0b8cc707..6059c244373c8 100644
--- a/drivers/net/dsa/mv88e6xxx/global2.c
+++ b/drivers/net/dsa/mv88e6xxx/global2.c
@@ -280,6 +280,26 @@ int mv88e6xxx_g2_set_switch_mac(struct mv88e6xxx_chip *chip, u8 *addr)
 	return err;
 }
 
+/* Offset 0x0E: ATU Statistics */
+
+int mv88e6xxx_g2_atu_stats_set(struct mv88e6xxx_chip *chip, u16 kind, u16 bin)
+{
+	return mv88e6xxx_g2_write(chip, MV88E6XXX_G2_ATU_STATS,
+				  kind | bin);
+}
+
+int mv88e6xxx_g2_atu_stats_get(struct mv88e6xxx_chip *chip)
+{
+	int err;
+	u16 val;
+
+	err = mv88e6xxx_g2_read(chip, MV88E6XXX_G2_ATU_STATS, &val);
+	if (err)
+		return err;
+
+	return val & MV88E6XXX_G2_ATU_STATS_MASK;
+}
+
 /* Offset 0x0F: Priority Override Table */
 
 static int mv88e6xxx_g2_pot_write(struct mv88e6xxx_chip *chip, int pointer,
diff --git a/drivers/net/dsa/mv88e6xxx/global2.h b/drivers/net/dsa/mv88e6xxx/global2.h
index 12807e52ecea1..0e0ecf78f5ea7 100644
--- a/drivers/net/dsa/mv88e6xxx/global2.h
+++ b/drivers/net/dsa/mv88e6xxx/global2.h
@@ -113,7 +113,16 @@
 #define MV88E6XXX_G2_SWITCH_MAC_DATA_MASK	0x00ff
 
 /* Offset 0x0E: ATU Stats Register */
-#define MV88E6XXX_G2_ATU_STATS		0x0e
+#define MV88E6XXX_G2_ATU_STATS				0x0e
+#define MV88E6XXX_G2_ATU_STATS_BIN_0			(0x0 << 14)
+#define MV88E6XXX_G2_ATU_STATS_BIN_1			(0x1 << 14)
+#define MV88E6XXX_G2_ATU_STATS_BIN_2			(0x2 << 14)
+#define MV88E6XXX_G2_ATU_STATS_BIN_3			(0x3 << 14)
+#define MV88E6XXX_G2_ATU_STATS_MODE_ALL			(0x0 << 12)
+#define MV88E6XXX_G2_ATU_STATS_MODE_ALL_DYNAMIC		(0x1 << 12)
+#define MV88E6XXX_G2_ATU_STATS_MODE_FID_ALL		(0x2 << 12)
+#define MV88E6XXX_G2_ATU_STATS_MODE_FID_ALL_DYNAMIC	(0x3 << 12)
+#define MV88E6XXX_G2_ATU_STATS_MASK			0x0fff
 
 /* Offset 0x0F: Priority Override Table */
 #define MV88E6XXX_G2_PRIO_OVERRIDE		0x0f
@@ -354,6 +363,8 @@ extern const struct mv88e6xxx_gpio_ops mv88e6352_gpio_ops;
 
 int mv88e6xxx_g2_scratch_gpio_set_smi(struct mv88e6xxx_chip *chip,
 				      bool external);
+int mv88e6xxx_g2_atu_stats_set(struct mv88e6xxx_chip *chip, u16 kind, u16 bin);
+int mv88e6xxx_g2_atu_stats_get(struct mv88e6xxx_chip *chip);
 
 #else /* !CONFIG_NET_DSA_MV88E6XXX_GLOBAL2 */
 
@@ -516,6 +527,17 @@ static inline int mv88e6xxx_g2_device_mapping_write(struct mv88e6xxx_chip *chip,
 	return -EOPNOTSUPP;
 }
 
+static inline int mv88e6xxx_g2_atu_stats_set(struct mv88e6xxx_chip *chip,
+					     u16 kind, u16 bin)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int mv88e6xxx_g2_atu_stats_get(struct mv88e6xxx_chip *chip)
+{
+	return -EOPNOTSUPP;
+}
+
 #endif /* CONFIG_NET_DSA_MV88E6XXX_GLOBAL2 */
 
 #endif /* _MV88E6XXX_GLOBAL2_H */
-- 
2.43.0



