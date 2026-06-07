Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC3F32ED3A;
	Sun,  7 Jun 2026 10:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829593; cv=none; b=JrM8wO0YkYL3uuqlr7s5C0QWWuW/wolLpiGWAvpXiI3cafMgRrTJBsnHAnPzLEWdQh2Ec7s1+F8aFbL6ehv4tffuL/iYJ3st2rDS5444cFC1K4wszmGt94vdRXml58AMe/wZKzSYXMFMNkJ/7W9dhB77Hlo9Z/WtJtSsV96u7jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829593; c=relaxed/simple;
	bh=LhAAfeHcUbCufhFLxxip50hdcANE6Rl5sR/y5oUpyxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PtAO8aHtSu1BoOn0SYLbHtmJ7Gq6g/xpQVzisoT9DW+sIqXm9KK8vp7H72jd3eqWXUdxAU3LdyfQAjvWcpZviW4qch4ICCAEZtsuX2wmrKGxA7VTc9O16Izij+2stheyXkOVhtbn2uvykF4xpDhoHKscv/C/W4hWMSrtS/aPeHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0TvPRMJJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0TvPRMJJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 837981F00893;
	Sun,  7 Jun 2026 10:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829591;
	bh=5kzWj/0ZoZWKoir3oL9Ggv7ALOQbnikfmbZPuK1oPuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0TvPRMJJwZgOk/E1KTKQ8vjgkvpZAyRql072FcM6QO0RM2gxl8nyiNXHhp4OEJJxM
	 qvYzbzIja5X4CA1d6SIbLJzNqH9DTi6jU7SAoXh0/eXJyoP7eAaqd/EavfvPclkX/n
	 +IXVMUHBoGtAIGe+gMWajSgImgS9+3jlLkyZUpPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>
Subject: [PATCH 6.18 261/315] serial: altera_jtaguart: handle uart_add_one_port() failures
Date: Sun,  7 Jun 2026 12:00:48 +0200
Message-ID: <20260607095737.158799410@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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
@@ -379,6 +379,7 @@ static int altera_jtaguart_probe(struct
 	struct resource *res_mem;
 	int i = pdev->id;
 	int irq;
+	int ret;
 
 	/* -1 emphasizes that the platform must have one port, no .N suffix */
 	if (i == -1)
@@ -418,7 +419,11 @@ static int altera_jtaguart_probe(struct
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


