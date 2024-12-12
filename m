Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529EA23D41A;
	Thu, 12 Dec 2024 16:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021389; cv=none; b=hNrT/iX+H8oG5/tUhqA9lHjqcGiEzLk9uuszMCm2+9vDGxa25FdUAkLXGe+0X0rTSAmYLDGcuB6tiNGVKz6y/eXHg9aKn0bAhqWX/RloQJERiSxuYS+mC693n7fnbYYA275omOUOdf31pUqBZUlYOPVQApi1yqlvMYFiDolw82c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021389; c=relaxed/simple;
	bh=23mm1DgTsziXuhOmRpohDWx+sWaCFtIacC80VqSmTUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FpmS5hilBvoOpQ0AQnIUQmjQvU0TkAndTAo7qi/JtfO5QM5qnJBc8Gv4Ys4qtS7sTjlWvBIE04z5np7zwj8mHg3D5LNGuBf/8H5pq2I8Wh/oAvX5Bf7Fnw/sW9wL7+XhgJy7STdvt8crG/bKpv4EWu+wd5xOCsAzpStPUG7ADWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NHpz+UqW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NHpz+UqW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4CD2C4CECE;
	Thu, 12 Dec 2024 16:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021389;
	bh=23mm1DgTsziXuhOmRpohDWx+sWaCFtIacC80VqSmTUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NHpz+UqW5lloy1nb+b6PB+rX9w2mQtbn/Q4hjfePACLgN/rXilDkCtQ7C4dyE+637
	 XDwza9nsb9pC5pP57epsQateRT955eZze8PRe4mgZRII8E46Qz9dKzbsAZkHEnkrzD
	 5FiFbuUg9i9yWB6c5kZejb1tc07cLwwM02umNSfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Parker Newman <pnewman@connecttech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 725/772] misc: eeprom: eeprom_93cx6: Add quirk for extra read clock cycle
Date: Thu, 12 Dec 2024 16:01:10 +0100
Message-ID: <20241212144419.850872471@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Parker Newman <pnewman@connecttech.com>

[ Upstream commit 7738a7ab9d12c5371ed97114ee2132d4512e9fd5 ]

Add a quirk similar to eeprom_93xx46 to add an extra clock cycle before
reading data from the EEPROM.

The 93Cx6 family of EEPROMs output a "dummy 0 bit" between the writing
of the op-code/address from the host to the EEPROM and the reading of
the actual data from the EEPROM.

More info can be found on page 6 of the AT93C46 datasheet (linked below).
Similar notes are found in other 93xx6 datasheets.

In summary the read operation for a 93Cx6 EEPROM is:
Write to EEPROM:	110[A5-A0]	(9 bits)
Read from EEPROM:	0[D15-D0]	(17 bits)

Where:
	110 is the start bit and READ OpCode
	[A5-A0] is the address to read from
	0 is a "dummy bit" preceding the actual data
	[D15-D0] is the actual data.

Looking at the READ timing diagrams in the 93Cx6 datasheets the dummy
bit should be clocked out on the last address bit clock cycle meaning it
should be discarded naturally.

However, depending on the hardware configuration sometimes this dummy
bit is not discarded. This is the case with Exar PCI UARTs which require
an extra clock cycle between sending the address and reading the data.

Datasheet: https://ww1.microchip.com/downloads/en/DeviceDoc/Atmel-5193-SEEPROM-AT93C46D-Datasheet.pdf
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Parker Newman <pnewman@connecttech.com>
Link: https://lore.kernel.org/r/0f23973efefccd2544705a0480b4ad4c2353e407.1727880931.git.pnewman@connecttech.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/eeprom/eeprom_93cx6.c | 10 ++++++++++
 include/linux/eeprom_93cx6.h       | 11 +++++++++++
 2 files changed, 21 insertions(+)

diff --git a/drivers/misc/eeprom/eeprom_93cx6.c b/drivers/misc/eeprom/eeprom_93cx6.c
index 9627294fe3e95..4c9827fe92173 100644
--- a/drivers/misc/eeprom/eeprom_93cx6.c
+++ b/drivers/misc/eeprom/eeprom_93cx6.c
@@ -186,6 +186,11 @@ void eeprom_93cx6_read(struct eeprom_93cx6 *eeprom, const u8 word,
 	eeprom_93cx6_write_bits(eeprom, command,
 		PCI_EEPROM_WIDTH_OPCODE + eeprom->width);
 
+	if (has_quirk_extra_read_cycle(eeprom)) {
+		eeprom_93cx6_pulse_high(eeprom);
+		eeprom_93cx6_pulse_low(eeprom);
+	}
+
 	/*
 	 * Read the requested 16 bits.
 	 */
@@ -252,6 +257,11 @@ void eeprom_93cx6_readb(struct eeprom_93cx6 *eeprom, const u8 byte,
 	eeprom_93cx6_write_bits(eeprom, command,
 		PCI_EEPROM_WIDTH_OPCODE + eeprom->width + 1);
 
+	if (has_quirk_extra_read_cycle(eeprom)) {
+		eeprom_93cx6_pulse_high(eeprom);
+		eeprom_93cx6_pulse_low(eeprom);
+	}
+
 	/*
 	 * Read the requested 8 bits.
 	 */
diff --git a/include/linux/eeprom_93cx6.h b/include/linux/eeprom_93cx6.h
index c860c72a921d0..3a485cc0e0fa0 100644
--- a/include/linux/eeprom_93cx6.h
+++ b/include/linux/eeprom_93cx6.h
@@ -11,6 +11,8 @@
 	Supported chipsets: 93c46, 93c56 and 93c66.
  */
 
+#include <linux/bits.h>
+
 /*
  * EEPROM operation defines.
  */
@@ -34,6 +36,7 @@
  * @register_write(struct eeprom_93cx6 *eeprom): handler to
  * write to the eeprom register by using all reg_* fields.
  * @width: eeprom width, should be one of the PCI_EEPROM_WIDTH_* defines
+ * @quirks: eeprom or controller quirks
  * @drive_data: Set if we're driving the data line.
  * @reg_data_in: register field to indicate data input
  * @reg_data_out: register field to indicate data output
@@ -50,6 +53,9 @@ struct eeprom_93cx6 {
 	void (*register_write)(struct eeprom_93cx6 *eeprom);
 
 	int width;
+	unsigned int quirks;
+/* Some EEPROMs require an extra clock cycle before reading */
+#define PCI_EEPROM_QUIRK_EXTRA_READ_CYCLE	BIT(0)
 
 	char drive_data;
 	char reg_data_in;
@@ -71,3 +77,8 @@ extern void eeprom_93cx6_wren(struct eeprom_93cx6 *eeprom, bool enable);
 
 extern void eeprom_93cx6_write(struct eeprom_93cx6 *eeprom,
 			       u8 addr, u16 data);
+
+static inline bool has_quirk_extra_read_cycle(struct eeprom_93cx6 *eeprom)
+{
+	return eeprom->quirks & PCI_EEPROM_QUIRK_EXTRA_READ_CYCLE;
+}
-- 
2.43.0



