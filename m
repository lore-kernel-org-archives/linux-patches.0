Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB8A43C04B;
	Thu, 30 Jul 2026 14:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421589; cv=none; b=pyBop9d2/dVI/OLt7u339s7yk3mKgFAU2Lxe4IAjT54f6h8sKe67YTzePZPKxtOrEmAR/UL1HBuujoQwuF/5METGfEFwXduHATTcJyOigkJ22CJhSracnf189glWt/pdDy53mr1vnvMyfgHgocfRrcyF9omvW4lCTN7oYsTQ0qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421589; c=relaxed/simple;
	bh=vPkIN5yFKJYUSHS069xC0nt2KtO/jNiQfoxRA+h4o4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I9PuSi37P1W7A5ITT3Tko42TeKIPv6/7IijCF19w4CDWS+kKsGMZ2ZibKzZotOfl+aU4sSUMq3hfL0slJLITvQPBhrERCrmSNUs8YCpGJ7M6JfAJpgAXiNnGiPpKcS1aTriokNmsu34Viewe43hc9vMFSw8OB8yFNJp9ZqJRv9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oHG+eDmg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oHG+eDmg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6D721F00A3A;
	Thu, 30 Jul 2026 14:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421587;
	bh=8wr4yhUmMVjOJ99AgT/5H38aSkdBDQOj064rji2AyCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oHG+eDmgwcUzTrP6NjjaqnWeLfIJohsdtaf4YVM9sBvJwARmJ0Wy7MlN76kgQkXtM
	 TmqIHz4/71EoOcpgo60DmMtO6XNnzQZFhYUeVQWwwkFsYs4YxMvA+s8vi8YuOWJoBx
	 idt61zxIuXXn5rb9++cE1/HtAc8Bls82xh4DmXEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunho Park <shpark061104@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 7.1 154/744] USB: serial: io_edgeport: cap received transmit credits
Date: Thu, 30 Jul 2026 16:07:07 +0200
Message-ID: <20260730141447.561125313@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


