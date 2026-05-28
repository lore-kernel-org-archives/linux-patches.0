Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E11310620;
	Thu, 28 May 2026 20:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001396; cv=none; b=sNHP26SrMpLZugFgezIcCr8ysoAsvqxQhi8s0onSw8w4dZNWfvXHs3PTs2C/DPJUSs1Z2vzBnOUI27G34rwRFC2SfL9SLWnAsWeix2ddJWBTw9ZLG1ITM63H25pdzmou9fmnRdbGBD5jyTeeEhzoQfE5nMvp+mOgKRbNmtgzzNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001396; c=relaxed/simple;
	bh=f6b2Aqvmy2klYx6zSMFGVW/5AV9e9fmoAWKWWOEZwH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kXQaDFfFeNCf7ekOVWxZrTcbPGM1UUCa7mEfk84ioFqOJYqcmiXiG2g2qBDg6kIJH9EkaVj2KvDl9LQsUG+XSzBSNlLYko7MvwrLdZhKrmCQJu+mbLt6CAoteK9gJmhwey58r2k03gSpYX6UYjodu5R2zND0GmfjlVhANmz+8S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IMPxX6rT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IMPxX6rT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0CD01F000E9;
	Thu, 28 May 2026 20:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001395;
	bh=kcmC3Pjt2rXwAlMa2JFkJzDs6vO3zOhhgW+UVAKP4fY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IMPxX6rT9/823xOlZAS4wynJ1d7IAL2mjU7D4l3p2XapOUd3k/nWq3kw1cMN5Kxan
	 v50+bZoCOKcdc2g6Gq7IL9SYzEqyVYqHVsJz7OzwbsCf3O54Oz2CY/XryOMrkTZ1x3
	 VuqD1W7pwcbfeoZEDdVgPnBjhQqeJxX3F9UbRNuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lanqing Liu <lanqing.liu@unisoc.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 065/186] spi: sprd: fix error pointer deref after DMA setup failure
Date: Thu, 28 May 2026 21:49:05 +0200
Message-ID: <20260528194930.710202968@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

commit 3d67fffb74267772d461c02c67f1eff893ad547d upstream.

The driver falls back to PIO mode if DMA setup fails during probe.

Make sure to check the dma.enabled flag before trying to release the DMA
channels also on late probe errors to avoid dereferencing an error
pointer (or attempting to release a channel a second time).

This issue was flagged by Sashiko when reviewing a devres allocation
conversion patch.

Fixes: 386119bc7be9 ("spi: sprd: spi: sprd: Add DMA mode support")
Link: https://sashiko.dev/#/patchset/20260505072909.618363-1-johan%40kernel.org?part=10
Cc: stable@vger.kernel.org	# 5.1
Cc: Lanqing Liu <lanqing.liu@unisoc.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260512074733.915029-1-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-sprd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-sprd.c
+++ b/drivers/spi/spi-sprd.c
@@ -993,7 +993,8 @@ err_rpm_put:
 disable_clk:
 	clk_disable_unprepare(ss->clk);
 release_dma:
-	sprd_spi_dma_release(ss);
+	if (ss->dma.enable)
+		sprd_spi_dma_release(ss);
 free_controller:
 	spi_controller_put(sctlr);
 


