Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B18A83FB7DE;
	Tue, 25 Aug 2026 13:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665467; cv=none; b=H5QJ4npOMV+KLvehzfrlorsedM5wigXxesj/Kw0krf/TzryVRV3MGEmMMjqNn7o10jgecu2MZ42QZZQth6QDSx1YUvpaJUigj+6Tp/H3SahF9tEThvy++padeVQyWPjvSd1ksurWSzP9uXXTIlbOSwJ87LDjf6unLkjknmsri4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665467; c=relaxed/simple;
	bh=EgjztT1HikaJzU7EBoIoxGXuav7xatf8/8t9wSl1UsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JkPa0J4V/hL5n5oh5L0ak7O76VgoTDKLTkE3TbMIsXCrQxxPKygoOKu+55oarCKd+V/jj0TvTs5ZXAydD60aUKhPkUTEF2Roq0oj4Kdhicnzx4KdcZ5Zk3/qtopBQzrn9BEUNqdx7y0/f7AyTh/VlAUn+q0xZh51uaZ7YwiH0ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qxszaaUI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qxszaaUI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8611F000E9;
	Tue, 25 Aug 2026 13:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665466;
	bh=yPrtfoxrKci+qFtqIkpKOH2GRZWq7KNI+9nVoWROBZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qxszaaUIuISD/LZG0CP4YmVk88cAxE+1NshMmCrryydvQnYgkbMkNgxs/Begct+2w
	 2x+mboLkjcT49/hLLluU2JtY7Rn6bKba4ebUHzBjD6M8asEgUJjHDOym03Nr/aigXV
	 8em9nXHSGir1BeFgNJMXRAtGMV+Tz6PQkTHQzy6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Bryam Vargas <hexlabsecurity@proton.me>,
	David Heidelberg <david@ixit.cz>
Subject: [PATCH 6.12 35/77] nfc: fdp: bound the device-reported read length and fix an skb leak
Date: Tue, 25 Aug 2026 15:25:57 +0200
Message-ID: <20260825132542.936651166@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.580275153@linuxfoundation.org>
References: <20260825132541.580275153@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


