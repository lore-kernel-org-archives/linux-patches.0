Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9E0347515;
	Wed, 20 May 2026 18:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300990; cv=none; b=WXo3l+nLPm/bsbRDKN//KsBm3TWme5LNDWBzuokwbBxSyDmN/q6bDwXpWnAZl4IwfukmCfMYEg5AOwWZZ6v5w/AopbJIWx8toun9v6/L3Z0Za9McsokPtd7kRsD+WWRxkfOdcO6g/R8FdB7gU0jMcWUuMvmh0rhL1DKw+BoF63U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300990; c=relaxed/simple;
	bh=dvV5beroYmAAan+vHyJp2OxGZ4RL7svroNwiW72K4vE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GCYlThEomhGkJjhLpey1Q8OFT7VtYKiuVEBO3gtS9ZudfPq2pK88X6egusYye7AkCMjx3TwJly82Jn42CUJ4gmKIhuSdMuCsd1zCml4cai/V4goODPXCrmFJN/Nj4lGYZ6L50Pc0fLdDN1zeFPYv6kR8gbtE66EkOz1dLFLHCAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GumUzPjC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GumUzPjC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A03C1F000E9;
	Wed, 20 May 2026 18:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300988;
	bh=Xrrfru7IZu+s35mgoofRI8Sn9nA35DZ+gUK95zWvAyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GumUzPjC4F/7X7haryGGPOen29lqNjeqmf/VbACtq69BlIKOsUFNBFEfKPZXNxegP
	 p/DCIyu3+3sbQVAt+oNk+IHUL33IKRx0TQYMXIJdYl6DHbKcThsikz0IBOvanaCztw
	 /AcQ9DI2oxhXFJ+OGA+w/WlZXPoR3+158xiqwQx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Felix Gu <ustc.gu@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 382/666] i3c: master: dw-i3c: Fix missing reset assertion in remove() callback
Date: Wed, 20 May 2026 18:19:53 +0200
Message-ID: <20260520162119.532657944@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit bef1eef667186cedb0bc6d152464acb3c97d5f72 ]

The reset line acquired during probe is currently left deasserted when
the driver is unbound.

Switch to devm_reset_control_get_optional_exclusive_deasserted() to
ensure the reset is automatically re-asserted by the devres core when
the driver is removed.

Fixes: 62fe9d06f570 ("i3c: dw: Add power management support")
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260320-dw-i3c-v3-1-477040c2e3f5@gmail.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/dw-i3c-master.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/i3c/master/dw-i3c-master.c b/drivers/i3c/master/dw-i3c-master.c
index 3453431e49a24..6c56e0b89b02d 100644
--- a/drivers/i3c/master/dw-i3c-master.c
+++ b/drivers/i3c/master/dw-i3c-master.c
@@ -1566,13 +1566,11 @@ int dw_i3c_common_probe(struct dw_i3c_master *master,
 	if (IS_ERR(master->pclk))
 		return PTR_ERR(master->pclk);
 
-	master->core_rst = devm_reset_control_get_optional_exclusive(&pdev->dev,
-								    "core_rst");
+	master->core_rst = devm_reset_control_get_optional_exclusive_deasserted(&pdev->dev,
+										"core_rst");
 	if (IS_ERR(master->core_rst))
 		return PTR_ERR(master->core_rst);
 
-	reset_control_deassert(master->core_rst);
-
 	spin_lock_init(&master->xferqueue.lock);
 	INIT_LIST_HEAD(&master->xferqueue.list);
 
@@ -1584,7 +1582,7 @@ int dw_i3c_common_probe(struct dw_i3c_master *master,
 			       dw_i3c_master_irq_handler, 0,
 			       dev_name(&pdev->dev), master);
 	if (ret)
-		goto err_assert_rst;
+		return ret;
 
 	platform_set_drvdata(pdev, master);
 
@@ -1620,9 +1618,6 @@ int dw_i3c_common_probe(struct dw_i3c_master *master,
 	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
 
-err_assert_rst:
-	reset_control_assert(master->core_rst);
-
 	return ret;
 }
 EXPORT_SYMBOL_GPL(dw_i3c_common_probe);
-- 
2.53.0



