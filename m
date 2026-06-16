Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F9032C302;
	Tue, 16 Jun 2026 16:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628387; cv=none; b=M/AEHqvxGZ5rwInQR+OpQcNiGRUsvGaAd3vRQjG4oaoAyCD5meToWyL0K8qrlHFniUcxjFw9iJ9wZHsrDtWWn8RPTdtHMHTcoBdLFgxIzktguFmTyzf93AtW+mzzrsNGAtix6W1Enl/nBlp/nvSvyxzH8kjFXHgXWKCN5DgRWCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628387; c=relaxed/simple;
	bh=6xzD+GvgCoynPWfAgN99skP5xyGg8KMTU+naLM/87FA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g1gYX84+XnZfM34YVMvo9QKE7kUzzo1YVTbSUolPS9c9KXtXQiTS9NU87A5fROLsE5vbbOye0sKtsuLmr09Dktg9vO5l4wXWg8ImP0jsP3tDQm3hZuHIO2bjgEsbl40HJfpqJsh3NplkFp5XMKPsEYHoTbLbPOWKOEsWNm6Z/zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FNkrT3gX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FNkrT3gX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A5CC1F000E9;
	Tue, 16 Jun 2026 16:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628386;
	bh=bhl4eJY6cei9B+omydQdk3JIerNpWS02ntSvDJtQ62c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FNkrT3gXcvldaFR0tAnhKMYXHLufdqE8NBvWRYmbSWVXEYu1vaxjuLZjwia7fYo90
	 4jdGePhqMQsFGnzN2BIGi9ZLcBSsgFJccp5TeWYv2+hfgvbezqmRxaWv/0aI+Rd376
	 YXaD6jL3G8a5ceKs/7Rjt4TJTbKf29h0/UG/5h5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.6 086/452] usb: typec: wcove: dont write past struct pd_message in wcove_read_rx_buffer()
Date: Tue, 16 Jun 2026 20:25:13 +0530
Message-ID: <20260616145122.373833600@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -444,9 +444,11 @@ static int wcove_start_toggling(struct t
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
 
@@ -454,12 +456,13 @@ static int wcove_read_rx_buffer(struct w
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


