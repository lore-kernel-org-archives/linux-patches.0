Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20DB190477;
	Tue, 10 Sep 2024 10:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964609; cv=none; b=pWcQWmY6jXBaC6mcAwRlwHEzwEuKfBqBcMiWqKEqDwBYrGOu4figWPYPFqSfRekCuMiG18P/+Z7zEnyAWxFWX96adb5Ttz/cmv5NAnD93TFARCBETEloj+Z8XSZ0HJ51rekSyD8yN6UttsZvtsI4GUY9gFL/xH94zVkAjvIzfIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964609; c=relaxed/simple;
	bh=kl4zknEna8Ok4g4SBHE21LXDG3vYHjCbuRPyQ2MxxPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CeeE2XmaxIhrR0shVdAm1YbpIe29sRLNbYP1493HYCN19mKUKff4kG0N8t3KlDGYGh6/RNp1pIiGLticjpeC1rtFSofTStUBzx8NUsv2qKmzYirJDxt2Q4zAjoHmiZ9OuG6E2WQrZSFN4AEhDKnOF0yQeegUtMzNzHbSlSz4aVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pqo4Huss; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pqo4Huss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF35C4CEC6;
	Tue, 10 Sep 2024 10:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964609;
	bh=kl4zknEna8Ok4g4SBHE21LXDG3vYHjCbuRPyQ2MxxPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pqo4Huss3lpyuLAu2cPBI9bj7xaH6mJsJx4SBPMXBPKVvzCodoCzxgPoE5Wp8VnM/
	 Y/9GsmzujUQeel8e151OctHWMVO0RPVMizEHTNUZPk/YJUbiRuqcXYkqPzz6wQKKcW
	 AuCffqDjE/O6uHxWOsH7yQXLSblrJ7Kyg78Hf2D4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Prashanth K <quic_prashk@quicinc.com>
Subject: [PATCH 6.6 213/269] usb: dwc3: Avoid waking up gadget during startxfer
Date: Tue, 10 Sep 2024 11:33:20 +0200
Message-ID: <20240910092615.601678227@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prashanth K <quic_prashk@quicinc.com>

commit 00dcf2fa449f23a263343d7fe051741bdde65d0b upstream.

When operating in High-Speed, it is observed that DSTS[USBLNKST] doesn't
update link state immediately after receiving the wakeup interrupt. Since
wakeup event handler calls the resume callbacks, there is a chance that
function drivers can perform an ep queue, which in turn tries to perform
remote wakeup from send_gadget_ep_cmd(STARTXFER). This happens because
DSTS[[21:18] wasn't updated to U0 yet, it's observed that the latency of
DSTS can be in order of milli-seconds. Hence avoid calling gadget_wakeup
during startxfer to prevent unnecessarily issuing remote wakeup to host.

Fixes: c36d8e947a56 ("usb: dwc3: gadget: put link to U0 before Start Transfer")
Cc: stable@vger.kernel.org
Suggested-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Signed-off-by: Prashanth K <quic_prashk@quicinc.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20240828064302.3796315-1-quic_prashk@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |   41 +++++++++++++++++------------------------
 1 file changed, 17 insertions(+), 24 deletions(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -287,6 +287,23 @@ static int __dwc3_gadget_wakeup(struct d
  *
  * Caller should handle locking. This function will issue @cmd with given
  * @params to @dep and wait for its completion.
+ *
+ * According to the programming guide, if the link state is in L1/L2/U3,
+ * then sending the Start Transfer command may not complete. The
+ * programming guide suggested to bring the link state back to ON/U0 by
+ * performing remote wakeup prior to sending the command. However, don't
+ * initiate remote wakeup when the user/function does not send wakeup
+ * request via wakeup ops. Send the command when it's allowed.
+ *
+ * Notes:
+ * For L1 link state, issuing a command requires the clearing of
+ * GUSB2PHYCFG.SUSPENDUSB2, which turns on the signal required to complete
+ * the given command (usually within 50us). This should happen within the
+ * command timeout set by driver. No additional step is needed.
+ *
+ * For L2 or U3 link state, the gadget is in USB suspend. Care should be
+ * taken when sending Start Transfer command to ensure that it's done after
+ * USB resume.
  */
 int dwc3_send_gadget_ep_cmd(struct dwc3_ep *dep, unsigned int cmd,
 		struct dwc3_gadget_ep_cmd_params *params)
@@ -327,30 +344,6 @@ int dwc3_send_gadget_ep_cmd(struct dwc3_
 			dwc3_writel(dwc->regs, DWC3_GUSB2PHYCFG(0), reg);
 	}
 
-	if (DWC3_DEPCMD_CMD(cmd) == DWC3_DEPCMD_STARTTRANSFER) {
-		int link_state;
-
-		/*
-		 * Initiate remote wakeup if the link state is in U3 when
-		 * operating in SS/SSP or L1/L2 when operating in HS/FS. If the
-		 * link state is in U1/U2, no remote wakeup is needed. The Start
-		 * Transfer command will initiate the link recovery.
-		 */
-		link_state = dwc3_gadget_get_link_state(dwc);
-		switch (link_state) {
-		case DWC3_LINK_STATE_U2:
-			if (dwc->gadget->speed >= USB_SPEED_SUPER)
-				break;
-
-			fallthrough;
-		case DWC3_LINK_STATE_U3:
-			ret = __dwc3_gadget_wakeup(dwc, false);
-			dev_WARN_ONCE(dwc->dev, ret, "wakeup failed --> %d\n",
-					ret);
-			break;
-		}
-	}
-
 	/*
 	 * For some commands such as Update Transfer command, DEPCMDPARn
 	 * registers are reserved. Since the driver often sends Update Transfer


