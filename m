Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7EA51C58;
	Mon, 11 Dec 2023 18:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SrpQ6+AH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE21C433C8;
	Mon, 11 Dec 2023 18:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319728;
	bh=WGhIkioPyCtlSOEjBJgo7MMI35yqjcf5IAc74XB/FcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SrpQ6+AHUTyTGvZ9XECXHYEPcQxsQEcBl31LqLbPbEIzqfgVH4OrXgGoIfImG99i9
	 9PE9Ib81w2ufc5+Gg9+UT+MdYMs50eAzCgFy4v5QfOSXq+VhbBDQP2OpzDmVLe8a4K
	 y8NATuqKSNqfwwgrawQsAyNGeZx+t7nbPaPyNCZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andi Shyti <andi.shyti@kernel.org>,
	Jacky Huang <ychuang3@nuvoton.com>
Subject: [PATCH 6.6 213/244] serial: ma35d1: Validate console index before assignment
Date: Mon, 11 Dec 2023 19:21:46 +0100
Message-ID: <20231211182055.519492788@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andi Shyti <andi.shyti@kernel.org>

commit f0b9d97a77fa8f18400450713358303a435ab688 upstream.

The console is immediately assigned to the ma35d1 port without
checking its index. This oversight can lead to out-of-bounds
errors when the index falls outside the valid '0' to
MA35_UART_NR range. Such scenario trigges ran error like the
following:

 UBSAN: array-index-out-of-bounds in drivers/tty/serial/ma35d1_serial.c:555:51
 index -1 is out of range for type 'uart_ma35d1_port [17]

Check the index before using it and bail out with a warning.

Fixes: 930cbf92db01 ("tty: serial: Add Nuvoton ma35d1 serial driver support")
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Cc: Jacky Huang <ychuang3@nuvoton.com>
Cc: <stable@vger.kernel.org> # v6.5+
Link: https://lore.kernel.org/r/20231204163804.1331415-2-andi.shyti@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/ma35d1_serial.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/ma35d1_serial.c
+++ b/drivers/tty/serial/ma35d1_serial.c
@@ -552,11 +552,19 @@ static void ma35d1serial_console_putchar
  */
 static void ma35d1serial_console_write(struct console *co, const char *s, u32 count)
 {
-	struct uart_ma35d1_port *up = &ma35d1serial_ports[co->index];
+	struct uart_ma35d1_port *up;
 	unsigned long flags;
 	int locked = 1;
 	u32 ier;
 
+	if ((co->index < 0) || (co->index >= MA35_UART_NR)) {
+		pr_warn("Failed to write on ononsole port %x, out of range\n",
+			co->index);
+		return;
+	}
+
+	up = &ma35d1serial_ports[co->index];
+
 	if (up->port.sysrq)
 		locked = 0;
 	else if (oops_in_progress)


