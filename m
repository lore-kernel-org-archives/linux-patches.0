Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D1646AF3C;
	Tue, 16 Jun 2026 18:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635052; cv=none; b=iWODZXEmsCpTDmWI9bQQJqFjao72O8usU0kX0mXkXsmr8lM/q1qZJocI89UN5wNLrrLhDhbwk/eqOVZ1A5VPNukULVdTlw7qCAo002p3+U7tXHSuTpZk99+uA8Zkw566n4FFrcRNPdaQltdpOY3w1veDjHsDvT1OAkNZ0pgCMp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635052; c=relaxed/simple;
	bh=XZSU3OJRp0Gslcs4eAxt+AGs5SfC9O99XURPOxzpTfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CIza1GxWRRXxqatIzSCAYf+V/bI0zI2eHtUsbr0TClvl49xG5JF97H1oXjm71rKoUtL/EPR2uKEHIaXZX7r1W8V4kq/GRxL/zOZVFPyJjQCVU6msugdN8z/BJsF6zM0o6FDamRucg96iVP5FDRk14ErnVsnFdojR/CFh2lJicxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tKXNRXdR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tKXNRXdR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1AF91F000E9;
	Tue, 16 Jun 2026 18:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635050;
	bh=BfjOCbkD9MAYYqbSppuJLOOvDhoh7NN8bWwO1Hf+awc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tKXNRXdRUlGHdZX4C2ZQk4aNVWrmRMdWOQZvWuo1G/JukLh+w5yteg1yZhtssCRFg
	 0H3OgXM9V81kDYqYihe2e2qK1vDDkGGkRu/HMKpT25ELdLtotFPm44eGaC8CQIy206
	 kDgrOXLPJuaoplI23LT8M4vDeKZAqZvZYlCctHfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 382/411] serial: altera_jtaguart: handle uart_add_one_port() failures
Date: Tue, 16 Jun 2026 20:30:20 +0530
Message-ID: <20260616145121.575814858@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit ea66be25f0e934f49d24cd0c5845d13cdba3520b ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/altera_jtaguart.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/altera_jtaguart.c
+++ b/drivers/tty/serial/altera_jtaguart.c
@@ -421,6 +421,7 @@ static int altera_jtaguart_probe(struct
 	struct resource *res_mem;
 	int i = pdev->id;
 	int irq;
+	int ret;
 
 	/* -1 emphasizes that the platform must have one port, no .N suffix */
 	if (i == -1)
@@ -460,7 +461,11 @@ static int altera_jtaguart_probe(struct
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


