Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF6B1C2A1;
	Wed,  3 Jan 2024 17:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vxq6tGvA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAC10C433C8;
	Wed,  3 Jan 2024 17:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301260;
	bh=kEHdBygQy9aBzXXhfOZzYp7WXrc1itd9mSe1MdpfQ2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vxq6tGvAdLKrWe7H77oyLGMw5vW+8a2IK0G2nNbbJG91RwmuUbPpjZ31tXBCSPRzR
	 seOJWrdHIvWLYdL/M1msksb9TUVUIQeypG8d5qXpXnKHJu40b5SZ5+ROKIlBiNRzQO
	 QRDzPE/7fXy2jtB+Klj2qHrB7YDoZQWgDQ3J9ny0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Louis Chauvet <louis.chauvet@bootlin.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 083/100] spi: atmel: Fix clock issue when using devices with different polarities
Date: Wed,  3 Jan 2024 17:55:12 +0100
Message-ID: <20240103164908.566606889@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164856.169912722@linuxfoundation.org>
References: <20240103164856.169912722@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Louis Chauvet <louis.chauvet@bootlin.com>

[ Upstream commit fc70d643a2f6678cbe0f5c86433c1aeb4d613fcc ]

The current Atmel SPI controller driver (v2) behaves incorrectly when
using two SPI devices with different clock polarities and GPIO CS.

When switching from one device to another, the controller driver first
enables the CS and then applies whatever configuration suits the targeted
device (typically, the polarities). The side effect of such order is the
apparition of a spurious clock edge after enabling the CS when the clock
polarity needs to be inverted wrt. the previous configuration of the
controller.

This parasitic clock edge is problematic when the SPI device uses that edge
for internal processing, which is perfectly legitimate given that its CS
was asserted. Indeed, devices such as HVS8080 driven by driver gpio-sr in
the kernel are shift registers and will process this first clock edge to
perform a first register shift. In this case, the first bit gets lost and
the whole data block that will later be read by the kernel is all shifted
by one.

    Current behavior:
      The actual switching of the clock polarity only occurs after the CS
      when the controller sends the first message:

    CLK ------------\   /-\ /-\
                    |   | | | |    . . .
                    \---/ \-/ \
    CS  -----\
             |
             \------------------

             ^      ^   ^
             |      |   |
             |      |   Actual clock of the message sent
             |      |
             |      Change of clock polarity, which occurs with the first
             |      write to the bus. This edge occurs when the CS is
             |      already asserted, and can be interpreted as
             |      the first clock edge by the receiver.
             |
             GPIO CS toggle

This issue is specific to this controller because while the SPI core
performs the operations in the right order, the controller however does
not. In practice, the controller only applies the clock configuration right
before the first transmission.

So this is not a problem when using the controller's dedicated CS, as the
controller does things correctly, but it becomes a problem when you need to
change the clock polarity and use an external GPIO for the CS.

One possible approach to solve this problem is to send a dummy message
before actually activating the CS, so that the controller applies the clock
polarity beforehand.

New behavior:

CLK     ------\      /-\     /-\      /-\     /-\
              |      | | ... | |      | | ... | |
              \------/ \-   -/ \------/ \-   -/ \------

CS      -\/-----------------------\
         ||                       |
         \/                       \---------------------
         ^    ^       ^           ^    ^
         |    |       |           |    |
         |    |       |           |    Expected clock cycles when
         |    |       |           |    sending the message
         |    |       |           |
         |    |       |           Actual GPIO CS activation, occurs inside
         |    |       |           the driver
         |    |       |
         |    |       Dummy message, to trigger clock polarity
         |    |       reconfiguration. This message is not received and
         |    |       processed by the device because CS is low.
         |    |
         |    Change of clock polarity, forced by the dummy message. This
         |    time, the edge is not detected by the receiver.
         |
         This small spike in CS activation is due to the fact that the
         spi-core activates the CS gpio before calling the driver's
         set_cs callback, which deactivates this gpio again until the
         clock polarity is correct.

To avoid having to systematically send a dummy packet, the driver keeps
track of the clock's current polarity. In this way, it only sends the dummy
packet when necessary, ensuring that the clock will have the correct
polarity when the CS is toggled.

There could be two hardware problems with this patch:
1- Maybe the small CS activation peak can confuse SPI devices
2- If on a design, a single wire is used to select two devices depending
on its state, the dummy message may disturb them.

Fixes: 5ee36c989831 ("spi: atmel_spi update chipselect handling")
Cc:  <stable@vger.kernel.org>
Signed-off-by: Louis Chauvet <louis.chauvet@bootlin.com>
Link: https://msgid.link/r/20231204154903.11607-1-louis.chauvet@bootlin.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-atmel.c | 82 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 81 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
index c4f22d50dba58..78daf2b2143c5 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -22,6 +22,7 @@
 #include <linux/gpio/consumer.h>
 #include <linux/pinctrl/consumer.h>
 #include <linux/pm_runtime.h>
+#include <linux/iopoll.h>
 #include <trace/events/spi.h>
 
 /* SPI register offsets */
@@ -278,6 +279,7 @@ struct atmel_spi {
 	bool			keep_cs;
 
 	u32			fifo_size;
+	bool			last_polarity;
 	u8			native_cs_free;
 	u8			native_cs_for_gpio;
 };
@@ -290,6 +292,22 @@ struct atmel_spi_device {
 #define SPI_MAX_DMA_XFER	65535 /* true for both PDC and DMA */
 #define INVALID_DMA_ADDRESS	0xffffffff
 
+/*
+ * This frequency can be anything supported by the controller, but to avoid
+ * unnecessary delay, the highest possible frequency is chosen.
+ *
+ * This frequency is the highest possible which is not interfering with other
+ * chip select registers (see Note for Serial Clock Bit Rate configuration in
+ * Atmel-11121F-ATARM-SAMA5D3-Series-Datasheet_02-Feb-16, page 1283)
+ */
+#define DUMMY_MSG_FREQUENCY	0x02
+/*
+ * 8 bits is the minimum data the controller is capable of sending.
+ *
+ * This message can be anything as it should not be treated by any SPI device.
+ */
+#define DUMMY_MSG		0xAA
+
 /*
  * Version 2 of the SPI controller has
  *  - CR.LASTXFER
@@ -303,6 +321,43 @@ static bool atmel_spi_is_v2(struct atmel_spi *as)
 	return as->caps.is_spi2;
 }
 
+/*
+ * Send a dummy message.
+ *
+ * This is sometimes needed when using a CS GPIO to force clock transition when
+ * switching between devices with different polarities.
+ */
+static void atmel_spi_send_dummy(struct atmel_spi *as, struct spi_device *spi, int chip_select)
+{
+	u32 status;
+	u32 csr;
+
+	/*
+	 * Set a clock frequency to allow sending message on SPI bus.
+	 * The frequency here can be anything, but is needed for
+	 * the controller to send the data.
+	 */
+	csr = spi_readl(as, CSR0 + 4 * chip_select);
+	csr = SPI_BFINS(SCBR, DUMMY_MSG_FREQUENCY, csr);
+	spi_writel(as, CSR0 + 4 * chip_select, csr);
+
+	/*
+	 * Read all data coming from SPI bus, needed to be able to send
+	 * the message.
+	 */
+	spi_readl(as, RDR);
+	while (spi_readl(as, SR) & SPI_BIT(RDRF)) {
+		spi_readl(as, RDR);
+		cpu_relax();
+	}
+
+	spi_writel(as, TDR, DUMMY_MSG);
+
+	readl_poll_timeout_atomic(as->regs + SPI_SR, status,
+				  (status & SPI_BIT(TXEMPTY)), 1, 1000);
+}
+
+
 /*
  * Earlier SPI controllers (e.g. on at91rm9200) have a design bug whereby
  * they assume that spi slave device state will not change on deselect, so
@@ -319,11 +374,17 @@ static bool atmel_spi_is_v2(struct atmel_spi *as)
  * Master on Chip Select 0.")  No workaround exists for that ... so for
  * nCS0 on that chip, we (a) don't use the GPIO, (b) can't support CS_HIGH,
  * and (c) will trigger that first erratum in some cases.
+ *
+ * When changing the clock polarity, the SPI controller waits for the next
+ * transmission to enforce the default clock state. This may be an issue when
+ * using a GPIO as Chip Select: the clock level is applied only when the first
+ * packet is sent, once the CS has already been asserted. The workaround is to
+ * avoid this by sending a first (dummy) message before toggling the CS state.
  */
-
 static void cs_activate(struct atmel_spi *as, struct spi_device *spi)
 {
 	struct atmel_spi_device *asd = spi->controller_state;
+	bool new_polarity;
 	int chip_select;
 	u32 mr;
 
@@ -352,6 +413,25 @@ static void cs_activate(struct atmel_spi *as, struct spi_device *spi)
 		}
 
 		mr = spi_readl(as, MR);
+
+		/*
+		 * Ensures the clock polarity is valid before we actually
+		 * assert the CS to avoid spurious clock edges to be
+		 * processed by the spi devices.
+		 */
+		if (spi_get_csgpiod(spi, 0)) {
+			new_polarity = (asd->csr & SPI_BIT(CPOL)) != 0;
+			if (new_polarity != as->last_polarity) {
+				/*
+				 * Need to disable the GPIO before sending the dummy
+				 * message because it is already set by the spi core.
+				 */
+				gpiod_set_value_cansleep(spi_get_csgpiod(spi, 0), 0);
+				atmel_spi_send_dummy(as, spi, chip_select);
+				as->last_polarity = new_polarity;
+				gpiod_set_value_cansleep(spi_get_csgpiod(spi, 0), 1);
+			}
+		}
 	} else {
 		u32 cpol = (spi->mode & SPI_CPOL) ? SPI_BIT(CPOL) : 0;
 		int i;
-- 
2.43.0



