Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5323C442B32;
	Mon, 17 Aug 2026 14:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977487; cv=none; b=aaSP7nYdk8OIaLn5/nhs/0njGV8XTjFw1wm+6qnnQjTvHZJ3h1J4atPN84Kcv7wkeatOSkEL+bxs7aLA82BwUgRGg8LJwPelofjB+Z1oAxMu0yPzq7VvqXxVM1symWCjNuqWT1vkrGy/6cejD+q1KCxWLhbIDoSUAK3VFjgunwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977487; c=relaxed/simple;
	bh=1rjgbPRFxQ10RhlgfSegG0hQNSlj0MeCnrihDaKX6Q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RCBjSIp2mG/7k1okmHZiAnv/GbH9+XbxXsSm5qJa8Kxo2hGac9v7qqndgQ7BTttTTyGhir9BeT8xGPJI35HS7AGrU7XiBgl5j23cxxRL0On6KZqK5eQiFWXkFThwXhj/QJGG5mwO7U58nfZyZuPwDropteW7kfKfqOwO+FaTPFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IIqkriCG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IIqkriCG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A26E81F00A3A;
	Mon, 17 Aug 2026 14:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977486;
	bh=lmxK0o+F5Dm9Px4DWDt9TgfmBv2OLDcAMArWr74AaT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IIqkriCGLMLlI1F8VtkhsjggE42yW4I/Z4tjOYG1IVxgprWyXnO/cZqB/6se+5csA
	 BFXXo37jJDxiAoWuSzKIxxE07AFO9z9xj53RB64HqXR+tS2hdeI5vmwl6+Iw9Z+yaD
	 DyfkQpvxsSRdQ1G5r27WV+TPmJnvHmVd591IYFqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liem <liem16213@gmail.com>,
	Carlos Song <carlos.song@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 5.15 345/456] i2c: imx: Cancel hrtimer before clearing slave pointer
Date: Mon, 17 Aug 2026 15:32:15 +0200
Message-ID: <20260817132553.065094263@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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
@@ -865,6 +865,7 @@ static int i2c_imx_unreg_slave(struct i2
 
 	i2c_imx_reset_regs(i2c_imx);
 
+	hrtimer_cancel(&i2c_imx->slave_timer);
 	i2c_imx->slave = NULL;
 
 	/* Suspend */


