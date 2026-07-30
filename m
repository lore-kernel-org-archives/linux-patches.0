Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42DF041F5E6;
	Thu, 30 Jul 2026 15:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425607; cv=none; b=Kd6ehxYNqJw5tEMO2WXC369ASouJKQNYSk5yI2lLWahqdtNbacoi9k7iRCk8Rt8cD5up17cObbgrvY7eSJWYd9knkm1fPT/Gdho724ZYBx/jSgQszf8Naj1aBsHULEWEenmx+gzSGUkDwWve2Mi8sA+ks0F7j99FRWwAigtQoJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425607; c=relaxed/simple;
	bh=JXVSbEnBGD3zK+wEmHaAop2VFv24VVNAHd2eEb/xbj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BDDkdY8bUKmbtjiw5gQ8ggZ0+sSFI5rZxBMDp3JLDWjtHGAqqnqPFOJa99kccigXcqDcUJXZkK11ixJcilnVePDZNl8DyNziL1kRYmhvC9qrZsyiyAWL722LzGzMXZrFWrpLHav7PdEh3cUz11yl4ufp110dzkCRnbghvl5r/20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hg01PmtI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hg01PmtI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DEBB1F00A3F;
	Thu, 30 Jul 2026 15:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425606;
	bh=Utwbob6G5dViLvH7aJspebBUES1/Oas1EgdaaOupPRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hg01PmtIvQbMxA3g5VpWx4WVn2e1IyInymECVCQ8+fBBJ1FTub/GAMnksT17+Qanu
	 OJ+Vo/er/8JGpZ79E9X8X8SzCXg+coOPRVPnMUrAuU97QVMPXlx4ijDK46Av4xZXnT
	 VW3B69TuT1Y4wCd9pMwXApikP1Rb1dO56FgRFY8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunho Park <shpark061104@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 127/602] USB: serial: io_edgeport: cap received transmit credits
Date: Thu, 30 Jul 2026 16:08:39 +0200
Message-ID: <20260730141438.656526963@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sunho Park <shpark061104@gmail.com>

commit faaddd811c5099f11a5f52e68a6b31a5898cda4f upstream.

The interrupt-status packet reports transmit credits returned by the
device. edge_interrupt_callback() adds the 16-bit value to txCredits
without checking maxTxCredits.

edge_write() uses txCredits minus the software FIFO count as the amount
of data that fits. Since the FIFO is allocated with maxTxCredits bytes,
txCredits exceeding maxTxCredits can cause OOB write in ring buffer.

Cap accumulated credits at maxTxCredits. Conforming devices should never
hit the cap.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5
Signed-off-by: Sunho Park <shpark061104@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/io_edgeport.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -646,7 +646,8 @@ static void edge_interrupt_callback(stru
 				if (edge_port && edge_port->open) {
 					spin_lock_irqsave(&edge_port->ep_lock,
 							  flags);
-					edge_port->txCredits += txCredits;
+					edge_port->txCredits = min(edge_port->txCredits + txCredits,
+								   edge_port->maxTxCredits);
 					spin_unlock_irqrestore(&edge_port->ep_lock,
 							       flags);
 					dev_dbg(dev, "%s - txcredits for port%d = %d\n",


