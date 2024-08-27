Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2601C5793;
	Tue, 27 Aug 2024 14:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770520; cv=none; b=Gzx06WdZ2STPyPsFZ+WSiGIspCIOHOZVV0YYHl+o068ivgO1orZwz79Bxhf7Fdkzvji+wTXgqTMbc8bx2bOSI1g4+9rjK0TaGjM5+o56Ym7K7UWr61lHmjpoy8eclz+T9WCaWkoVYYWtxA9uEnPSg7js/04R2X53mfpGJicdEFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770520; c=relaxed/simple;
	bh=Y6fhQpDKi5GBSGm0peyTuKPel4oSysW6BkxCO9feXR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H710/KIlEJtzRMtw7ObCe8+8dEwZ9GgBJGuL19hqueue1DAnoech5ZefHpqBHeuNHihfwutRJjvBH3F8la5WFQtZbjQHF5oha23Mrfiwi45HgZmocPG/iYAu0lGkvw3yemxB52/c8xq0MjoHubZdC+MaOKL1vAYZW2ga6hv/pJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JItcZ2NG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JItcZ2NG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3AE6C4E690;
	Tue, 27 Aug 2024 14:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770520;
	bh=Y6fhQpDKi5GBSGm0peyTuKPel4oSysW6BkxCO9feXR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JItcZ2NGsygiEm5iDwmOasSSkmJGB2bMJRwA4n2kGxbHQUbGX2M9rQsPlWRji8SAD
	 AvkqhjNln+vj1JVkuejOEFnov+QpZOtDh8o/s8/ZwM6DB9hFV10piP5ZXMc5xy24EB
	 W6wd/4f+yPo3l4cZosIirQb52mFgrINf+BnHev0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Nyekjaer <sean@geanix.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Wolfram Sang <wsa@kernel.org>,
	Christoph Niedermaier <cniedermaier@dh-electronics.com>
Subject: [PATCH 6.6 223/341] i2c: stm32f7: Add atomic_xfer method to driver
Date: Tue, 27 Aug 2024 16:37:34 +0200
Message-ID: <20240827143851.898632425@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Nyekjaer <sean@geanix.com>

commit 470a662688563d8f5e0fb164930d6f5507a883e4 upstream.

Add an atomic_xfer method to the driver so that it behaves correctly
when controlling a PMIC that is responsible for device shutdown.

The atomic_xfer method added is similar to the one from the i2c-mv64xxx
driver. When running an atomic_xfer a bool flag in the driver data is
set, the interrupt is not unmasked on transfer start, and the IRQ
handler is manually invoked while waiting for pending transfers to
complete.

Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Acked-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Cc: Christoph Niedermaier <cniedermaier@dh-electronics.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-stm32f7.c |   51 +++++++++++++++++++++++++++++++++++----
 1 file changed, 47 insertions(+), 4 deletions(-)

--- a/drivers/i2c/busses/i2c-stm32f7.c
+++ b/drivers/i2c/busses/i2c-stm32f7.c
@@ -357,6 +357,7 @@ struct stm32f7_i2c_dev {
 	u32 dnf_dt;
 	u32 dnf;
 	struct stm32f7_i2c_alert *alert;
+	bool atomic;
 };
 
 /*
@@ -915,7 +916,8 @@ static void stm32f7_i2c_xfer_msg(struct
 
 	/* Configure DMA or enable RX/TX interrupt */
 	i2c_dev->use_dma = false;
-	if (i2c_dev->dma && f7_msg->count >= STM32F7_I2C_DMA_LEN_MIN) {
+	if (i2c_dev->dma && f7_msg->count >= STM32F7_I2C_DMA_LEN_MIN
+	    && !i2c_dev->atomic) {
 		ret = stm32_i2c_prep_dma_xfer(i2c_dev->dev, i2c_dev->dma,
 					      msg->flags & I2C_M_RD,
 					      f7_msg->count, f7_msg->buf,
@@ -939,6 +941,9 @@ static void stm32f7_i2c_xfer_msg(struct
 			cr1 |= STM32F7_I2C_CR1_TXDMAEN;
 	}
 
+	if (i2c_dev->atomic)
+		cr1 &= ~STM32F7_I2C_ALL_IRQ_MASK; /* Disable all interrupts */
+
 	/* Configure Start/Repeated Start */
 	cr2 |= STM32F7_I2C_CR2_START;
 
@@ -1673,7 +1678,22 @@ static irqreturn_t stm32f7_i2c_isr_error
 	return IRQ_HANDLED;
 }
 
-static int stm32f7_i2c_xfer(struct i2c_adapter *i2c_adap,
+static int stm32f7_i2c_wait_polling(struct stm32f7_i2c_dev *i2c_dev)
+{
+	ktime_t timeout = ktime_add_ms(ktime_get(), i2c_dev->adap.timeout);
+
+	while (ktime_compare(ktime_get(), timeout) < 0) {
+		udelay(5);
+		stm32f7_i2c_isr_event(0, i2c_dev);
+
+		if (completion_done(&i2c_dev->complete))
+			return 1;
+	}
+
+	return 0;
+}
+
+static int stm32f7_i2c_xfer_core(struct i2c_adapter *i2c_adap,
 			    struct i2c_msg msgs[], int num)
 {
 	struct stm32f7_i2c_dev *i2c_dev = i2c_get_adapdata(i2c_adap);
@@ -1697,8 +1717,12 @@ static int stm32f7_i2c_xfer(struct i2c_a
 
 	stm32f7_i2c_xfer_msg(i2c_dev, msgs);
 
-	time_left = wait_for_completion_timeout(&i2c_dev->complete,
-						i2c_dev->adap.timeout);
+	if (!i2c_dev->atomic)
+		time_left = wait_for_completion_timeout(&i2c_dev->complete,
+							i2c_dev->adap.timeout);
+	else
+		time_left = stm32f7_i2c_wait_polling(i2c_dev);
+
 	ret = f7_msg->result;
 	if (ret) {
 		if (i2c_dev->use_dma)
@@ -1730,6 +1754,24 @@ pm_free:
 	return (ret < 0) ? ret : num;
 }
 
+static int stm32f7_i2c_xfer(struct i2c_adapter *i2c_adap,
+			    struct i2c_msg msgs[], int num)
+{
+	struct stm32f7_i2c_dev *i2c_dev = i2c_get_adapdata(i2c_adap);
+
+	i2c_dev->atomic = false;
+	return stm32f7_i2c_xfer_core(i2c_adap, msgs, num);
+}
+
+static int stm32f7_i2c_xfer_atomic(struct i2c_adapter *i2c_adap,
+			    struct i2c_msg msgs[], int num)
+{
+	struct stm32f7_i2c_dev *i2c_dev = i2c_get_adapdata(i2c_adap);
+
+	i2c_dev->atomic = true;
+	return stm32f7_i2c_xfer_core(i2c_adap, msgs, num);
+}
+
 static int stm32f7_i2c_smbus_xfer(struct i2c_adapter *adapter, u16 addr,
 				  unsigned short flags, char read_write,
 				  u8 command, int size,
@@ -2098,6 +2140,7 @@ static u32 stm32f7_i2c_func(struct i2c_a
 
 static const struct i2c_algorithm stm32f7_i2c_algo = {
 	.master_xfer = stm32f7_i2c_xfer,
+	.master_xfer_atomic = stm32f7_i2c_xfer_atomic,
 	.smbus_xfer = stm32f7_i2c_smbus_xfer,
 	.functionality = stm32f7_i2c_func,
 	.reg_slave = stm32f7_i2c_reg_slave,


