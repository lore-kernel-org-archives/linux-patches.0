Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7881F37F306;
	Fri,  4 Sep 2026 06:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501747; cv=none; b=idfHtCt/B22oCZBARl/LPrOWf1Pw/jmJwRolV+2gLi35qRE82x2mrsDy3UUFapNdiaYUQdTFVuXKCbiMZGzYl4jaqSRIYXUOFLvc3tAB/yhJqSvMBH8PIKXm+C9wFevhuIz0LJhjxjYpBFCZYYdvo2ehbVKc+B8WPr9hIqCRTZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501747; c=relaxed/simple;
	bh=gIYzswMsh9V/17BB0UawxIsIYwIdrKH/fMpIZzLHMpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GuaaqYvrb+iHoA5CCZT8go4Qva9vNfWALJu/T768q5SMtw+ShlPa3S96yDDkVeAd9J9EpQ81Xy2KRgNxHNGatitajuFJwZs2zZXdgWlWlWbSpk0PkinpkyNpDGUPO8YqLc+WhZSTYE8jl1pCOdEgYzl/N87SxKkwy/9SVC9uSVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aAQx3jcl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aAQx3jcl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3B471F00A3D;
	Fri,  4 Sep 2026 06:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501746;
	bh=d4exBFyRA1HNST+IbbKz3yv10bw8St9r8upxBPkUruo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aAQx3jclOnMkpQIf7uCf58wLQQekLEa6iiUyGxvYaivzhD8bZ3blmyje4j4180aDZ
	 EP/Xu2mZEc+ISBxCIR45o8Bu1HBvk2I8tzfzNPL1B+Ukr6J6oCubtTsoHFIuqTztqK
	 d53cy5kGHkEEc6CUW6fkVuG1vDnvzt/beWmGYFDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaixuan Li <kaixuan.li@ntu.edu.sg>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.18 517/552] i3c: master: svc: bound IBI payload to the requested max_payload_len
Date: Fri,  4 Sep 2026 07:01:14 +0200
Message-ID: <20260904045802.350976678@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maoyi Xie <maoyixie.tju@gmail.com>

commit e2bda39d7f9f285ec803e200b5c1f17143d0b483 upstream.

svc_i3c_master_handle_ibi() reads the IBI payload from the RX FIFO into
the IBI slot. The loop is bounded by the hardware FIFO size
(SVC_I3C_FIFO_SIZE), not by the slot size.

slot->data points into the IBI pool, which i3c_generic_ibi_alloc_pool()
sizes at max_payload_len per slot. svc_i3c_master_request_ibi() only
rejects a max_payload_len larger than SVC_I3C_FIFO_SIZE, so a driver can
request a smaller one. mctp-i3c requests 1. Each readsb() then copies the
controller RXCOUNT bytes (up to 31) with no check against the slot size.
A device that sends more bytes than the slot holds writes past
slot->data, an out-of-bounds write into the IBI pool.

Bound the loop by dev->ibi->max_payload_len and clamp each read to the
space left in the slot, the same way dw-i3c does. A device can still send
more than the requested payload. Flush the leftover bytes from the RX FIFO
so they do not leak into the next transfer.

Fixes: dd3c52846d59 ("i3c: master: svc: Add Silvaco I3C master driver")
Cc: stable@vger.kernel.org
Co-developed-by: Kaixuan Li <kaixuan.li@ntu.edu.sg>
Signed-off-by: Kaixuan Li <kaixuan.li@ntu.edu.sg>
Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/178227747353.2931373.15868718612134648277@maoyixie.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master/svc-i3c-master.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -418,14 +418,22 @@ static int svc_i3c_master_handle_ibi(str
 	buf = slot->data;
 
 	while (SVC_I3C_MSTATUS_RXPEND(readl(master->regs + SVC_I3C_MSTATUS))  &&
-	       slot->len < SVC_I3C_FIFO_SIZE) {
+	       slot->len < dev->ibi->max_payload_len) {
 		mdatactrl = readl(master->regs + SVC_I3C_MDATACTRL);
 		count = SVC_I3C_MDATACTRL_RXCOUNT(mdatactrl);
+		count = min(count, dev->ibi->max_payload_len - slot->len);
 		readsb(master->regs + SVC_I3C_MRDATAB, buf, count);
 		slot->len += count;
 		buf += count;
 	}
 
+	/*
+	 * The device may have sent more than the requested payload. Drop the
+	 * extra bytes so they do not leak into the next transfer.
+	 */
+	if (SVC_I3C_MSTATUS_RXPEND(readl(master->regs + SVC_I3C_MSTATUS)))
+		writel(SVC_I3C_MDATACTRL_FLUSHRB, master->regs + SVC_I3C_MDATACTRL);
+
 	master->ibi.tbq_slot = slot;
 
 	return 0;


