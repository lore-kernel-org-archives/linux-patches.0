Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E56226CF1;
	Mon, 23 Jun 2025 22:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716847; cv=none; b=OB2ay0+iU6A6mrRijdHBjzWFqaUF6DC8dScERb/rGzzHk156Dv8KCQh4e90p6Ib0NbAWqe/h7qPhEFT7eyxcUQQdHTlvsBqrOgjBc/FMiRfoM5P6n2Oxnfer+TsHrZXbOTZ1cEf2PIP4zgp/ribyVklIyD5dQUJFR0I2ig4j6dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716847; c=relaxed/simple;
	bh=plAFY97hYnbXOM2rmsk+gTYqVyXQWHr8WIChAzwroRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g98Uo3GyvHfLIBbhHlfymQzupku8UcfZTE8+l5aOq2eFEwZ/sgkxifgNMi1zprhfyfWjaSfrdIWLVJb0dCJXj3pMaXuXMK0WB31elpgzSFCxuA4yuewa56/+8UPvj6pp5pjw7ATuUAfWaCPcAWUNkSJbX4vBD6b1ZvVCMhvttHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dbgx1MsS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dbgx1MsS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3030BC4CEEA;
	Mon, 23 Jun 2025 22:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716847;
	bh=plAFY97hYnbXOM2rmsk+gTYqVyXQWHr8WIChAzwroRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dbgx1MsSwqYrUfBj0zPBtqUdsqve8lYt/yBwMGgmKkgQiIMYLFax0ExSOiqtm94LV
	 N+DI2a+N2bB0lWRtL4vFYxCWo3ZmF/d2jjhFNDI4Zf073s93I5yz3b0yKrDkrDpcLf
	 cUqJtsxNlor4jXD2ayZtTqq72itRj2w1j7qNX9zY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Elder <elder@riscstar.com>,
	Troy Mitchell <troymitchell988@gmail.com>,
	Andi Shyti <andi@smida.it>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: [PATCH 6.15 562/592] i2c: k1: check for transfer error
Date: Mon, 23 Jun 2025 15:08:40 +0200
Message-ID: <20250623130713.810476550@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@riscstar.com>

commit a6c23dac756b9541b33aa3bcd30f464df2879209 upstream.

If spacemit_i2c_xfer_msg() times out waiting for a message transfer to
complete, or if the hardware reports an error, it returns a negative
error code (-ETIMEDOUT, -EAGAIN, -ENXIO. or -EIO).

The sole caller of spacemit_i2c_xfer_msg() is spacemit_i2c_xfer(),
which is the i2c_algorithm->xfer callback function.  It currently
does not save the value returned by spacemit_i2c_xfer_msg().

The result is that transfer errors go unreported, and a caller
has no indication anything is wrong.

When this code was out for review, the return value *was* checked
in early versions.  But for some reason, that assignment got dropped
between versions 5 and 6 of the series, perhaps related to reworking
the code to merge spacemit_i2c_xfer_core() into spacemit_i2c_xfer().

Simply assigning the value returned to "ret" fixes the problem.

Fixes: 5ea558473fa31 ("i2c: spacemit: add support for SpacemiT K1 SoC")
Signed-off-by: Alex Elder <elder@riscstar.com>
Cc: <stable@vger.kernel.org> # v6.15+
Reviewed-by: Troy Mitchell <troymitchell988@gmail.com>
Link: https://lore.kernel.org/r/20250616125137.1555453-1-elder@riscstar.com
Signed-off-by: Andi Shyti <andi@smida.it>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-k1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-k1.c
+++ b/drivers/i2c/busses/i2c-k1.c
@@ -477,7 +477,7 @@ static int spacemit_i2c_xfer(struct i2c_
 
 	ret = spacemit_i2c_wait_bus_idle(i2c);
 	if (!ret)
-		spacemit_i2c_xfer_msg(i2c);
+		ret = spacemit_i2c_xfer_msg(i2c);
 	else if (ret < 0)
 		dev_dbg(i2c->dev, "i2c transfer error: %d\n", ret);
 	else


