Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D1F1A01CE;
	Tue, 10 Sep 2024 10:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963538; cv=none; b=b38OBgC4ja1E5936auECDIhxQQk9OT7Ok/q3kk0dwKj0p8llVin14hsKBv0IrNK0V6lPwoe9on5N9rfsgtq5ybFiAgrz5aU9ooPujACMMCoSBRbv4oh73AL2aTUril7ndZ9qWA+znlHnn3HH+rLn2s7PmlkjUbTFlCNC33cDyPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963538; c=relaxed/simple;
	bh=J5v/VQ54xBopp7jDS6jLPukv6Z5vpNb8Q5CzF901ZpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=huyuTWvnejWCT9Kv+oQeiiOdZ519zzLUz/NYjROSU9WrTBtLzgg44WEzgkM4a779vBdilTQdb5lkJlT1+gQxexnqWEDOS+DHzrUCdP+ImbQZ4NbGVQsjbeYnVhpsVbcvrrN2QaQCPaHw90MhYLulnE2kSjHLqHvkxvshRTsKZ+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s/Q+yCtf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s/Q+yCtf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0AF7C4CEC3;
	Tue, 10 Sep 2024 10:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963538;
	bh=J5v/VQ54xBopp7jDS6jLPukv6Z5vpNb8Q5CzF901ZpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s/Q+yCtf/45oq9iwzYqTAR8UNFw0JYvfAQ6KXgieVdGrSfp/M4wV0/4BQefndH75N
	 BOHyQcKb+YuXH2KWClZHXMTX9gLJfLNKo0mDf2Bc3AnAh9dLBj7R8Asm0Zec2YIrdF
	 gAQ+hRXoBa7U/vkdYVF2r94n9QgYh7dUSrCghCrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Arlott <simon@octiron.net>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.15 084/214] can: mcp251x: fix deadlock if an interrupt occurs during mcp251x_open
Date: Tue, 10 Sep 2024 11:31:46 +0200
Message-ID: <20240910092602.177579894@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Arlott <simon@octiron.net>

commit 7dd9c26bd6cf679bcfdef01a8659791aa6487a29 upstream.

The mcp251x_hw_wake() function is called with the mpc_lock mutex held and
disables the interrupt handler so that no interrupts can be processed while
waking the device. If an interrupt has already occurred then waiting for
the interrupt handler to complete will deadlock because it will be trying
to acquire the same mutex.

CPU0                           CPU1
----                           ----
mcp251x_open()
 mutex_lock(&priv->mcp_lock)
  request_threaded_irq()
                               <interrupt>
                               mcp251x_can_ist()
                                mutex_lock(&priv->mcp_lock)
  mcp251x_hw_wake()
   disable_irq() <-- deadlock

Use disable_irq_nosync() instead because the interrupt handler does
everything while holding the mutex so it doesn't matter if it's still
running.

Fixes: 8ce8c0abcba3 ("can: mcp251x: only reset hardware as required")
Signed-off-by: Simon Arlott <simon@octiron.net>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/4fc08687-1d80-43fe-9f0d-8ef8475e75f6@0882a8b5-c6c3-11e9-b005-00805fc181fe.uuid.home.arpa
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/spi/mcp251x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -755,7 +755,7 @@ static int mcp251x_hw_wake(struct spi_de
 	int ret;
 
 	/* Force wakeup interrupt to wake device, but don't execute IST */
-	disable_irq(spi->irq);
+	disable_irq_nosync(spi->irq);
 	mcp251x_write_2regs(spi, CANINTE, CANINTE_WAKIE, CANINTF_WAKIF);
 
 	/* Wait for oscillator startup timer after wake up */


