Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16BC314A81
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 17:18:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35B02C433C8;
	Thu, 24 Aug 2023 17:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692897537;
	bh=Vg1HpZFdF9kS7h+dgZY265u6RH3wYZzcEWah0kpZ69s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mC4kWbN6oLOqDIRfgcWJ6M19Tloe8snhPYKxN0mue1OWIgEbI35OTF88I/mYzI4tm
	 GLKGe8brx9lCHyaOmbC1c8uHE8TwAEE9TrErtL4f49fvrh6innirRihBUqJbizxV5I
	 vTxXZ9lYjBESYiZorSuEpzI4su/xJo58Meu+AO1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tam Nguyen <tamnguyenchi@os.amperecomputing.com>,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.10 075/135] i2c: designware: Handle invalid SMBus block data response length value
Date: Thu, 24 Aug 2023 19:09:07 +0200
Message-ID: <20230824170620.479920965@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824170617.074557800@linuxfoundation.org>
References: <20230824170617.074557800@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

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
@@ -432,8 +432,19 @@ i2c_dw_read(struct dw_i2c_dev *dev)
 
 			regmap_read(dev->map, DW_IC_DATA_CMD, &tmp);
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


