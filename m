Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D442E1EFC;
	Sun,  7 Jun 2026 10:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780826870; cv=none; b=dkRXYxJVhoEPFVL2t9vycCWM9c4jBN2GmL91oCJ5oXpytmQPh1P0v+s6EjqkjCdGyp+Xr+Cuo5F/rSwM8f2EYHXKZVoxC59vIzwkQJKhIN2Gw6V7hdTih8YpSlu+KET2VVdZqfoBJE+yggFJsWW7MHVbQUYWzkINc3/rz6iW3KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780826870; c=relaxed/simple;
	bh=HcbJxzN9AO0I0d6/5gEajzYt5LTJYgtzZ6YZzyufbyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BlYGd9+VfhZAnlo9N4P4aOb5ljKvivsKbJzwnfgRlArm32nl4bBcQwGSns8lkU+dogm98+aEDBF2Uzq+4fyYnrwxhvjdujxJiexkJXM7d7Dc/hxSMEmCBSP/93hJD3Py2WR+4Rqia2YWkgS6HnT7wKqW6HDRxYe5V6y7YVG64/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gov0z2//; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gov0z2//"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA6771F00893;
	Sun,  7 Jun 2026 10:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780826869;
	bh=y8f201vZL0aefN4G0AOVcRfLwC8D7vsQPvVA5G+9VJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gov0z2//ts6UNwFCyNszDAzChmgX1PHZeJRyQVVh3mWqekyzNcbOrnS78Yo0UlCIX
	 xinf+xpqkTfgzw3607y18Chpyfh7GhBvPLUy7WKvO3fCmYuqX9DC9cGuaeUtTHEAe+
	 tvqoTzzSbrsmJmcQprcU2g6sYps1IVn7KtDHXr4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Frank Li <Frank.Li@nxp.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 038/332] gpio: mxc: fix irq_high handling
Date: Sun,  7 Jun 2026 11:56:47 +0200
Message-ID: <20260607095729.510984047@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit dac917ed5aead741004db8d0d5151dd577802df8 ]

If port->irq_high is -1 (fsl,imx21-gpio compatible) and gpio_idx is >= 16
enable_irq_wake() is called with -1 which is wrong.

Fixes: 5f6d1998adeb ("gpio: mxc: release the parent IRQ in runtime suspend")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260526063504.25916-1-alexander.stein@ew.tq-group.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mxc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-mxc.c b/drivers/gpio/gpio-mxc.c
index 647b6f4861b744..12f11a6c96653c 100644
--- a/drivers/gpio/gpio-mxc.c
+++ b/drivers/gpio/gpio-mxc.c
@@ -469,7 +469,7 @@ static int mxc_gpio_probe(struct platform_device *pdev)
 		 * the handler is needed only once, but doing it for every port
 		 * is more robust and easier.
 		 */
-		port->irq_high = -1;
+		port->irq_high = 0;
 		port->mx_irq_handler = mx2_gpio_irq_handler;
 	} else
 		port->mx_irq_handler = mx3_gpio_irq_handler;
-- 
2.53.0



