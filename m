Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433AA337EB9;
	Wed, 17 Sep 2025 12:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112883; cv=none; b=Hfo7QFZ+QcyMUol4k926OSuig4vH/qU+n15XO9PBpcOqIgAPGjT/fMPtuoD/nwuA1lZ5FllmRXjXr1WDSVEVB4dQv/OwENNfrD42r+Dzp/706EmKR48xAmwQ64B+gilJAsO3ZEiht5RS2dy6V4gvRRjCs+1C3v7UUXEDh29Pfjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112883; c=relaxed/simple;
	bh=kVjeoa4d9qPwFps18sw6FomZUU/IovSTbTf+xK5jxWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dsPmvnfNsyYwM3AYrok9gAYQl7HSGhDYaA1xgKuUSiWEo5rlCFrJuKrPRCk5OL/g/eFJ1mh7Rex6YyKZuBs+5a+kjWEDMtHhb+/VH5REEYbaZQ2C8IF4uOC6iQpUEsLyA1EMrBb6CfO48VGlChrl8dfLjpCr1QHceTZNlgCFGso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C9anWFlK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C9anWFlK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89475C4CEF5;
	Wed, 17 Sep 2025 12:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112883;
	bh=kVjeoa4d9qPwFps18sw6FomZUU/IovSTbTf+xK5jxWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C9anWFlKWGiXXNqgimQ5O3lUSSJ+DqdfQxtdtYhqaL05IAMrUXO0g7EAuZiTOc2xN
	 mCfPYKuv2FaemCmU0IAgGvSN2BqjQ5/D7B1mN+RdOfp8J+ynSDOgck1ZUoW1vxcAZw
	 7gn8fsQXYjHBdr7FEC6M78Otp2hX10LnS3tT9HIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Jelonek <jelonek.jonas@gmail.com>,
	Sven Eckelmann <sven@narfation.org>,
	Chris Packham <chris.packham@alliedtelesis.co.nz>,
	Markus Stockhausen <markus.stockhausen@gmx.de>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.16 061/189] i2c: rtl9300: remove broken SMBus Quick operation support
Date: Wed, 17 Sep 2025 14:32:51 +0200
Message-ID: <20250917123353.362978078@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Jelonek <jelonek.jonas@gmail.com>

commit ede965fd555ac2536cf651893a998dbfd8e57b86 upstream.

Remove the SMBus Quick operation from this driver because it is not
natively supported by the hardware and is wrongly implemented in the
driver.

The I2C controllers in Realtek RTL9300 and RTL9310 are SMBus-compliant
but there doesn't seem to be native support for the SMBus Quick
operation. It is not explicitly mentioned in the documentation but
looking at the registers which configure an SMBus transaction, one can
see that the data length cannot be set to 0. This suggests that the
hardware doesn't allow any SMBus message without data bytes (except for
those it does on it's own, see SMBus Block Read).

The current implementation of SMBus Quick operation passes a length of
0 (which is actually invalid). Before the fix of a bug in a previous
commit, this led to a read operation of 16 bytes from any register (the
one of a former transaction or any other value.

This caused issues like soft-bricked SFP modules after a simple probe
with i2cdetect which uses Quick by default. Running this with SFP
modules whose EEPROM isn't write-protected, some of the initial bytes
are overwritten because a 16-byte write operation is executed instead of
a Quick Write. (This temporarily soft-bricked one of my DAC cables.)

Because SMBus Quick operation is obviously not supported on these
controllers (because a length of 0 cannot be set, even when no register
address is set), remove that instead of claiming there is support. There
also shouldn't be any kind of emulated 'Quick' which just does another
kind of operation in the background. Otherwise, specific issues occur
in case of a 'Quick' Write which actually writes unknown data to an
unknown register.

Fixes: c366be720235 ("i2c: Add driver for the RTL9300 I2C controller")
Cc: stable@vger.kernel.org # v6.13+
Signed-off-by: Jonas Jelonek <jelonek.jonas@gmail.com>
Tested-by: Sven Eckelmann <sven@narfation.org>
Reviewed-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Tested-by: Chris Packham <chris.packham@alliedtelesis.co.nz> # On RTL9302C based board
Tested-by: Markus Stockhausen <markus.stockhausen@gmx.de>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20250831100457.3114-4-jelonek.jonas@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-rtl9300.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/i2c/busses/i2c-rtl9300.c b/drivers/i2c/busses/i2c-rtl9300.c
index 2b3e80aa1bdf..9e1f71fed0fe 100644
--- a/drivers/i2c/busses/i2c-rtl9300.c
+++ b/drivers/i2c/busses/i2c-rtl9300.c
@@ -225,15 +225,6 @@ static int rtl9300_i2c_smbus_xfer(struct i2c_adapter *adap, u16 addr, unsigned s
 	}
 
 	switch (size) {
-	case I2C_SMBUS_QUICK:
-		ret = rtl9300_i2c_config_xfer(i2c, chan, addr, 0);
-		if (ret)
-			goto out_unlock;
-		ret = rtl9300_i2c_reg_addr_set(i2c, 0, 0);
-		if (ret)
-			goto out_unlock;
-		break;
-
 	case I2C_SMBUS_BYTE:
 		if (read_write == I2C_SMBUS_WRITE) {
 			ret = rtl9300_i2c_config_xfer(i2c, chan, addr, 0);
@@ -315,9 +306,9 @@ static int rtl9300_i2c_smbus_xfer(struct i2c_adapter *adap, u16 addr, unsigned s
 
 static u32 rtl9300_i2c_func(struct i2c_adapter *a)
 {
-	return I2C_FUNC_SMBUS_QUICK | I2C_FUNC_SMBUS_BYTE |
-	       I2C_FUNC_SMBUS_BYTE_DATA | I2C_FUNC_SMBUS_WORD_DATA |
-	       I2C_FUNC_SMBUS_BLOCK_DATA;
+	return I2C_FUNC_SMBUS_BYTE | I2C_FUNC_SMBUS_BYTE_DATA |
+	       I2C_FUNC_SMBUS_WORD_DATA | I2C_FUNC_SMBUS_BLOCK_DATA |
+	       I2C_FUNC_SMBUS_I2C_BLOCK;
 }
 
 static const struct i2c_algorithm rtl9300_i2c_algo = {
-- 
2.51.0



