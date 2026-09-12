Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD10C3A9D80;
	Sat, 12 Sep 2026 08:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201442; cv=none; b=RCNiU/51cGb1tTQHDOsk2KoutDEzZRU1rkzDPwp+LTLTwuhpZJBsidpSG8XP9WJ2mNnoKIK23vKXl8Bvd+WvlyrhDpaUoWneWuA5mQkTBBaTRDm8jhVVwpY/KHroUD98zCRtjVMr0MSBUak4LbzB6JRXcDXsUqtFCQR+j0NqiZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201442; c=relaxed/simple;
	bh=09cZEcrf4lrOfchRI/ipiWB78ijAy9Iq5DYYb1500BM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RNQmAvnnpgUU8Ty5wrd4YhvBulxTQI+O18w2BUdhEzpsCYjLYW+hqLYMnup+qwl6sD74L30IG0NW5+4bUESyh3Bxqa8nU2U1URjQ1LzQp+oYRNz+ZjMgiJ6tV0y8jqj7jY2whyNLPo2m1sZkB/2rqS45RUzyh6FPFK/Z/WqmveE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ky5jGH0b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ky5jGH0b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FEE71F000FF;
	Sat, 12 Sep 2026 08:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201441;
	bh=1bVcMiiQWZyBYGUq/TYAoHfDXqFNhwlWEIJ3tkV9so0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ky5jGH0buQ8Unh5uSOHxR27xA4kJ9inkD/CFD1tl1nSgyE6828BOFZdOeR+qSSlDK
	 r+oe6gBWRRitORTI+AazPBGHJrTDUebMARIjJrOEKQEU3Syvis9U4d/LaBobpJM/wG
	 DUl3dq5l6V1l11lXHA6ktirF0CN8BDvYoih3NNI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0996/1815] serial: core: clear freed pointers on uart_register_driver() failure
Date: Sat, 12 Sep 2026 08:45:46 +0200
Message-ID: <20260912065712.380095826@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 03ee3d038f4e1..234976fb2a87f 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2777,8 +2777,10 @@ int uart_register_driver(struct uart_driver *drv)
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



