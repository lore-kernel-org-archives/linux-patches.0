Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE22E2D8378;
	Sun,  7 Jun 2026 10:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827926; cv=none; b=rKpZPX0Vcf+BXlNilRXH7xNIVlv2UN//np4E7DTd4cs3yRJbv+BHpqcGL/r7Q9lhv5q2iePepGtxQuv6Le2ADxz2jGS1ET9aDZrOp+e+kNeAx/UmtfOrEaseBVecnas3dX2pPFSoXlasl7lQSByML1DKQc+ckSu9/9fJo1Eyb0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827926; c=relaxed/simple;
	bh=7jeiiOd7Fe+T8y/gxysAl/b/Lvtb2L18CB+adX6/svM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bR5IAG5qUfcDyBpxs0BQYV7CHZVq7FbfE9GfiSNIp54guhEoIZb63TSKQafiIKskTJDbMJrjyA2vwj6ofZSSCy6N3WyqLSWj+bj5LpGZjvZ8Lq+PIkSzYxEbvYdagy9pdUAZRexhrhYe6uxgD7M9Ybifz7fDWnhtXVaGIZIj9ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OmuROP/C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OmuROP/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080B61F00893;
	Sun,  7 Jun 2026 10:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827925;
	bh=ogJCWID7T3SpDh4hmIfDyUiTjNz2WlNgmeMHYlmxbHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OmuROP/CaZd+/ctgamEcv5Yl8aPB0xGl3IpkADzNPEj+Y4MTZ5x+XoXSTnO4puImi
	 m382rjEfrTkF1UFnXlcm3bOI7v4OCJEaWEjoXCGJzYhBB0iN5bRDlcO+HK8uA1xIgu
	 d+eOQqRlBv4jfhR2lPiGNXhWKSbu+372NsgW5ukQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Badhri Jagan Sridharan <badhri@google.com>,
	Amit Sunil Dhamne <amitsd@google.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.18 113/315] usb: typec: tcpm/tcpci_maxim: validate header NDO against RX_BYTE_CNT
Date: Sun,  7 Jun 2026 11:58:20 +0200
Message-ID: <20260607095731.790756545@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit aa2f716327be1818e1cb156da8a2844804aaec2f upstream.

A broken/malicious port can transmit a CRC-valid frame whose header
advertises up to seven data objects but whose body carries fewer than
that.  Check for this, and rightfully reject the message, instead of
reading from uninitialized stack memory.

Assisted-by: gkh_clanker_t1000
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: "André Draszik" <andre.draszik@linaro.org>
Cc: Badhri Jagan Sridharan <badhri@google.com>
Cc: Amit Sunil Dhamne <amitsd@google.com>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/2026051350-sitter-canopener-9045@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpci_maxim_core.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/usb/typec/tcpm/tcpci_maxim_core.c
+++ b/drivers/usb/typec/tcpm/tcpci_maxim_core.c
@@ -186,6 +186,15 @@ static void process_rx(struct max_tcpci_
 	rx_buf_ptr = rx_buf + TCPC_RECEIVE_BUFFER_RX_BYTE_BUF_OFFSET;
 	msg.header = cpu_to_le16(*(u16 *)rx_buf_ptr);
 	rx_buf_ptr = rx_buf_ptr + sizeof(msg.header);
+
+	if (count < TCPC_RECEIVE_BUFFER_RX_BYTE_BUF_OFFSET + sizeof(msg.header) +
+		    pd_header_cnt_le(msg.header) * sizeof(msg.payload[0])) {
+		max_tcpci_write16(chip, TCPC_ALERT, TCPC_ALERT_RX_STATUS);
+		dev_err(chip->dev, "Invalid TCPC_RX_BYTE_CNT %d for header cnt %d\n",
+			count, pd_header_cnt_le(msg.header));
+		return;
+	}
+
 	for (payload_index = 0; payload_index < pd_header_cnt_le(msg.header); payload_index++,
 	     rx_buf_ptr += sizeof(msg.payload[0]))
 		msg.payload[payload_index] = cpu_to_le32(*(u32 *)rx_buf_ptr);


