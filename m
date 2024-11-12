Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7DD21312A;
	Tue, 12 Nov 2024 10:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408183; cv=none; b=i8gcgQCJN1gmxx+o32xSjZlLHv8Ys3glsZqtFvyU/BtevnM+7vAcvcIkGbasQp8OvGXV96Ik/9WYqYrDdT3nllR2vWoTms60wAtdYSZ3aJHiYG6dRhA8k9z0tZRgaMmdUunwkLZ10X2frI8l9CCgEM1lFiCRGL3X3t5c/mn6AIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408183; c=relaxed/simple;
	bh=dCcq5ZyDQs8NnfHeEqSG3HF54WDb1SwmXaKwupiDhtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EzEWWvwedqopK/39B1utkMGL8981lg/Ud2rwFTVc0OzDeAb5rRgvRKsnD1EGtoYvOf8uEvKbKBlE0mvhBrgZUeO2ULrvdfGWHaPabIzuBSXtmwJgLLMkZL9KEKjRj+4n/YaD+qalEgkBCi8562AEbZ4adlFkCoaaElS9xW5xXj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u6INkgjb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u6INkgjb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B81DC4CECD;
	Tue, 12 Nov 2024 10:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408183;
	bh=dCcq5ZyDQs8NnfHeEqSG3HF54WDb1SwmXaKwupiDhtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u6INkgjbKdD+DeyQ7uSV5QjJKx+7V7rg558qmzfSpVUhtIauzsrMENivEJtidFN/0
	 /YNEZDy5BP9g0kElYWFakPC+Ix+8Y/eE3PDLQl4+6hJMb48jOdJuFsS42tB9y/m0RR
	 nmssPRJknd/gBMoZM/8UNBHnPlULMGVo8oyb6+KI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Markus Schneider-Pargmann <msp@baylibre.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.11 085/184] can: m_can: m_can_close(): dont call free_irq() for IRQ-less devices
Date: Tue, 12 Nov 2024 11:20:43 +0100
Message-ID: <20241112101904.121609178@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit e4de81f9e134c78ff7c75a00e43bd819643530d0 upstream.

In commit b382380c0d2d ("can: m_can: Add hrtimer to generate software
interrupt") support for IRQ-less devices was added. Instead of an
interrupt, the interrupt routine is called by a hrtimer-based polling
loop.

That patch forgot to change free_irq() to be only called for devices
with IRQs. Fix this, by calling free_irq() conditionally only if an
IRQ is available for the device (and thus has been requested
previously).

Fixes: b382380c0d2d ("can: m_can: Add hrtimer to generate software interrupt")
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Markus Schneider-Pargmann <msp@baylibre.com>
Link: https://patch.msgid.link/20240930-m_can-cleanups-v1-1-001c579cdee4@pengutronix.de
Cc: <stable@vger.kernel.org> # v6.6+
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/m_can/m_can.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1764,7 +1764,8 @@ static int m_can_close(struct net_device
 	netif_stop_queue(dev);
 
 	m_can_stop(dev);
-	free_irq(dev->irq, dev);
+	if (dev->irq)
+		free_irq(dev->irq, dev);
 
 	m_can_clean(dev);
 


