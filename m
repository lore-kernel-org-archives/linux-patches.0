Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A231C68C;
	Sun,  1 Sep 2024 16:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208974; cv=none; b=CaQOjMF3aKAAiPIVLyhOB1FSeBjFRs9e4dA8XLEulHfFF/PjA5K2CXMTLr6Ua2HHWIg+1+pmgore9oTCRVi1TS2kLVc2xd1Jk7dD/+rRhpXtw5JLLgyg8Yx+AtKyc3mZVXUq3K2yj2aO9D1qjFZ2867Dz684/KbUifMASz+1ovw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208974; c=relaxed/simple;
	bh=6HE3yGRYkjrPXstzaZN2u96jfVNzyrwYmsVkDTfhfV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VIszoLqDSfsadtmSvo4mBBw5M4RrBRzYMyt0yzlyCed8PMTZvZLnQNUFYlQOnuYYodBsK4PYkRuNUZT7L5pyA9IsMJOuMLSiyy9lJwa0q8AC+oYK4kFpDXFJVGFcFJ+fwwQVBdEkmI0VNzp62cW+sx5wI0td+sGW88pY3q1CznQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gFPOMbP/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gFPOMbP/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFCB6C4CEC3;
	Sun,  1 Sep 2024 16:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208974;
	bh=6HE3yGRYkjrPXstzaZN2u96jfVNzyrwYmsVkDTfhfV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gFPOMbP/q4ToZDGxPtNs0IN97Sem+1br+uwngQdiGUyNXuzyCGyHklc1O0+oYGFIn
	 gTOThcqMWGWoszee3vvQB2Qu8J7ZI2YuHwmNqFAQoRObjeca4fxhkx2UGK2K1CFKd9
	 zqIG56yjN6pPvz4ILrWF7AMm5F23I9jd2C7yuOIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Hans J. Schultz" <netdev@kapio-technology.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 088/134] net: dsa: mv88e6xxx: read FID when handling ATU violations
Date: Sun,  1 Sep 2024 18:17:14 +0200
Message-ID: <20240901160813.411962613@linuxfoundation.org>
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

From: Hans J. Schultz <netdev@kapio-technology.com>

[ Upstream commit 4bf24ad09bc0b05e97fb48b962b2c9246fc76727 ]

When an ATU violation occurs, the switch uses the ATU FID register to
report the FID of the MAC address that incurred the violation. It would
be good for the driver to know the FID value for purposes such as
logging and CPU-based authentication.

Up until now, the driver has been calling the mv88e6xxx_g1_atu_op()
function to read ATU violations, but that doesn't do exactly what we
want, namely it calls mv88e6xxx_g1_atu_fid_write() with FID 0.
(side note, the documentation for the ATU Get/Clear Violation command
says that writes to the ATU FID register have no effect before the
operation starts, it's only that we disregard the value that this
register provides once the operation completes)

So mv88e6xxx_g1_atu_fid_write() is not what we want, but rather
mv88e6xxx_g1_atu_fid_read(). However, the latter doesn't exist, we need
to write it.

The remainder of mv88e6xxx_g1_atu_op() except for
mv88e6xxx_g1_atu_fid_write() is still needed, namely to send a
GET_CLR_VIOLATION command to the ATU. In principle we could have still
kept calling mv88e6xxx_g1_atu_op(), but the MDIO writes to the ATU FID
register are pointless, but in the interest of doing less CPU work per
interrupt, write a new function called mv88e6xxx_g1_read_atu_violation()
and call it.

The FID will be the port default FID as set by mv88e6xxx_port_set_fid()
if the VID from the packet cannot be found in the VTU. Otherwise it is
the FID derived from the VTU entry associated with that VID.

Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 528876d867a2 ("net: dsa: mv88e6xxx: Fix out-of-bound access")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/global1_atu.c | 72 +++++++++++++++++++++----
 1 file changed, 61 insertions(+), 11 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/global1_atu.c b/drivers/net/dsa/mv88e6xxx/global1_atu.c
index d655a96f27f0a..13ca45bf0f0bb 100644
--- a/drivers/net/dsa/mv88e6xxx/global1_atu.c
+++ b/drivers/net/dsa/mv88e6xxx/global1_atu.c
@@ -82,6 +82,19 @@ static int mv88e6xxx_g1_atu_op_wait(struct mv88e6xxx_chip *chip)
 	return mv88e6xxx_g1_wait_bit(chip, MV88E6XXX_G1_ATU_OP, bit, 0);
 }
 
+static int mv88e6xxx_g1_read_atu_violation(struct mv88e6xxx_chip *chip)
+{
+	int err;
+
+	err = mv88e6xxx_g1_write(chip, MV88E6XXX_G1_ATU_OP,
+				 MV88E6XXX_G1_ATU_OP_BUSY |
+				 MV88E6XXX_G1_ATU_OP_GET_CLR_VIOLATION);
+	if (err)
+		return err;
+
+	return mv88e6xxx_g1_atu_op_wait(chip);
+}
+
 static int mv88e6xxx_g1_atu_op(struct mv88e6xxx_chip *chip, u16 fid, u16 op)
 {
 	u16 val;
@@ -127,6 +140,41 @@ int mv88e6xxx_g1_atu_get_next(struct mv88e6xxx_chip *chip, u16 fid)
 	return mv88e6xxx_g1_atu_op(chip, fid, MV88E6XXX_G1_ATU_OP_GET_NEXT_DB);
 }
 
+static int mv88e6xxx_g1_atu_fid_read(struct mv88e6xxx_chip *chip, u16 *fid)
+{
+	u16 val = 0, upper = 0, op = 0;
+	int err = -EOPNOTSUPP;
+
+	if (mv88e6xxx_num_databases(chip) > 256) {
+		err = mv88e6xxx_g1_read(chip, MV88E6352_G1_ATU_FID, &val);
+		val &= 0xfff;
+		if (err)
+			return err;
+	} else {
+		err = mv88e6xxx_g1_read(chip, MV88E6XXX_G1_ATU_OP, &op);
+		if (err)
+			return err;
+		if (mv88e6xxx_num_databases(chip) > 64) {
+			/* ATU DBNum[7:4] are located in ATU Control 15:12 */
+			err = mv88e6xxx_g1_read(chip, MV88E6XXX_G1_ATU_CTL,
+						&upper);
+			if (err)
+				return err;
+
+			upper = (upper >> 8) & 0x00f0;
+		} else if (mv88e6xxx_num_databases(chip) > 16) {
+			/* ATU DBNum[5:4] are located in ATU Operation 9:8 */
+			upper = (op >> 4) & 0x30;
+		}
+
+		/* ATU DBNum[3:0] are located in ATU Operation 3:0 */
+		val = (op & 0xf) | upper;
+	}
+	*fid = val;
+
+	return err;
+}
+
 /* Offset 0x0C: ATU Data Register */
 
 static int mv88e6xxx_g1_atu_data_read(struct mv88e6xxx_chip *chip,
@@ -321,14 +369,12 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
 {
 	struct mv88e6xxx_chip *chip = dev_id;
 	struct mv88e6xxx_atu_entry entry;
-	int spid;
-	int err;
-	u16 val;
+	int err, spid;
+	u16 val, fid;
 
 	mv88e6xxx_reg_lock(chip);
 
-	err = mv88e6xxx_g1_atu_op(chip, 0,
-				  MV88E6XXX_G1_ATU_OP_GET_CLR_VIOLATION);
+	err = mv88e6xxx_g1_read_atu_violation(chip);
 	if (err)
 		goto out;
 
@@ -336,6 +382,10 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
 	if (err)
 		goto out;
 
+	err = mv88e6xxx_g1_atu_fid_read(chip, &fid);
+	if (err)
+		goto out;
+
 	err = mv88e6xxx_g1_atu_data_read(chip, &entry);
 	if (err)
 		goto out;
@@ -354,22 +404,22 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
 
 	if (val & MV88E6XXX_G1_ATU_OP_MEMBER_VIOLATION) {
 		dev_err_ratelimited(chip->dev,
-				    "ATU member violation for %pM portvec %x spid %d\n",
-				    entry.mac, entry.portvec, spid);
+				    "ATU member violation for %pM fid %u portvec %x spid %d\n",
+				    entry.mac, fid, entry.portvec, spid);
 		chip->ports[spid].atu_member_violation++;
 	}
 
 	if (val & MV88E6XXX_G1_ATU_OP_MISS_VIOLATION) {
 		dev_err_ratelimited(chip->dev,
-				    "ATU miss violation for %pM portvec %x spid %d\n",
-				    entry.mac, entry.portvec, spid);
+				    "ATU miss violation for %pM fid %u portvec %x spid %d\n",
+				    entry.mac, fid, entry.portvec, spid);
 		chip->ports[spid].atu_miss_violation++;
 	}
 
 	if (val & MV88E6XXX_G1_ATU_OP_FULL_VIOLATION) {
 		dev_err_ratelimited(chip->dev,
-				    "ATU full violation for %pM portvec %x spid %d\n",
-				    entry.mac, entry.portvec, spid);
+				    "ATU full violation for %pM fid %u portvec %x spid %d\n",
+				    entry.mac, fid, entry.portvec, spid);
 		chip->ports[spid].atu_full_violation++;
 	}
 	mv88e6xxx_reg_unlock(chip);
-- 
2.43.0



