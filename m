Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160C9BA45;
	Fri,  9 Oct 2026 14:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556620; cv=none; b=C4Y34ymUd2MWiyXWIfLW89CcVL4V9irzulUix62yztBxzDecqyBRNepOFKGJyxcrqeyRCMiswikNRRxjkiygo2kCDyEA6ZQ9LgR+s4KHL02SYoWc/oN55+3nUi8s5qTcVyhL58/LEa3n08MHFpelZlmzBF9OYpuirkT1FQtR13c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556620; c=relaxed/simple;
	bh=48ATcru1t56P8f3zolEad5sWMmCFx3gGKQrHsqs3muw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HLSJllYUvpc7P4MotDW+RVdj6poCbAoG0wFITIvlKhCo5YwN8AUbYjPZ24OO7/WggRagA9jRYWWkHL420Mq6JplfK9mdwmj9l4r2dgIM1nF+DAiZ12kVIWTttmcwA3ADoVK6xCS9c9t6a+WyTdn3XIST6S2ENQyZvjtPCQaMIjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k16d9YVw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k16d9YVw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 676311F000FF;
	Fri,  9 Oct 2026 14:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556619;
	bh=+mZoqs0QpZF/6jV3+ADD5OcJ6KYoxV4J5d3UI02nw6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k16d9YVw/1h/u2Gfbwfwm2s1r+tRbFeLMWUFX32cH+DN6UyMl6d07mnenE1t6tEyZ
	 gcT/aMM1cnywAByIH2lz758sRyTfNl7B6EmNb4X+vIdrZXViKOZxVRHzDcTF+fDNOU
	 bxTizl08OXY4VtqR52bzoZJNQjllxthLXVLcwRso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Orgad Shaneh <orgads@gmail.com>
Subject: [PATCH 7.2 210/428] usb: octeon-hcd: fix the FIFO-flush timeout computation
Date: Fri,  9 Oct 2026 16:09:07 +0200
Message-ID: <20261009140950.740586520@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


