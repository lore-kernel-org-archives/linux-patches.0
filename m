Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E14E3112A5;
	Sun,  7 Jun 2026 10:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828373; cv=none; b=QSdv5oNbrMeHrFsBvuFoKk+neelQ9NdD26m94d2upZSm/CheLgJnId45XpB4IjCFimNCoLUveugRq5k7RnZC0KS3I6l00wcuAPjLyJnjybemIT5f2QPSjO8jSxS3qFoxtbgRBne3uWQ13wae8Vm/F2s1D0iLiBZQgvOzORwUI+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828373; c=relaxed/simple;
	bh=bBggSPtYdOSJaAk5oUyVCTqHaMZW9coYkr2beBmm6ZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eRdLdbllspCkL4e2FbLoefI+N5A07WFxncNWa3aukdVTmscgveeHHChlCfJENhgfTVjQDsxaQrG2lslkSmnt0/z5jy89cXdpzVfy7lJV4/YJ7NrDYmQl5vpBHm+/PNRcuXuvK4cMwnJcNsaXaW+NtYqqxdmRqZBDFrLKu3mA90c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fiDW6rxD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fiDW6rxD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C516C1F00893;
	Sun,  7 Jun 2026 10:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828372;
	bh=qwXd5RSeQoj1SCPm7BZ+Ovwynp4kQDhj9tohEAW0ers=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fiDW6rxDJSxiHPXcPEhyjhiwEGjHwVbN5nsiGrSdEzQ+7RsdAMwj47ch272b0Rxbl
	 TuwLtP8wI3e4RIIi64EcN699dM2/hI8y1ktjHEa1MRM2Og1pXTyy9D6RxBgDZfyPmd
	 QmQa6h4+LTUTm/k1z7UhCisneJ9EtOfqntpRKGVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Badhri Jagan Sridharan <badhri@google.com>,
	Amit Sunil Dhamne <amitsd@google.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.12 133/307] usb: typec: tcpm/tcpci_maxim: validate header NDO against RX_BYTE_CNT
Date: Sun,  7 Jun 2026 11:58:50 +0200
Message-ID: <20260607095732.633573370@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


