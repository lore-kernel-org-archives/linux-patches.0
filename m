Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F36188904;
	Fri, 15 Nov 2024 06:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653076; cv=none; b=Azxs77wTZ8A7lqFQ0M107+qxCe7ShCNMUE1VrDRScxvHKEYEHroEGsUuBHMlpeAuOoVYwKeQziB5ymGtqp8h+DLm2ZjpIx0eEMmeaKYsauEcWI9GGIy7mZYUw5AAu9FEpRUXXM1+wlHHWV/ncOexUHp5KPpJIDDTqXx0+hJwF6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653076; c=relaxed/simple;
	bh=HMCaZojqD0tCQe7Zt1gW+kYXewVsen6V+xJBgo9dWFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L35eImlrvX0TQz6iIcmSlOHTGe5rWVTyiYOSALPvtxGwjcG2iY6N8V3hp3pUMAr+i1yYOpFhM7p2zwHEfPWmPaENDYe4XiYJDhjmpv6iKyRCOh52Y+k7Zd6Nmu1cEjmrhE2yP+3cvS4ZgGF8B63LJT3Huq6s55KS3tY9rcpD5N4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xpkcadFI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xpkcadFI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89568C4CECF;
	Fri, 15 Nov 2024 06:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653076;
	bh=HMCaZojqD0tCQe7Zt1gW+kYXewVsen6V+xJBgo9dWFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xpkcadFIl7BO/S/FJT8VISxgxLJUWOFQK2WhvnNvI7Jnp3kpxgMuCSUu3MrW18+/g
	 tqwiP2HxBVViLnEYfjlLoQHiFe/J/c3zH39yxBToCk5s1VDbTD+/UWMxoJ0NBtXABw
	 QZocCvTgRKR2m+qaQz9QQ7dgXDaYXiAsFuCslGXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoffer Dall <christoffer.dall@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.4 45/66] irqchip/gic-v3: Force propagation of the active state with a read-back
Date: Fri, 15 Nov 2024 07:37:54 +0100
Message-ID: <20241115063724.470637018@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.834793938@linuxfoundation.org>
References: <20241115063722.834793938@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -383,6 +383,13 @@ static int gic_irq_set_irqchip_state(str
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
 


