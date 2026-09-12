Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A650B23BD03;
	Sat, 12 Sep 2026 12:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215192; cv=none; b=hSt/7CzW10NuWMJilR7BSVBDuMbr3Y1uoQiFHtUtKbnir0KKG4Y7iXFNWU1TSK+jjWrOkYzOwXAdYVpOubpQmPfecXsxZ/op8skXRuCgXax00TyBkynDB+yVkwAuZbDVJF1tkfN0fPhvv/gnZly53VSC0SlBU4za1V0v/7kCrNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215192; c=relaxed/simple;
	bh=1rg1Z38SyEZCvOxOdFxveRkvHeYx6ThWhuHJzMxkggg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZYo7R88UbG5j3ccmD3LvrRiIk9g1ZwE7XrhSgIGGpveUAJyankVUspsCq882RqoEqQDyqXf3D2rT3PXXr+Nk0TP2hxIQwAxJ5WBjxNDSp2hfTQC/80pxPj4+YRhzI0Zm69SvvtZS4XKbOgj2F9ftbZofNiUjs+dZP9PymgeBiW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CuHbfVET; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CuHbfVET"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E431F000FF;
	Sat, 12 Sep 2026 12:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215191;
	bh=iMKtOmKjTfx3wPzGFJAXhaFQgPReXaZp6s8SbG7zhxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CuHbfVETOuNukvIPFwbWoaQMXvFH3xL6Wzjw7GsqOXgbjk1irKkxxBcPhzz7YBb+N
	 SBSejcq1cd/x9nZMxptGVwkfSwGtijQ321oO2/QdBFOUzS1EZhgIIDEzdnyyLupTmq
	 0pbPhHEciGa8AJCaWnIAQIIKOaSqbtZJylD8Dt9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0482/1376] serial: ma35d1: Fix OF node reference leaks in console init
Date: Sat, 12 Sep 2026 08:48:28 +0200
Message-ID: <20260912065618.278496934@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 8dfea56f350b3dc826f35711802ad6ae8fae0748 ]

ma35d1serial_console_init_port() stores matching UART device nodes in
ma35d1serial_uart_nodes[] with an extra of_node_get() so that console
setup can later read the "reg" property.  However, the stored references
are never released after console setup has finished using them.

Drop the stored node reference after ma35d1serial_console_setup() reads
the "reg" property, and clear the array slot to avoid leaving a stale
pointer behind.  Also release the iterator reference before breaking out
of for_each_matching_node(), since the normal iterator advance will not
run in that path.

Fixes: 930cbf92db01 ("tty: serial: Add Nuvoton ma35d1 serial driver support")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Link: https://patch.msgid.link/20260630214043.1887351-1-dbgh9129@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/ma35d1_serial.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/ma35d1_serial.c b/drivers/tty/serial/ma35d1_serial.c
index 3b4206e815fe9..2c1c8d7480230 100644
--- a/drivers/tty/serial/ma35d1_serial.c
+++ b/drivers/tty/serial/ma35d1_serial.c
@@ -608,8 +608,14 @@ static int __init ma35d1serial_console_setup(struct console *co, char *options)
 	if (!np || !p)
 		return -ENODEV;
 
-	if (of_property_read_u32_array(np, "reg", val32, ARRAY_SIZE(val32)) != 0)
+	if (of_property_read_u32_array(np, "reg", val32, ARRAY_SIZE(val32)) != 0) {
+		of_node_put(np);
+		ma35d1serial_uart_nodes[co->index] = NULL;
 		return -EINVAL;
+	}
+
+	of_node_put(np);
+	ma35d1serial_uart_nodes[co->index] = NULL;
 
 	p->port.iobase = val32[1];
 	p->port.membase = ioremap(p->port.iobase, MA35_UART_REG_SIZE);
@@ -648,8 +654,10 @@ static void ma35d1serial_console_init_port(void)
 			of_node_get(np);
 			ma35d1serial_uart_nodes[i] = np;
 			i++;
-			if (i == MA35_UART_NR)
+			if (i == MA35_UART_NR) {
+				of_node_put(np);
 				break;
+			}
 		}
 	}
 }
-- 
2.53.0



