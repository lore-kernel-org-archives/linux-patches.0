Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F3B4195BE;
	Fri,  7 Aug 2026 15:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115490; cv=none; b=tNURzyFlqpMtNDrMkFtCDmPczNGfnzhRNT6F54DYdof0f/eCD34F7HnJE2EHbzI8mQA8bXb7A7Ddy6dXBfHZe6cgTupeSt0KuGQUhT3cNwxUcopDjPMhvKM53n2urelgrlG1IX+MgA0NYhuPVXHUafvk3jasP9hnIfM08hoefcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115490; c=relaxed/simple;
	bh=svTWWyID+5qeXZyPpgBsi0q5JTRnULwhw7N68bNMh00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PgBubfsWMWv+2FTGOdGwYm+JQwVlxjhGpEpRbnr1lPN21J97itLuNOQpXVov6sE/2YVWUWhvewqbDcipEohh8AY2XwShMLBG5U+PGYysHiO26u0loUOC8YmDTZtWmCBvdcW/h2O0FDtPWofbTOP//o7c0hvVladX9GHRtjbk8ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nODCPQOh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nODCPQOh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE6671F000E9;
	Fri,  7 Aug 2026 15:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115485;
	bh=FZqaJUAfx2A8mo5DO0YF7hyVi1v6T0qD1pgJrnCOLuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nODCPQOhd07fpRmoYI8/m1Himtln42/++u0bYRI1BXgOnd9DWUNp6d5QehGxiYECG
	 vJZJIFNPohJJRQyelJEzOAQ/FnB2IaDm3MduiU1+Pk6ZKkYdM4+BallGpfsmVCy/X3
	 jhO9ShxsYjoD+L5gNT6Jys6Oo7tnHXGLedYggTMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liem <liem16213@gmail.com>,
	Carlos Song <carlos.song@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.18 294/396] i2c: imx: Cancel hrtimer before clearing slave pointer
Date: Fri,  7 Aug 2026 16:37:34 +0200
Message-ID: <20260807143430.613134919@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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
@@ -960,6 +960,7 @@ static int i2c_imx_unreg_slave(struct i2
 
 	i2c_imx_reset_regs(i2c_imx);
 
+	hrtimer_cancel(&i2c_imx->slave_timer);
 	i2c_imx->slave = NULL;
 
 	/* Suspend */


