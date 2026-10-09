Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6788E1A682B;
	Fri,  9 Oct 2026 14:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556044; cv=none; b=BIp/IKpWL/K9g0hvkMfJsj+90Vw9NxGJ59om5eRkRwUmLKJGMWJxGZx2RigWaNQ7bVwR/pPf1K9DSLRCIletdKn+ny3OF7utvTunlQF0BV365j+VcbtDFwc9f3kXbZYqa5xAkwSpBol4sWNzmwV0gqmZtfYD/rYQwKCVkLTML4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556044; c=relaxed/simple;
	bh=0uTwRrSYkN5kvCx/2b1AWLDkP+Yp3MdD2pA9fym0qdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rmGacXcfyudH4h0kzU/NMQPcVlEnYR89IIbAPujVDe2zzW7cv3X4CF4/2Ru2NHcf7ddr4EjS4rXMNfle1G2t4JK6CrmzedM2ZKzvwXqt4HM3qlUTd2g7U02uA3gW4JicOzLkulSdHxRmWosEx9NrT59Xg9Oeqnhdq7jZgM5PS1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yEqNOt7A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yEqNOt7A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF98D1F000FF;
	Fri,  9 Oct 2026 14:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556043;
	bh=BoXvazWxD3x1sI5FqPxnolKt61CkclZrqL7s7srMJTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yEqNOt7AYwxEQtS4U3B6THy0Y0gtvrCUXKuH/afWQxyFFFVouNeViEHrZhhhvFFvN
	 Lg9v8t3Ffh4ryFkIzZKJwUbWZeWyNM2GvQ5lZsfFeRJFH18F4th/CtSQs+JS6kaICG
	 c1oVz/8vJxLbtH3czW5UllMXwIpbysTsbXptI0mM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Orgad Shaneh <orgads@gmail.com>
Subject: [PATCH 6.18 165/403] usb: octeon-hcd: fix the FIFO-flush timeout computation
Date: Fri,  9 Oct 2026 16:08:46 +0200
Message-ID: <20261009140955.955317975@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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


