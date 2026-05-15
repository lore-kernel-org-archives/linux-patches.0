Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7C03D1CAF;
	Fri, 15 May 2026 16:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862604; cv=none; b=EPK3dPmOFlfmxaQ7gEpWw0lFUwLssEmo8xGfW6t0oxXDH7ONo5CbM6yUzIYbqA54iPakwT+JyYAW5fO+4xwxMvlL2GYnQcRUSuek0LS8ffVoTkX0aDwxrHSs5Fj6gH9J02pbV725XeLtmahcJ2km0vFOOx8x+UqI8HMrdRIAS2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862604; c=relaxed/simple;
	bh=na68LGBAeA7Lj3yaBpBuQ9hujQauePh5xaBjnjMOLoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F8Ks7lwUP215ynIBzJPTqzOH0zAxbhTf9VMisqzFYsMRcdXD4EuMPxHC61QTQIOlXE76SEUW5qY91h+p4qyKHpGd4nwkVRIm0EfZJXmZSFf9GP8CLVG3/KNYpVv4hEOPQZjYVh9s/6aCc092Em/BnKZYSBXQmZUnlVq+6gyiIxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HhTm5OUb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HhTm5OUb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA2BFC2BCB0;
	Fri, 15 May 2026 16:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862604;
	bh=na68LGBAeA7Lj3yaBpBuQ9hujQauePh5xaBjnjMOLoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HhTm5OUbREthNqcWWuns4V5OSUY6GH+h7C845vCjOBzt0ZJb+2KhlirgnmnUV8+bR
	 A9TbW1R/agvzkImMdyl2UCT5fB3RhOh0vuFzwxP88QMZMGE/c7qbY9boZxHzBktVZE
	 Zlk7VrZ+G7SIMdHCv+GGy4k9yf4wI+NhJDe/fHX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 112/201] spi: orion: fix clock imbalance on registration failure
Date: Fri, 15 May 2026 17:48:50 +0200
Message-ID: <20260515154700.978008343@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -784,10 +785,15 @@ static int orion_spi_probe(struct platfo
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


