Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7254213124;
	Tue, 12 Nov 2024 10:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407488; cv=none; b=uXOuCfwBkaiNfWW3FwQ+c9lTiWRZGcWS5CwDRB2oY/uP366hjtsoxo4zFaRugjX3lTBWRqhdNrVZCEK9rviYWWMER1rMNXtMCGNsPYgpmKIYj1dudn7Qyt8I7CD6g/X1FyMV8rD62C6+eNkOri84xO+nazJz1gelouKsY5mpr10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407488; c=relaxed/simple;
	bh=Nj+s6ZIC3SCDPARZ1jbF2fcMszXjzy/ik2uQ4E4zWTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eC0YjsIAKlIYl9lXK52hq7d0zR6lb2q1spIX0cXTr53AsIICsz7KBAuv0jkvFUYjbI9HZLsb3iPYXrAvKrI00s22v0J0ougxktNnHQ5KYk/1Erpe7H64gmZh6VzEZCuC1fPRpyZ3wYPmOxv8dsomWbJm7ObEKp8BBczcumBEWAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cOVF16yw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cOVF16yw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E2FC4CECD;
	Tue, 12 Nov 2024 10:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407488;
	bh=Nj+s6ZIC3SCDPARZ1jbF2fcMszXjzy/ik2uQ4E4zWTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cOVF16ywUktidU+bKLT1zpuRjPbTG4xj2D1dIs0sDAJkiZLGVi/oWpL9IwKa2taT3
	 MzkRFmDq6PQZHChzhwM8g1swLXqxAStvxp/rBO7Gxman1Jn2+MOOmfz0MAOLBbLy8q
	 F5gtoyU7lQULfVTCb6OTgi9C+YQhDxR4S8tvbfLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoffer Dall <christoffer.dall@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.1 91/98] irqchip/gic-v3: Force propagation of the active state with a read-back
Date: Tue, 12 Nov 2024 11:21:46 +0100
Message-ID: <20241112101847.713357314@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
References: <20241112101844.263449965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -473,6 +473,13 @@ static int gic_irq_set_irqchip_state(str
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
 


