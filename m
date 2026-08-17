Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEBBE3C661A;
	Mon, 17 Aug 2026 14:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976690; cv=none; b=geYkalF6tWPHF5rF7jOLYR9yk9+XmRTddLYzA7BjVO4HYDqxsmhCsvZ4soglkT+o/MxDS0p2TtqvxWQqmqsZsiAkxgBF123n5EZT7irmfe/sVxWQfYYM+oBe0Nco0CO844qmiyUDnUMRbQB0R55SN0imfjXIoG5C0BC0gNhDzyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976690; c=relaxed/simple;
	bh=3nEMYzjaXnBh7UgSbbsaoX5Fu/xiwD6bAurW6kPhw9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NmT+yQVh2rUXcNJyIkNCtAwEHJwhXfvo/KG129T6bGrFmKAGdyxhIjOrmdmxxYzWmPRYc2n8G9ZPLoIs5epQnzfJCjRo4hUD9/Et5XbdraRd4OcUlqDV/nZMRJflk4XVaEcT9YdMva3J3oLk7RETKRVXcfgthZLk7DaE4zMgGSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nu1NFORS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nu1NFORS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47CDF1F000E9;
	Mon, 17 Aug 2026 14:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976688;
	bh=dcFdNAy4xpgWQHBbr01xLm3uZOHee/dvDyze/DqOSKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nu1NFORSEanptCWObzoFpBfX7R7jPNbPzct4f/ZxZQZWyS9woyduUjMjsmUeY+BZQ
	 D0Z6s+QZqoD6ELC0sk+svCiYhorV8TyzmSjLGzs6CQxU11qKYdXYpVeg3Tsw0pGzTZ
	 AR69VUbCfDpAdTQywr8F8LgnktqRvVcKFIqIYNp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunho Park <shpark061104@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 071/456] USB: serial: io_edgeport: cap received transmit credits
Date: Mon, 17 Aug 2026 15:27:41 +0200
Message-ID: <20260817132542.842413112@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


