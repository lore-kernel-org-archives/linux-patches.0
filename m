Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5563E168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:16:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE683C433EF;
	Mon,  8 May 2023 10:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540998;
	bh=ZEvsQuva0xNOrYGykGwpQjElS5A1ix7RmXvxqguUFJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jAfxJH4H9ulitkw4zxzU2Tsp8wFwWWIBOMlpG2AFc1x1FuV7e1jPyIxzrpzDx550v
	 MKX4ZyjimAUXKKfLy490ZvIEACcd/M/rMq7hFjnA86DpCyyvccpqS6EGrR8VcqFaPv
	 EEav49hTrtAFSvlxJraaNS++WGrytRh7GiZjKrZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tanmay Shah <tanmay.shah@amd.com>,
	Michal Simek <michal.simek@amd.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 6.1 577/611] mailbox: zynqmp: Fix IPI isr handling
Date: Mon,  8 May 2023 11:46:59 +0200
Message-Id: <20230508094440.696067272@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tanmay Shah <tanmay.shah@amd.com>

commit 74ad37a30ffee3643bc34f9ca7225b20a66abaaf upstream.

Multiple IPI channels are mapped to same interrupt handler.
Current isr implementation handles only one channel per isr.
Fix this behavior by checking isr status bit of all child
mailbox nodes.

Fixes: 4981b82ba2ff ("mailbox: ZynqMP IPI mailbox controller")
Signed-off-by: Tanmay Shah <tanmay.shah@amd.com>
Acked-by: Michal Simek <michal.simek@amd.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230311012407.1292118-3-tanmay.shah@amd.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mailbox/zynqmp-ipi-mailbox.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/mailbox/zynqmp-ipi-mailbox.c
+++ b/drivers/mailbox/zynqmp-ipi-mailbox.c
@@ -152,7 +152,7 @@ static irqreturn_t zynqmp_ipi_interrupt(
 	struct zynqmp_ipi_message *msg;
 	u64 arg0, arg3;
 	struct arm_smccc_res res;
-	int ret, i;
+	int ret, i, status = IRQ_NONE;
 
 	(void)irq;
 	arg0 = SMC_IPI_MAILBOX_STATUS_ENQUIRY;
@@ -170,11 +170,11 @@ static irqreturn_t zynqmp_ipi_interrupt(
 				memcpy_fromio(msg->data, mchan->req_buf,
 					      msg->len);
 				mbox_chan_received_data(chan, (void *)msg);
-				return IRQ_HANDLED;
+				status = IRQ_HANDLED;
 			}
 		}
 	}
-	return IRQ_NONE;
+	return status;
 }
 
 /**


