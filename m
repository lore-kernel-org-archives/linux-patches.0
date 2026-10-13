Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7929A3E557D;
	Tue, 13 Oct 2026 12:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894108; cv=none; b=qblx+msXTAoy8iGyM7Sobhepq5+RN2UHXp8zwUFObDqESRauLuFSwry4bytE/H+tyyAgKYPSSw61+JmyV7w9Da8fjEcfunnnV5CDJ62faZ2EzEVFFkHCTg47XhaPcGw0R3pAxZN6oHj74zbdX1W8wuzlkuM4GOYQFzJyuJTt/tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894108; c=relaxed/simple;
	bh=MJcwSufR5HaG8LS+2+0TENLE05V+6Dx23cC8bSliuFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KKwenl4jMa/qVodUqk9vJ671UgLzm6nGSDNvaKikZwQcSLZxC6HLt0FNLyMTlI0bl86PkgazpJBaDzvkF9zUb1u7DIip75KM9O2/o71wdveXep9e7zAyu5abiBa416ZO3Q0h+PX/05SuTpchK8b/RqOc3elqYtxug8Nyb0Kq1MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LOcoRQv9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LOcoRQv9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A54F1F000FF;
	Tue, 13 Oct 2026 12:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894107;
	bh=T3qy9Slj/3f27CJ/ST2jqEzLvR+5iiqeIRSW2gku27Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LOcoRQv9Kj8KrGXn3hmVBJ+nGC0v+gk44UGK/DX66tnkEqJhlfNthYik5vCSzByxP
	 W1/YkFd6jAF12PQ3aTABpDe6HMPYLmDraPyDX0YquM2YaALtUSNl5FljWcfIDVchuI
	 Kzs41u+7xBvS1cNk2fPG5jYbKL0QQoGOCC004jNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 450/621] serial: core: clear freed pointers on uart_register_driver() failure
Date: Tue, 13 Oct 2026 13:37:25 +0200
Message-ID: <20261013112931.509329185@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
index 32cdfc59a9ad9..355e7ce6212fc 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2810,8 +2810,10 @@ int uart_register_driver(struct uart_driver *drv)
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



