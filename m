Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837C83043B8;
	Tue, 30 Sep 2025 15:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245271; cv=none; b=Zcrf1/gSlFoVHXc3KqtpmuHjf8fdnVMDVgCdDFjQiytTAYLHXNhhghlO/vhMzVMzF4U8ELsRAYFx1odfG7O8Nv9gmC0PiU0a8BQ7QIkq5gnDmsrABBcBMULq8pMdwwf28NVynE7zVwcbzM/cK7NMGXXWMGd8hMvZJNdHuWrpR+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245271; c=relaxed/simple;
	bh=sIDPSvqkB7qhBgqFAt4w25X32qpzdRdjGFDd5kG0gzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hulZalhzA2hlANCkeSnlQjZT81bqANJbLxPH43wSVrg7JIPSjq4V7Fmpf182VrGrToCQp+pL72tYHDJ4lVZ3XBdkJEYc7tzY2a2a2AXtRdPuKY7k1FUo4VHB+S8N4qFAZKqI9qHxyWWHJfHrA1+tA1FQIJkvotVyp5pZwKlB1FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tjfAC0/Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tjfAC0/Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E57C0C4CEF0;
	Tue, 30 Sep 2025 15:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245271;
	bh=sIDPSvqkB7qhBgqFAt4w25X32qpzdRdjGFDd5kG0gzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tjfAC0/YdVaMZTXORiop7ccenBxkbzsNBJ+UJ86fiX/XRhyxLRGk2WrAUAePH1Bvl
	 3EXpgdmv6SiWpUfa2Q2L5p+fSsTCUG/AZA3WZSazlAcQlfGHuVS5jzNKSh4L1NUOKi
	 jTUhsuoqJLMrcSq6ZtkLSL96rIAtIQkWThpYMjXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 117/151] can: bittiming: allow TDC{V,O} to be zero and add can_tdc_const::tdc{v,o,f}_min
Date: Tue, 30 Sep 2025 16:47:27 +0200
Message-ID: <20250930143832.267989475@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

[ Upstream commit 63dfe0709643528290c8a6825f278eda0e3f3c2e ]

ISO 11898-1 specifies in section 11.3.3 "Transmitter delay
compensation" that "the configuration range for [the] SSP position
shall be at least 0 to 63 minimum time quanta."

Because SSP = TDCV + TDCO, it means that we should allow both TDCV and
TDCO to hold zero value in order to honor SSP's minimum possible
value.

However, current implementation assigned special meaning to TDCV and
TDCO's zero values:
  * TDCV = 0 -> TDCV is automatically measured by the transceiver.
  * TDCO = 0 -> TDC is off.

In order to allow for those values to really be zero and to maintain
current features, we introduce two new flags:
  * CAN_CTRLMODE_TDC_AUTO indicates that the controller support
    automatic measurement of TDCV.
  * CAN_CTRLMODE_TDC_MANUAL indicates that the controller support
    manual configuration of TDCV. N.B.: current implementation failed
    to provide an option for the driver to indicate that only manual
    mode was supported.

TDC is disabled if both CAN_CTRLMODE_TDC_AUTO and
CAN_CTRLMODE_TDC_MANUAL flags are off, c.f. the helper function
can_tdc_is_enabled() which is also introduced in this patch.

Also, this patch adds three fields: tdcv_min, tdco_min and tdcf_min to
struct can_tdc_const. While we are not convinced that those three
fields could be anything else than zero, we can imagine that some
controllers might specify a lower bound on these. Thus, those minimums
are really added "just in case".

Comments of struct can_tdc and can_tdc_const are updated accordingly.

Finally, the changes are applied to the etas_es58x driver.

Link: https://lore.kernel.org/all/20210918095637.20108-2-mailhol.vincent@wanadoo.fr
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Stable-dep-of: 38c0abad45b1 ("can: etas_es58x: populate ndo_change_mtu() to prevent buffer overflow")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/dev/bittiming.c           | 10 ++--
 drivers/net/can/usb/etas_es58x/es58x_fd.c |  7 ++-
 include/linux/can/bittiming.h             | 64 +++++++++++++++++------
 include/linux/can/dev.h                   |  4 ++
 include/uapi/linux/can/netlink.h          |  2 +
 5 files changed, 65 insertions(+), 22 deletions(-)

diff --git a/drivers/net/can/dev/bittiming.c b/drivers/net/can/dev/bittiming.c
index b1b5a82f08299..9dda44c0ae9df 100644
--- a/drivers/net/can/dev/bittiming.c
+++ b/drivers/net/can/dev/bittiming.c
@@ -182,9 +182,12 @@ void can_calc_tdco(struct net_device *dev)
 	struct can_tdc *tdc = &priv->tdc;
 	const struct can_tdc_const *tdc_const = priv->tdc_const;
 
-	if (!tdc_const)
+	if (!tdc_const ||
+	    !(priv->ctrlmode_supported & CAN_CTRLMODE_TDC_AUTO))
 		return;
 
+	priv->ctrlmode &= ~CAN_CTRLMODE_TDC_MASK;
+
 	/* As specified in ISO 11898-1 section 11.3.3 "Transmitter
 	 * delay compensation" (TDC) is only applicable if data BRP is
 	 * one or two.
@@ -193,9 +196,10 @@ void can_calc_tdco(struct net_device *dev)
 		/* Reuse "normal" sample point and convert it to time quanta */
 		u32 sample_point_in_tq = can_bit_time(dbt) * dbt->sample_point / 1000;
 
+		if (sample_point_in_tq < tdc_const->tdco_min)
+			return;
 		tdc->tdco = min(sample_point_in_tq, tdc_const->tdco_max);
-	} else {
-		tdc->tdco = 0;
+		priv->ctrlmode |= CAN_CTRLMODE_TDC_AUTO;
 	}
 }
 #endif /* CONFIG_CAN_CALC_BITTIMING */
diff --git a/drivers/net/can/usb/etas_es58x/es58x_fd.c b/drivers/net/can/usb/etas_es58x/es58x_fd.c
index 26bf4775e884c..b71d1530638b7 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_fd.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_fd.c
@@ -427,7 +427,7 @@ static int es58x_fd_enable_channel(struct es58x_priv *priv)
 		es58x_fd_convert_bittiming(&tx_conf_msg.data_bittiming,
 					   &priv->can.data_bittiming);
 
-		if (priv->can.tdc.tdco) {
+		if (can_tdc_is_enabled(&priv->can)) {
 			tx_conf_msg.tdc_enabled = 1;
 			tx_conf_msg.tdco = cpu_to_le16(priv->can.tdc.tdco);
 			tx_conf_msg.tdcf = cpu_to_le16(priv->can.tdc.tdcf);
@@ -504,8 +504,11 @@ static const struct can_bittiming_const es58x_fd_data_bittiming_const = {
  * Register" from Microchip.
  */
 static const struct can_tdc_const es58x_tdc_const = {
+	.tdcv_min = 0,
 	.tdcv_max = 0, /* Manual mode not supported. */
+	.tdco_min = 0,
 	.tdco_max = 127,
+	.tdcf_min = 0,
 	.tdcf_max = 127
 };
 
@@ -522,7 +525,7 @@ const struct es58x_parameters es58x_fd_param = {
 	.clock = {.freq = 80 * CAN_MHZ},
 	.ctrlmode_supported = CAN_CTRLMODE_LOOPBACK | CAN_CTRLMODE_LISTENONLY |
 	    CAN_CTRLMODE_3_SAMPLES | CAN_CTRLMODE_FD | CAN_CTRLMODE_FD_NON_ISO |
-	    CAN_CTRLMODE_CC_LEN8_DLC,
+	    CAN_CTRLMODE_CC_LEN8_DLC | CAN_CTRLMODE_TDC_AUTO,
 	.tx_start_of_frame = 0xCEFA,	/* FACE in little endian */
 	.rx_start_of_frame = 0xFECA,	/* CAFE in little endian */
 	.tx_urb_cmd_max_len = ES58X_FD_TX_URB_CMD_MAX_LEN,
diff --git a/include/linux/can/bittiming.h b/include/linux/can/bittiming.h
index 9de6e9053e34f..9e20260611ccb 100644
--- a/include/linux/can/bittiming.h
+++ b/include/linux/can/bittiming.h
@@ -19,6 +19,9 @@
 /* Megahertz */
 #define CAN_MHZ 1000000UL
 
+#define CAN_CTRLMODE_TDC_MASK					\
+	(CAN_CTRLMODE_TDC_AUTO | CAN_CTRLMODE_TDC_MANUAL)
+
 /*
  * struct can_tdc - CAN FD Transmission Delay Compensation parameters
  *
@@ -33,29 +36,43 @@
  *
  * This structure contains the parameters to calculate that SSP.
  *
- * @tdcv: Transmitter Delay Compensation Value. Distance, in time
- *	quanta, from when the bit is sent on the TX pin to when it is
- *	received on the RX pin of the transmitter. Possible options:
+ * -+----------- one bit ----------+-- TX pin
+ *  |<--- Sample Point --->|
+ *
+ *                         --+----------- one bit ----------+-- RX pin
+ *  |<-------- TDCV -------->|
+ *                           |<------- TDCO ------->|
+ *  |<----------- Secondary Sample Point ---------->|
+ *
+ * @tdcv: Transmitter Delay Compensation Value. The time needed for
+ *	the signal to propagate, i.e. the distance, in time quanta,
+ *	from the start of the bit on the TX pin to when it is received
+ *	on the RX pin. @tdcv depends on the controller modes:
+ *
+ *	  CAN_CTRLMODE_TDC_AUTO is set: The transceiver dynamically
+ *	  measures @tdcv for each transmitted CAN FD frame and the
+ *	  value provided here should be ignored.
  *
- *	  0: automatic mode. The controller dynamically measures @tdcv
- *	  for each transmitted CAN FD frame.
+ *	  CAN_CTRLMODE_TDC_MANUAL is set: use the fixed provided @tdcv
+ *	  value.
  *
- *	  Other values: manual mode. Use the fixed provided value.
+ *	N.B. CAN_CTRLMODE_TDC_AUTO and CAN_CTRLMODE_TDC_MANUAL are
+ *	mutually exclusive. Only one can be set at a time. If both
+ *	CAN_TDC_CTRLMODE_AUTO and CAN_TDC_CTRLMODE_MANUAL are unset,
+ *	TDC is disabled and all the values of this structure should be
+ *	ignored.
  *
  * @tdco: Transmitter Delay Compensation Offset. Offset value, in time
  *	quanta, defining the distance between the start of the bit
  *	reception on the RX pin of the transceiver and the SSP
  *	position such that SSP = @tdcv + @tdco.
  *
- *	If @tdco is zero, then TDC is disabled and both @tdcv and
- *	@tdcf should be ignored.
- *
  * @tdcf: Transmitter Delay Compensation Filter window. Defines the
- *	minimum value for the SSP position in time quanta. If SSP is
- *	less than @tdcf, then no delay compensations occur and the
- *	normal sampling point is used instead. The feature is enabled
- *	if and only if @tdcv is set to zero (automatic mode) and @tdcf
- *	is configured to a value greater than @tdco.
+ *	minimum value for the SSP position in time quanta. If the SSP
+ *	position is less than @tdcf, then no delay compensations occur
+ *	and the normal sampling point is used instead. The feature is
+ *	enabled if and only if @tdcv is set to zero (automatic mode)
+ *	and @tdcf is configured to a value greater than @tdco.
  */
 struct can_tdc {
 	u32 tdcv;
@@ -67,19 +84,32 @@ struct can_tdc {
  * struct can_tdc_const - CAN hardware-dependent constant for
  *	Transmission Delay Compensation
  *
- * @tdcv_max: Transmitter Delay Compensation Value maximum value.
- *	Should be set to zero if the controller does not support
- *	manual mode for tdcv.
+ * @tdcv_min: Transmitter Delay Compensation Value minimum value. If
+ *	the controller does not support manual mode for tdcv
+ *	(c.f. flag CAN_CTRLMODE_TDC_MANUAL) then this value is
+ *	ignored.
+ * @tdcv_max: Transmitter Delay Compensation Value maximum value. If
+ *	the controller does not support manual mode for tdcv
+ *	(c.f. flag CAN_CTRLMODE_TDC_MANUAL) then this value is
+ *	ignored.
+ *
+ * @tdco_min: Transmitter Delay Compensation Offset minimum value.
  * @tdco_max: Transmitter Delay Compensation Offset maximum value.
  *	Should not be zero. If the controller does not support TDC,
  *	then the pointer to this structure should be NULL.
+ *
+ * @tdcf_min: Transmitter Delay Compensation Filter window minimum
+ *	value. If @tdcf_max is zero, this value is ignored.
  * @tdcf_max: Transmitter Delay Compensation Filter window maximum
  *	value. Should be set to zero if the controller does not
  *	support this feature.
  */
 struct can_tdc_const {
+	u32 tdcv_min;
 	u32 tdcv_max;
+	u32 tdco_min;
 	u32 tdco_max;
+	u32 tdcf_min;
 	u32 tdcf_max;
 };
 
diff --git a/include/linux/can/dev.h b/include/linux/can/dev.h
index 2413253e54c70..6dacbbb41e68c 100644
--- a/include/linux/can/dev.h
+++ b/include/linux/can/dev.h
@@ -96,6 +96,10 @@ struct can_priv {
 #endif
 };
 
+static inline bool can_tdc_is_enabled(const struct can_priv *priv)
+{
+	return !!(priv->ctrlmode & CAN_CTRLMODE_TDC_MASK);
+}
 
 /* helper to define static CAN controller features at device creation time */
 static inline void can_set_static_ctrlmode(struct net_device *dev,
diff --git a/include/uapi/linux/can/netlink.h b/include/uapi/linux/can/netlink.h
index f730d443b9184..004cd09a7d49d 100644
--- a/include/uapi/linux/can/netlink.h
+++ b/include/uapi/linux/can/netlink.h
@@ -101,6 +101,8 @@ struct can_ctrlmode {
 #define CAN_CTRLMODE_PRESUME_ACK	0x40	/* Ignore missing CAN ACKs */
 #define CAN_CTRLMODE_FD_NON_ISO		0x80	/* CAN FD in non-ISO mode */
 #define CAN_CTRLMODE_CC_LEN8_DLC	0x100	/* Classic CAN DLC option */
+#define CAN_CTRLMODE_TDC_AUTO		0x200	/* CAN transiver automatically calculates TDCV */
+#define CAN_CTRLMODE_TDC_MANUAL		0x400	/* TDCV is manually set up by user */
 
 /*
  * CAN device statistics
-- 
2.51.0



