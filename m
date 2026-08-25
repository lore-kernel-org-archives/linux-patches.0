Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D86B471433;
	Tue, 25 Aug 2026 13:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665926; cv=none; b=O7Vwjj08ieWHjNfzL/L3Eq0m8JQgP9l9tbQpDDqvFKN8WaSr6GKk2e2TUGGYw7dy6JHLfsyP2iW6mVBYizf+6H7BLXChvktbn5WpcN7dQk/CymFoGh+k0RogiHLy7lS+cufWsP55cBTtvXFdz4X4A0OMbWMvQClDm9/YPs6oV0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665926; c=relaxed/simple;
	bh=6LVZWkYgNrU1tRXVgsThB7kDVjyPdGd6g4fLIGMMROE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D3xkbPvdKS9WeSaYb56yD/cI5iyrIOSVVMIAEuC+VNF3XpArLZeeZRGT7P1q8jM5EEF6FF4rccqBBG+up5KqM694NiwJK7Jd3Yod7QUBNlvwmCoxhSJPYNLQHidFMEyQfLys3BMweiNRT7QLtD/NyIu3+NTO+NOTTNt9nHyFdEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lPLPLUwZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lPLPLUwZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 964521F000E9;
	Tue, 25 Aug 2026 13:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665924;
	bh=jjJubz84rG20xYBPNh1EnUcwaFa/q2GWSCU82+qfeM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lPLPLUwZ9iF8LeYXWPIzVNMaE3/tdAj/Fu6b3DvjVAOnWWC8EwXTQpIECK6Pt5AmC
	 CTZw4fRAaitA/WAABIJPmI2ztCUEtRvPkoK7W9I1AlfxQCC3Yz8Iej1v+iFhTG3PAj
	 du0w/X/p6BEKlkN6BtGXh6R/G+CujpkUik2tIE/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 24/79] serial: sc16is7xx: use guards for simple mutex locks
Date: Tue, 25 Aug 2026 15:26:04 +0200
Message-ID: <20260825132542.645151412@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.677185791@linuxfoundation.org>
References: <20260825132541.677185791@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

[ Upstream commit 0f4f88bfd7e7bf3f3293045fffdc63586b0a889f ]

Guards can help to make the code more readable, so use them wherever they
do so.

In sc16is7xx_port_irq(), labels and 'rc' locals are eliminated completely.

Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://patch.msgid.link/20251027142957.1032073-6-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 246ac114f485 ("serial: sc16is7xx: enable THRI before filling TX FIFO")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sc16is7xx.c |   23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -10,6 +10,7 @@
 
 #include <linux/bitops.h>
 #include <linux/bits.h>
+#include <linux/cleanup.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/device.h>
@@ -794,18 +795,15 @@ static void sc16is7xx_update_mlines(stru
 
 static bool sc16is7xx_port_irq(struct sc16is7xx_port *s, int portno)
 {
-	bool rc = true;
 	unsigned int iir, rxlen;
 	struct uart_port *port = &s->p[portno].port;
 	struct sc16is7xx_one *one = to_sc16is7xx_one(port, port);
 
-	mutex_lock(&one->lock);
+	guard(mutex)(&one->lock);
 
 	iir = sc16is7xx_port_read(port, SC16IS7XX_IIR_REG);
-	if (iir & SC16IS7XX_IIR_NO_INT_BIT) {
-		rc = false;
-		goto out_port_irq;
-	}
+	if (iir & SC16IS7XX_IIR_NO_INT_BIT)
+		return false;
 
 	iir &= SC16IS7XX_IIR_ID_MASK;
 
@@ -845,10 +843,7 @@ static bool sc16is7xx_port_irq(struct sc
 		break;
 	}
 
-out_port_irq:
-	mutex_unlock(&one->lock);
-
-	return rc;
+	return true;
 }
 
 static irqreturn_t sc16is7xx_irq(int irq, void *dev_id)
@@ -878,9 +873,8 @@ static void sc16is7xx_tx_proc(struct kth
 	    (port->rs485.delay_rts_before_send > 0))
 		msleep(port->rs485.delay_rts_before_send);
 
-	mutex_lock(&one->lock);
+	guard(mutex)(&one->lock);
 	sc16is7xx_handle_tx(port);
-	mutex_unlock(&one->lock);
 }
 
 static void sc16is7xx_reconf_rs485(struct uart_port *port)
@@ -947,9 +941,8 @@ static void sc16is7xx_ms_proc(struct kth
 	struct sc16is7xx_port *s = dev_get_drvdata(one->port.dev);
 
 	if (one->port.state) {
-		mutex_lock(&one->lock);
-		sc16is7xx_update_mlines(one);
-		mutex_unlock(&one->lock);
+		scoped_guard(mutex, &one->lock)
+			sc16is7xx_update_mlines(one);
 
 		kthread_queue_delayed_work(&s->kworker, &one->ms_work, HZ);
 	}


