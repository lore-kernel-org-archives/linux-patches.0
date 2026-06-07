Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95894308F38;
	Sun,  7 Jun 2026 10:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829700; cv=none; b=tnf6n6wwXTmWis1SqBSNHoPcxTqy+rylvVEpz+16OwN0HWtoAVo8oY6rHQAQnXdo8Qtm4up8207VhN6rhrTBtRtSMfiizHGJO6epZE14B3fX0xU60pGauJr5oZ2MBqqlUhAU3g3CvqA1LZAnknxuRGxiQSGddILW+r1E72tsFDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829700; c=relaxed/simple;
	bh=qgw9KJ+M5scG+rFYtZWn8ETljrNG8ujsinc0+o5Whvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kk4pugf90BXkj1vn98qwLerh5UwkSO236USLJEM+OC2a521j7NYZl6sJVZflg/gYEMhKQG7S1j940SLpZ97boW4P44SZ8OGirdzeKhPSZUyCTcd25cVBcJWNG4nzk+xUq7Qeb+TIzfiXjQv9wsS8BCqu5/cHW9zPmBtZ+GBg3JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PMZ/J0AM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PMZ/J0AM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F1D1F00893;
	Sun,  7 Jun 2026 10:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829699;
	bh=YKhw7aAibVW1fYVBFojnIqliqw4RLewvl1pLoUhYOPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PMZ/J0AMqaAdjzwYSF0kxOX/p427qdaf55HTBILjY0uOWV7QZOTuLmVytNU9Hw5Fg
	 8Pj42aYHephgMz+jiJz2yM21jgQ4v6pCd5dNJeb0Pc5/L+RbCHidZ9DJ2px45PDbBe
	 1v9RwwjdtFa+JbJRRBRr1lJLH8o7gtIYimuNhsFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>
Subject: [PATCH 6.12 247/307] serial: altera_jtaguart: handle uart_add_one_port() failures
Date: Sun,  7 Jun 2026 12:00:44 +0200
Message-ID: <20260607095736.768122523@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

commit ea66be25f0e934f49d24cd0c5845d13cdba3520b upstream.

altera_jtaguart_probe() maps the register window before registering the
UART port, but it ignores failures from uart_add_one_port(). If port
registration fails, probe still returns success and the mapping remains
live until a later remove path that is not part of probe failure cleanup.

Return the uart_add_one_port() error and unmap the register window on
that failure path.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 5bcd601049c6 ("serial: Add driver for the Altera JTAG UART")
Cc: stable <stable@kernel.org>
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Link: https://patch.msgid.link/20260512065837.79528-1-mhun512@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/altera_jtaguart.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/altera_jtaguart.c
+++ b/drivers/tty/serial/altera_jtaguart.c
@@ -381,6 +381,7 @@ static int altera_jtaguart_probe(struct
 	struct resource *res_mem;
 	int i = pdev->id;
 	int irq;
+	int ret;
 
 	/* -1 emphasizes that the platform must have one port, no .N suffix */
 	if (i == -1)
@@ -420,7 +421,11 @@ static int altera_jtaguart_probe(struct
 	port->flags = UPF_BOOT_AUTOCONF;
 	port->dev = &pdev->dev;
 
-	uart_add_one_port(&altera_jtaguart_driver, port);
+	ret = uart_add_one_port(&altera_jtaguart_driver, port);
+	if (ret) {
+		iounmap(port->membase);
+		return ret;
+	}
 
 	return 0;
 }


