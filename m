Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D7D200A6
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:03:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CEF4C433C9;
	Fri, 21 Jul 2023 19:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966224;
	bh=aGWAJdA4UGhYuvO+CutXyqZZMSESuj3kgaCsoS2Yjuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zgOUCewpM9uC1fk8Sb8txhy6C3o2OFsKHW1c/DOdg/xmmFgIUIdTELelsgq94SUF5
	 QhBIHAkcNQkm5xdVr2CnfEnDpIXZAlCPsBM0StpTzpRhI5nDOuOTryOnj8NFzHGSUb
	 KZHjMN3zLJ+z7ntFsdxmR5AFiBNYg4fy49czCWak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Lindgren <tony@atomide.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 269/532] serial: 8250: omap: Fix freeing of resources on failed register
Date: Fri, 21 Jul 2023 18:02:53 +0200
Message-ID: <20230721160628.933847940@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
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

[ Upstream commit b9ab22c2bc8652324a803b3e2be69838920b4025 ]

If serial8250_register_8250_port() fails, the SoC can hang as the
deferred PMQoS work will still run as is not flushed and removed.

Fixes: 61929cf0169d ("tty: serial: Add 8250-core based omap driver")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20230508082014.23083-2-tony@atomide.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_omap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index 078a7028ee5a2..6fa0e3ca469a0 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -1469,7 +1469,9 @@ static int omap8250_probe(struct platform_device *pdev)
 err:
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_put_sync(&pdev->dev);
+	flush_work(&priv->qos_work);
 	pm_runtime_disable(&pdev->dev);
+	cpu_latency_qos_remove_request(&priv->pm_qos_request);
 	return ret;
 }
 
-- 
2.39.2



