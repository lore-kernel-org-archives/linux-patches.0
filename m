Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E32C3A3E7E;
	Sat, 17 Oct 2026 15:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792252531; cv=none; b=hS/FP75TOTjsCVZ9pwoF6TsPGkdVN6PKiywUH0EESG7cii4UN7nmg2hsAvdYA+Jo/lx+Tea3WAQdHtzVoXj80iATe5xnG4MdUaVqARwk/bVhdjoZAlHjBp+OAAz5rKMdoSiEOua6gJLDgVIqkhoHteI2lbZlodLDbwShzGueU5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792252531; c=relaxed/simple;
	bh=zPxxQlMqyqvipzLA7Cn5m4SEglG4XO1+cS3Lo2L0i2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o5CRtiSQhqnPzyB8vsTCrD0lW6CKnFYLhJLZ9h1cwV6mPfdLpARZ8KEopMJpkUENb7pV4HLDbzf+fY5TM7dkd8T6aNkdj3AEc7oFOlXMGepXLU/1hpbeJGxt3WOConBM9XD6TLG+DQ6zHDDjdE+n92eGKl+rQrxV932nXEX7Nq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HwA1OcFq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HwA1OcFq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A5501F000C4;
	Sat, 17 Oct 2026 15:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792252523;
	bh=ruD59vlXNVKM6TTfG9VS7Ztd6uamgwGp41MpuzqvYSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HwA1OcFqh1vUMwq6F7IAgCxQolxWNWj7Rci0mvm7JBNOPejq4yuutMVHPvFRgOXEq
	 WBGcEywmKtkTeLYj21vFYgMhMdlRLiwYl21+p6nerz+as/mVeZkWGkOLsiGvRMIW3N
	 7X3gGLCsh/EeJrJbtkcm9xQVFDNLsHT3QpOlk78s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 01/52] spi: mpc52xx: clean up interrupt handling
Date: Sat, 17 Oct 2026 17:54:02 +0200
Message-ID: <20261017155104.881992074@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017155104.830766652@linuxfoundation.org>
References: <20261017155104.830766652@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 76645c1fd682c9df746c3f7c149b868ceff914fb ]

The driver is relying on the assumption that the invalid interrupt 0 can
be freed without any side effects, but that is not the case on
architectures like x86 where it would trigger a warning about freeing an
already free interrupt.

This should not cause any trouble on powerpc where this driver is used,
but make the code more portable (and obviously correct) by making sure
that the interrupts have been requested before freeing them.

Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260423075801.2252318-1-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mpc52xx.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/spi/spi-mpc52xx.c b/drivers/spi/spi-mpc52xx.c
index 84aade1416068..36692aa62bbd4 100644
--- a/drivers/spi/spi-mpc52xx.c
+++ b/drivers/spi/spi-mpc52xx.c
@@ -475,13 +475,15 @@ static int mpc52xx_spi_probe(struct platform_device *op)
 	if (ms->irq0 && ms->irq1) {
 		rc = request_irq(ms->irq0, mpc52xx_spi_irq, 0,
 				  "mpc5200-spi-modf", ms);
-		rc |= request_irq(ms->irq1, mpc52xx_spi_irq, 0,
-				  "mpc5200-spi-spif", ms);
-		if (rc) {
-			free_irq(ms->irq0, ms);
-			free_irq(ms->irq1, ms);
-			ms->irq0 = ms->irq1 = 0;
+		if (rc == 0) {
+			rc = request_irq(ms->irq1, mpc52xx_spi_irq, 0,
+					 "mpc5200-spi-spif", ms);
+			if (rc)
+				free_irq(ms->irq0, ms);
 		}
+
+		if (rc)
+			ms->irq0 = ms->irq1 = 0;
 	} else {
 		/* operate in polled mode */
 		ms->irq0 = ms->irq1 = 0;
@@ -501,8 +503,10 @@ static int mpc52xx_spi_probe(struct platform_device *op)
 
  err_register:
 	dev_err(&ms->host->dev, "initialization failed\n");
-	free_irq(ms->irq0, ms);
-	free_irq(ms->irq1, ms);
+	if (ms->irq0) {
+		free_irq(ms->irq0, ms);
+		free_irq(ms->irq1, ms);
+	}
 	cancel_work_sync(&ms->work);
  err_gpio:
 	while (i-- > 0)
@@ -525,8 +529,10 @@ static void mpc52xx_spi_remove(struct platform_device *op)
 
 	spi_unregister_controller(host);
 
-	free_irq(ms->irq0, ms);
-	free_irq(ms->irq1, ms);
+	if (ms->irq0) {
+		free_irq(ms->irq0, ms);
+		free_irq(ms->irq1, ms);
+	}
 
 	cancel_work_sync(&ms->work);
 
-- 
2.53.0



