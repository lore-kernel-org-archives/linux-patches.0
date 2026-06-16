Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C3F43CEC7;
	Tue, 16 Jun 2026 18:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635441; cv=none; b=agA+BN3YClHR4x7mtuAhQ46uXeAuYGhMTQBCHAtY6QY53nvrmD6OxGbqVd/HOt+5J9hjWL9yh7wriY77/jSD2JpXLlHG3pzmWhTnN9riZQ3q9yPcpGSP2W6YGx7DnJWOwkCZQpMqWY3snCfdExNF+fNrrJOaWgyfNXwzEE+/i3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635441; c=relaxed/simple;
	bh=amlaw6Ptp1qfpoJYmWxWuSQRsXcSXz1Zs7VhecYnV9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K18NK+wSFVupQBUYV7xRwEO/Xsu/WeKu9u4AtBDieEcKI95WUIZQxIGj51fiZHVcUobkaJur6cW04nbf259/XKlaqjdxK+fjz+nlHLDedeeuc/2nl3kvgmeiWya+s1IWKaSxUa91Q2PhedPj+AaCi8q/v5yNdEE8v/r0yufM7pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bhQLKm2v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bhQLKm2v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26FAC1F000E9;
	Tue, 16 Jun 2026 18:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635440;
	bh=katwKT6hhJHJVLxhhFQFnGuBS1j3BnDowZB7phGspUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bhQLKm2v78pJ9vOthXgHcVtpCD0UHD9uZsjyPeXoN57WpcJVmYyW2i5+tcuuFMqri
	 Sj8VuGg4/x75WfURkG2q+oUM1GyPBGCCR0ah4DCFA0StvXntMNS4qEXKUoqr2szbR9
	 8/3qsZd1ey44XbnDH99+F1fen7PcJtEv9ETSICiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.10 048/342] usb: typec: wcove: dont write past struct pd_message in wcove_read_rx_buffer()
Date: Tue, 16 Jun 2026 20:25:44 +0530
Message-ID: <20260616145050.495191556@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 4af7ad0e6d7aa4403dbb1dac7b9659b0421efcaa upstream.

wcove_read_rx_buffer() copies the PD RX FIFO into the caller's
struct pd_message with

	for (i = 0; i < USBC_RXINFO_RXBYTES(info); i++)
		regmap_read(wcove->regmap, USBC_RX_DATA + i, msg + i);

which has two problems:

USBC_RXINFO_RXBYTES() is a 5-bit field (max 31) while struct pd_message
is 30 bytes (__le16 header + __le32 payload[PD_MAX_PAYLOAD], packed).
The byte count latched in RXINFO is the number of bytes the port partner
put on the wire, so a malicious partner that transmits a 31-byte frame
can drive the loop one byte past the destination if the WCOVE BMC
receiver does not enforce the PD object-count limit in hardware. The
existing FIXME flagged this as unverified.

Independently, regmap_read() takes an unsigned int * and stores a full
unsigned int at the destination. Passing the byte pointer msg + i means
each iteration writes four bytes; the high three are zero (val_bits is
8) and are normally overwritten by the next iteration, but the final
iteration's high bytes are not. With RXBYTES == 30 the i == 29 iteration
already writes three zero bytes past msg, which sits on the IRQ thread's
stack in wcove_typec_irq().

Clamp the loop to sizeof(struct pd_message) and read each register into
a local before storing only its low byte, so the copy can never exceed
the destination regardless of what RXINFO reports.

Assisted-by: gkh_clanker_t1000
Cc: stable <stable@kernel.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/2026051347-clustered-deflected-9543@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/wcove.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/usb/typec/tcpm/wcove.c
+++ b/drivers/usb/typec/tcpm/wcove.c
@@ -443,9 +443,11 @@ static int wcove_start_toggling(struct t
 	return regmap_write(wcove->regmap, USBC_CONTROL1, usbc_ctrl);
 }
 
-static int wcove_read_rx_buffer(struct wcove_typec *wcove, void *msg)
+static int wcove_read_rx_buffer(struct wcove_typec *wcove,
+				struct pd_message *msg)
 {
-	unsigned int info;
+	unsigned int info, val, len;
+	u8 *buf = (u8 *)msg;
 	int ret;
 	int i;
 
@@ -453,12 +455,13 @@ static int wcove_read_rx_buffer(struct w
 	if (ret)
 		return ret;
 
-	/* FIXME: Check that USBC_RXINFO_RXBYTES(info) matches the header */
+	len = min(USBC_RXINFO_RXBYTES(info), sizeof(*msg));
 
-	for (i = 0; i < USBC_RXINFO_RXBYTES(info); i++) {
-		ret = regmap_read(wcove->regmap, USBC_RX_DATA + i, msg + i);
+	for (i = 0; i < len; i++) {
+		ret = regmap_read(wcove->regmap, USBC_RX_DATA + i, &val);
 		if (ret)
 			return ret;
+		buf[i] = val;
 	}
 
 	return regmap_write(wcove->regmap, USBC_RXSTATUS,


