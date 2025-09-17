Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54AB1EF36C;
	Wed, 17 Sep 2025 12:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112880; cv=none; b=GxuVXGJLBd1bZqr5GTswohOQ+47+Wgwmk5sybESjPbGOCqUF3DjlJoi9F9Op823w6tvqmXQdoCh1d1diRbtRBQgTpD8fOAbj+8wqjSUxe/ee3XhM3r/xj4EiMa3bExwEzjDVBQZig5L85WntiOiQoEq9cUjy3Z5HQLZD5l3fAms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112880; c=relaxed/simple;
	bh=85fGUMi8h1rVg2xCPlPdP4I7glCQf7PfwxK4AJqSwsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BOpevDH95zjBFZgXj9Nb2Um6ppqZAd20OYmAJ7IwvFRI3shFvypyzUiAyyeJjIbNeqb4F8i1Kuib4ITZisabT4HoL/dUaaMW0+yTDSnAVvfzyOqlN5QY2YnZltbUz90KRjVanla+xBMayMiJsQ043sgmbwNu1PwO6hKxZXtTp8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lh5CT6z/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lh5CT6z/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3AE6C4CEF5;
	Wed, 17 Sep 2025 12:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112879;
	bh=85fGUMi8h1rVg2xCPlPdP4I7glCQf7PfwxK4AJqSwsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lh5CT6z/k+5jjv+f7cpLSChrTl0b6kUt0atkKFevQBbaGZavtmZx3Fbv7EHWB6zMY
	 MZpYu/gaKyx5ghG9tF64WzkkMuHID3/3HZgwMt81DqLe+JFda0WmJ6QamYEyHTWJoB
	 cD2RAwSfwodbPUaMabuiGhRgPPs9VlzXZQzNdT90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Jelonek <jelonek.jonas@gmail.com>,
	Sven Eckelmann <sven@narfation.org>,
	Chris Packham <chris.packham@alliedtelesis.co.nz>,
	Markus Stockhausen <markus.stockhausen@gmx.de>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.16 060/189] i2c: rtl9300: ensure data length is within supported range
Date: Wed, 17 Sep 2025 14:32:50 +0200
Message-ID: <20250917123353.336781358@linuxfoundation.org>
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

commit 06418cb5a1a542a003fdb4ad8e76ea542d57cfba upstream.

Add an explicit check for the xfer length to 'rtl9300_i2c_config_xfer'
to ensure the data length isn't within the supported range. In
particular a data length of 0 is not supported by the hardware and
causes unintended or destructive behaviour.

This limitation becomes obvious when looking at the register
documentation [1]. 4 bits are reserved for DATA_WIDTH and the value
of these 4 bits is used as N + 1, allowing a data length range of
1 <= len <= 16.

Affected by this is the SMBus Quick Operation which works with a data
length of 0. Passing 0 as the length causes an underflow of the value
due to:

(len - 1) & 0xf

and effectively specifying a transfer length of 16 via the registers.
This causes a 16-byte write operation instead of a Quick Write. For
example, on SFP modules without write-protected EEPROM this soft-bricks
them by overwriting some initial bytes.

For completeness, also add a quirk for the zero length.

[1] https://svanheule.net/realtek/longan/register/i2c_mst1_ctrl2

Fixes: c366be720235 ("i2c: Add driver for the RTL9300 I2C controller")
Cc: stable@vger.kernel.org # v6.13+
Signed-off-by: Jonas Jelonek <jelonek.jonas@gmail.com>
Tested-by: Sven Eckelmann <sven@narfation.org>
Reviewed-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Tested-by: Chris Packham <chris.packham@alliedtelesis.co.nz> # On RTL9302C based board
Tested-by: Markus Stockhausen <markus.stockhausen@gmx.de>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20250831100457.3114-3-jelonek.jonas@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-rtl9300.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-rtl9300.c
+++ b/drivers/i2c/busses/i2c-rtl9300.c
@@ -99,6 +99,9 @@ static int rtl9300_i2c_config_xfer(struc
 {
 	u32 val, mask;
 
+	if (len < 1 || len > 16)
+		return -EINVAL;
+
 	val = chan->bus_freq << RTL9300_I2C_MST_CTRL2_SCL_FREQ_OFS;
 	mask = RTL9300_I2C_MST_CTRL2_SCL_FREQ_MASK;
 
@@ -323,7 +326,7 @@ static const struct i2c_algorithm rtl930
 };
 
 static struct i2c_adapter_quirks rtl9300_i2c_quirks = {
-	.flags		= I2C_AQ_NO_CLK_STRETCH,
+	.flags		= I2C_AQ_NO_CLK_STRETCH | I2C_AQ_NO_ZERO_LEN,
 	.max_read_len	= 16,
 	.max_write_len	= 16,
 };


