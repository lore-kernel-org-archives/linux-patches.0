Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F94A2C15AC;
	Tue, 13 Oct 2026 12:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895846; cv=none; b=BusTPICqP7DkJg1bAqJvakxHZE06K9BDX1kodP9c6PfTYG6qT1UL4viUyAaynrvmtC3IYbOaveM8HwcBLmnegY762oot7+vndw2VeG0WtOb8o+8XNKT9Xq5oo/6SBLPElbpCJq1jcCTVT/p4WcNpWq7kjqfOljFO6vHGuIr1GfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895846; c=relaxed/simple;
	bh=bcUe9SC4usts4zZB9dGA9RJ83+5re5uXKcY73JnzlDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BnB4NRDLa96M2XbdPi512NlKZUGCkVsm6QRphl6OYm09LhVoWZqOe4AQNpTH9oRxKUiuc2MDyvtI3V0jmTa3jIqrr39jxdSgClawfxgm8I3cJ9/XtgtSW8nCqwgFFKzPBY/jsfEH5v4bpRt/G1uBPdIqHLfeD679MxcbUQ/tB3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ln/5M6hn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ln/5M6hn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 838DF1F000FF;
	Tue, 13 Oct 2026 12:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895845;
	bh=f+3hDV7IyxxxKGceKDnMH5+bg2bzoJDPEUI7g9za/YY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ln/5M6hn33bS6YSlBRLly7OxdmhvCUN9MeeuNlW0xlRpHmCaijgQK9gCmr+BuG6nJ
	 GHXyEjIdK/96EHrxSswOdLcKQsEw3PL7C0nlB0z7YW2I6drRevzOcNoR+l0UnMMsPc
	 Jmccqxoa0+z1JXDg6zB4C6jHwHFRb4qS8wyGqI0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhishek Ojha <Abhishek.ojha@savoirfairelinux.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 410/497] regulator: ltc3676: dont read the write-only HRST and CLIRQ registers
Date: Tue, 13 Oct 2026 13:39:37 +0200
Message-ID: <20261013112917.621482101@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abhishek Ojha <Abhishek.ojha@savoirfairelinux.com>

commit 28c2388ee24cdbefbcc458fa41ef7bffaaa1cc83 upstream.

HRST (0x1e) and CLIRQ (0x1f) are write-only command strobes. Writing HRST
triggers a hard reset of the chip and writing CLIRQ clears the interrupt;
reading them returns nothing useful, and the read itself fires the command.

The result is that a plain register dump resets the board:

  cat /sys/kernel/debug/regmap/2-003c/registers

walks every readable register, hits HRST, and the board reboots.

Split the callback back in two so HRST and CLIRQ stay writable but are no
longer readable. The readable range is left unchanged
(LTC3676_BUCK1 ... LTC3676_IRQSTAT).

Fixes: 37b918a034fe ("regulator: Add LTC3676 support")
Cc: stable@vger.kernel.org
Signed-off-by: Abhishek Ojha <Abhishek.ojha@savoirfairelinux.com>
Link: https://patch.msgid.link/20260902010701.3360310-1-Abhishek.ojha@savoirfairelinux.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/ltc3676.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/regulator/ltc3676.c
+++ b/drivers/regulator/ltc3676.c
@@ -232,7 +232,7 @@ static const struct regulator_desc ltc36
 	LTC3676_FIXED_REG(LDO4, ldo4, LDOB, 2),
 };
 
-static bool ltc3676_readable_writeable_reg(struct device *dev, unsigned int reg)
+static bool ltc3676_writeable_reg(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
 	case LTC3676_BUCK1 ... LTC3676_IRQSTAT:
@@ -243,6 +243,15 @@ static bool ltc3676_readable_writeable_r
 	return false;
 }
 
+static bool ltc3676_readable_reg(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case LTC3676_BUCK1 ... LTC3676_IRQSTAT:
+		return true;
+	}
+	return false;
+}
+
 static bool ltc3676_volatile_reg(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
@@ -255,8 +264,8 @@ static bool ltc3676_volatile_reg(struct
 static const struct regmap_config ltc3676_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
-	.writeable_reg = ltc3676_readable_writeable_reg,
-	.readable_reg = ltc3676_readable_writeable_reg,
+	.writeable_reg = ltc3676_writeable_reg,
+	.readable_reg = ltc3676_readable_reg,
 	.volatile_reg = ltc3676_volatile_reg,
 	.max_register = LTC3676_CLIRQ,
 	.use_single_read = true,


