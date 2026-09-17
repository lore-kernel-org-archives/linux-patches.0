Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EFE44F3934;
	Thu, 17 Sep 2026 16:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661093; cv=none; b=VvUSjCxeVhTyiLJC5p54aDQ/9MeyQEeOKnNQYiksQHi3cm6trK32eOiFcRfb0yfeyKyBv2cm6fNM1Yyo+2X+ZnNdnCUb1CMb7Osb3dE5ljSCJ+ZdS9wKv97s/OP5CRmkvmJn4Mlyi1bndgCUnhwi3d6cJWYjPGirE0KpoUN4x6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661093; c=relaxed/simple;
	bh=6yfl0k1gCjjENCcLHnty6jI4/egf0vtlc40oYO9loXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e6OTJvJp2+kczb29Sh019NRbt1JPV/dePqNtpzW7UHNbsFrbRFmmdW2vBQ7EVt+pzupXOJKUhIqh5RCkkQ/3bwa2lICJMWU6YQRg8083knMbP9P6ygrjUeeSPzxLirFfVl4f5MrZEsgjiT+dS4kwOxvzXlDaz7ui/fKivmzE9/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CPz2lS15; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CPz2lS15"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D70531F000FF;
	Thu, 17 Sep 2026 16:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661092;
	bh=OaHxuKKZi4V/xStwM3sIg6cTnMuWoum25++hAilZoKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CPz2lS15w0hne782XiMtz0QpMs9dSk3sAxto7Ac718pkYa06lymFHXJ9OxzV+Q4pe
	 Zx4PwFGxpckoQ6Fwhtl8flpomHofPdEn3CmAyK7+hnmvJg4Q9b8RdAMioKciuVAlLc
	 ED+ntuJyWfjvyaN2T45rzTCWcA0Vm72fuV+ztSGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanley Chu <yschu@nuvoton.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0039/1250] i3c: master: svc: Prevent IRQ storm from false SLVSTART on NPCM845
Date: Thu, 17 Sep 2026 15:57:14 +0100
Message-ID: <20260917151552.995272084@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Stanley Chu <yschu@nuvoton.com>

[ Upstream commit 1effa3adfe53cb2bb28bf5640a676b791d5ab405 ]

On NPCM845, when a target on the I3C bus gets stuck holding SDA low,
the controller reports a false Master Request (MR) in-band interrupt
event. The driver handles this by emitting a STOP condition to restore
the bus.

However, the hardware quirk SVC_I3C_QUIRK_FALSE_SLVSTART indicates that
emitting a STOP condition may spuriously set the SLVSTART interrupt
status bit. In the Master Request case, this creates a feedback loop:
the STOP triggers a new SLVSTART event, the IRQ handler fires again,
the controller still reports an MR type, another STOP is emitted, and
the cycle repeats indefinitely, resulting in an IRQ storm that can lock
up the CPU.

Clear the SLVSTART status bit explicitly after emitting the STOP in the
Master Request IBI handler when the SVC_I3C_QUIRK_FALSE_SLVSTART quirk
is set. This breaks the feedback loop without affecting normal SLVSTART
processing, which is already guarded in the top-level IRQ handler by
checking that MSTATUS is in SLVREQ state.

Signed-off-by: Stanley Chu <yschu@nuvoton.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260413005040.1211107-3-yschu@nuvoton.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/svc-i3c-master.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/i3c/master/svc-i3c-master.c b/drivers/i3c/master/svc-i3c-master.c
index b6a697173e19e..1f936196b30cc 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -616,6 +616,15 @@ static void svc_i3c_master_ibi_isr(struct svc_i3c_master *master)
 		break;
 	case SVC_I3C_MSTATUS_IBITYPE_MASTER_REQUEST:
 		svc_i3c_master_emit_stop(master);
+
+		/*
+		 * If a target gets stuck holding SDA low, the controller reports a MR.
+		 * On NPCM845, emitting STOP may spuriously set SLVSTART, retriggering
+		 * the interrupt and re-entering MR handling, leading to an IRQ storm.
+		 * Clear SLVSTART after STOP to break the loop.
+		 */
+		if (svc_has_quirk(master, SVC_I3C_QUIRK_FALSE_SLVSTART))
+			writel(SVC_I3C_MINT_SLVSTART, master->regs + SVC_I3C_MSTATUS);
 		break;
 	default:
 		break;
-- 
2.53.0



