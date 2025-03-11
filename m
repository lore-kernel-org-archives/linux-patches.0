Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA9525EFB8;
	Tue, 11 Mar 2025 15:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707070; cv=none; b=o3FU+YEBqx9eB7cG6BBfhApU/G6JhYVc02lwrm3PBFYWHaMD7lNRdkUPZiU5Qz2f+IQpBAVgcgTKTMyfiY0bVnMbzSxt6hfbUhYUeNqQyHrOTKKzql/YqLDIBO5WOAzqA/e0qvAznKnRNyck0tMR5JuRqZSICABmktewPkj1nl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707070; c=relaxed/simple;
	bh=4EkXgRL6l4sRBmwvaSS+pUqmcxoNXT6wv6cQYMsqe2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a72Jp560lRXzEjJPGU56EmuKaZ2fgESZHYpt7akXdxKPgnCSa9Ar/3zA0IOleuZ4vB6wBXG5EOZd5gEQTP39sWfyExKQ45KQzfchszJ+FI0HrGqOyU6gH/3+zZH24CsfEyFuhd0ElEwsR6zA4QBe3SptFrpWgj4UsjsXbizq74o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UYJOW30B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UYJOW30B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D4EC4CEEA;
	Tue, 11 Mar 2025 15:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707069;
	bh=4EkXgRL6l4sRBmwvaSS+pUqmcxoNXT6wv6cQYMsqe2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UYJOW30B8S9G2MpnOBHb4m7bD8Z2MY+KjdB0rP17mXfbxt0xmhKlBUzsgSCz8HLX4
	 zBjaDlToEV0cLNoeDPIkmQ4TiayRmAoKUTbZ6Aa/W4EBE3p8ojVxb2xQTRw/vdBqMr
	 xi9IzUXOtSgqiaAAALv8EbIvy29/y6dpUV3mk6z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.10 263/462] can: c_can: fix unbalanced runtime PM disable in error path
Date: Tue, 11 Mar 2025 15:58:49 +0100
Message-ID: <20250311145808.750250621@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 257a2cd3eb578ee63d6bf90475dc4f4b16984139 upstream.

Runtime PM is enabled as one of the last steps of probe(), so all
earlier gotos to "exit_free_device" label were not correct and were
leading to unbalanced runtime PM disable depth.

Fixes: 6e2fe01dd6f9 ("can: c_can: move runtime PM enable/disable to c_can_platform")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://patch.msgid.link/20250112-syscon-phandle-args-can-v1-1-314d9549906f@linaro.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/c_can/c_can_platform.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/can/c_can/c_can_platform.c
+++ b/drivers/net/can/c_can/c_can_platform.c
@@ -392,15 +392,16 @@ static int c_can_plat_probe(struct platf
 	if (ret) {
 		dev_err(&pdev->dev, "registering %s failed (err=%d)\n",
 			KBUILD_MODNAME, ret);
-		goto exit_free_device;
+		goto exit_pm_runtime;
 	}
 
 	dev_info(&pdev->dev, "%s device registered (regs=%p, irq=%d)\n",
 		 KBUILD_MODNAME, priv->base, dev->irq);
 	return 0;
 
-exit_free_device:
+exit_pm_runtime:
 	pm_runtime_disable(priv->device);
+exit_free_device:
 	free_c_can_dev(dev);
 exit:
 	dev_err(&pdev->dev, "probe failed\n");


