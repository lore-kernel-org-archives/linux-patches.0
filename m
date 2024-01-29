Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64FCE1586C5;
	Mon, 29 Jan 2024 17:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548365; cv=none; b=PN1QUk2I1mKMdQgc9bsweaUP9BcrLHLjNFYGQxCUVstSKuKOE342SCwMfhcwGnPP4tzQx9DQi/LSLCtRGz6wrHGvxV6LC4zjr8sb7UjIoAc8Jz/91TQWPYHEruXrh5rMVTEmru2Ocbh6G8pofi79fAYGcYibQvFpVUlXoD+TSSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548365; c=relaxed/simple;
	bh=MlUiS0xK7u6PqzLH936oVRlvPzK9G85j64ZH4PfRAiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sYn9JbpTzRukMRYs5wQOGizCOujA8t6Z/8YAOEj7hfJevvjmwkZn58G8V53TtFnV+wjRID98u1stQR9qk5fr6LTN9y3McJaZjsee+UorlZ14MQV9YsDxj6ikgWROklqExgwAl7qYEsanShv0r1JOLUM6KauLnVBpeJpKnD5E1po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aNe5Qfqd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aNe5Qfqd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28A8CC43394;
	Mon, 29 Jan 2024 17:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548365;
	bh=MlUiS0xK7u6PqzLH936oVRlvPzK9G85j64ZH4PfRAiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aNe5QfqdnCqHJsfM6S/g2JyC9RBieFwsPq7vO81t/9nvkLtuncGSs3PkE7epBPWh+
	 WsrE0/iwgBv3fIVZWxrjL84fBI44wSJ5hfhFu2Mgnx3GtOUGJmSCiOgXSUnvnpO8Pm
	 aj3ZBwgBfymAG9Bw2L6n+3Wa+9KLqy0Joo/0DyuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xinglong Yang <xinglong.yang@cixtech.com>,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 6.1 129/185] firmware: arm_scmi: Check mailbox/SMT channel for consistency
Date: Mon, 29 Jan 2024 09:05:29 -0800
Message-ID: <20240129170002.727685897@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -244,6 +244,7 @@ void shmem_fetch_notification(struct scm
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
@@ -122,3 +122,9 @@ bool shmem_poll_done(struct scmi_shared_
 		(SCMI_SHMEM_CHAN_STAT_CHANNEL_ERROR |
 		 SCMI_SHMEM_CHAN_STAT_CHANNEL_FREE);
 }
+
+bool shmem_channel_free(struct scmi_shared_mem __iomem *shmem)
+{
+	return (ioread32(&shmem->channel_status) &
+			SCMI_SHMEM_CHAN_STAT_CHANNEL_FREE);
+}


