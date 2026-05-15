Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2473FF1D1;
	Fri, 15 May 2026 15:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860361; cv=none; b=k3s6RdTRsBhkZYr/D8a81HQDP7w+jXfstLXMq2KOIOZtXqAMyQyD7B6bPvJM+aRafjiEyaK4zzNRqZ2JfX7D1/qOjqJbFPpHCjJJncAlC//triEl10l7PvGOqyyLAJZp6gPvHFPZQstRBlahtgdbL3c19QUBZeyMEljzKQe7fdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860361; c=relaxed/simple;
	bh=7OMhqu4su5KhuFKs+n4Df0raHNuALnmCgaZgSulC6Xg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mtiC6b4DkLBz5wyWk+0niDj1VK76hvQIfpcsY9SG3uOx45Qc4qN/DFoC7cdSNIpAKpgUcoCsftdZA1ICKrRyTaEz9alNml2zlGp5FUqOO/zpjeFuZy6EZtoS0dQ31+ihmybl9GDZyNMdYXUQCNTEOtueZb4ruCyAcPZJBGzwM1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L3Pq0BhB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L3Pq0BhB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 161CEC2BCB0;
	Fri, 15 May 2026 15:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860361;
	bh=7OMhqu4su5KhuFKs+n4Df0raHNuALnmCgaZgSulC6Xg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L3Pq0BhBBDubQTf1u3SUfcEQBXDB55D9QzJ02H90lxHWKrT2gaauLFCdlgrgY+Te4
	 /RCp/ccY/1IvnCph8dZpQXz7Q4t0ZrNhx8OiwXYvqT+9m1l+Z/T6ZfCCSkjy4ZfUJZ
	 m5E7Gc/ITKJF7ZNla26okEbwwgwM6FjVfKwQded0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 057/144] spi: orion: fix controller deregistration
Date: Fri, 15 May 2026 17:48:03 +0200
Message-ID: <20260515154654.871445956@linuxfoundation.org>
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

commit 220f4f11104a7f83b71543ef0e48dde1da2bc5d3 upstream.

Make sure to deregister the controller before disabling underlying
resources like clocks during driver unbind.

Fixes: 60cadec9da7b ("spi: new orion_spi driver")
Cc: stable@vger.kernel.org	# 2.6.27
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260414134319.978196-7-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-orion.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-orion.c
+++ b/drivers/spi/spi-orion.c
@@ -802,10 +802,15 @@ static void orion_spi_remove(struct plat
 	struct spi_controller *host = platform_get_drvdata(pdev);
 	struct orion_spi *spi = spi_controller_get_devdata(host);
 
+	spi_controller_get(host);
+
+	spi_unregister_controller(host);
+
 	pm_runtime_get_sync(&pdev->dev);
 	clk_disable_unprepare(spi->axi_clk);
 
-	spi_unregister_controller(host);
+	spi_controller_put(host);
+
 	pm_runtime_disable(&pdev->dev);
 }
 


