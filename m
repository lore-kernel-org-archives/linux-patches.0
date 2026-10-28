Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212772;
	b=BGTPG++5RnbY56pPuYOckL+UIvzXzGKoVYckoWWh4mLOBumkiWyla6p8xIbOq3NLL8ya
	 1QUEzfXqjO2GDO+NIMoWbsVguB2t0BJ9q5U7MXY4GOSaJxmJ8Yyg/mm5ulaLzLFqPEr0+
	 1GQ2TMjDKJrJ4bo+zkqiK+XQTbZX+jUsq3rir87mMoWnyz5EUo2316B5GFppFqxLvWBkZ
	 iTpDEz2mXgqVo16J2hyMpSMUOSDH2mRi+0w8cqj6GcIX4RUDKsj/qxKxBUNat067cLK0b
	 nShoPGPufRyuAuhpbCtLj3glzNcJ+HRVitADrToq8/K9xqSld4pMrnoVohFjpP5aixQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212772;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AA3pNQowjP2egiRHvNtE17fv/4GKEnv8kzmMQKIqmoI=;
	b=CQTy4Ft18QzNk7goS/16zIaWo5MROUruMf6qX6gLGvEGmgObFx4RECHHNEpKZxd6mDUk
	 6icWe9uCdZ6DB9mmtqr735CqmaK30F+T5qW1AZjuxz01oJCNdMbLpo19QGCdI5xsUMuLX
	 soP6feFZmdYJWHakbXYv/RSaTDl+JOh/npP9Gj85uWQZEjPBiVqFnv1BgQC/pZ8Rxekvg
	 7EYLhznfpvrGozkUFneuRzm6iHUgkrq0UxwrZ+2dbLa2vEcWuO+Bk7LRW2q7cDrTXP4mQ
	 z6PgosK1AffTal6gQ0O0S8NiGM4IgsEqYUhwa4B11UsX2JtZU2d8tyxwevMjBcWPvzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dIPP80sl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256AE606A322;
	Wed, 28 Oct 2026 18:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dIPP80sl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A1D1F01825;
	Wed, 28 Oct 2026 18:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212772;
	bh=AA3pNQowjP2egiRHvNtE17fv/4GKEnv8kzmMQKIqmoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dIPP80slzqxosaFIqwgusE9nPeIJwd97rZbDZBVpvCnxA7HD1moHVzeZ+d8/bfDnm
	 Vr+XeSJ8g4CxfBYys1AsP/IEcHx/Sy2oBMkXCDi9ohuUP8wwHamI2qg98OUAPRwcKc
	 jsCNIQH8xeEH1U2WJSXbJ10hbaus4S/I5hEoc8Ig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Orgad Shaneh <orgads@gmail.com>
Subject: [PATCH 6.1 0271/1887] usb: octeon-hcd: fix the FIFO-flush timeout computation
Date: Wed, 28 Oct 2026 17:39:27 +0100
Message-ID: <20261028170505.396489838@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Orgad Shaneh <orgads@gmail.com>

commit 4c7a1b9f1f1979f2b3b69428ada12680695159c2 upstream.

cvmx_wait_tx_rx() computes its 100us deadline from
(u64)octeon_get_clock_rate - the address of the function, not its
return value; the parentheses have been missing since the
CVMX_WAIT_FOR_FIELD32 macro became a function. The cast makes it
compile silently, and the resulting deadline is effectively infinite.

On a healthy controller the flush bit clears on the first read and
nothing is noticed. On a controller whose PHY did not come up (for
example when the reference-clock configuration is wrong for the board),
txfflsh/rxfflsh never clear and probe spins forever in __delay() -
observed as a hard hang with a soft-lockup splat on a CN5020 board,
where the board watchdog then resets the system with no console output.

Call the function, restoring the 100us timeout the code always
intended.

Fixes: 3e195a80e096 ("Staging: octeon-usb: Replaces CVMX_WAIT_FOR_FIELD32 macro with a function")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: Orgad Shaneh <orgads@gmail.com>
Link: https://patch.msgid.link/20260901193100.1352110-1-orgads@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/octeon-hcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/octeon-hcd.c
+++ b/drivers/usb/host/octeon-hcd.c
@@ -578,7 +578,7 @@ static int cvmx_wait_tx_rx(struct octeon
 	int result;
 	u64 address = CVMX_USBCX_GRSTCTL(usb->index);
 	u64 done = cvmx_get_cycle() + 100 *
-		   (u64)octeon_get_clock_rate / 1000000;
+		   (u64)octeon_get_clock_rate() / 1000000;
 	union cvmx_usbcx_grstctl c;
 
 	while (1) {


