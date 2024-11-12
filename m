Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3835620B20B;
	Tue, 12 Nov 2024 10:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407158; cv=none; b=aQdN2/uIOZsgovaMhHfnuzoKH8RAIRzOlLp06mmrD4VhbTVSsBOdI3PKlkj9Mja4/aJwDDW8UEru4sWza18qbOAwZb9gmqgZu0UNgWbR5Tamo3H4faCZpoGnjNBh4T/7vDciFptNhbGRgip8c+WK9LkClc1QZLSQTfhbjzUfdhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407158; c=relaxed/simple;
	bh=6EjPaQ0n12JmNEfJNIQusFabeu4YZXnxusFRd57/rjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DHO4siGp22xFkWLhhytjUD0Olhik/E7vr+dXXXQ1c4Wt7HifCzu4B3ng5Tj8gBVbCuKS3seK+Z7NaWLB0c6tSwKk2ZbqJEeodnb5Y5mL7gN0vG1iFnRqaibcntvyhZ9s30azj66xZ9Tm1c2XWj7UfsLoDwpAp6HRQFlR721p3gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jFY12WJQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jFY12WJQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C235C4CECD;
	Tue, 12 Nov 2024 10:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407158;
	bh=6EjPaQ0n12JmNEfJNIQusFabeu4YZXnxusFRd57/rjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jFY12WJQ6J9/h0ntl6JVvivZnRKEmKUwTca7XqMH7WXIPz7gZ9RqmOaLs0Hh127Zb
	 wB9/mk/sJiNTgfJgsL7tGbxdDPB45NAb7aiGwFKD1zXkOXnVoQbw6iY4t83qJ93ziC
	 weiYCGT+Rh6PdftdJYRZ9JDU+gV0+adWnnP9YnB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoffer Dall <christoffer.dall@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.15 68/76] irqchip/gic-v3: Force propagation of the active state with a read-back
Date: Tue, 12 Nov 2024 11:21:33 +0100
Message-ID: <20241112101842.371419163@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101839.777512218@linuxfoundation.org>
References: <20241112101839.777512218@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

commit 464cb98f1c07298c4c10e714ae0c36338d18d316 upstream.

Christoffer reports that on some implementations, writing to
GICR_ISACTIVER0 (and similar GICD registers) can race badly with a guest
issuing a deactivation of that interrupt via the system register interface.

There are multiple reasons to this:

 - this uses an early write-acknoledgement memory type (nGnRE), meaning
   that the write may only have made it as far as some interconnect
   by the time the store is considered "done"

 - the GIC itself is allowed to buffer the write until it decides to
   take it into account (as long as it is in finite time)

The effects are that the activation may not have taken effect by the time
the kernel enters the guest, forcing an immediate exit, or that a guest
deactivation occurs before the interrupt is active, doing nothing.

In order to guarantee that the write to the ISACTIVER register has taken
effect, read back from it, forcing the interconnect to propagate the write,
and the GIC to process the write before returning the read.

Reported-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Christoffer Dall <christoffer.dall@arm.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20241106084418.3794612-1-maz@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-gic-v3.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -429,6 +429,13 @@ static int gic_irq_set_irqchip_state(str
 	}
 
 	gic_poke_irq(d, reg);
+
+	/*
+	 * Force read-back to guarantee that the active state has taken
+	 * effect, and won't race with a guest-driven deactivation.
+	 */
+	if (reg == GICD_ISACTIVER)
+		gic_peek_irq(d, reg);
 	return 0;
 }
 


