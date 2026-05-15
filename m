Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8223BB11C;
	Fri, 15 May 2026 16:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862656; cv=none; b=at02NBK9KLg+BgNxUMHOebR3pvvN007bbqgTlO5SfZHmgRx3jQUZxW4e3i6gHXUloxiSDyqgk60LsD1dSGSgAxjznC7yaJGm4v8iuWC2XTzVC5TV1ut02azWGEQqeoft2EMWmfL+vwq2csuskIWwm3cCaHSlK4VKXPBnd5Ue4O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862656; c=relaxed/simple;
	bh=v1osI2FsHC95s9wLer/5PQ002J0UxBFGhX02gATXPOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j6QGiB8nB35H1sg/HQutC0m8C8hmMnCn+SHW0L18Zh3nBXAumFsXL/zGH3Phn84ufYq1/GWEAy37QbPjez3FnB+B9AGIIJagPnKOLdJou9RFn+TEl48aB90io9ufhCsQefig3d9vRuEMGYYsZvZaedt1xKEimzRqdakP9k+wr30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b93BpFFu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b93BpFFu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4E8AC2BCB0;
	Fri, 15 May 2026 16:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862656;
	bh=v1osI2FsHC95s9wLer/5PQ002J0UxBFGhX02gATXPOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b93BpFFumcJrT5IuP+9c6lZFz12EKOlFHOtVgKdVGmq/TylN7DEzLn8OH5Fk3BSO5
	 YyfTx48PsOW0xF6uGkwxu4EEscu9JO8ysf3hzN3Onm2PHUAS7MwvMfVgkYoqKNh1QA
	 D1rp5cJ4xRO4HcCaav/0QE7j9Dh5jgQTMzeKivRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuanhong Guo <gch981213@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 091/201] spi: mtk-nor: fix controller deregistration
Date: Fri, 15 May 2026 17:48:29 +0200
Message-ID: <20260515154700.504304361@linuxfoundation.org>
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

commit 76336f24934621db286cabb20b483773ee01dcaa upstream.

Make sure to deregister the controller before disabling underlying
resources like clocks during driver unbind.

Fixes: 881d1ee9fe81 ("spi: add support for mediatek spi-nor controller")
Cc: stable@vger.kernel.org	# 5.7
Cc: Chuanhong Guo <gch981213@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-3-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-mtk-nor.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-mtk-nor.c
+++ b/drivers/spi/spi-mtk-nor.c
@@ -913,7 +913,7 @@ static int mtk_nor_probe(struct platform
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_get_noresume(&pdev->dev);
 
-	ret = devm_spi_register_controller(&pdev->dev, ctlr);
+	ret = spi_register_controller(ctlr);
 	if (ret < 0)
 		goto err_probe;
 
@@ -938,6 +938,8 @@ static void mtk_nor_remove(struct platfo
 	struct spi_controller *ctlr = dev_get_drvdata(&pdev->dev);
 	struct mtk_nor *sp = spi_controller_get_devdata(ctlr);
 
+	spi_unregister_controller(ctlr);
+
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_dont_use_autosuspend(&pdev->dev);


