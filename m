Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0FA1C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:14:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B44FC433C1;
	Wed, 23 Nov 2022 09:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669194882;
	bh=ACFH985g1QAhEuT0ILlWYOKR/NvWkRGb7N/OMB6mBk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aCpDxg9tGfZg3onVzxF8eRKyykBYxQLQwVd+R1rqY7oUwADmy+0xE14W9bhpFHn0w
	 jYX+FtUR5vILSE3AppVAb5zCwJ+A2OisGy/sZrjmLBeDc/Thc6pEBsjcwEBQSag+za
	 MMRpxR503GdQULnc+hMCBivFU4UKhryG2RBgrveo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Lindgren <tony@atomide.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 086/156] serial: 8250: omap: Flush PM QOS work on remove
Date: Wed, 23 Nov 2022 09:50:43 +0100
Message-Id: <20221123084601.110561478@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit d0b68629bd2fb61e0171a62f2e8da3db322f5cf6 ]

Rebinding 8250_omap in a loop will at some point produce a warning for
kernel/power/qos.c:296 cpu_latency_qos_update_request() with error
"cpu_latency_qos_update_request called for unknown object". Let's flush
the possibly pending PM QOS work scheduled from omap8250_runtime_suspend()
before we disable runtime PM.

Fixes: 61929cf0169d ("tty: serial: Add 8250-core based omap driver")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/r/20221028110044.54719-1-tony@atomide.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_omap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index 6e46524e0e73..3d6a159c87f4 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -1281,6 +1281,7 @@ static int omap8250_remove(struct platform_device *pdev)
 
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_put_sync(&pdev->dev);
+	flush_work(&priv->qos_work);
 	pm_runtime_disable(&pdev->dev);
 	serial8250_unregister_port(priv->line);
 	pm_qos_remove_request(&priv->pm_qos_request);
-- 
2.35.1



