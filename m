Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2911F480323;
	Tue, 25 Aug 2026 13:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664791; cv=none; b=SVFBNFJ9RtMTfkL//pgeGIF6UgLGyUl7hmWfDAH+nVrQPrOERu6FgxZfta/I0S3wI2R0v8FxDRWzj6ROZjGX+BrHe+1JdT6HghmXj97MsvEcaDoGrNLK3WIVoUGr3UbRpqsagit2tGQedp6e6ahdEUYQ6DuToP8Bcs2OO960VTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664791; c=relaxed/simple;
	bh=zNF/LNk9tVFsl3fM6swVomme8vmt2FGIr0Q6mMURgQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H7P98o5N9+ZWFyELuu+BTpTKsymRwphtcPMyP40C+p5WMnr82cnB42YhCwm1RTslq+KQMPLPZKM2dtdNg2560iTYxD0h5qo5IY/QmoWx4O5oHs2AEDmabxWWFnR/lOgnldKUgsNMvisCZiKfENxZQTU3vJLg6rtlboz2bxvLMg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jpz5adx9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jpz5adx9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79FD01F000E9;
	Tue, 25 Aug 2026 13:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664790;
	bh=lfpn1K5iQjnIP1MuXKwhl50JMDdp4o5a71gXHu/I9Q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jpz5adx9iJBwEGHLtv0SNCNalKDL+wXXr13g3urxmPzSDyp2jW9miy/XyoYEDgI0G
	 lvAm7mzKKYTFNsJlzqC3jdCgIa9FnTAZa5U22zZdY5xPSoidQl58TGnaItvOjQ7Cjv
	 j9CbTuiCsymtij4HUZ4Osy5mfzA8BaJe9JnS3/sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Ahmet Memis <ali@iusegentoo.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.2 81/82] Bluetooth: MGMT: reject HCI_CMD_SYNC params_len above 255
Date: Tue, 25 Aug 2026 15:26:08 +0200
Message-ID: <20260825132544.658266177@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.560541185@linuxfoundation.org>
References: <20260825132541.560541185@linuxfoundation.org>
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

From: Ali Ahmet Memis <ali@iusegentoo.com>

commit 5d95286b6d6e8f1d304da7522bfa6860fc017e48 upstream.

mgmt_hci_cmd_sync() checks that the message length agrees with params_len
but puts no upper bound on it. params_len is __le16 while the parameter
length in the HCI command header is a u8:

	struct hci_command_hdr {
		__le16	opcode;
		__u8	plen;
	} __packed;

hci_cmd_sync_alloc() assigns one to the other:

	hdr->plen = plen;

	if (plen)
		skb_put_data(skb, param, plen);

so a params_len of 256 leaves plen at 0 while all 256 bytes are still
appended. The frame handed to the driver then declares no parameters and
carries 256 of them. On a length framed transport such as H:4 the
controller takes the trailing bytes as the start of the next packet.

The mgmt socket MTU is HCI_MAX_FRAME_SIZE, so params_len can reach about
1KB this way. Commit 03f1700b9b4d ("Bluetooth: MGMT: reject malformed
HCI_CMD_SYNC commands") only made params_len agree with the message
length, a value that fits the message but not the header field is still
accepted.

Reject params_len that does not fit the header field.

Fixes: 827af4787e74 ("Bluetooth: MGMT: Add initial implementation of MGMT_OP_HCI_CMD_SYNC")
Cc: stable@vger.kernel.org
Signed-off-by: Ali Ahmet Memis <ali@iusegentoo.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/mgmt.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -2668,6 +2668,14 @@ static int mgmt_hci_cmd_sync(struct sock
 		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_HCI_CMD_SYNC,
 				       MGMT_STATUS_INVALID_PARAMS);
 
+	/* The HCI command header carries the parameter length in a u8, a
+	 * larger value would be truncated there while the parameters are
+	 * still appended to the frame in full.
+	 */
+	if (le16_to_cpu(cp->params_len) > U8_MAX)
+		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_HCI_CMD_SYNC,
+				       MGMT_STATUS_INVALID_PARAMS);
+
 	hci_dev_lock(hdev);
 	cmd = mgmt_pending_new(sk, MGMT_OP_HCI_CMD_SYNC, hdev, data, len);
 	if (!cmd)


