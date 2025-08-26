Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03D226AEC;
	Tue, 26 Aug 2025 11:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207838; cv=none; b=dbYHeT8xPg6vymVTo5yJiAU5/Xdy/p82ZO8qLv8ytyx9tB/MIAn6lSqTuJKX5EUWF5gjasFjLiLgieGLw22s6uFZnvRIll7Og84UBw23dI0aLC6KCIFCwlilNH3hjSDkYrlFb2r6FnpM1rJE9zzeVFlW2ag3kAjs26sHvv3Xg3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207838; c=relaxed/simple;
	bh=cEpZq0ccfJkz/x3EJc3sjNejzzz8oC5QxJJjB5NXMj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TERMhdPO6GvZG1DUgGRBNVevyXvRHA/YNUgOQNZA1LAwgSumzbkapHWB5wpp38FIcKCHmk5AUOul7iyEdYtqxSy82pkVASsUp4sVM7Jbgc+IkVfs80RbuiV6/DeLvaGv6tjg1B62PCfUmSDKCIupJzxxUYOY/S+RemR6C2lrcNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZsjRD+jq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZsjRD+jq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5278DC4CEF4;
	Tue, 26 Aug 2025 11:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207838;
	bh=cEpZq0ccfJkz/x3EJc3sjNejzzz8oC5QxJJjB5NXMj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZsjRD+jqULcf1m0j+NhsioP38G439YpBVE4dOK9PohjEFpVoV5HTYT/M+415F+dBY
	 uktPp0BepxDZZQEkP5xzMBxUjBeneF44sLCqbJKgdUNU2PyhAC6/Y3ONAiXjWaBay6
	 TMdCbXd+P3sJT2GpluRpvY7eIVcM+BxR4XfTbK/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Chris Packham <chris.packham@alliedtelesis.co.nz>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.16 336/457] i2c: rtl9300: Add missing count byte for SMBus Block Ops
Date: Tue, 26 Aug 2025 13:10:20 +0200
Message-ID: <20250826110945.637389869@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

commit 82b350dd8185ce790e61555c436f90b6501af23c upstream.

The expected on-wire format of an SMBus Block Write is

  S Addr Wr [A] Comm [A] Count [A] Data [A] Data [A] ... [A] Data [A] P

Everything starting from the Count byte is provided by the I2C subsystem in
the array data->block. But the driver was skipping the Count byte
(data->block[0]) when sending it to the RTL93xx I2C controller.

Only the actual data could be seen on the wire:

  S Addr Wr [A] Comm [A] Data [A] Data [A] ... [A] Data [A] P

This wire format is not SMBus Block Write compatible but matches the format
of an I2C Block Write. Simply adding the count byte to the buffer for the
I2C controller is enough to fix the transmission.

This also affects read because the I2C controller must receive the count
byte + $count * data bytes.

Fixes: c366be720235 ("i2c: Add driver for the RTL9300 I2C controller")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Cc: <stable@vger.kernel.org> # v6.13+
Reviewed-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Tested-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20250810-i2c-rtl9300-multi-byte-v5-4-cd9dca0db722@narfation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-rtl9300.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/i2c/busses/i2c-rtl9300.c
+++ b/drivers/i2c/busses/i2c-rtl9300.c
@@ -285,15 +285,15 @@ static int rtl9300_i2c_smbus_xfer(struct
 			ret = -EINVAL;
 			goto out_unlock;
 		}
-		ret = rtl9300_i2c_config_xfer(i2c, chan, addr, data->block[0]);
+		ret = rtl9300_i2c_config_xfer(i2c, chan, addr, data->block[0] + 1);
 		if (ret)
 			goto out_unlock;
 		if (read_write == I2C_SMBUS_WRITE) {
-			ret = rtl9300_i2c_write(i2c, &data->block[1], data->block[0]);
+			ret = rtl9300_i2c_write(i2c, &data->block[0], data->block[0] + 1);
 			if (ret)
 				goto out_unlock;
 		}
-		len = data->block[0];
+		len = data->block[0] + 1;
 		break;
 
 	default:


