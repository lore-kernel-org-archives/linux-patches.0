Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4575D23BCFD;
	Mon, 23 Mar 2026 14:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274667; cv=none; b=arkW7mdflgBBcSAJ7v+t3//uDFkOk5XxKkdnZkvnn2l+DCwIz4JXqKrY2+3fgoGkvrlrgudnwfy/S5CNpkDUQ6FVagiZ8W0ZtARp+nD7cXMT0Exe5fDcVBY3KZRAalbvUCOo4jLUyrdsdfX8bO3Wo335ExHS5HgK4S6534q2Www=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274667; c=relaxed/simple;
	bh=PgaB0uceDATYatEzhCR59mT4oJPE7rowdup3pzCU5gI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B2ePGhtuaeA8KhaXySyCPE/kk5WAjbk1Aa9F3b6vhyTMYEaQ23Ul3xZgMG/XzX1g5t7S4kX3OnZ7maKLDel5LZue5GQO8/dVgSCtUghEyDYKuKsFFe/GHyZfaPlz0FJoB/1TRuVlbon6HwdCWhkMr/dJ2SAmIYUDwJw1fKa/zl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N29Fe2EN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N29Fe2EN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD54BC2BCB4;
	Mon, 23 Mar 2026 14:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274667;
	bh=PgaB0uceDATYatEzhCR59mT4oJPE7rowdup3pzCU5gI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N29Fe2ENG/YjelpC/WV2GIBv3NE0AAd3xcljUmBwjpYtHDg2KMjUn8p1no8eJIjdP
	 wVpzgYu2uBP3Vnu+yoglJLQEEvZapz3vzg8D4M/DYgadCmJloRVutSH1q1Lm0Monjc
	 IDMas3w43Tma1iord4Rm3TkM+Z66bvU/z+w8vKno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Peng Zhang <zhangpeng.00@bytedance.com>,
	Muchun Song <songmuchun@bytedance.com>,
	Alban Bedel <alban.bedel@lht.dlh.de>,
	Maximilian Lueer <maximilian.lueer@lht.dlh.de>
Subject: [PATCH 6.18 069/212] serial: 8250: always disable IRQ during THRE test
Date: Mon, 23 Mar 2026 14:44:50 +0100
Message-ID: <20260323134505.950339978@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

From: Peng Zhang <zhangpeng.00@bytedance.com>

commit 24b98e8664e157aff0814a0f49895ee8223f382f upstream.

commit 039d4926379b ("serial: 8250: Toggle IER bits on only after irq
has been set up") moved IRQ setup before the THRE test, in combination
with commit 205d300aea75 ("serial: 8250: change lock order in
serial8250_do_startup()") the interrupt handler can run during the
test and race with its IIR reads. This can produce wrong THRE test
results and cause spurious registration of the
serial8250_backup_timeout timer. Unconditionally disable the IRQ for
the short duration of the test and re-enable it afterwards to avoid
the race.

Fixes: 039d4926379b ("serial: 8250: Toggle IER bits on only after irq has been set up")
Depends-on: 205d300aea75 ("serial: 8250: change lock order in serial8250_do_startup()")
Cc: stable <stable@kernel.org>
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Alban Bedel <alban.bedel@lht.dlh.de>
Tested-by: Maximilian Lueer <maximilian.lueer@lht.dlh.de>
Link: https://patch.msgid.link/20260224121639.579404-1-alban.bedel@lht.dlh.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_port.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -2147,8 +2147,7 @@ static void serial8250_THRE_test(struct
 	if (up->port.flags & UPF_NO_THRE_TEST)
 		return;
 
-	if (port->irqflags & IRQF_SHARED)
-		disable_irq_nosync(port->irq);
+	disable_irq(port->irq);
 
 	/*
 	 * Test for UARTs that do not reassert THRE when the transmitter is idle and the interrupt
@@ -2170,8 +2169,7 @@ static void serial8250_THRE_test(struct
 		serial_port_out(port, UART_IER, 0);
 	}
 
-	if (port->irqflags & IRQF_SHARED)
-		enable_irq(port->irq);
+	enable_irq(port->irq);
 
 	/*
 	 * If the interrupt is not reasserted, or we otherwise don't trust the iir, setup a timer to


