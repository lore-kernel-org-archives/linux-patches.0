Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC04186E4B;
	Tue, 10 Sep 2024 09:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961464; cv=none; b=Ik7Mn2pQ+K53Phxk40wjyKRYVXCmBx3gpWEKoesVsa0h+0zRpaQfs36qyoy9aguGyDtDP1mrr1Qrqescnf4I3RNYYDLv+IdklLjQ6NCG1Qn0blngx2jf9wLCaT0ajuPUWTi4VmN+nRw391wNL+iF8wURh6n0M+7xsvEZMUHGeBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961464; c=relaxed/simple;
	bh=t7le1L/1AqRaPDed5qhE2rD3GDcUsIIMychRbkgwa7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t/XA4N4jdfY5t/ZD3xagjaQ0Djy408z0z1ImiPYFWf4sg+fFntTFZR9GltjcUHKOPju2Vk+Jl1gO1PmejbEtNlrw9L74a2jhg3mOONFm+Svy36C4+gRFW4+rlgJL9cyX6V5ru2u2s5XCHcHedhSHgei3al/hePYLOVCyG/TdBko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hF2CFWGl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hF2CFWGl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 039CAC4CECC;
	Tue, 10 Sep 2024 09:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961464;
	bh=t7le1L/1AqRaPDed5qhE2rD3GDcUsIIMychRbkgwa7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hF2CFWGlos8Pgr5NsW20fbUaqpZc6cDueNPSX/nTel/Mrh7m7DplWBmD94m8fcSFe
	 N1nQcqS9cVpx/rUjPoZpRWBO3z9uK+ZD+3P11yyvDTnu3okHFS2ci0ONcFTaemSHAv
	 9QS1XNAvEXwvUf5VLYtXoHc5Bk9oghK83wR290b4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Arlott <simon@octiron.net>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.10 052/375] can: mcp251x: fix deadlock if an interrupt occurs during mcp251x_open
Date: Tue, 10 Sep 2024 11:27:29 +0200
Message-ID: <20240910092623.988406830@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -753,7 +753,7 @@ static int mcp251x_hw_wake(struct spi_de
 	int ret;
 
 	/* Force wakeup interrupt to wake device, but don't execute IST */
-	disable_irq(spi->irq);
+	disable_irq_nosync(spi->irq);
 	mcp251x_write_2regs(spi, CANINTE, CANINTE_WAKIE, CANINTF_WAKIF);
 
 	/* Wait for oscillator startup timer after wake up */


