Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD812C85B;
	Fri, 24 Nov 2023 18:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0I9BzR6H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB5D2C433C9;
	Fri, 24 Nov 2023 18:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851404;
	bh=lagw3M79FzeaCDkj+dwBz4jw4r/Gpagzc3Zr3u3dKkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0I9BzR6H48BAJMIgGaZNHoij5RocAkQOHi/wVaWMXApe6B8uriPOj4fgGM4aODTwY
	 GjCRwQLxAGlvvvu5WybMMMZyW91C0RKN6Be3PVSVcROwATQfLUd7NbBSCW6w3TM+K/
	 1K+rlu8pWQ3EKv3/YM7tK0aC2KQoHS9VFvG+9rdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuong Tran <chuong@os.amperecomputing.com>,
	Tam Nguyen <tamnguyenchi@os.amperecomputing.com>,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Serge Semin <fancer.lancer@gmail.com>,
	Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 6.5 410/491] i2c: designware: Disable TX_EMPTY irq while waiting for block length byte
Date: Fri, 24 Nov 2023 17:50:46 +0000
Message-ID: <20231124172036.928427608@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tam Nguyen <tamnguyenchi@os.amperecomputing.com>

commit e8183fa10c25c7b3c20670bf2b430ddcc1ee03c0 upstream.

During SMBus block data read process, we have seen high interrupt rate
because of TX_EMPTY irq status while waiting for block length byte (the
first data byte after the address phase). The interrupt handler does not
do anything because the internal state is kept as STATUS_WRITE_IN_PROGRESS.
Hence, we should disable TX_EMPTY IRQ until I2C DesignWare receives
first data byte from I2C device, then re-enable it to resume SMBus
transaction.

It takes 0.789 ms for host to receive data length from slave.
Without the patch, i2c_dw_isr() is called 99 times by TX_EMPTY interrupt.
And it is none after applying the patch.

Cc: stable@vger.kernel.org
Co-developed-by: Chuong Tran <chuong@os.amperecomputing.com>
Signed-off-by: Chuong Tran <chuong@os.amperecomputing.com>
Signed-off-by: Tam Nguyen <tamnguyenchi@os.amperecomputing.com>
Acked-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-designware-master.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/drivers/i2c/busses/i2c-designware-master.c
+++ b/drivers/i2c/busses/i2c-designware-master.c
@@ -518,10 +518,16 @@ i2c_dw_xfer_msg(struct dw_i2c_dev *dev)
 
 		/*
 		 * Because we don't know the buffer length in the
-		 * I2C_FUNC_SMBUS_BLOCK_DATA case, we can't stop
-		 * the transaction here.
+		 * I2C_FUNC_SMBUS_BLOCK_DATA case, we can't stop the
+		 * transaction here. Also disable the TX_EMPTY IRQ
+		 * while waiting for the data length byte to avoid the
+		 * bogus interrupts flood.
 		 */
-		if (buf_len > 0 || flags & I2C_M_RECV_LEN) {
+		if (flags & I2C_M_RECV_LEN) {
+			dev->status |= STATUS_WRITE_IN_PROGRESS;
+			intr_mask &= ~DW_IC_INTR_TX_EMPTY;
+			break;
+		} else if (buf_len > 0) {
 			/* more bytes to be written */
 			dev->status |= STATUS_WRITE_IN_PROGRESS;
 			break;
@@ -557,6 +563,13 @@ i2c_dw_recv_len(struct dw_i2c_dev *dev,
 	msgs[dev->msg_read_idx].len = len;
 	msgs[dev->msg_read_idx].flags &= ~I2C_M_RECV_LEN;
 
+	/*
+	 * Received buffer length, re-enable TX_EMPTY interrupt
+	 * to resume the SMBUS transaction.
+	 */
+	regmap_update_bits(dev->map, DW_IC_INTR_MASK, DW_IC_INTR_TX_EMPTY,
+			   DW_IC_INTR_TX_EMPTY);
+
 	return len;
 }
 


