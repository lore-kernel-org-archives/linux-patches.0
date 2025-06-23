Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DF5C2E0;
	Mon, 23 Jun 2025 21:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714314; cv=none; b=bIsgo4ugqyvYWCsJcFEvvwt671uW3zj2Q17tclVzjFPBx6zcMSgQP/nlj/EmsbxULnojb0gkICXq/h8OV3TuQvnjDL3NqDCbhtFy/TpNcLH7cLnZe2AMj8lCYbn5RVU7a4InIDiG4HGkQZMEaKPX2el/pVHMQJv//QKTkjyHnp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714314; c=relaxed/simple;
	bh=O3zN4yi4ORNAgt8Gqq3QzNWLUhQ3Im4eY5/Pgag6cWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gp3BTjH+dMex2gS0Rzioqa89HnaMrZULVQ28fdHwtAJ10PBaXgPPwxzUkRr3KxRC5t5Ac47Cgmh84J+j7QpRC7zS8csVQs1Bm0r1Izk4PYxI5DLl0pOoB9TXoic/VC8gGNool37bPazoff6GoZHY9lB98u76UhUtbkDg3nqLJVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ay4YS30O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ay4YS30O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A38C4CEEA;
	Mon, 23 Jun 2025 21:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714313;
	bh=O3zN4yi4ORNAgt8Gqq3QzNWLUhQ3Im4eY5/Pgag6cWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ay4YS30OsoNg2HTMrut+aEc46quf4RqFV7dheKrGi7+4nPThXKLhdNbm27QWa8PT6
	 G3LazlMtCInIHTPw710xyNfHTCBavfeiflsBzmyz2pB+82qp5ABTOKsv6Ea/LJtJjo
	 JBcvJmbEm814LgXkCeLkYeij4JZalyJiruHxKVsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Pawel Laszczak <pawell@cadence.com>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 5.15 180/411] usb: cdnsp: Fix issue with detecting command completion event
Date: Mon, 23 Jun 2025 15:05:24 +0200
Message-ID: <20250623130638.216185769@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawel Laszczak <pawell@cadence.com>

commit f4ecdc352646f7d23f348e5c544dbe3212c94fc8 upstream.

In some cases, there is a small-time gap in which CMD_RING_BUSY can be
cleared by controller but adding command completion event to event ring
will be delayed. As the result driver will return error code.

This behavior has been detected on usbtest driver (test 9) with
configuration including ep1in/ep1out bulk and ep2in/ep2out isoc
endpoint.

Probably this gap occurred because controller was busy with adding some
other events to event ring.

The CMD_RING_BUSY is cleared to '0' when the Command Descriptor has been
executed and not when command completion event has been added to event
ring.

To fix this issue for this test the small delay is sufficient less than
10us) but to make sure the problem doesn't happen again in the future
the patch introduces 10 retries to check with delay about 20us before
returning error code.

Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://lore.kernel.org/r/PH7PR07MB9538AA45362ACCF1B94EE9B7DD96A@PH7PR07MB9538.namprd07.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-gadget.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/drivers/usb/cdns3/cdnsp-gadget.c
+++ b/drivers/usb/cdns3/cdnsp-gadget.c
@@ -546,6 +546,7 @@ int cdnsp_wait_for_cmd_compl(struct cdns
 	dma_addr_t cmd_deq_dma;
 	union cdnsp_trb *event;
 	u32 cycle_state;
+	u32 retry = 10;
 	int ret, val;
 	u64 cmd_dma;
 	u32  flags;
@@ -577,8 +578,23 @@ int cdnsp_wait_for_cmd_compl(struct cdns
 		flags = le32_to_cpu(event->event_cmd.flags);
 
 		/* Check the owner of the TRB. */
-		if ((flags & TRB_CYCLE) != cycle_state)
+		if ((flags & TRB_CYCLE) != cycle_state) {
+			/*
+			 * Give some extra time to get chance controller
+			 * to finish command before returning error code.
+			 * Checking CMD_RING_BUSY is not sufficient because
+			 * this bit is cleared to '0' when the Command
+			 * Descriptor has been executed by controller
+			 * and not when command completion event has
+			 * be added to event ring.
+			 */
+			if (retry--) {
+				udelay(20);
+				continue;
+			}
+
 			return -EINVAL;
+		}
 
 		cmd_dma = le64_to_cpu(event->event_cmd.cmd_trb);
 


