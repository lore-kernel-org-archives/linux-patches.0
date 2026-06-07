Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B5C2D8378;
	Sun,  7 Jun 2026 10:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827914; cv=none; b=otrDNlGnUhYjQYR7pLT3/eVHFQRYceKq9994Ha1LOpljrkb/CU7Xqrq4mcYqJ/IBHvKlCqC7HJgN497Xy/5G8VAlHwAsngRb3WTdI9/mzuL4ARirDCkkso2c2mTVlitDMnZbsjV8sgzOVAOA3Hx0TFcGXAL7cZR/8DuoC7u0Lx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827914; c=relaxed/simple;
	bh=HKUObmvtZGdmTn2388qJL08WcD4edHdqIaxgVBd6CNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sAF5BUypYgSmh6A1Z9ROtZwHHN+zZfjnDnfbqnUJT3TAOhlk/Rxn/i7W281Na9l1dqTEJfRhcbH7ML/Fyuw4hPPkAePqi55a1vWmcrGsDzERA/UAwiSVbUGqoBOboJxThqx7NLeh4RO8jCOsNoQWCuK9LjwajbWTROD8Uxz3cLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S42SCVIz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S42SCVIz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 376FC1F00893;
	Sun,  7 Jun 2026 10:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827912;
	bh=NwwPnmqXeU1h0ximJoNIwSBr3HmtpzbOjwLs6fx5sNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S42SCVIzVXMAXgco6v0DrBmpz+hHoTo16CW4flUc6mvUWdNCid3/bdLC0PT6i4+ki
	 j4c4LvpGY+o4MxhabLvxvGAKS1/RxOeCZChDs3t6/rGB3KA7/7Djy2l2bU4rbOl1Pk
	 Jb7GhNOyAP/liEKkW01dIy524cDTZJ2CeIIOE5JM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.18 112/315] usb: typec: wcove: dont write past struct pd_message in wcove_read_rx_buffer()
Date: Sun,  7 Jun 2026 11:58:19 +0200
Message-ID: <20260607095731.754738560@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


