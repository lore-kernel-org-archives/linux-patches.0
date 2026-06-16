Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D85478E55;
	Tue, 16 Jun 2026 17:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630736; cv=none; b=bBs39Qi9TO6LiKRVP+4Tx/5sPYI9z4mJhMgD7ANSwEl6bTtqVKbMqx2vLZ8ZNBX4DyovJN/PTnq9Sl/KeOGVbPmLu4oiL1hvvztpZJs09opCJ6rnDznLa4lpqEF8+ZPbBTpcTcmQcid7027Ycb+ywOIKWUjpx3sO7qLoFUCx0+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630736; c=relaxed/simple;
	bh=2fswfuxLYHEdWkDmiKkpByeDvLszh+7rsGg6O9F25F0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CwjVrK3GvZ4d1mJrLXEd4Qhz2cmqGCd81VcYhqFKMQqVH49fSPYeBQnYGA0hHi0P2igyjo+XoIyIE8JC0mIQQtXLrfsmd+gncq+xODSSw/mqynvL2984TuxsNcKzPkeA+6CWEkZk4sJ1b1Q0ZD1IA1LueeqUa99vfAxYLKwObc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kBgIJzc7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kBgIJzc7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CC1D1F000E9;
	Tue, 16 Jun 2026 17:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630735;
	bh=5JuzznAI4QxX/w4J5DxvGnHlSb9NZUugFx8aXTmBUy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kBgIJzc7RTS+0/6+iFs3veqV7PNjRA/krXwsdArKaH7vD2Z+5pAd+/1PbZr6FYU4X
	 LaiQxz5TH9E2DeMjPg8oPdBJXSjzoIdq0zToSrtFz4Qa7uLNg7XLU7twUYlpksV/ua
	 BBoUM1tL0uVf6HectbeGs8Hu0gXCRZKMODGQeClE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.1 086/522] usb: typec: wcove: dont write past struct pd_message in wcove_read_rx_buffer()
Date: Tue, 16 Jun 2026 20:23:53 +0530
Message-ID: <20260616145129.894921126@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


