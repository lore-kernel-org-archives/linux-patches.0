Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D4B3B4417;
	Mon, 17 Aug 2026 14:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975525; cv=none; b=MURNQLlKQal8vw5Sm5/gZjjpLzbOOaM/f09lQ82Ihssd8XD04jtYM6NScJAKe5zdlJcLin1fN1NfyB3LEBnE2kKZJC1GvJi6dv91Rnd4mojURVqLNa0f85WlvT1gaytIQBiBaVHRErQDOBb7TJNbhrecSZ8rKkUhg7/qeDoG8wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975525; c=relaxed/simple;
	bh=mXOeO8zTzIcXaoXaeocHv5D3QqObyKYe/i0D8VbJI8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oLDRLdr0HsSNDcRevDjB43Z7Fn67T23/aIiR8Dr6iGvmj2eGaOA0n+5KmygIlw3iGyqwktL6a3q+ywnybl6OztplcRGf5cDjo1wcotJILHWgSk4tFZRJKg6+3T88He22jOskMuPGU/HIr5LQPaXNvXbx83yPZL1daowo4TTpj38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w9akLlQv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w9akLlQv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9107E1F000E9;
	Mon, 17 Aug 2026 14:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975524;
	bh=35trEbAs6b48oQdzjOjpj6hH21yJS4NVVjfXMBYGSdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w9akLlQvYvGyTBsuYr18Qpzn+S/yQzuKQPagy92YkrbjuQkWOxtEZbKWN34Uo4SPc
	 Th05J/VByIN208BVeq0/YA8ngOhjo4IJk+lilemV8WeMtHsfiYGAnv9Ftb332h95lB
	 0vMGzFe5YLFhu7Hc0HxKAfH/aWiwZko1/1R4mkBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunho Park <shpark061104@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 056/389] USB: serial: io_edgeport: cap received transmit credits
Date: Mon, 17 Aug 2026 15:28:15 +0200
Message-ID: <20260817132541.246397525@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -722,7 +722,8 @@ static void edge_interrupt_callback(stru
 				if (edge_port && edge_port->open) {
 					spin_lock_irqsave(&edge_port->ep_lock,
 							  flags);
-					edge_port->txCredits += txCredits;
+					edge_port->txCredits = min(edge_port->txCredits + txCredits,
+								   edge_port->maxTxCredits);
 					spin_unlock_irqrestore(&edge_port->ep_lock,
 							       flags);
 					dev_dbg(dev, "%s - txcredits for port%d = %d\n",


