Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07050391E51;
	Sat, 17 Oct 2026 17:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257281; cv=none; b=T3BIF0eWewM9ahcbgg+KasJOGP82QIWZz0zLmmxX/Tr/OYf6ntBM+KJOkPW1rouXO/yUQAZXUccN7sWxHZeOjy+kWfqvpxTKISyXuInMhtaM2NR3gPa4gBhqRlEI7mMAoFgeKO/UjqIoNl0CVA5qV1NiG+Cf3KEfy0KBsj+i4xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257281; c=relaxed/simple;
	bh=KUZ/6xAZBMFUa4pUTjAMZGDp/2twBPn52/oQZQ6j280=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sbcVnuvifIAsVCojC0+euCqy8v3FH/6xVIvHIrnWxCFJaQOlKL4XKy7O6JE6xkByKPUFqV2YckvWVOu34/+nrQRXf3pvkZ/tQL2iV8aBQ2+7lNaVussQIVjL3At24AQSe4gw22i2RV350bOHFaCvzKBazgUoREpgyouKaHcsYTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H/EEYJv/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H/EEYJv/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 543901F000C4;
	Sat, 17 Oct 2026 17:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257279;
	bh=fMrdtFQ+p9JNg/29GTBj2OCbWHJMzpOgY60Hok82/gA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H/EEYJv/QcAfCapvFLEl1HmT6uX9u0SXNwO00R6GyrEEBpvvWegJbPlFGx1/Mj/Ma
	 N33Y0/0fy58CZ5Bu/LMkXkT2gV5NT8L/Vfv/FJPALKPCNLnkCPCcVVfy9cgPcXMv5f
	 WIjQHqbXTsYEYOqoo8xKIIXbgODBA1Q0qebtUqaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhishek Ojha <Abhishek.ojha@savoirfairelinux.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 0508/1674] regulator: ltc3676: dont read the write-only HRST and CLIRQ registers
Date: Sat, 17 Oct 2026 17:46:20 +0200
Message-ID: <20261017160444.147280496@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


