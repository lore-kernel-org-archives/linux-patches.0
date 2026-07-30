Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C96F644A72C;
	Thu, 30 Jul 2026 16:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427262; cv=none; b=lwX0HEmo4FCxh3IifLVDRBNCCK3/UwTXJCCK6SiAV3Ehrv6sexIS+i+wQ7/mM9oJbIYcOrudn9hf7CR8y8HDROZhklZE0Gf+3IW+gtlvHOriOk0+1lRUIWbO/FLP2odSPx+i2H8A3j4u4fDtbbJCcxDT1OsOjTo1L00rUIvx1zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427262; c=relaxed/simple;
	bh=eIOGkCJToYZHzZrrnwOXyteben+tGMTTnYmr3jQBfAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FFUC/Y7Vm3gJjokiu76qEbYCM0osgadmHM35B6Zg6JoxYM3O555tQO1pymD2c6ZM0rfOlar270N+4gD9UJspyKIikl4dNYn4EOUwkY7IJoi/lY3XM3hjGRiVi7G7PfyllleGEAvpma8crD2lvs0hB/pZ11jo9M0jYxBWXe76R9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RkwP1zjU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RkwP1zjU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B971F00ADB;
	Thu, 30 Jul 2026 16:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427260;
	bh=py47bZw4yxXRxqQNVzSWOjQ2c3aI+QqD+Cn4sqYwj4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RkwP1zjUKOiozPIEiJsSmGNKwtcFXi6f3yg0YdgyCOeQYjQLGXZKCVTNaPxinUFy8
	 U0jww0ZBTO5+smGIQytdj7rMyxDYwCi+S+ScAcq3hLfpWZ7uKXdGJ+M7r1b+3wkNUr
	 8n30dpYW9PzB6SDNGYA/o3+NuBGJz4x2hAaxnWtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunho Park <shpark061104@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.6 108/484] USB: serial: io_edgeport: cap received transmit credits
Date: Thu, 30 Jul 2026 16:10:05 +0200
Message-ID: <20260730141425.805915543@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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


