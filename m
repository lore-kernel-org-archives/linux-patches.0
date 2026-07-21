Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48DD46D56F;
	Tue, 21 Jul 2026 18:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656938; cv=none; b=qhxx30OPeNXw0SjtCi7b+ZI2BmNwA3pac0TEumdqin3jQ+0/+QpF4y5ckVgpubeFCBTBRehnjXxjjp751uoJgMBZjCzNDhT6Uen+TatjdZLwS1NY5vAOypcUmeuNKiSS8VtFoARLzpu1nwB14xQwfW9Mmy2Pkh0yTzM+Kbjk5lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656938; c=relaxed/simple;
	bh=fyNY5UVyJ+4aZDqPet0FrV9otH6HCGjsF32zj+lu72s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZgEqvnM2yO2eSubpToonj6qV2VFJXouMa2r8icdjDATujuUjqXPeKo5uR/nZ4E8NPNkLz3B3wC8pFPfMiCBA0N9aMr/G7DWEOAYQzTU8eXnDYToUDZ6GkHzncDxYhyvPgvQqPBsx+PI9i+vFX9tgclB7JXyfo6Ix4ff2Wg1u87w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L3mmq+Xc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L3mmq+Xc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 559B61F000E9;
	Tue, 21 Jul 2026 18:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656936;
	bh=CrX7QuPm6//cWTqIzIPJqendPr+tQN6/Am4NkWl+5Qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L3mmq+XczIHh1A6BiRnLqasOVIZiYYET3ok5F8z6dFB7YEM49hD72xnSCXsqLJ0Sp
	 qsgP9+oAgSVPbegzVXmwqD3cBuk6GAg05FT5iTqgPwt6wTKqrEaTM/uq5GBAbWoq1z
	 +4SFqyICUx0DKNb4zPgYe+8P3ySbPjPMnQYdZOhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanley Chu <yschu@nuvoton.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0576/1611] i3c: master: svc: Fix missed IBI after false SLVSTART on NPCM845
Date: Tue, 21 Jul 2026 17:11:32 +0200
Message-ID: <20260721152528.332405224@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

[ Upstream commit fa1d4fa118f4229168e9ca88cea260c5e5a94652 ]

The NPCM845 I3C controller may raise a false SLVSTART interrupt. The
handler first latches MSTATUS and then clears SLVSTART. If a real IBI
request arrives after the handler latches MSTATUS but before it clears
the SLVSTART interrupt status, HW sets the SLVREQ state. However, the
handler still relies on the stale MSTATUS snapshot, returns early, and
misses the real IBI. No further interrupt is generated for this pending
IBI.

Re-read MSTATUS to obtain the latest state and avoid missing a real IBI
due to this race condition.

Fixes: 4dd12e944f07 ("i3c: master: svc: Fix npcm845 invalid slvstart event")
Signed-off-by: Stanley Chu <yschu@nuvoton.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260413005040.1211107-2-yschu@nuvoton.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/svc-i3c-master.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/i3c/master/svc-i3c-master.c b/drivers/i3c/master/svc-i3c-master.c
index 93531cb216d169..3d9f905d560397 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -635,10 +635,18 @@ static irqreturn_t svc_i3c_master_irq_handler(int irq, void *dev_id)
 	/* Clear the interrupt status */
 	writel(SVC_I3C_MINT_SLVSTART, master->regs + SVC_I3C_MSTATUS);
 
-	/* Ignore the false event */
-	if (svc_has_quirk(master, SVC_I3C_QUIRK_FALSE_SLVSTART) &&
-	    !SVC_I3C_MSTATUS_STATE_SLVREQ(active))
-		return IRQ_HANDLED;
+	if (svc_has_quirk(master, SVC_I3C_QUIRK_FALSE_SLVSTART)) {
+		/*
+		 * Re-read MSTATUS to obtain the latest state and avoid
+		 * missing an IBI that arrives after MSTATUS is latched
+		 * but before SLVSTART is cleared.
+		 */
+		active = readl(master->regs + SVC_I3C_MSTATUS);
+
+		/* Ignore the false event */
+		if (!SVC_I3C_MSTATUS_STATE_SLVREQ(active))
+			return IRQ_HANDLED;
+	}
 
 	/*
 	 * The SDA line remains low until the request is processed.
-- 
2.53.0



