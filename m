Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56C812D1E8;
	Tue, 30 Apr 2024 11:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476113; cv=none; b=CNFZY65LegwJk1VpwLKVzCDN8f06e/e6M4bA/Yi63ZEpF2Qj7aN9f/iRX/ZtiY5ZKEyIdnX2wWKnJG5HcRzRQSq6cLdDHhpIRx8SXtuhteLdgBeaNj12z7/fuBACrtGrNWf+/sPkmaY8MRwqGS9PqbGnoF5X61av3+0nD+VUBNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476113; c=relaxed/simple;
	bh=4MX5XKy1uzzHIsAGFpkz1OnXNsilD0HZDCFAV2L2Y2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QVUTTAjch2KCvkYGuYT05Ce8dvNg1ixRSJqdu3XJlepCtG36+QWsJxYldrkJNow1NYYA7mpl0xAiUqWcuQDHVoY44tsJLnBgnaLycCw8YaBps/M88jbjhkm2AjOwSJwmWYLkq4NQ7ok3MYbxVvhOJvzoVN2Pr6vyHxaMYvUquO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kDwX8Tjt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kDwX8Tjt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C768C2BBFC;
	Tue, 30 Apr 2024 11:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476113;
	bh=4MX5XKy1uzzHIsAGFpkz1OnXNsilD0HZDCFAV2L2Y2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kDwX8Tjt+hyBPIkGdiWCVCD7bKUT+MtuuVA+zFm7O1VhCoWoB+RNVkURocBujAu43
	 RNOdImPWuJx3pw0CaH3mPwuitB5j65u+ds1eY5hpSZXWfbRikd6xPb5bCdOhsGtYmp
	 FYrWWFDgPWTcKHbXKtt0ceLiKnsA82c1Ufvnsw8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	"Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	stable@kernel.org,
	linux-m68k@lists.linux-m68k.org,
	Finn Thain <fthain@linux-m68k.org>
Subject: [PATCH 5.4 037/107] serial/pmac_zilog: Remove flawed mitigation for rx irq flood
Date: Tue, 30 Apr 2024 12:39:57 +0200
Message-ID: <20240430103045.754334412@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103044.655968143@linuxfoundation.org>
References: <20240430103044.655968143@linuxfoundation.org>
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

From: Finn Thain <fthain@linux-m68k.org>

commit 1be3226445362bfbf461c92a5bcdb1723f2e4907 upstream.

The mitigation was intended to stop the irq completely. That may be
better than a hard lock-up but it turns out that you get a crash anyway
if you're using pmac_zilog as a serial console:

ttyPZ0: pmz: rx irq flood !
BUG: spinlock recursion on CPU#0, swapper/0

That's because the pr_err() call in pmz_receive_chars() results in
pmz_console_write() attempting to lock a spinlock already locked in
pmz_interrupt(). With CONFIG_DEBUG_SPINLOCK=y, this produces a fatal
BUG splat. The spinlock in question is the one in struct uart_port.

Even when it's not fatal, the serial port rx function ceases to work.
Also, the iteration limit doesn't play nicely with QEMU, as can be
seen in the bug report linked below.

A web search for other reports of the error message "pmz: rx irq flood"
didn't produce anything. So I don't think this code is needed any more.
Remove it.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Naveen N. Rao <naveen.n.rao@linux.ibm.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: stable@kernel.org
Cc: linux-m68k@lists.linux-m68k.org
Link: https://github.com/vivier/qemu-m68k/issues/44
Link: https://lore.kernel.org/all/1078874617.9746.36.camel@gaston/
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@kernel.org>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Link: https://lore.kernel.org/r/e853cf2c762f23101cd2ddec0cc0c2be0e72685f.1712568223.git.fthain@linux-m68k.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/pmac_zilog.c |   14 --------------
 1 file changed, 14 deletions(-)

--- a/drivers/tty/serial/pmac_zilog.c
+++ b/drivers/tty/serial/pmac_zilog.c
@@ -220,7 +220,6 @@ static bool pmz_receive_chars(struct uar
 {
 	struct tty_port *port;
 	unsigned char ch, r1, drop, flag;
-	int loops = 0;
 
 	/* Sanity check, make sure the old bug is no longer happening */
 	if (uap->port.state == NULL) {
@@ -301,25 +300,12 @@ static bool pmz_receive_chars(struct uar
 		if (r1 & Rx_OVR)
 			tty_insert_flip_char(port, 0, TTY_OVERRUN);
 	next_char:
-		/* We can get stuck in an infinite loop getting char 0 when the
-		 * line is in a wrong HW state, we break that here.
-		 * When that happens, I disable the receive side of the driver.
-		 * Note that what I've been experiencing is a real irq loop where
-		 * I'm getting flooded regardless of the actual port speed.
-		 * Something strange is going on with the HW
-		 */
-		if ((++loops) > 1000)
-			goto flood;
 		ch = read_zsreg(uap, R0);
 		if (!(ch & Rx_CH_AV))
 			break;
 	}
 
 	return true;
- flood:
-	pmz_interrupt_control(uap, 0);
-	pmz_error("pmz: rx irq flood !\n");
-	return true;
 }
 
 static void pmz_status_handle(struct uart_pmac_port *uap)


