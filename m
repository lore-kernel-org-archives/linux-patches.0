Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 376133FF1D1;
	Fri, 15 May 2026 15:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860359; cv=none; b=cA4e2Kg6yRcdrid3sila2FIeFK7cqLfygapsIMeI/RVugaY8quVWUhKMZ8OGpXVI1+kZIfvYlF2CXKIk1k3obFxibMvNtxdSM5dgRLwaMwEg5EkZ2Vg+AcB7fmIKbh8bohODYivoOqO7jk5RJztqDU729dOTG5RTbTV4MBcNO04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860359; c=relaxed/simple;
	bh=BTXJJ8gm6QXvsRIXmWfAwi3LrEacgbhnZoNn2t7ihMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ib6XvAlFy1C4y3P/aOOrHR4VKSaDBZqHlTZX4WB4GJfxssRw7ZG1XjJ3U49AQSZ2Aff6oniBLpA+DCoW3Da/MqOqbZbEI13NIlKYoGgfMCRmZO28z5iN7Gq+C26++CNBgZLdCITp41DWyldufJeKbJMvZf79/4Kdfj7KLEZYy84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=02N8MqLn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="02N8MqLn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 821CDC2BCB0;
	Fri, 15 May 2026 15:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860358;
	bh=BTXJJ8gm6QXvsRIXmWfAwi3LrEacgbhnZoNn2t7ihMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=02N8MqLnokcH6C3EoGqkQWPYKOyMGiGR8PNGIvw9NdDtDK6iFYrZzCJvoV7/aAnJE
	 gUhD3rqe7MuJnI/8QqTyCZJHSw+L8pxxgLcB7nIc7NtHkB2iBgNDdp4lGCEb7xT/Pa
	 SxxBGk9tATQNAY3h9OUtaW3eJxLwAw2YSXjiL8+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mason Yang <masonccyang@mxic.com.tw>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 056/144] spi: mxic: fix controller deregistration
Date: Fri, 15 May 2026 17:48:02 +0200
Message-ID: <20260515154654.847792343@linuxfoundation.org>
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

commit adbc595e272052181d40ec307a4c5ba98571b0fe upstream.

Make sure to deregister the controller before disabling underlying
resources like clocks (via runtime pm) during driver unbind.

Fixes: b942d80b0a39 ("spi: Add MXIC controller driver")
Cc: stable@vger.kernel.org	# 5.0: cc53711b2191
Cc: stable@vger.kernel.org	# 5.0
Cc: Mason Yang <masonccyang@mxic.com.tw>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260414134319.978196-6-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-mxic.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-mxic.c
+++ b/drivers/spi/spi-mxic.c
@@ -823,9 +823,10 @@ static void mxic_spi_remove(struct platf
 	struct spi_controller *host = platform_get_drvdata(pdev);
 	struct mxic_spi *mxic = spi_controller_get_devdata(host);
 
+	spi_unregister_controller(host);
+
 	pm_runtime_disable(&pdev->dev);
 	mxic_spi_mem_ecc_remove(mxic);
-	spi_unregister_controller(host);
 }
 
 static const struct of_device_id mxic_spi_of_ids[] = {


