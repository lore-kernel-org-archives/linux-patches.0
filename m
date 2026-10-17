Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0335D3382C7;
	Sat, 17 Oct 2026 16:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253094; cv=none; b=X12DQtWL7fwWIHbmaZ60T0aMCfg/eyAwl6sI6rbNqLikUdc3XGRQeznrlodMeGeH8erUT+SfQ97YMHdLIhBfSJsM9yHXoA1eDlMJ+I4gu1ymS6dQYDPL2DWW38tAKKQ4J9yH+dVRfMA3qvYL/TB7jJ6AlQnjh4YAepwkppJ3SYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253094; c=relaxed/simple;
	bh=MblKIXHbOFW0fnTImlnXCvgETzC0GpgUwyf+nzPzr3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m2oZQTQq13IzFb4nv2QffZ7JtydpUrpb9qDiAznfkvX1+3jasbpyibkpbJ9Zy74Qd9oERP/o4JiKlRKxoaoYDpx3jyp8WyaN+KVlLnGeG7VYxnvx3tIpSRldDR7iPDskFNnBWfr+DvnC0bzHGtrczA4LOpJGPlK5iRa2vZdi7/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EjDtOxj+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EjDtOxj+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBDB11F000C4;
	Sat, 17 Oct 2026 16:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253092;
	bh=lk2hkpkRMfeOZAOMea8rO54LuKcYz+thlVr5rYl5LwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EjDtOxj+6jyKNWNkRk9CZMhT324gnVVNHWg9E1HnqXQZROpcZ1mXeeS1iOco0AOvl
	 YsaoOEzVju/2npbfOqvkHHqXpbNXEj5y57sdWQX+vnb+6iljduL1rMDm2q3IaZS/aZ
	 7Kk/68lnr41w0piLyL42YN8Hf4QWP++Bio0neXDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 001/869] spi: mpc52xx: clean up interrupt handling
Date: Sat, 17 Oct 2026 17:47:22 +0200
Message-ID: <20261017160037.027925757@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
index a4991f3bc9b63..a067e73d9d4db 100644
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



