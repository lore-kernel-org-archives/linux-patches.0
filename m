Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51BA78B73;
	Wed, 21 Feb 2024 13:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523458; cv=none; b=im7eDPYLitdX7/uUr+zMb/UnbXvVKjih7sIa0QBhmAIPe8zcJg85r/+TgT2n8LtHV7zxvV1Hrw0KyVOnb5zRpIv/GDn2rgTGjsS8Q+I/fqzkVjbOvgbbDUYeH2kUYGfUm3NiCGLuw9E5Xo+D0BunGfgKJiFwEj0ZiPXsDmkyyJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523458; c=relaxed/simple;
	bh=kA3tfJEeop8IA1czY6W1CBRqIooGIIEgNkdaoWTOAT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XMIJlUslmYHAteXqpu1XjPk8lPfmQ5jQvg8cZRg8/jg1GyzKHllJHmmkLXn+bjYTq8n3cXobfpGMP48PTchAFeA5AHiKRh95kIskZ2mvAI8EX7ZbJ1yx7+i1+kbCWF0XpAAeEy+WR3UbfoU6HS3H03N95GIyZbYGP8SyWgLjHwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=id+kAbnc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="id+kAbnc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ABBFC433C7;
	Wed, 21 Feb 2024 13:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523458;
	bh=kA3tfJEeop8IA1czY6W1CBRqIooGIIEgNkdaoWTOAT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=id+kAbnc1k9LT+TbsOUqWjQ4cdM8Q7Boh/PyQkaDMnm8ZIsi4RJogM2u1OIKflHhp
	 PchzkHMPzCuZ1xjSv51FjPjcNG99TfPxp7GhhPx38qc7VxC3BeEdkke2Va9iAXEFT+
	 jmrf4SWfMt/HF8nfozH87drt82nHrd5TRf4xib8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Wesley Cheng <quic_wcheng@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 441/476] usb: dwc3: gadget: Refactor EP0 forced stall/restart into a separate API
Date: Wed, 21 Feb 2024 14:08:12 +0100
Message-ID: <20240221130024.344979322@linuxfoundation.org>
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

From: Wesley Cheng <quic_wcheng@quicinc.com>

[ Upstream commit 8f40fc0808137c157dd408d2632e63bfca2aecdb ]

Several sequences utilize the same routine for forcing the control endpoint
back into the SETUP phase.  This is required, because those operations need
to ensure that EP0 is back in the default state.

Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Signed-off-by: Wesley Cheng <quic_wcheng@quicinc.com>
Link: https://lore.kernel.org/r/20230420212759.29429-3-quic_wcheng@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 730e12fbec53 ("usb: dwc3: gadget: Handle EP0 request dequeuing properly")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/gadget.c | 53 ++++++++++++++++-----------------------
 1 file changed, 21 insertions(+), 32 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index a74ac44c6cd8..7704e2444b4b 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -139,6 +139,24 @@ int dwc3_gadget_set_link_state(struct dwc3 *dwc, enum dwc3_link_state state)
 	return -ETIMEDOUT;
 }
 
+static void dwc3_ep0_reset_state(struct dwc3 *dwc)
+{
+	unsigned int	dir;
+
+	if (dwc->ep0state != EP0_SETUP_PHASE) {
+		dir = !!dwc->ep0_expect_in;
+		if (dwc->ep0state == EP0_DATA_PHASE)
+			dwc3_ep0_end_control_data(dwc, dwc->eps[dir]);
+		else
+			dwc3_ep0_end_control_data(dwc, dwc->eps[!dir]);
+
+		dwc->eps[0]->trb_enqueue = 0;
+		dwc->eps[1]->trb_enqueue = 0;
+
+		dwc3_ep0_stall_and_restart(dwc);
+	}
+}
+
 /**
  * dwc3_ep_inc_trb - increment a trb index.
  * @index: Pointer to the TRB index to increment.
@@ -2495,16 +2513,9 @@ static int dwc3_gadget_soft_disconnect(struct dwc3 *dwc)
 		ret = wait_for_completion_timeout(&dwc->ep0_in_setup,
 				msecs_to_jiffies(DWC3_PULL_UP_TIMEOUT));
 		if (ret == 0) {
-			unsigned int    dir;
-
 			dev_warn(dwc->dev, "wait for SETUP phase timed out\n");
 			spin_lock_irqsave(&dwc->lock, flags);
-			dir = !!dwc->ep0_expect_in;
-			if (dwc->ep0state == EP0_DATA_PHASE)
-				dwc3_ep0_end_control_data(dwc, dwc->eps[dir]);
-			else
-				dwc3_ep0_end_control_data(dwc, dwc->eps[!dir]);
-			dwc3_ep0_stall_and_restart(dwc);
+			dwc3_ep0_reset_state(dwc);
 			spin_unlock_irqrestore(&dwc->lock, flags);
 		}
 	}
@@ -3762,16 +3773,7 @@ static void dwc3_gadget_disconnect_interrupt(struct dwc3 *dwc)
 	dwc->setup_packet_pending = false;
 	usb_gadget_set_state(dwc->gadget, USB_STATE_NOTATTACHED);
 
-	if (dwc->ep0state != EP0_SETUP_PHASE) {
-		unsigned int    dir;
-
-		dir = !!dwc->ep0_expect_in;
-		if (dwc->ep0state == EP0_DATA_PHASE)
-			dwc3_ep0_end_control_data(dwc, dwc->eps[dir]);
-		else
-			dwc3_ep0_end_control_data(dwc, dwc->eps[!dir]);
-		dwc3_ep0_stall_and_restart(dwc);
-	}
+	dwc3_ep0_reset_state(dwc);
 }
 
 static void dwc3_gadget_reset_interrupt(struct dwc3 *dwc)
@@ -3827,20 +3829,7 @@ static void dwc3_gadget_reset_interrupt(struct dwc3 *dwc)
 	 * phase. So ensure that EP0 is in setup phase by issuing a stall
 	 * and restart if EP0 is not in setup phase.
 	 */
-	if (dwc->ep0state != EP0_SETUP_PHASE) {
-		unsigned int	dir;
-
-		dir = !!dwc->ep0_expect_in;
-		if (dwc->ep0state == EP0_DATA_PHASE)
-			dwc3_ep0_end_control_data(dwc, dwc->eps[dir]);
-		else
-			dwc3_ep0_end_control_data(dwc, dwc->eps[!dir]);
-
-		dwc->eps[0]->trb_enqueue = 0;
-		dwc->eps[1]->trb_enqueue = 0;
-
-		dwc3_ep0_stall_and_restart(dwc);
-	}
+	dwc3_ep0_reset_state(dwc);
 
 	/*
 	 * In the Synopsis DesignWare Cores USB3 Databook Rev. 3.30a
-- 
2.43.0



