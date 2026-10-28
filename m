Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216523;
	b=Du4rgy8cNbvd+lRiLzb9fGRVGCVuRgtGUIuuS2nOZ7Wcw+wVZdpDPRgQhtnUWMG9ZOhU
	 JO7n2BGpP3NQJPKDLOAH991kJEDgYmpejfKL0oHnvXjUXabUROFHbCXgvZBKXUdmEkqw0
	 eSkoojro2Nh05QkVEFYVoa22UBLQDHrrK3+CRPkWjYToLM+jYU/VRUuRGN035+CgnPpft
	 5hrzNluBHtMToaAKN+Ppa7P4MUbV9XdbCmEGU/Y+n+xh3PGxTaE4X5FsRtWrNqlcNvnKf
	 hURr/Ae7wOpeufZ1Xq03zjQ9U7rBiIXXXv+IuLCi+h2deKixELMmS9QjQQVcbJBTiug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216523;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sv3DIDWIQpCdIn5GC55dXSttXuPDbUHlkh1ISWd5Jzs=;
	b=Opx4qnbG5OcJ2SYF5Q+KbOwVB4ND0Y56CiSysChMkdwdePZbRlhG4eK8FLJZo4rWTuDB
	 iexI97IZADVrIrioJsIeAyK3pL1YQ9NCuxcE5kAHskVriNMbk9V8A/9X3rR+tLdPmxchV
	 EdFg5I+eE6RthpNAnZkJNoy7ErlgaAAzlhGuZTc7Tojeny5aZ6NmG7SO4pqRyHfFGPYwG
	 nyDHMAvbu05F7x2zU9mntksBhPf8qs8Mu8K+J/16/eAHQJ3vA4XAnmi4N/dFOXlYxTgZD
	 /9tFp7SP9mMVQP1AavldPR5ayjRBmU9USh2BKfEqXJeodCl3k06pLhUv/8hanmiIBsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I8XHKip7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33031606A31C;
	Wed, 28 Oct 2026 19:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I8XHKip7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD7481F01825;
	Wed, 28 Oct 2026 19:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216523;
	bh=sv3DIDWIQpCdIn5GC55dXSttXuPDbUHlkh1ISWd5Jzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I8XHKip742Lna+lGdgUHKV30WyLZeldklS2fmR4PPW5dlezaQQnqvh/n94A6sxd6H
	 ZfHNWwERbPmZDzPPT5mO9DPeKtCJm/r/W3HHaOTm4KPZvDOce7iRrqC5f38T2iU1mj
	 XpJj6lAYtGleCjzousxyzz3Yrc365dcEOzhjU46s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1585/1887] serial: core: clear freed pointers on uart_register_driver() failure
Date: Wed, 28 Oct 2026 18:01:21 +0100
Message-ID: <20261028170535.537332179@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 61a2fb25551be0375bc16ef2a70c987dfca26183 ]

uart_register_driver() leaves drv->state pointing to freed memory when
tty_alloc_driver() fails. If tty_register_driver() fails, drv->tty_driver
also retains a pointer after its reference is dropped.

Drivers that use drv->state as an "already registered" flag can then skip
registration on the next probe and pass the freed state to
uart_add_one_port().

This issue was found with failslab on QEMU's raspi1ap board by
failing registration and binding the PL011 port again.

Clear both pointers on their failure paths, as uart_unregister_driver()
already does.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Fixes: 9e845abfc8a8 ("serial: fix NULL pointer dereference")
Assisted-by: Claude:claude-fable-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260731181844.11330-3-kmehltretter@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/serial_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 4b035292a3840..3e2ecbf5dd91d 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2812,8 +2812,10 @@ int uart_register_driver(struct uart_driver *drv)
 	for (i = 0; i < drv->nr; i++)
 		tty_port_destroy(&drv->state[i].port);
 	tty_driver_kref_put(normal);
+	drv->tty_driver = NULL;
 out_kfree:
 	kfree(drv->state);
+	drv->state = NULL;
 out:
 	return retval;
 }
-- 
2.53.0



