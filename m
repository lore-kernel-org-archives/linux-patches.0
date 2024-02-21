Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4DCE7C081;
	Wed, 21 Feb 2024 13:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522255; cv=none; b=i1Iz6hN0qvxP6JgL3dB6J1iiR8VuzVnf21T/SbWTXTcjN8Sd3QQUj7rsZ/gFEt+PxaDy927fDEETc6gJsqO5uDqWxYXVQHiMB/IHIN3u4nYoTb5z/bzCV3+A7+xM5Unec7O1nvp5E+hHz75iVF8LcMRwIZUn8mqVqdOA1M3Te08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522255; c=relaxed/simple;
	bh=kW1QYP3CoBCBV6DOBRi7gd7BobdYIzkG345QuQ3lymw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JUnU95OHXLWXixfYEls7QgKbtFDRQ1lcj+Clizfnir69KJ6Y+JFqnoZz+tl/JsleeAefTmtEw+iH2c+DhB7CpPDZr8y2c+k7erGL7ozghiUcgRaN8FKT5vAUE1zT2ssRJ6zc0Pshibu6EHRXTARIBVGTl8SyumwysJGIZa45iDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gsh2wfgK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gsh2wfgK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4416AC433F1;
	Wed, 21 Feb 2024 13:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522255;
	bh=kW1QYP3CoBCBV6DOBRi7gd7BobdYIzkG345QuQ3lymw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gsh2wfgKxek+klCEzlhcJ1TdCvO7DOIWWzJMgkxlIjy7K/8WJedMEazwn69AO7tMr
	 oP4n2CcRWdiEYzlnbCONf2H2NEOGVaLUifFPIB7cBZ7if2xJxpUXz+CXTCjCyaFrUZ
	 879xbvTD1IeWZvfYpaLmPXRXxbDHWrpNLSqEvB5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xinglong Yang <xinglong.yang@cixtech.com>,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 5.15 088/476] firmware: arm_scmi: Check mailbox/SMT channel for consistency
Date: Wed, 21 Feb 2024 14:02:19 +0100
Message-ID: <20240221130011.233913823@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Cristian Marussi <cristian.marussi@arm.com>

commit 437a310b22244d4e0b78665c3042e5d1c0f45306 upstream.

On reception of a completion interrupt the shared memory area is accessed
to retrieve the message header at first and then, if the message sequence
number identifies a transaction which is still pending, the related
payload is fetched too.

When an SCMI command times out the channel ownership remains with the
platform until eventually a late reply is received and, as a consequence,
any further transmission attempt remains pending, waiting for the channel
to be relinquished by the platform.

Once that late reply is received the channel ownership is given back
to the agent and any pending request is then allowed to proceed and
overwrite the SMT area of the just delivered late reply; then the wait
for the reply to the new request starts.

It has been observed that the spurious IRQ related to the late reply can
be wrongly associated with the freshly enqueued request: when that happens
the SCMI stack in-flight lookup procedure is fooled by the fact that the
message header now present in the SMT area is related to the new pending
transaction, even though the real reply has still to arrive.

This race-condition on the A2P channel can be detected by looking at the
channel status bits: a genuine reply from the platform will have set the
channel free bit before triggering the completion IRQ.

Add a consistency check to validate such condition in the A2P ISR.

Reported-by: Xinglong Yang <xinglong.yang@cixtech.com>
Closes: https://lore.kernel.org/all/PUZPR06MB54981E6FA00D82BFDBB864FBF08DA@PUZPR06MB5498.apcprd06.prod.outlook.com/
Fixes: 5c8a47a5a91d ("firmware: arm_scmi: Make scmi core independent of the transport type")
Cc: stable@vger.kernel.org # 5.15+
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Tested-by: Xinglong Yang <xinglong.yang@cixtech.com>
Link: https://lore.kernel.org/r/20231220172112.763539-1-cristian.marussi@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/arm_scmi/common.h  |    1 +
 drivers/firmware/arm_scmi/mailbox.c |   14 ++++++++++++++
 drivers/firmware/arm_scmi/shmem.c   |    6 ++++++
 3 files changed, 21 insertions(+)

--- a/drivers/firmware/arm_scmi/common.h
+++ b/drivers/firmware/arm_scmi/common.h
@@ -439,6 +439,7 @@ void shmem_fetch_notification(struct scm
 void shmem_clear_channel(struct scmi_shared_mem __iomem *shmem);
 bool shmem_poll_done(struct scmi_shared_mem __iomem *shmem,
 		     struct scmi_xfer *xfer);
+bool shmem_channel_free(struct scmi_shared_mem __iomem *shmem);
 
 /* declarations for message passing transports */
 struct scmi_msg_payld;
--- a/drivers/firmware/arm_scmi/mailbox.c
+++ b/drivers/firmware/arm_scmi/mailbox.c
@@ -43,6 +43,20 @@ static void rx_callback(struct mbox_clie
 {
 	struct scmi_mailbox *smbox = client_to_scmi_mailbox(cl);
 
+	/*
+	 * An A2P IRQ is NOT valid when received while the platform still has
+	 * the ownership of the channel, because the platform at first releases
+	 * the SMT channel and then sends the completion interrupt.
+	 *
+	 * This addresses a possible race condition in which a spurious IRQ from
+	 * a previous timed-out reply which arrived late could be wrongly
+	 * associated with the next pending transaction.
+	 */
+	if (cl->knows_txdone && !shmem_channel_free(smbox->shmem)) {
+		dev_warn(smbox->cinfo->dev, "Ignoring spurious A2P IRQ !\n");
+		return;
+	}
+
 	scmi_rx_callback(smbox->cinfo, shmem_read_header(smbox->shmem), NULL);
 }
 
--- a/drivers/firmware/arm_scmi/shmem.c
+++ b/drivers/firmware/arm_scmi/shmem.c
@@ -99,3 +99,9 @@ bool shmem_poll_done(struct scmi_shared_
 		(SCMI_SHMEM_CHAN_STAT_CHANNEL_ERROR |
 		 SCMI_SHMEM_CHAN_STAT_CHANNEL_FREE);
 }
+
+bool shmem_channel_free(struct scmi_shared_mem __iomem *shmem)
+{
+	return (ioread32(&shmem->channel_status) &
+			SCMI_SHMEM_CHAN_STAT_CHANNEL_FREE);
+}


