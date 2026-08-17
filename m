Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99AD839A807;
	Mon, 17 Aug 2026 15:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980192; cv=none; b=b9A/q2fpOo3V98i8MGpDUADWMJaD+5a1tl+2garjgV/QRK3fkuPANDiqbhk3/C0jwvZHdTEy/NSxIIZU61RAbwTN/KhIPS2QzCOFuJbVU2dmV48Xm3s+IxUi+dVc8KE3JwwQ5j1aCCnNdthvRLBaOfvTN2hyLs77PHxPjKJj1vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980192; c=relaxed/simple;
	bh=OLaLZyOCO26nJPCx+ZfcXXbx3ROT4+K84tLwNwaZhXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C2tljIyzSl5S9yhJ5fvz1PRzwhpGKaL5hJFVKB1+2O0I2cMojo1mdO4wcT3xdilTyhYhEbCbHS9FzgztCTmEo0SkYFnZmahGXMM/WW3EnSDYF6BRJuMa/3CP348dVvHybg8/aPeQh5fblvHzRUT2vcDaXNdzmid2/q7RM333fos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WwccefwJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WwccefwJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C33B01F000E9;
	Mon, 17 Aug 2026 15:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980191;
	bh=iPhjBpsbl8mEfvxU3JjtY08mYUXr74UUBaT25QIIJPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WwccefwJqveBLIeNZpMEFi0DVa4nZAjEektBAkB/cDbh7nvilKuMxzJzB/Uk7vewt
	 NAKeIabwi7sXDVlJ3jSQV2yK7pml0IKhaYLqJhE2o8K+2p2susm5qwPIe+XmyeGFyc
	 pEwE6Z/eTFbCu3Zn8e/VGyDoDixE8VeDzEwj728E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liem <liem16213@gmail.com>,
	Carlos Song <carlos.song@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.1 448/609] i2c: imx: Cancel hrtimer before clearing slave pointer
Date: Mon, 17 Aug 2026 15:32:24 +0200
Message-ID: <20260817132559.055705872@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liem <liem16213@gmail.com>

commit 6ac7702b6cc2b94aaed9ef2d95bfbefcdc90061f upstream.

In i2c_imx_unreg_slave(), the slave pointer is set to NULL after
disabling interrupts.  However, a pending interrupt might already
have started the hrtimer (i2c_imx_slave_timeout) before the pointer
was cleared.  If the hrtimer fires after i2c_imx->slave is set to
NULL, the timer callback i2c_imx_slave_finish_op() will call
i2c_imx_slave_event() with a NULL slave pointer, which results in a
use-after-free / NULL pointer dereference.

Fix by canceling the hrtimer and waiting for it to complete after
disabling interrupts, before clearing the slave pointer.

Fixes: f7414cd6923f ("i2c: imx: support slave mode for imx I2C driver")
Signed-off-by: Liem <liem16213@gmail.com>
Cc: <stable@vger.kernel.org> # v5.11+
Acked-by: Carlos Song <carlos.song@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260629023829.152651-3-liem16213@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-imx.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -901,6 +901,7 @@ static int i2c_imx_unreg_slave(struct i2
 
 	i2c_imx_reset_regs(i2c_imx);
 
+	hrtimer_cancel(&i2c_imx->slave_timer);
 	i2c_imx->slave = NULL;
 
 	/* Suspend */


