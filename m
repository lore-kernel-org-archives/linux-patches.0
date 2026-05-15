Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442E820297C;
	Fri, 15 May 2026 16:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861450; cv=none; b=gBiQdEgIZIk+dA/oMPYFAB9a9yUfiN0J29F+20yIq1dXSfw1SXQVGDir4lXUUh415N9hai1AtbDtLlIz2VxZMArTiofyo4U13NkTPYkiYG++CahcgPKSxt+5MFJ3Y1YrpCp1srN3GIpGgDUgtAk/+0fvRlyNvR4m2meCJMDXe0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861450; c=relaxed/simple;
	bh=HV8dezZ15hU1pNc2wK/w1gmcKJtIJvpAsj1kZfW+KHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PitLaaQywpZq7gX1sdTC7rB8M8YvR1RwTkTBqopRXfyrKb/jNs7MX4hh7cXfJUp8FplJzByTsqEiYXegK4pLvFTD2ucaz6jbofJaEHS8XLkRYpQQhF/MevTZyN1QeHsLWeOOhgYfo/IXXXaCNBt9WJYxAE5UKGKhtbr6cKYb3PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SAoDy4Ht; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SAoDy4Ht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F00CC2BCB0;
	Fri, 15 May 2026 16:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861449;
	bh=HV8dezZ15hU1pNc2wK/w1gmcKJtIJvpAsj1kZfW+KHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SAoDy4HtsDTtCiIfVwrgNG8PDo0we2kwe3CSFb0vLzAE82/61BPvoqJrURkA3Ggt9
	 IvSC3AaGgQijzjXwphVyvbAfPoa8Qo9dqHvx4Y66pJWI0J5BPvmSUdB3I68/TH7JmB
	 G2boPeuCLvcNRahMJJQbzmqZj0xC0glECGcJ6TtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lanqing Liu <lanqing.liu@spreadtrum.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 331/474] spi: sprd: fix controller deregistration
Date: Fri, 15 May 2026 17:47:20 +0200
Message-ID: <20260515154722.174352750@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

commit 123d17dbc5f07059752fa5e616385ca29a8f935a upstream.

Make sure to deregister the controller before disabling underlying
resources like clocks during driver unbind.

Note that the controller is suspended before disabling and releasing
resources since commit de082d866cce ("spi: sprd: Add the SPI irq
function for the SPI DMA mode") which avoids issues like unclocked
accesses but prevents SPI device drivers from doing I/O during
deregistration.

Fixes: e7d973a31c24 ("spi: sprd: Add SPI driver for Spreadtrum SC9860")
Cc: stable@vger.kernel.org	# 4.20
Cc: Lanqing Liu <lanqing.liu@spreadtrum.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-17-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-sprd.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/spi/spi-sprd.c
+++ b/drivers/spi/spi-sprd.c
@@ -978,7 +978,7 @@ static int sprd_spi_probe(struct platfor
 		goto err_rpm_put;
 	}
 
-	ret = devm_spi_register_controller(&pdev->dev, sctlr);
+	ret = spi_register_controller(sctlr);
 	if (ret)
 		goto err_rpm_put;
 
@@ -1010,7 +1010,9 @@ static void sprd_spi_remove(struct platf
 	if (ret < 0)
 		dev_err(ss->dev, "failed to resume SPI controller\n");
 
-	spi_controller_suspend(sctlr);
+	spi_controller_get(sctlr);
+
+	spi_unregister_controller(sctlr);
 
 	if (ret >= 0) {
 		if (ss->dma.enable)
@@ -1019,6 +1021,8 @@ static void sprd_spi_remove(struct platf
 	}
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
+
+	spi_controller_put(sctlr);
 }
 
 static int __maybe_unused sprd_spi_runtime_suspend(struct device *dev)


