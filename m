Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD3E3FF1AC;
	Fri, 15 May 2026 15:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860495; cv=none; b=cuHrd6vZm4vWNLxJSN7SFCfuNVsVZOhcJ9t/knKcknApgpibc/L3w5oBg4pGNBeuZgRyrDdSYx329najjimtQIjR13EUaStlsNQBPLmlKBDYaZtgE5gpa2ciG/BXIiZGwO+9g4ipHaxVR+LqFfhCKAZ98lAG4Fb34G2bTaR2jOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860495; c=relaxed/simple;
	bh=26jt1JgaAekHvCZqOeH/xsCpuY1zF6P8/Wd+tevFVZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fRTgUyuP13+pPk6TgUxvWL1gf6LxNgAt/TlbESrsaLw/6jjMWw9sQpz8CFA3Bg1hM9omksvhIs3tymNQdWfw0y4Q571bsXR7T25MKQFcDUfMQQRaG9gJcAEsrPCZxJ+jRPBiqDONOLJSaHQyiG+XVF3uRZCh4Tn7wE/vr+wSRoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oy2jaq1h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oy2jaq1h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F70C2BCB0;
	Fri, 15 May 2026 15:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860495;
	bh=26jt1JgaAekHvCZqOeH/xsCpuY1zF6P8/Wd+tevFVZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oy2jaq1hbRDpCX0ohJ7YmndutCbTKXQcapKRTFAvi6ZnwrfA2H49HynqdPm9u/3W4
	 hFRdE1S4l68ZAzjorhDERr2VUbrzoIifh0UJnFgMN6SyT6pkncMCK32XN1XspY3eoh
	 Vn7RQqOaLzliGSFave/w8RpfZtz3J3Ow4Oa5SEAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 059/144] spi: orion: fix clock imbalance on registration failure
Date: Fri, 15 May 2026 17:48:05 +0200
Message-ID: <20260515154654.918207995@linuxfoundation.org>
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

commit 443cde0dc59c5d154156ac9f27a7dadef8ebc0c2 upstream.

Make sure that the controller is not runtime suspended before disabling
clocks on probe failure.

Also restore the autosuspend setting.

Fixes: 5c6786945b4e ("spi: spi-orion: add runtime PM support")
Cc: stable@vger.kernel.org	# 3.17
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260421130211.1537628-3-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-orion.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/spi/spi-orion.c
+++ b/drivers/spi/spi-orion.c
@@ -774,6 +774,7 @@ static int orion_spi_probe(struct platfo
 	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_use_autosuspend(&pdev->dev);
 	pm_runtime_set_autosuspend_delay(&pdev->dev, SPI_AUTOSUSPEND_TIMEOUT);
+	pm_runtime_get_noresume(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 
 	status = orion_spi_reset(spi);
@@ -785,10 +786,15 @@ static int orion_spi_probe(struct platfo
 	if (status < 0)
 		goto out_rel_pm;
 
+	pm_runtime_put_autosuspend(&pdev->dev);
+
 	return status;
 
 out_rel_pm:
 	pm_runtime_disable(&pdev->dev);
+	pm_runtime_put_noidle(&pdev->dev);
+	pm_runtime_set_suspended(&pdev->dev);
+	pm_runtime_dont_use_autosuspend(&pdev->dev);
 out_rel_axi_clk:
 	clk_disable_unprepare(spi->axi_clk);
 out:


