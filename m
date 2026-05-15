Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366B53E0096;
	Fri, 15 May 2026 16:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862046; cv=none; b=nTsr3RfS0DF9My8NgBMfn5kFyQ947p4y5dwgnG0d7BHXXUEHO/APuSo9zJWL6CQIWBo4kYNoEp80PAV03Tyj2ZqY3Oyvqtp6jiGCvqwF4zPrVTklSejig+r2k+4HVw5tRlZ7OhXbwW3auGE1F3diM4c7F+9JMtRPRhM9ZMo5Y0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862046; c=relaxed/simple;
	bh=DEmmlZpm7jh8yU0bPDs2jHuhj+xOiUoC3mho0gW2slg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z6lu3mAVNDJvHS2za0jAtCoujPZz0kdMwD8O2vb86W3NgkmqMkgTJS9tySPWwKfjaX5OZXI+Pvv0et101hMyT1wR8883zlYN/45J9a89/AFHpaTyuODAFTRlOhXgH5BSYIzZLWMOnfBVWDwXe1fo/fyexRAXWch43CPtJ7n/WtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aR4HdM9U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aR4HdM9U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF529C2BCB0;
	Fri, 15 May 2026 16:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862046;
	bh=DEmmlZpm7jh8yU0bPDs2jHuhj+xOiUoC3mho0gW2slg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aR4HdM9UMyrE6F/HiiGeO0B8hwNkR1jD5Cv99AkE75vKCOURByaXDtATmxsA3seZ5
	 /tWcieWQdGxNZXegAnujHfxdbo1jf+0Zlv9EcjVJQT1wH/W09Tnx1SWHKcECRVd5Jz
	 PGBs7uMjS1Bo82Vx11y7BKFbMxH9+FW+hefr9Yvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mason Yang <masonccyang@mxic.com.tw>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 087/188] spi: mxic: fix controller deregistration
Date: Fri, 15 May 2026 17:48:24 +0200
Message-ID: <20260515154659.212932758@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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
@@ -833,9 +833,10 @@ static void mxic_spi_remove(struct platf
 	struct spi_controller *host = platform_get_drvdata(pdev);
 	struct mxic_spi *mxic = spi_controller_get_devdata(host);
 
+	spi_unregister_controller(host);
+
 	pm_runtime_disable(&pdev->dev);
 	mxic_spi_mem_ecc_remove(mxic);
-	spi_unregister_controller(host);
 }
 
 static const struct of_device_id mxic_spi_of_ids[] = {


