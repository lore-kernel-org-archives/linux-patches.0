Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865A9183CA5;
	Sun,  1 Sep 2024 16:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208137; cv=none; b=YIpfIvjaY8809XetIYSMfkrCjrhGDXk1rTxhwIE28YX+MlbsF6QaPtg3bIe+0053Reko085j2VPI60rNOITMaCQ7SXWhd6M45JnURRfD6P7M5IjVL41+5/V2bQuM6NLIWnZCvd9i5mvZgOelYOMJno530zwY2NQlufc3U13D1R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208137; c=relaxed/simple;
	bh=3X5Ds3N6ZnS8y2rqhWzku7u12jdpB8AR+SmAv5594YA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OB6x5en7cmhZRTpbW//A4GfE5fHiSun+9Z0xFEa8bDiLtUn/ksE+ZZMT3ThDjOwhi1IFsGnyGgA3g+nSU3hhNGlV92aOsewY/SBF/TUBKcht86JaTONINmFoyQ9hjnJy1pT4qTGvw1exYSNi7dYKgzdrWofSvyzFOxpLOmqQlqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qts9mhSC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qts9mhSC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D593EC4CEC3;
	Sun,  1 Sep 2024 16:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208137;
	bh=3X5Ds3N6ZnS8y2rqhWzku7u12jdpB8AR+SmAv5594YA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qts9mhSCt67v3YgkUyq//wn0stg9eaLiLu6KkoZpBgMZfdMlE189/t2dTxP/3KvTK
	 ffqPQSzA2LogOHUnOrEUm/yVDJ03Yj/TktF8Pmv3b+hf41vaegqyhWxRcD814lsg7m
	 cXSIidbr8xWrDLh3IHOAJNHACDZUN7J9A208rrWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawel Laszczak <pawell@cadence.com>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 6.6 84/93] usb: cdnsp: fix for Link TRB with TC
Date: Sun,  1 Sep 2024 18:17:11 +0200
Message-ID: <20240901160810.897794170@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
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

From: Pawel Laszczak <pawell@cadence.com>

commit 740f2e2791b98e47288b3814c83a3f566518fed2 upstream.

Stop Endpoint command on LINK TRB with TC bit set to 1 causes that
internal cycle bit can have incorrect state after command complete.
In consequence empty transfer ring can be incorrectly detected
when EP is resumed.
NOP TRB before LINK TRB avoid such scenario. Stop Endpoint command
is then on NOP TRB and internal cycle bit is not changed and have
correct value.

Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
cc: <stable@vger.kernel.org>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Reviewed-by: Peter Chen <peter.chen@kernel.org>
Link: https://lore.kernel.org/r/PH7PR07MB953878279F375CCCE6C6F40FDD8E2@PH7PR07MB9538.namprd07.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-gadget.h |    3 +++
 drivers/usb/cdns3/cdnsp-ring.c   |   28 ++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

--- a/drivers/usb/cdns3/cdnsp-gadget.h
+++ b/drivers/usb/cdns3/cdnsp-gadget.h
@@ -811,6 +811,7 @@ struct cdnsp_stream_info {
  *        generate Missed Service Error Event.
  *        Set skip flag when receive a Missed Service Error Event and
  *        process the missed tds on the endpoint ring.
+ * @wa1_nop_trb: hold pointer to NOP trb.
  */
 struct cdnsp_ep {
 	struct usb_ep endpoint;
@@ -838,6 +839,8 @@ struct cdnsp_ep {
 #define EP_UNCONFIGURED		BIT(7)
 
 	bool skip;
+	union cdnsp_trb	 *wa1_nop_trb;
+
 };
 
 /**
--- a/drivers/usb/cdns3/cdnsp-ring.c
+++ b/drivers/usb/cdns3/cdnsp-ring.c
@@ -1905,6 +1905,23 @@ int cdnsp_queue_bulk_tx(struct cdnsp_dev
 		return ret;
 
 	/*
+	 * workaround 1: STOP EP command on LINK TRB with TC bit set to 1
+	 * causes that internal cycle bit can have incorrect state after
+	 * command complete. In consequence empty transfer ring can be
+	 * incorrectly detected when EP is resumed.
+	 * NOP TRB before LINK TRB avoid such scenario. STOP EP command is
+	 * then on NOP TRB and internal cycle bit is not changed and have
+	 * correct value.
+	 */
+	if (pep->wa1_nop_trb) {
+		field = le32_to_cpu(pep->wa1_nop_trb->trans_event.flags);
+		field ^= TRB_CYCLE;
+
+		pep->wa1_nop_trb->trans_event.flags = cpu_to_le32(field);
+		pep->wa1_nop_trb = NULL;
+	}
+
+	/*
 	 * Don't give the first TRB to the hardware (by toggling the cycle bit)
 	 * until we've finished creating all the other TRBs. The ring's cycle
 	 * state may change as we enqueue the other TRBs, so save it too.
@@ -1999,6 +2016,17 @@ int cdnsp_queue_bulk_tx(struct cdnsp_dev
 		send_addr = addr;
 	}
 
+	if (cdnsp_trb_is_link(ring->enqueue + 1)) {
+		field = TRB_TYPE(TRB_TR_NOOP) | TRB_IOC;
+		if (!ring->cycle_state)
+			field |= TRB_CYCLE;
+
+		pep->wa1_nop_trb = ring->enqueue;
+
+		cdnsp_queue_trb(pdev, ring, 0, 0x0, 0x0,
+				TRB_INTR_TARGET(0), field);
+	}
+
 	cdnsp_check_trb_math(preq, enqd_len);
 	ret = cdnsp_giveback_first_trb(pdev, pep, preq->request.stream_id,
 				       start_cycle, start_trb);


