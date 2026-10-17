Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF973B9616;
	Sat, 17 Oct 2026 17:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256509; cv=none; b=dbT0V8AWD/qRwCcqZ9wdOwtTomAa2Dy4uC2vvGVbnxg/ghXs8vvJYIFTH1W4JT1g3b4fPTWOXv17g6wygEaaVAtM9gj07fwxZZUSMIkmyuC2zhsEycJtXQIyYbXNtRaLhprUFnL3bGkCsFa2eycN818W3GhfFy9Nu2rbsQRYONA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256509; c=relaxed/simple;
	bh=gh2q+LNpEygjbHF29KuIWbeehJ0Hj+5zSX5iQKZPDrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tU4ymEXaDzwZCcQYQR/mwjFbRZMB7S9G3x7TFXmWjcCeLVtR5oH6ISaEMsDLMx/FHFI5XuuP61g0XfHoov+/qY1KXR//1CR6hJY5erm/aQNzhQrjHfbOSYAXnxLhRfDE/PwyRO0f2wVptagyEoS5g+EPhEoQlMECF4Fa1iCYKoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=beM7qbWH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="beM7qbWH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C89F61F000C4;
	Sat, 17 Oct 2026 17:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256508;
	bh=g9/9pX/Ad6dtGS27sPLF5b9G8UvJYJkEJHSxAG3ReME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=beM7qbWHPMdVqFUqalWsP0Rfv3EOfxgYIclaTQJIvdCK1PjjVs4Yc90aCr1vmbEHo
	 BXAog+72xNNSICv85qvZUIa42f1D2/I7jc/P9NG4HuEaqjnVHcBllV2NivugZ6Dra8
	 hcEB6mSMxINTNZ5DXbDOcIv1UROil4+gdYaE6ox4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Orgad Shaneh <orgads@gmail.com>
Subject: [PATCH 6.6 0260/1674] usb: octeon-hcd: fix the FIFO-flush timeout computation
Date: Sat, 17 Oct 2026 17:42:12 +0200
Message-ID: <20261017160437.800876452@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


