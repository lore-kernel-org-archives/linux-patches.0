Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32EE4204E;
	Sun,  7 Jun 2026 10:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827023; cv=none; b=HFy33SyWtf8s1aaNlMd4Fch5++vwcYST1XXYvxJ3QWEv+nt8if/n1ZmKotB3Wa5UuDxO5Sa0iFuMtZkCOV6TMIA3GWbiiquIUIpOn+GWvVmpgAtiXHprRBW7+5vSbSyFDrCQdy3IUy9eyKRAwYBqTNTARyLR3NVnp+qUg118mW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827023; c=relaxed/simple;
	bh=KJ7IpcAoj2C+UChnS+csKMN4+tHRCZ2Jp/YpwFz1YK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VGnuOm9pXcwfnf0JE8wTdYULlpOsJgfyNUXbQ21VGE+JJzVFnUG5llEJ0psvYXH4N2y0qHjWWFK6A0x2SkCrqevTZYbvaUwQagPzT3wtxA66ZibUqoFTJpKM21/TGOpcqmQb97u84QLfShH+FkFxbRIoPCXSx4TVyQR2KSn9gdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pl48kf3V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pl48kf3V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F311F00893;
	Sun,  7 Jun 2026 10:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827022;
	bh=rqDf5cIM2uBE982oIZb5Qeu+eUSLtY3c6BBH/dhLJQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pl48kf3V37YVAeHAmBhpzsLLkYNSu8OW3BqpKQejb54teRkKJHCI13eYV44fK3/RB
	 06k2vxc8J+YV3SdRuvMmPz4n4WC/JMu893SMJ2v9zfED7aFn5UAVd+EJrd6sfho6Bx
	 EGLXg0wgVKjEw2HsX9CZ9E0cnOu/CSdQhtwgqPTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Frank Li <Frank.Li@nxp.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 033/315] gpio: mxc: fix irq_high handling
Date: Sun,  7 Jun 2026 11:57:00 +0200
Message-ID: <20260607095728.739380393@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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
index 441ba95b38cf9b..dbdf0f41b6bb91 100644
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



