Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92531171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:04:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF21FC433C7;
	Mon, 21 Aug 2023 20:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648264;
	bh=2THKcNxLAcd+ATlpULelVfzP9k8jslJitnzFS1BXOo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mZ8MbnvNUepdQV7ezn7Hexp1vrLQHS815hl2MUW23qjKvu61TCzkeKP0TgNBFPLZa
	 f/CWkMvUZwplYsKtZVyc0MyNRAqySYg/e2TyHVb9Ut0ll1g0CW6Bpi7v+CmQl9FlWi
	 GjNT0TDz4pYLvdmZS5Q8Jug2Nct70TWbeKYw1+LA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tam Nguyen <tamnguyenchi@os.amperecomputing.com>,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 6.4 113/234] i2c: designware: Handle invalid SMBus block data response length value
Date: Mon, 21 Aug 2023 21:41:16 +0200
Message-ID: <20230821194133.814177761@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tam Nguyen <tamnguyenchi@os.amperecomputing.com>

commit 69f035c480d76f12bf061148ccfd578e1099e5fc upstream.

In the I2C_FUNC_SMBUS_BLOCK_DATA case, the invalid length byte value
(outside of 1-32) of the SMBus block data response from the Slave device
is not correctly handled by the I2C Designware driver.

In case IC_EMPTYFIFO_HOLD_MASTER_EN==1, which cannot be detected
from the registers, the Master can be disabled only if the STOP bit
is set. Without STOP bit set, the Master remains active, holding the bus
until receiving a block data response length. This hangs the bus and
is unrecoverable.

Avoid this by issuing another dump read to reach the stop condition when
an invalid length byte is received.

Cc: stable@vger.kernel.org
Signed-off-by: Tam Nguyen <tamnguyenchi@os.amperecomputing.com>
Acked-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Link: https://lore.kernel.org/r/20230726080001.337353-3-tamnguyenchi@os.amperecomputing.com
Reviewed-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-designware-master.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/i2c/busses/i2c-designware-master.c
+++ b/drivers/i2c/busses/i2c-designware-master.c
@@ -528,8 +528,19 @@ i2c_dw_read(struct dw_i2c_dev *dev)
 			regmap_read(dev->map, DW_IC_DATA_CMD, &tmp);
 			tmp &= DW_IC_DATA_CMD_DAT;
 			/* Ensure length byte is a valid value */
-			if (flags & I2C_M_RECV_LEN &&
-			    tmp <= I2C_SMBUS_BLOCK_MAX && tmp > 0) {
+			if (flags & I2C_M_RECV_LEN) {
+				/*
+				 * if IC_EMPTYFIFO_HOLD_MASTER_EN is set, which cannot be
+				 * detected from the registers, the controller can be
+				 * disabled if the STOP bit is set. But it is only set
+				 * after receiving block data response length in
+				 * I2C_FUNC_SMBUS_BLOCK_DATA case. That needs to read
+				 * another byte with STOP bit set when the block data
+				 * response length is invalid to complete the transaction.
+				 */
+				if (!tmp || tmp > I2C_SMBUS_BLOCK_MAX)
+					tmp = 1;
+
 				len = i2c_dw_recv_len(dev, tmp);
 			}
 			*buf++ = tmp;


