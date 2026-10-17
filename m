Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 987F03A1E92;
	Sat, 17 Oct 2026 17:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258701; cv=none; b=cqWQwQq7NeA/7E/XbtMitIx05xnwqk6yzUUEY/wUZhamViG8MuXKAJralk4gkCsSmPCloekPBoRn5cqBNHBDAdtZuN+1OPJpv2BRVBqzwfN8gVP5hI0DiDdSBYOQDCqcV1QoSiDE2EWGhBJKtdGBXogE7OHalXzSd3GMFeaXCyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258701; c=relaxed/simple;
	bh=1ri0Fzj+hdScXcm4EpJ+EPGv2iT20LOTnUDMIHFIv0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eOEUwVCaBTdkEHBfdOvfnOnytuYBEfwinR48HzaCV5VPEAWY+x/DcFi2tmdZ3aiYQ7DiC56QMGIgP9ZsECISwbc5MCjRy7hyx2svTCMJs+/H7wJmmbtFvrWsiJt4L2rizt5zGz5sr4zXoCS6nwUywwt1/Bq+W+gqn6eC5E0eizA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PsfxolU2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PsfxolU2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE2EE1F000C4;
	Sat, 17 Oct 2026 17:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258700;
	bh=9aDbrthybDz7+MT5npPT8c+igM1OCP7Rcya05finXvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PsfxolU2p9xGGyJeRytcDq+RjS9Z7XvQkd5rX4YBsnol3WQZRDQzloXCe3ffDLexM
	 bg6xEC7oePjg99G4HAHlJAZs/r4pJqiQGpoCOCICGhNU88oFouPTUs3iB5+5ak7YO6
	 gUeCuURNoOI6OR+k2OpQ1kEVkz7H5rVKMVBvSxjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grant Likely <grant.likely@secretlab.ca>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0969/1674] spi: mpc52xx: fix use-after-free on registration failure
Date: Sat, 17 Oct 2026 17:54:01 +0200
Message-ID: <20261017160455.995977556@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit f62c060272b9d7423b1650b844e8e4e7b8f9f925 ]

Make sure to disable and free the interrupts in case controller
registration fails to avoid a potential use-after-free and resource
leak.

This issue was flagged by Sashiko when reviewing a controller
deregistration fix.

Fixes: 42bbb70980f3 ("powerpc/5200: Add mpc5200-spi (non-PSC) device driver")
Cc: stable@vger.kernel.org	# 2.6.33
Cc: Grant Likely <grant.likely@secretlab.ca>
Link: https://sashiko.dev/#/patchset/20260414134319.978196-1-johan%40kernel.org?part=3
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260421125800.1537361-1-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mpc52xx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/spi/spi-mpc52xx.c b/drivers/spi/spi-mpc52xx.c
index 9b758efb0b7fa..8f2f0821b1e1a 100644
--- a/drivers/spi/spi-mpc52xx.c
+++ b/drivers/spi/spi-mpc52xx.c
@@ -500,6 +500,9 @@ static int mpc52xx_spi_probe(struct platform_device *op)
 
  err_register:
 	dev_err(&ms->host->dev, "initialization failed\n");
+	free_irq(ms->irq0, ms);
+	free_irq(ms->irq1, ms);
+	cancel_work_sync(&ms->work);
  err_gpio:
 	while (i-- > 0)
 		gpiod_put(ms->gpio_cs[i]);
-- 
2.53.0



