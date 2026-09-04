Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C643ECBCF;
	Fri,  4 Sep 2026 05:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500147; cv=none; b=WZUnlT4k5f02n3m/26aQDlKZBO4OTCoU+BPO+V/g+OnNeDpvECOs9eN78Zmw7k8EGgr43qu/KSOL3U5fIo9cbeHxWNcGRCvZMg2fNLwykudpI4nrIRscq+fOhP0HzOPHBVhhlFjzFqMvi7eYA6IPn6lN+VOXW8BK3fjwCz0UlBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500147; c=relaxed/simple;
	bh=KlQpxXykfqS2VGR3rkqSUNBazVMQpvXyl2WcdY0KVeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DpJSZVrEYah12AGDnEaFHXgvMwnwSByrqA9qoU6Vx+2MOmi/aZ/U72E3GtmE8H+3NGgU1c1l8UC6OsRZ2UkFuf6E6v3gcfO7SyT04go0q5hoC5+c1bWqyPFFNBRnD7WpkJI8kzTEYvrQzsSdZglqoHCBjNeeQZ7VBxCGwDm1184=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V+Rf0aFP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V+Rf0aFP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B03861F00A3D;
	Fri,  4 Sep 2026 05:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500146;
	bh=Ync8EEpME8RRaRP2ySTiDolN5RTOycxuGplB6xO0POI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V+Rf0aFPHoGZ7VXxrtxm2b8k2+d0CA5vv/rJapC6snaFfoO9llfPMgZyiNjD9GuKJ
	 9J7nvXmD83EZdsq9Tun6KoHlbGcmte2aKoYYx3xd9ixbvpTz17aTmdMSqHCLIP0nyn
	 T2TqWrteDKZ2s0rw8Ju7NwRZTT1szezzg6Lb3u14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaixuan Li <kaixuan.li@ntu.edu.sg>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 7.2 666/713] i3c: master: svc: bound IBI payload to the requested max_payload_len
Date: Fri,  4 Sep 2026 07:00:34 +0200
Message-ID: <20260904045818.764845065@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -455,14 +455,22 @@ static int svc_i3c_master_handle_ibi(str
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


