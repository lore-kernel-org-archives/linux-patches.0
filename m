Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4FB7B
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 08:54:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C41BC433D6;
	Wed, 23 Nov 2022 08:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669193694;
	bh=WuOatFaHEEJKoHnJOXukaUL+csS/5Tspcj27u+vlgog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sqTMEub3P9THKW0yMS6YakAPK7UJ9HRBGeqCpKPeew9jV5B52iuIoNLbsakc+ity1
	 WObwWflVKnvSDvvw4i4twX0+iLa/sRf0uVeC3B8bponKMkRww9/jGTHHjHn9V8/kaW
	 dEzNkllZrVsmEMOEwgbUtghkp+uJFtbuCJ2wd9i4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Lindgren <tony@atomide.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 35/76] serial: 8250: omap: Flush PM QOS work on remove
Date: Wed, 23 Nov 2022 09:50:34 +0100
Message-Id: <20221123084547.882089295@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084546.742331901@linuxfoundation.org>
References: <20221123084546.742331901@linuxfoundation.org>
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
index cecc266b3640..d5962162c590 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -1234,6 +1234,7 @@ static int omap8250_remove(struct platform_device *pdev)
 
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_put_sync(&pdev->dev);
+	flush_work(&priv->qos_work);
 	pm_runtime_disable(&pdev->dev);
 	serial8250_unregister_port(priv->line);
 	pm_qos_remove_request(&priv->pm_qos_request);
-- 
2.35.1



