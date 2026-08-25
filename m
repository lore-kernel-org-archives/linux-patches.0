Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1DA348380D;
	Tue, 25 Aug 2026 13:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666400; cv=none; b=bcABbK7rNdvwfC3kqWROQdi0mFHD1YvF3O/CWs2durZh1Zsc+l+nfb/1WNwY3RN79asSpZiFzfPFv7eu/GFBkIC2nXuJai2Xru7X1XGf01oL7hint3sSUHLsDcmFThxhJtI8vxpg94EmnF30nNu4YeIBLo4+8c5ubR1klU0477Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666400; c=relaxed/simple;
	bh=dgzHdXMuATX1dhoHBYY0LqCM29DXatJwAEM4hsdYgSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tiLIWMOKDcV+5TWuuywnp1X356HzhqUig9OzBRSObLJVqCWK1UlyGfYEOJ8J6hZy3MBL3ygm63Hs6EW/ObdD3wyp36WRX4OreKjU14hRwzc6s9ZwhYa2LN5AlVgpnOTQ6/y4ovAXa/nTef7aYubGLp5Pk1Uur3qdkEsng/I2xAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BAflKqt+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BAflKqt+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3E151F000E9;
	Tue, 25 Aug 2026 13:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666399;
	bh=q7gkMLA9DEJX9Tf+x5Z27JNTu1ZEabcfXlyruW+ZO/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BAflKqt++p3dCcaMRlnZuDfRa3lXeSd1oAdPcZ941TmDkKHoDZSL7whI18Hgj3Bx/
	 8AtNCKhf7LFsreLDyew2vKGovp78NWKObi5fS09EkD0Tzp/BSRhLgLeUA9b6RUgpb3
	 5R/I+FkvmpAlP8ceanGyy3dR4mFT4WVlezBgZAno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Bryam Vargas <hexlabsecurity@proton.me>,
	David Heidelberg <david@ixit.cz>
Subject: [PATCH 5.10 30/57] nfc: fdp: bound the device-reported read length and fix an skb leak
Date: Tue, 25 Aug 2026 15:26:52 +0200
Message-ID: <20260825132542.498321714@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.342390421@linuxfoundation.org>
References: <20260825132541.342390421@linuxfoundation.org>
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

From: Bryam Vargas <hexlabsecurity@proton.me>

commit 7ad21dcfeb5181af0c3ee2608808c0c0a5283aa1 upstream.

fdp_nci_i2c_read() takes the next packet length from two device-supplied
bytes and never validates it. The value is a u16 used as the
i2c_master_recv() count into a 261-byte on-stack buffer: a malicious,
counterfeit or malfunctioning controller (or an i2c bus interposer) can
drive it far past the buffer for a stack out-of-bounds write that
clobbers the canary and return address, or below the minimum frame size
(directly, or by truncating the computed sum) so the header/LRC strip
and the next length read run past a short receive. Reject a length
outside [FDP_NCI_I2C_MIN_PAYLOAD, FDP_NCI_I2C_MAX_PAYLOAD], as a
corrupted packet already is, and force resynchronization.

The same loop allocates one data skb per iteration and assumes a length
packet followed by a data packet; a device that sends two data packets
in one call leaks the first skb when the second allocation overwrites
it. Free a previously allocated skb before allocating the next.

Fixes: a06347c04c13 ("NFC: Add Intel Fields Peak NFC solution driver")
Cc: stable@vger.kernel.org
Suggested-by: Simon Horman <horms@kernel.org>
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Link: https://patch.msgid.link/20260616-b4-disp-b1f8ab4c-v2-1-2d1fe5955325@proton.me
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nfc/fdp/i2c.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

--- a/drivers/nfc/fdp/i2c.c
+++ b/drivers/nfc/fdp/i2c.c
@@ -166,9 +166,36 @@ static int fdp_nci_i2c_read(struct fdp_i
 		/* Packet that contains a length */
 		if (tmp[0] == 0 && tmp[1] == 0) {
 			phy->next_read_size = (tmp[2] << 8) + tmp[3] + 3;
+
+			/*
+			 * next_read_size is taken from the device and is used
+			 * as the i2c_master_recv() count for the next packet
+			 * and as the data skb size. A value above the receive
+			 * buffer overflows tmp[]; one below the minimum frame
+			 * size runs the header/LRC strip and the length-field
+			 * read past a short receive. Either way the packet is
+			 * corrupt: drop it and force resynchronization.
+			 */
+			if (phy->next_read_size < FDP_NCI_I2C_MIN_PAYLOAD ||
+			    phy->next_read_size > FDP_NCI_I2C_MAX_PAYLOAD) {
+				dev_dbg(&client->dev, "%s: corrupted packet\n",
+					__func__);
+				phy->next_read_size = FDP_NCI_I2C_MIN_PAYLOAD;
+				goto flush;
+			}
 		} else {
 			phy->next_read_size = FDP_NCI_I2C_MIN_PAYLOAD;
 
+			/*
+			 * Only one data packet is delivered per call; if the
+			 * device sends another, do not overwrite and leak the
+			 * skb allocated for the previous one.
+			 */
+			if (*skb) {
+				kfree_skb(*skb);
+				*skb = NULL;
+			}
+
 			*skb = alloc_skb(len, GFP_KERNEL);
 			if (*skb == NULL) {
 				r = -ENOMEM;


