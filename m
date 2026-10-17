Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4652C3C345F;
	Sat, 17 Oct 2026 16:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255391; cv=none; b=g3IPLj+o8kzXoAQisuiGSeeTl+xqXtkzFIBi0czJRcFO9hX76BhVBj+LtBeGcB7C8Odk7l+b6Ej4+uF/ZYnUqoxYi56Wik0hINx3wPLyE79XAR6hG02v+1IwToY1xweTJSfJxSSCkOjk7nfU9zLBADaGpKSUoO/1JxmhYzknwJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255391; c=relaxed/simple;
	bh=rVkXx7RoOlQZz/r6TNegNiffJkj+v2HdgqLpeRvwpNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SxlypX3CIO2+eoVwae/SaT4GDN/3qGgX8cf7PkSqbTHbmIT9KJwkiwKrMdBSPlq18xqSflzTe8oBjR6CAalRU9iUbgtdqgNlcTGfHjssnZcN5KChjfpO+95ZfDfkFavwctYYAvhekPHpkoMBLs4TTj9DS/a7k+kfipM7HMyfaH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fXi3/ktb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fXi3/ktb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A1CB1F000C4;
	Sat, 17 Oct 2026 16:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255389;
	bh=SHS6EN9cqQmE6CQ2SpbZfpQMJo0+dilk0c5Q7Y6CYSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fXi3/ktbYFJApMpN1umz66kGrhwgyvGTO8VYHNGs+Hejm+xx/7U5umplq6NN6TR/u
	 W7WWYCCpAqyAUfy7/x1pFgVyV7OJYtTvNpDugrLGyu4RMXJwSaLoTJQHnTuLaSpi/a
	 EEQ+GD8p7hFm4p5tA0bPKY10/JMLMi+jHk0euFsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanley Chu <yschu@nuvoton.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 761/869] i3c: master: svc: Prevent IRQ storm from false SLVSTART on NPCM845
Date: Sat, 17 Oct 2026 18:00:02 +0200
Message-ID: <20261017160056.439461680@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0b709be2544c2..1948d398ce503 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -570,6 +570,15 @@ static void svc_i3c_master_ibi_work(struct work_struct *work)
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



