Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9EE747D931;
	Thu, 20 Aug 2026 16:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243879; cv=none; b=s/kS1wh1/D5bIda6UVssCQd3dtvtRrIAqI8dTuTYOSPLeFhh1uFS2FfOW26/PU1oLFaomTp6wJWv2fUGGj9IsP021zyhsFdcoYBqJIaTe1AVLj2spIOIgapQ2WPVNDZy8j6ARCw4ti13fvOR3de6G6KhdQweZRcG2yovNxvugIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243879; c=relaxed/simple;
	bh=969WveCgFODyzxnSQ3Ko7bHdbzKhuh1c80iouwxC6v4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l5mLf2IwDQK8hpi3WGHKT8E1I9cSNO2R6Bx6P5uxwphopcqikyBPcn/eELy4jKxSpp+gBSOUvaiZOtVD1Voyu5/i0kulhWCgLlBMBNj1DAwSDmrZSa+LnsJxMlE0TF/herXN7ym7gRqxHEnp/+xdLjG6YBolliuOhW488E/uED4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oMkiZBAd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oMkiZBAd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F34841F000E9;
	Thu, 20 Aug 2026 16:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243877;
	bh=7I60U8cgJw2hU0oXl4B2UG94geu51t/K5Y6iilQ+YeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oMkiZBAdoeQU8sE7Kao2nvCeVTXRlkztyaFBnqhq3/ACkhWF0qKnjV/bzN7Q5PsOd
	 5uprqSYJZ778JeyJmn1qoZ5+Ny6IxCdzHjgDVJif5fX595VVF07oBzk6cC0Xfpt8zh
	 w7WKx6MVL+i4NewWxBlzNdcBGMivkc/U416YWzCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liem <liem16213@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Carlos Song <carlos.song@nxp.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 240/272] i2c: imx: Fix slave registration race and error handling
Date: Thu, 20 Aug 2026 16:57:04 +0200
Message-ID: <20260820145238.819781516@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liem <liem16213@gmail.com>

[ Upstream commit d64ec362c369bbc33833f7936d5f3a706b0d5c45 ]

In i2c_imx_reg_slave(), the slave pointer was assigned before
pm_runtime_resume_and_get().  If pm_runtime_resume_and_get() failed,
the error path returned without clearing i2c_imx->slave, leaving it
non-NULL and causing all subsequent registration attempts to fail
with -EBUSY.

Additionally, because this driver uses a shared IRQ, the interrupt
handler i2c_imx_isr() can execute concurrently and, after acquiring
slave_lock, dereference i2c_imx->slave.  The previous fix attempt
added a lockless i2c_imx->slave = NULL on the error path, but that
could race with the ISR under the lock and still cause a NULL pointer
dereference.

Fix both issues by deferring the assignment of i2c_imx->slave and
i2c_imx->last_slave_event to after a successful resume, and by
performing the assignment inside the slave_lock critical section.
This guarantees that the slave pointer is never left stale on the
error path and is always valid when observed by the interrupt handler.

Fixes: f7414cd6923f ("i2c: imx: support slave mode for imx I2C driver")
Signed-off-by: Liem <liem16213@gmail.com>
Cc: <stable@vger.kernel.org> # v5.11+
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Acked-by: Carlos Song <carlos.song@nxp.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260629023829.152651-2-liem16213@gmail.com
[ open-coded scoped_guard(spinlock_irqsave) into explicit spin_lock_irqsave/spin_unlock_irqrestore since 5.15 builds with -std=gnu89 ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-imx.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -832,14 +832,12 @@ static void i2c_imx_slave_init(struct im
 static int i2c_imx_reg_slave(struct i2c_client *client)
 {
 	struct imx_i2c_struct *i2c_imx = i2c_get_adapdata(client->adapter);
+	unsigned long flags;
 	int ret;
 
 	if (i2c_imx->slave)
 		return -EBUSY;
 
-	i2c_imx->slave = client;
-	i2c_imx->last_slave_event = I2C_SLAVE_STOP;
-
 	/* Resume */
 	ret = pm_runtime_resume_and_get(i2c_imx->adapter.dev.parent);
 	if (ret < 0) {
@@ -847,6 +845,11 @@ static int i2c_imx_reg_slave(struct i2c_
 		return ret;
 	}
 
+	spin_lock_irqsave(&i2c_imx->slave_lock, flags);
+	i2c_imx->slave = client;
+	i2c_imx->last_slave_event = I2C_SLAVE_STOP;
+	spin_unlock_irqrestore(&i2c_imx->slave_lock, flags);
+
 	i2c_imx_slave_init(i2c_imx);
 
 	return 0;


