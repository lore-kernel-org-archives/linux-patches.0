Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6232D2FD7C8;
	Tue, 26 Aug 2025 11:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207833; cv=none; b=G7ws0zwkhb82cC6f3NEovI41XWuvuDUKTBC05tVI31w2v+EWmK0SOAsV+Dpuuvha5NTNKLg7s3ZHLrdoBIRg777ESy2m1p3+Tg45PTdai/YsuGj9vMZ4RRSj7mSaJUQciIOR9nrHA9OiK+fUUO2E3qjHC2oKQHuqwmG8fou9Anw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207833; c=relaxed/simple;
	bh=AUkcE+sa6W8C4rXlW4EhgQtHnuM/GX0pc5/gjEEBanI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WD02rEU092Pug+uoZ7//ZSYEzImEjhiowe3PahABeBHN8r6zBvuy9R+YZNSXr2jxwGo2w6E59PXWH8aPIr7tnNxEgbtrilgSIQ+S5QueBcjNzYmzGGFBaYlsByNRScVYifxO0+ZInk0wLxvvQ+5ek7yeZf8hDB8107UahjVjU7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nQUIvJWD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nQUIvJWD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2ABBC4CEF1;
	Tue, 26 Aug 2025 11:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207833;
	bh=AUkcE+sa6W8C4rXlW4EhgQtHnuM/GX0pc5/gjEEBanI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nQUIvJWD7mDY1xiZJKLvVII0fRuXaiAgoGgVUlzgs4wOr03BKTgQvH/YDIoAvU/Ox
	 T6jShEqwQNBNqmPIhwM4dNFURoFUqDudCtpwN5Tz137DA236Ulci4z4BugI0UpOvHk
	 oeP2RD3OIoZSB55tUBX7dzJdcJ0Ldc5+8wTsJDfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshal Gohel <hg@simonwunderlich.de>,
	Sven Eckelmann <sven@narfation.org>,
	Chris Packham <chris.packham@alliedtelesis.co.nz>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.16 334/457] i2c: rtl9300: Fix multi-byte I2C write
Date: Tue, 26 Aug 2025 13:10:18 +0200
Message-ID: <20250826110945.590532079@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

From: Harshal Gohel <hg@simonwunderlich.de>

commit d67b740b9edfa46310355e2b68050f79ebf05a4c upstream.

The RTL93xx I2C controller has 4 32 bit registers to store the bytes for
the upcoming I2C transmission. The first byte is stored in the
least-significant byte of the first register. And the last byte in the most
significant byte of the last register. A map of the transferred bytes to
their order in the registers is:

reg 0: 0x04_03_02_01
reg 1: 0x08_07_06_05
reg 2: 0x0c_0b_0a_09
reg 3: 0x10_0f_0e_0d

The i2c_read() function basically demonstrates how the hardware would pick
up bytes from this register set. But the i2c_write() function was just
pushing bytes one after another to the least significant byte of a register
AFTER shifting the last one to the next more significant byte position.

If you would then have tried to send a buffer with numbers 1-11 using
i2c_write(), you would have ended up with following register content:

reg 0: 0x01_02_03_04
reg 1: 0x05_06_07_08
reg 2: 0x00_09_0a_0b
reg 3: 0x00_00_00_00

On the wire, you would then have seen:

  Sr Addr Wr [A] 04 A 03 A 02 A 01 A 08 A 07 A 06 A 05 A 0b A 0a A 09 A P

But the correct data transmission was expected to be

  Sr Addr Wr [A] 01 A 02 A 03 A 04 A 05 A 06 A 07 A 08 A 09 A 0a A 0b A P

Because of this multi-byte ordering problem, only single byte i2c_write()
operations were executed correctly (on the wire).

By shifting the byte directly to the correct end position in the register,
it is possible to avoid this incorrect byte ordering and fix multi-byte
transmissions.

The second initialization (to 0) of vals was also be dropped because this
array is initialized to 0 on the stack by using `= {};`. This makes the
fix a lot more readable.

Fixes: c366be720235 ("i2c: Add driver for the RTL9300 I2C controller")
Signed-off-by: Harshal Gohel <hg@simonwunderlich.de>
Cc: <stable@vger.kernel.org> # v6.13+
Co-developed-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Reviewed-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Tested-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20250810-i2c-rtl9300-multi-byte-v5-2-cd9dca0db722@narfation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-rtl9300.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/i2c/busses/i2c-rtl9300.c
+++ b/drivers/i2c/busses/i2c-rtl9300.c
@@ -143,10 +143,10 @@ static int rtl9300_i2c_write(struct rtl9
 		return -EIO;
 
 	for (i = 0; i < len; i++) {
-		if (i % 4 == 0)
-			vals[i/4] = 0;
-		vals[i/4] <<= 8;
-		vals[i/4] |= buf[i];
+		unsigned int shift = (i % 4) * 8;
+		unsigned int reg = i / 4;
+
+		vals[reg] |= buf[i] << shift;
 	}
 
 	return regmap_bulk_write(i2c->regmap, i2c->reg_base + RTL9300_I2C_MST_DATA_WORD0,


