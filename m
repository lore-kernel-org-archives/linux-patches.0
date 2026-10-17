Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31FF3CEB90;
	Sat, 17 Oct 2026 18:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260117; cv=none; b=NPngTpsGEtBinCioLLDMxE9KVl0rEnpE/d7Y+J4dIs+bws5bAAvLttpdi5JVub3vbVBWnysCSloL40ZFOgJsbAZa4EovpjoUlAaHwvE7BO3hmSQ7rCk4re5ZsLJ9sSi4f/oyquUYseVkop8aB1L7C7CLAT2AI3yGJ7i1dzBo0BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260117; c=relaxed/simple;
	bh=2sD+iTdhItH1OoHwxYZzpZGawjt4uQdFH/m63jIFaYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T2l0ExlP/BxgMt8+cgaUg/VVnO5ubkaddFIZW7s3h2K8DcknNubYP42zXo6oNzOgsgWTzRSdAu8HmZLs37xcWv14mCX49ezlJshjCk60I+5nRh5X8zvck5q+i7FQSZKz62jd2oWvGkT2cCDVOOTGz70dGLRYE25hoSV16REliNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e2AR3nzm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e2AR3nzm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03EA71F000C7;
	Sat, 17 Oct 2026 18:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260116;
	bh=8fWsBXMaG2yVg/XL5wJAN6YSoIsWLnUqTYy/jURscRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e2AR3nzmIbKZkQCTm+ofHlab1n5fSRob2/RcpmyvY9KXHPQ4MPk+mrln+yKeMxfv3
	 VDH5FSNlAVz24kyCsEEYQg6qwsQhbusDjT7ksbtbvcHeFAwisyL6PPQPlS+mcpLNiA
	 eE3KoySE7SjXfrQEqAX27aQyPPVqi5Bsg+UCQVzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1438/1674] serial: core: clear freed pointers on uart_register_driver() failure
Date: Sat, 17 Oct 2026 18:01:50 +0200
Message-ID: <20261017160508.091719531@linuxfoundation.org>
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
index e28f2e0c4b10f..ee5da5d2bc91d 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2877,8 +2877,10 @@ int uart_register_driver(struct uart_driver *drv)
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



