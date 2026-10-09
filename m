Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774084E66B9;
	Fri,  9 Oct 2026 14:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556998; cv=none; b=HPxjEpTLhLrzAzAwfJxRFgrt2K0hU8TR54tqoyVyoXPSN8JWuUD2efe+kzUgCybgKP7AqifBn1s67zFt6mNdTBtMZdNtVJRlLw6PHgJg8PX6Ls21JwiTqEb4rP2VZKYvUIp73feq6XX9HabkjkjjZmWPxbizw2jZRCYLMS8rQNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556998; c=relaxed/simple;
	bh=4mha64YW2Dr67N19J881Hjt6RMElyqarZbHEcHNfx0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sNE5HssPyRnzeNieduF/9m9dTwvsunkN3jCws7MxMtUucbdB9qGtC7R6dM9Zh2GIPcZP+eI1AwbPsB5IhAMLNXpY69uFohjRVBZN6bLgeUOCjZZarJd4PXWl7Q94I4E1nXTF198UE6W/Jo3RSLHHk+hyjcNCXU7C6GO43pRML2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nVDrXzg/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nVDrXzg/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE1C1F000FF;
	Fri,  9 Oct 2026 14:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556995;
	bh=Vjfl+700qWk/BrY4TOmbkTdi5UVIzi0WOX2iWnvC77Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nVDrXzg/LxIDex8G9jGA4FbNWmpoj+wRL8jd2vRp5Zhnp2JR0SRzlmUesSbhT9yBr
	 Ffop+jQiZHJOqTimxABUuR1ArJix7ySCDmRAgeM9Gk48LVNAKeDd5EjRL9QvqLjuzG
	 DwVFMMSsb8IfGXsVhy2RjAy/h3v8tgkd056LsenA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	Michal Simek <michal.simek@amd.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 7.2 279/428] i2c: xiic: preserve PEC byte length in SMBus block read setup
Date: Fri,  9 Oct 2026 16:10:16 +0200
Message-ID: <20261009140952.225968825@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdurrahman Hussain <abdurrahman@nexthop.ai>

commit b7e6df2f52ed5c02838832f53c171a5645f9b376 upstream.

xiic_smbus_block_read_setup() recalculates i2c->rx_msg->len based on the
length byte returned by the device, but historically clobbered the PEC
byte expectation the SMBus core had baked into msg->len. That dropped
the PEC byte from the caller's buffer on the normal and chunked
receive-fifo branches.

Compute pec_len up-front as (i2c->rx_msg->len - 1) -- the trailing bytes
the caller has already accounted for beyond the length byte, 1 when the
SMBus core enabled PEC, and possibly more for an I2C_M_RECV_LEN request
coming from i2c-dev -- and add it to the new length in every branch:

  - chunked: the trailing bytes do not fit in the Rx FIFO, so drain in
    chunks. The guard becomes (rxmsg_len + pec_len > IIC_RX_FIFO_DEPTH)
    rather than rxmsg_len alone, both because pec_len bytes also have to
    fit and because it is what bounds rfd_set in the else branch below
    to the 4 bits of XIIC_RFD_REG_OFFSET.

  - padded (1 + rxmsg_len + pec_len < SMBUS_BLOCK_READ_MIN_LEN): the
    hardware needs at least 3 bytes on the bus to exit the read cleanly
    (the second byte is already being clocked in by the time the ISR
    reads the length byte and is too late to NACK), so we still pad
    rx_msg->len up to SMBUS_BLOCK_READ_MIN_LEN. The dummy trailing byte
    that gets drained must then be trimmed off before handing the
    message back to the SMBus core; otherwise i2c_smbus_check_pec()
    reads buf[len-1] (= dummy) instead of the real PEC byte at buf[1]
    and rejects every clean zero-length block read with -EBADMSG.

    Record the true valid byte count in a new field
    i2c->smbus_actual_len and trim rx_msg->len down to it in
    xiic_smbus_trim_len(), called from both completion sites that clear
    rx_msg: xiic_process()'s RX_FULL branch and xiic_recv_atomic(),
    which drains the FIFO with interrupts off.

    smbus_actual_len is per-receive state, so xiic_start_recv() clears
    it before every receive. Only the padded branch ever sets it, and a
    block read aborted by arbitration loss or a TX error never reaches
    the completion site, so without that clear a stale value would trim
    the length of an unrelated later read.

    The condition is expressed in total bytes rather than the old
    "(rxmsg_len == 1) || (rxmsg_len == 0)" so that a request carrying
    more than one trailing byte does not get padded: padding records a
    length the drain never reaches, which would hand the caller a byte
    that was never received.

  - normal: all trailing bytes fit in one FIFO fill. rfd_set gains
    pec_len for the same reason the length does. Because the padded
    branch above has already taken every case with fewer than
    SMBUS_BLOCK_READ_MIN_LEN total bytes, rxmsg_len + pec_len is at
    least 2 here and the subtraction cannot underflow the u8.

Fixes: e4c1ff772e1a ("i2c: xiic: Add smbus_block_read functionality")
Signed-off-by: Abdurrahman Hussain <abdurrahman@nexthop.ai>
Cc: <stable@vger.kernel.org> # v6.3+
Acked-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://patch.msgid.link/20260924-i2c-xiic-v7-1-df7e752332ef@nexthop.ai
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-xiic.c |   54 +++++++++++++++++++++++++++++++-----------
 1 file changed, 41 insertions(+), 13 deletions(-)

--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -73,6 +73,9 @@ enum i2c_scl_freq {
  * @prev_msg_tx: Previous message is Tx
  * @quirks: To hold platform specific bug info
  * @smbus_block_read: Flag to handle block read
+ * @smbus_actual_len: Valid byte count (length + payload + optional PEC) of a
+ *	padded SMBus block read. msg->len is trimmed to this on completion.
+ *	Zero when no trimming is needed.
  * @input_clk: Input clock to I2C controller
  * @i2c_clk: I2C SCL frequency
  * @atomic: Mode of transfer
@@ -98,6 +101,7 @@ struct xiic_i2c {
 	bool prev_msg_tx;
 	u32 quirks;
 	bool smbus_block_read;
+	unsigned int smbus_actual_len;
 	unsigned long input_clk;
 	unsigned int i2c_clk;
 	bool atomic;
@@ -539,30 +543,38 @@ static void xiic_smbus_block_read_setup(
 
 	/* Check if received length is valid */
 	if (rxmsg_len <= I2C_SMBUS_BLOCK_MAX) {
+		unsigned int pec_len = i2c->rx_msg->len - 1;
+
 		/* Set Receive fifo depth */
-		if (rxmsg_len > IIC_RX_FIFO_DEPTH) {
+		if (rxmsg_len + pec_len > IIC_RX_FIFO_DEPTH) {
 			/*
-			 * When Rx msg len greater than or equal to Rx fifo capacity
-			 * Receive fifo depth should set to Rx fifo capacity minus 1
+			 * Trailing bytes (payload plus any PEC) exceed Rx FIFO
+			 * capacity, so drain in chunks. This also keeps the
+			 * else branch below from pushing rfd_set past the
+			 * 4-bit XIIC_RFD_REG_OFFSET field.
 			 */
 			rfd_set = IIC_RX_FIFO_DEPTH - 1;
-			i2c->rx_msg->len = rxmsg_len + 1;
-		} else if ((rxmsg_len == 1) ||
-			(rxmsg_len == 0)) {
+			i2c->rx_msg->len = rxmsg_len + 1 + pec_len;
+		} else if (1 + rxmsg_len + pec_len < SMBUS_BLOCK_READ_MIN_LEN) {
 			/*
-			 * Minimum of 3 bytes required to exit cleanly. 1 byte
-			 * already received, Second byte is being received. Have
-			 * to set NACK in read_rx before receiving the last byte
+			 * The HW needs SMBUS_BLOCK_READ_MIN_LEN bytes on the
+			 * bus to exit cleanly: by the time the ISR reads the
+			 * length byte the second byte is already being clocked
+			 * in, too late to NACK. Pad the drain target and record
+			 * the real length, trimmed back on completion so the
+			 * PEC check sees the right byte.
 			 */
 			rfd_set = 0;
 			i2c->rx_msg->len = SMBUS_BLOCK_READ_MIN_LEN;
+			i2c->smbus_actual_len = 1 + rxmsg_len + pec_len;
 		} else {
 			/*
-			 * When Rx msg len less than Rx fifo capacity
-			 * Receive fifo depth should set to Rx msg len minus 2
+			 * All trailing bytes fit in the Rx FIFO. The widened
+			 * condition above guarantees rxmsg_len + pec_len >= 2,
+			 * so this cannot underflow.
 			 */
-			rfd_set = rxmsg_len - 2;
-			i2c->rx_msg->len = rxmsg_len + 1;
+			rfd_set = rxmsg_len + pec_len - 2;
+			i2c->rx_msg->len = rxmsg_len + 1 + pec_len;
 		}
 		xiic_setreg8(i2c, XIIC_RFD_REG_OFFSET, rfd_set);
 
@@ -575,6 +587,16 @@ static void xiic_smbus_block_read_setup(
 	dev_err(i2c->adap.dev.parent, "smbus_block_read Invalid msg length\n");
 }
 
+/*
+ * Undo the setup-time padding of a short SMBus block read before rx_msg is
+ * cleared, so the PEC check sees the right byte.
+ */
+static void xiic_smbus_trim_len(struct xiic_i2c *i2c)
+{
+	if (i2c->rx_msg && i2c->smbus_actual_len)
+		i2c->rx_msg->len = i2c->smbus_actual_len;
+}
+
 static void xiic_read_rx(struct xiic_i2c *i2c)
 {
 	u8 bytes_in_fifo, cr = 0, bytes_to_read = 0;
@@ -797,6 +819,8 @@ static irqreturn_t xiic_process(int irq,
 
 		xiic_read_rx(i2c);
 		if (xiic_rx_space(i2c) == 0) {
+			xiic_smbus_trim_len(i2c);
+
 			/* this is the last part of the message */
 			i2c->rx_msg = NULL;
 
@@ -938,6 +962,7 @@ static void xiic_recv_atomic(struct xiic
 			return;
 	}
 
+	xiic_smbus_trim_len(i2c);
 	i2c->rx_msg = NULL;
 	xiic_irq_clr_en(i2c, XIIC_INTR_TX_ERROR_MASK);
 
@@ -955,6 +980,9 @@ static void xiic_start_recv(struct xiic_
 	u8 cr = 0, rfd_set = 0;
 	struct i2c_msg *msg = i2c->rx_msg = i2c->tx_msg;
 
+	/* A stale value from an aborted block read would truncate this msg. */
+	i2c->smbus_actual_len = 0;
+
 	if (!i2c->atomic)
 		dev_dbg(i2c->adap.dev.parent, "%s entry, ISR: 0x%x, CR: 0x%x\n",
 			__func__, xiic_getreg32(i2c, XIIC_IISR_OFFSET),


