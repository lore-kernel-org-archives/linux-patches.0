Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F023A2E25;
	Sat, 17 Oct 2026 16:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255104; cv=none; b=RQjoW2D9cLmYx0Z3mv5WMAfa9JoqnZQL7ZvZlg5uk/E9YzQ7AI/TocXP0WA1BRRV94xm64D6AcrLGnNG1T9loQnKhZ3Uhc8rwNdYEHc80pk4RTrMr2wrQfTICcJ5KfS8IbfHBorB847qDdePCwYGqiV8TNwnZ2ZZly9aIoqpEqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255104; c=relaxed/simple;
	bh=wHy1Swfkb0EVN+1DCJbBTdBChEkTLh4PsD7rik8Hdw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kxBEDk1QtuRYUamVZmU80hFh6ScnXvlZc5qlqyrZALO7kgmu2YVq7+NUOkwhvYWUmSf2VWNY4VgweQpoURnBUx5LQtn2KdAP4X+Ddv+C+TyEagHvZPibJR+/G80D9qctSpidznRXDZ+laUGNnVaE0c/9eyp4pwEvCIuD5J82yGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PCVtMmCV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PCVtMmCV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E8221F000C4;
	Sat, 17 Oct 2026 16:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255103;
	bh=aI3LoKLJreWqufn6CWV/M1mvMMjPYB7JZU119fEAvVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PCVtMmCVHY/ZO3warcvI1bzDBeLEXkCzTTZQ90c5vn+7j1Ykngt/r7zW7KrXItHgJ
	 XcUnqTTvOVI+WI5DTNzOziG+mtcRB7DruLVIMn6HxQl4uO2s1SnIzwOBLb5C3RCg0S
	 0Xqr8YkqQyOsgYvjTZlSjmqIJmhC1l9jkSAWyU0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 667/869] serial: core: clear freed pointers on uart_register_driver() failure
Date: Sat, 17 Oct 2026 17:58:28 +0200
Message-ID: <20261017160054.092547099@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
index 816f83141afd3..2da161227200a 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2861,8 +2861,10 @@ int uart_register_driver(struct uart_driver *drv)
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



