Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3B42C0F93;
	Thu, 30 Jul 2026 15:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423759; cv=none; b=V13rE5GnA+J3J4DNKsO1FaFCUti2+tKnOZklxjK7YLxZWByX8dq4i/CjdzwqyCLnvJNWGvm//elhwDzHHtTFR+kUFGX5e4HwEVF2wJAdkvQjynFzFZy3Rgfrd42xYGJ2bpClyNOrC4+eG/RSd3zEr3UGwKpZ8XLi9kb8uUt04ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423759; c=relaxed/simple;
	bh=Zik/UdXRCJvUUt6kKeEOqetQSv5bwIpBu4++d2nVvr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T+o4Reo10LCHUsLT6Xrl52u/iFlG11m7GQzpDQ7w4ICikE5FY41Bv+/dv0yy3AtQydWfXBPbg/MndLdnAc6QnJISdYcv1E4JkVAek3PDGhtSSxdtQjAvImFZuGjkPkPwdJffbWkz2BDT0vF44JiU7+wLHyRUd+emNjUUkjAxlb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fd8xpu7G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fd8xpu7G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 312871F000E9;
	Thu, 30 Jul 2026 15:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423758;
	bh=3eM6WG/60VB6ZceVN3kXfWVZSqEf050ku9U1vHGlPzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fd8xpu7GxrCUeXUo520W6X8gz+4Erz2EaOlNIGYP6vgkwGrl2MHLW9z68FDIkXmGQ
	 1HXI08jCPdX36UhXMdaok3QknrwAwY3VejIyqZOZc2MXuS4HVOZsSgIz9XubwYrlLr
	 1Y5O8IR5P+A4ttdNlKZtx2xuQ13sdDBrb/bUk4bU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunho Park <shpark061104@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.18 155/675] USB: serial: io_edgeport: cap received transmit credits
Date: Thu, 30 Jul 2026 16:08:05 +0200
Message-ID: <20260730141448.430228275@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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


