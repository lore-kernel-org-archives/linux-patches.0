Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194243AE1A2;
	Tue, 16 Jun 2026 18:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635764; cv=none; b=EBFjZVoY79/7tCegDQYEF0YiHCoSHYgBiW3093K9hyP5koPxKt+Pqgpe3PvilrDW2jJ1IaMcFdP7Oh/2J/PC+vnr4SlKegy+SaJxNG6NeR6wd9wSXvYN8QE1/+EO13VTOxFfc96sICUWbisxT4FJAiTSH7lkp1NQU64gHxzf6b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635764; c=relaxed/simple;
	bh=SB0kWsVwVHdQxTPI3CSsPNbsVjyAxIugE1GP+PE4+q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GIQ3MvU7TEY2eodYd76E4jSv4mUfxoZyWqXHvPDibDUhlbTFOmcRnauMASXq/lk0UVHmYID2IYAtfktwfWLcXaMAjp01nIwehbGsOfKBtM3thapMqPqHNXME3aO4nh05ZFE4Qt2R58/skepjHIxtckU1KHb1vPLuWkyDJIKABDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ChgaVF74; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ChgaVF74"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2579B1F000E9;
	Tue, 16 Jun 2026 18:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635763;
	bh=C/Ds43zYnaB7CUJObEYyr/CmYrNH730YSwLoZzllViY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ChgaVF74jLo1qmg74ORh2yyL6jUWBARGaahhWg/86XCrnrEWIRSV00g9sfZ3jXb0H
	 6XHSV8uTPhgOnXpaBw7CdPuRRiw+FqgH9gBBfbz/uaTRUuO+TPWF4oX5wRherBcz5m
	 sBMA2CLIn5IiBCTMhXMVeQPpoGoKglIoZxhamL9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: [PATCH 5.10 110/342] serial: zs: Fix swapped RI/DSR modem line transition counting
Date: Tue, 16 Jun 2026 20:26:46 +0530
Message-ID: <20260616145053.348037797@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej W. Rozycki <macro@orcam.me.uk>

commit d15cd40cb1858f75846eaafa9a6bca841b790a92 upstream.

Fix a thinko in the status interrupt handler that has caused counters
for the RI and DSR modem line transitions to be used for the other line
each.

Fixes: 8b4a40809e53 ("zs: move to the serial subsystem")
Cc: stable <stable@kernel.org>
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Link: https://patch.msgid.link/alpine.DEB.2.21.2604101747110.29980@angie.orcam.me.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/zs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/zs.c
+++ b/drivers/tty/serial/zs.c
@@ -679,9 +679,9 @@ static void zs_status_handle(struct zs_p
 			uart_handle_dcd_change(uport,
 					       zport->mctrl & TIOCM_CAR);
 		if (delta & TIOCM_RNG)
-			uport->icount.dsr++;
-		if (delta & TIOCM_DSR)
 			uport->icount.rng++;
+		if (delta & TIOCM_DSR)
+			uport->icount.dsr++;
 
 		if (delta)
 			wake_up_interruptible(&uport->state->port.delta_msr_wait);


