Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B188F30566B;
	Fri, 15 May 2026 15:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860327; cv=none; b=osAW1LIgZBDZGwQsbR3Wkrq0pW9xjc8Ua8kZRb0CZK7iVSWmv1erabi8CkO3DRSKUqQhpEt49C7v7OUia3MtHzbX7CY1HQ2xdR7ebtCK4KTr18VlEL24dHPE2J8pq7uXEMq4SsbUjf9osvOR5oQIr5aNF+1NT/T5DDzWSDz2jRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860327; c=relaxed/simple;
	bh=qeFa5UQQX+K3AmeR9j6BkRdfQYV59/l7YEgH3ErdKco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MIYjabjTmKjv37VUFo1OVRyZti+XMfBpfR2HI/gHGZ6cM6oDVkM7GrVaPxGJ2lsTmmtvBUYG7raABJG318vQ7NfWGUnG2fY/Yo7kqv0oVkMqL9h2B2LGnxlT+0lGYznheGiebRWzuhehcJsVutJfQRgDEgM9oVqHiUt2YRB/j5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yYrWQOO9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yYrWQOO9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 466D0C4AF09;
	Fri, 15 May 2026 15:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860327;
	bh=qeFa5UQQX+K3AmeR9j6BkRdfQYV59/l7YEgH3ErdKco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yYrWQOO9DmQixn8Bl49SIk+eme73drwXbiLpQ7bwBWiEAuUmwyzednRRcjXW6SFef
	 gXlBszq/P+SRNRgoZk6TDGt9u1tmiOKtpyHMMW6SbdvyURk54yUQhp0c4v3puYt0xb
	 ZYB9UbLkJ8UYLHzvgmd6wlvJzws3dV5p2HHIVrK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 045/144] spi: pl022: fix controller deregistration
Date: Fri, 15 May 2026 17:47:51 +0200
Message-ID: <20260515154654.576018910@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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

commit 994b33366be9148240690e3e94bffe17c4d89458 upstream.

Make sure to deregister the controller before releasing underlying
resources like DMA during driver unbind.

Fixes: b43d65f7e818 ("[ARM] 5546/1: ARM PL022 SSP/SPI driver v3")
Cc: stable@vger.kernel.org	# 2.6.31
Cc: Linus Walleij <linusw@kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-9-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-pl022.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-pl022.c
+++ b/drivers/spi/spi-pl022.c
@@ -1960,7 +1960,7 @@ static int pl022_probe(struct amba_devic
 
 	/* Register with the SPI framework */
 	amba_set_drvdata(adev, pl022);
-	status = devm_spi_register_controller(&adev->dev, host);
+	status = spi_register_controller(host);
 	if (status != 0) {
 		dev_err_probe(&adev->dev, status,
 			      "problem registering spi host\n");
@@ -2001,6 +2001,10 @@ pl022_remove(struct amba_device *adev)
 	if (!pl022)
 		return;
 
+	spi_controller_get(pl022->host);
+
+	spi_unregister_controller(pl022->host);
+
 	/*
 	 * undo pm_runtime_put() in probe.  I assume that we're not
 	 * accessing the primecell here.
@@ -2012,6 +2016,8 @@ pl022_remove(struct amba_device *adev)
 		pl022_dma_remove(pl022);
 
 	amba_release_regions(adev);
+
+	spi_controller_put(pl022->host);
 }
 
 #ifdef CONFIG_PM_SLEEP


