Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398F62773C3;
	Mon, 23 Mar 2026 15:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278619; cv=none; b=PGIG+J9Iy3oqKGvARcTuKaYwqXMLSVnfFcpQtneJ/omB6qRR+TcYTLfM1r5EekfULBpXk9Owem0TPhPkGL9NB/MDIWRsFs0YdoQJ4UixSv8a2HaK6TLB2dhNW74a7V7uWOxYPKLcAT58c3Bv/IaCQC6MnYQqxw9b02yFRAV98pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278619; c=relaxed/simple;
	bh=yFRsDeE44w5xi+s3sl+7wrpf0JV6QieOJ8tEf1+flwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pyu27bqsolzL8wxXic1+2G39s95WuqHSnHxk9y0/aBP/cx7hC+XGesbtcn8TLq+pwC5xorf9XkoDBOb7okKezqIOh8dce98GJIDkeOIfXPbk2ccDokgTEsyukPgUgFHSJuOL7XYoRR8sliHoTx5hoDPKPCi8+HFYij79L2EN1Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i4OEd/Js; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i4OEd/Js"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97EACC4CEF7;
	Mon, 23 Mar 2026 15:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278619;
	bh=yFRsDeE44w5xi+s3sl+7wrpf0JV6QieOJ8tEf1+flwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i4OEd/JsLLZKrj+MJygjBs5KLOp9B8PPa0ueXMBHY8KjKGmX3uvCe5q+w1GG6IXqx
	 RtCar4zF8YTx9ct6EF0g7I0HytvDQEQmK02TqSL/8IpHiJm6/QcHzNWW60TDkKuonx
	 pc8lQEaWNGAO5AXCsk8oTh7KY1Y6B3RZ82tJGqfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.6 363/567] i3c: mipi-i3c-hci: Restart DMA ring correctly after dequeue abort
Date: Mon, 23 Mar 2026 14:44:43 +0100
Message-ID: <20260323134542.805055152@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

commit b6d586431ae20d5157ee468d0ef62ad26798ef13 upstream.

The DMA dequeue path attempts to restart the ring after aborting an
in-flight transfer, but the current sequence is incomplete. The controller
must be brought out of the aborted state and the ring control registers
must be programmed in the correct order: first clearing ABORT, then
re-enabling the ring and asserting RUN_STOP to resume operation.

Add the missing controller resume step and update the ring control writes
so that the ring is restarted using the proper sequence.

Fixes: 9ad9a52cce282 ("i3c/master: introduce the mipi-i3c-hci driver")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260306072451.11131-11-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master/mipi-i3c-hci/dma.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/i3c/master/mipi-i3c-hci/dma.c
+++ b/drivers/i3c/master/mipi-i3c-hci/dma.c
@@ -491,7 +491,9 @@ static bool hci_dma_dequeue_xfer(struct
 	}
 
 	/* restart the ring */
+	mipi_i3c_hci_resume(hci);
 	rh_reg_write(RING_CONTROL, RING_CTRL_ENABLE);
+	rh_reg_write(RING_CONTROL, RING_CTRL_ENABLE | RING_CTRL_RUN_STOP);
 
 	return did_unqueue;
 }


