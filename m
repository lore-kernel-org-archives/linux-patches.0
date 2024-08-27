Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46CC01C6F5F;
	Tue, 27 Aug 2024 15:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770877; cv=none; b=T9cIRom+/H4rND1Ff3zLpNPfRYydrRwf4RCREgw1fzRRtlv7PPPtKz3x6WhbQGcDuFo/JtfVcn8Gd3T3n/D4ftv/g2amACmrAZYNjJlpmKPy+RiVO5LEH11OoUSPCBg+LRsn7q8qdIQbQj6QUDgGXs4KQK1GqM3sfpmeec7UCX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770877; c=relaxed/simple;
	bh=rbOmDiuGbPHOiKL4j72B14iher/rDzfpKyT3yqvRPYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BcOwthdV5M4gxg215FzjH3y7N0HzAHADKJ4BXJxi5gISs6m3Whv38dn0ydPmUyvTZcv8TAGwHdqIv9p2tZfAo7cgwnELG9zrqvYSWOKdv3S2uWXFlvfbj16e8ayqKe3oTA/TwdWW679dz646n9kNtUTBAUrkpR74mauE6A3HCOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KC9njsrx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KC9njsrx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82BFCC4AF1C;
	Tue, 27 Aug 2024 15:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770876;
	bh=rbOmDiuGbPHOiKL4j72B14iher/rDzfpKyT3yqvRPYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KC9njsrxrh0MjfZ6BS71BRdU1P7VYnfPUnDrMsaJ3VU+f8aNX6x5NUNE8VYIoz8vW
	 qz/SDCyUU346G4CJtkA48mOTzNTPFYGPo3ThKCoHp1lq50xx18efXozePmnS9V9OnU
	 zxRXPqRzYhO4ttOgPwmY9aAMqZsWALZrsDvNnFDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Peng Fan <peng.fan@nxp.com>
Subject: [PATCH 6.10 002/273] tty: serial: fsl_lpuart: mark last busy before uart_add_one_port
Date: Tue, 27 Aug 2024 16:35:26 +0200
Message-ID: <20240827143833.469662084@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

From: Peng Fan <peng.fan@nxp.com>

commit dc98d76a15bc29a9a4e76f2f65f39f3e590fb15c upstream.

With "earlycon initcall_debug=1 loglevel=8" in bootargs, kernel
sometimes boot hang. It is because normal console still is not ready,
but runtime suspend is called, so early console putchar will hang
in waiting TRDE set in UARTSTAT.

The lpuart driver has auto suspend delay set to 3000ms, but during
uart_add_one_port, a child device serial ctrl will added and probed with
its pm runtime enabled(see serial_ctrl.c).
The runtime suspend call path is:
device_add
     |-> bus_probe_device
           |->device_initial_probe
	           |->__device_attach
                         |-> pm_runtime_get_sync(dev->parent);
			 |-> pm_request_idle(dev);
			 |-> pm_runtime_put(dev->parent);

So in the end, before normal console ready, the lpuart get runtime
suspended. And earlycon putchar will hang.

To address the issue, mark last busy just after pm_runtime_enable,
three seconds is long enough to switch from bootconsole to normal
console.

Fixes: 43543e6f539b ("tty: serial: fsl_lpuart: Add runtime pm support")
Cc: stable <stable@kernel.org>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Link: https://lore.kernel.org/r/20240808140325.580105-1-peng.fan@oss.nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/fsl_lpuart.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -2923,6 +2923,7 @@ static int lpuart_probe(struct platform_
 	pm_runtime_set_autosuspend_delay(&pdev->dev, UART_AUTOSUSPEND_TIMEOUT);
 	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
+	pm_runtime_mark_last_busy(&pdev->dev);
 
 	ret = lpuart_global_reset(sport);
 	if (ret)


