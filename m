Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9714E2374A
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o/HTYjvb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15441C433C7;
	Mon,  6 Nov 2023 13:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699277559;
	bh=S3AeahdDLQfRxN3cMamVPj53esaq4I5SMyjMIAx0X3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o/HTYjvbK1qPpfT3KTCXG7TNt05hUchZ1MFHrzP9QBD20XAVk0vXrK4tBz02NEvrx
	 b6y8oo9GHxzmIupdOaWP7V93nqLD4QxDC/lFcw1m7LZjecCOrZOvSC3IjHlwc1lNpJ
	 obBkgYdZc1NkdX6vOPzIXhJQBvA9z8V+fFZU3aio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alain Volmat <alain.volmat@foss.st.com>,
	Pierre-Yves MORDRET <pierre-yves.mordret@foss.st.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.10 30/95] i2c: stm32f7: Fix PEC handling in case of SMBUS transfers
Date: Mon,  6 Nov 2023 14:03:58 +0100
Message-ID: <20231106130305.813361003@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130304.678610325@linuxfoundation.org>
References: <20231106130304.678610325@linuxfoundation.org>
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

From: Alain Volmat <alain.volmat@foss.st.com>

commit c896ff2dd8f30a6b0a922c83a96f6d43f05f0e92 upstream.

In case of SMBUS byte read with PEC enabled, the whole transfer
is split into two commands.  A first write command, followed by
a read command.  The write command does not have any PEC byte
and a PEC byte is appended at the end of the read command.
(cf Read byte protocol with PEC in SMBUS specification)

Within the STM32 I2C controller, handling (either sending
or receiving) of the PEC byte is done via the PECBYTE bit in
register CR2.

Currently, the PECBYTE is set at the beginning of a transfer,
which lead to sending a PEC byte at the end of the write command
(hence losing the real last byte), and also does not check the
PEC byte received during the read command.

This patch corrects the function stm32f7_i2c_smbus_xfer_msg
in order to only set the PECBYTE during the read command.

Fixes: 9e48155f6bfe ("i2c: i2c-stm32f7: Add initial SMBus protocols support")
Signed-off-by: Alain Volmat <alain.volmat@foss.st.com>
Reviewed-by: Pierre-Yves MORDRET <pierre-yves.mordret@foss.st.com>
Acked-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-stm32f7.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/i2c/busses/i2c-stm32f7.c
+++ b/drivers/i2c/busses/i2c-stm32f7.c
@@ -1042,9 +1042,10 @@ static int stm32f7_i2c_smbus_xfer_msg(st
 	/* Configure PEC */
 	if ((flags & I2C_CLIENT_PEC) && f7_msg->size != I2C_SMBUS_QUICK) {
 		cr1 |= STM32F7_I2C_CR1_PECEN;
-		cr2 |= STM32F7_I2C_CR2_PECBYTE;
-		if (!f7_msg->read_write)
+		if (!f7_msg->read_write) {
+			cr2 |= STM32F7_I2C_CR2_PECBYTE;
 			f7_msg->count++;
+		}
 	} else {
 		cr1 &= ~STM32F7_I2C_CR1_PECEN;
 		cr2 &= ~STM32F7_I2C_CR2_PECBYTE;
@@ -1132,8 +1133,10 @@ static void stm32f7_i2c_smbus_rep_start(
 	f7_msg->stop = true;
 
 	/* Add one byte for PEC if needed */
-	if (cr1 & STM32F7_I2C_CR1_PECEN)
+	if (cr1 & STM32F7_I2C_CR1_PECEN) {
+		cr2 |= STM32F7_I2C_CR2_PECBYTE;
 		f7_msg->count++;
+	}
 
 	/* Set number of bytes to be transferred */
 	cr2 &= ~(STM32F7_I2C_CR2_NBYTES_MASK);


