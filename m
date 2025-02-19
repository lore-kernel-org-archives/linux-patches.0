Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0874C1C175A;
	Wed, 19 Feb 2025 08:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954972; cv=none; b=QxLMbBgEXiRn17y2aJLH6ZjwbCj9o4zK8n2fA/rvCcksv28zMMK7/Gn8wYAnNuet0C83OS+h3wSivc3aAZJXcPwmiUd14ywQw4kMPvvt3ApbmS/wqHYOuoFYmc60t3098LTY71l9aq0GRDHlxlq3G4vf7Art+x0q6hoYfEJUhJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954972; c=relaxed/simple;
	bh=Gp1gDIit/EEnuyOiF9lq4fuCPfKuqs3IM2M9t5w0v0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jq9JCO8JTFBUI8MzOh/ct1QCIAKYeajhum0BE07RuEdy+04fI4ZsoNsggbwm7sgGCJCzBJStJRkvjjnrJ2Al90cuJQ0aE3y7AhQyJHn/0tf191kp3FoDTrzpqJuT7eOTmOFAA0jnFXEh92cmTxb355DUTlomMffe7DQZqi4/i1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eEP02bXi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eEP02bXi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6904DC4CED1;
	Wed, 19 Feb 2025 08:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954971;
	bh=Gp1gDIit/EEnuyOiF9lq4fuCPfKuqs3IM2M9t5w0v0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eEP02bXigBimOGl2Zw9HgUy5EeaLs+1tS3dglUTZBbZNii6u3KjWCFv/r+RQFgSU7
	 sU034ueIKlkQDDbV7y3UrJS6BZBpphoRrAPL74L5tv9gaic2bWb7KPzODT2oGXUsyC
	 4a3xrYDHKhFcG56RoHfkW4ara9C2IHltxAS7PJiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 062/230] i3c: mipi-i3c-hci: Add Intel specific quirk to ring resuming
Date: Wed, 19 Feb 2025 09:26:19 +0100
Message-ID: <20250219082604.139744468@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

[ Upstream commit ccdb2e0e3b00d13df90ac7a0524dd855173f1171 ]

MIPI I3C HCI on Intel hardware requires a quirk where ring needs to stop
and set to run again after resuming the halted controller. This is not
expected from the MIPI I3C HCI specification and is Intel specific.

Add this quirk to generic aborted transfer handling and execute it only
when ring is not in running state after a transfer error and attempted
controller resume. This is the case on Intel hardware.

It is not fully clear to me what is the ring running state in generic
hardware in such case. I would expect if ring is not running, then stop
request is a no-op and run request is either required or does the same
what controller resume would do.

Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Link: https://lore.kernel.org/r/20241231115904.620052-1-jarkko.nikula@linux.intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/mipi-i3c-hci/dma.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/i3c/master/mipi-i3c-hci/dma.c b/drivers/i3c/master/mipi-i3c-hci/dma.c
index 13adc58400942..fe955703e59b5 100644
--- a/drivers/i3c/master/mipi-i3c-hci/dma.c
+++ b/drivers/i3c/master/mipi-i3c-hci/dma.c
@@ -762,9 +762,26 @@ static bool hci_dma_irq_handler(struct i3c_hci *hci, unsigned int mask)
 			complete(&rh->op_done);
 
 		if (status & INTR_TRANSFER_ABORT) {
+			u32 ring_status;
+
 			dev_notice_ratelimited(&hci->master.dev,
 				"ring %d: Transfer Aborted\n", i);
 			mipi_i3c_hci_resume(hci);
+			ring_status = rh_reg_read(RING_STATUS);
+			if (!(ring_status & RING_STATUS_RUNNING) &&
+			    status & INTR_TRANSFER_COMPLETION &&
+			    status & INTR_TRANSFER_ERR) {
+				/*
+				 * Ring stop followed by run is an Intel
+				 * specific required quirk after resuming the
+				 * halted controller. Do it only when the ring
+				 * is not in running state after a transfer
+				 * error.
+				 */
+				rh_reg_write(RING_CONTROL, RING_CTRL_ENABLE);
+				rh_reg_write(RING_CONTROL, RING_CTRL_ENABLE |
+							   RING_CTRL_RUN_STOP);
+			}
 		}
 		if (status & INTR_WARN_INS_STOP_MODE)
 			dev_warn_ratelimited(&hci->master.dev,
-- 
2.39.5



