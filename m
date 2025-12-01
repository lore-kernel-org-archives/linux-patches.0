Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22CF68635C;
	Mon,  1 Dec 2025 11:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588721; cv=none; b=L6l1jZGTOsfrL7RUxPxsPDjIUr2A74n48HUTWN2FPxVup3+RRLbdeOOqHHa0joWQTYV2a3rkCHhpcqNeH5t8eqCNln2F83BksqDQByH9uAubdOFtuY3GYNAX0trixdcD90zCUZbIQgvo9Bcrsq8G5Wdo7ScTbXE+scrff8h8wEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588721; c=relaxed/simple;
	bh=zWYjA1v4JFSeZgD8C/rXAzZael8yFM/UP4/mU7K+5aM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=udbs++P0Lr85INRL7g0natUmlv5rIyuiYwZSl0DDWDM0nUoeZumLDO30EW9BImXfkCPoC3antPcg5pdanukCyhn9xzwbSL7ddla+Yp6j8DJw6xiW8O+fRiijfo9MPN2egX5zY6Ty5DXgy3Hqyv+Spk8HgmY00JASZjyfENBlcBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RAC82sLE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RAC82sLE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A935C4CEF1;
	Mon,  1 Dec 2025 11:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588721;
	bh=zWYjA1v4JFSeZgD8C/rXAzZael8yFM/UP4/mU7K+5aM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RAC82sLEAH8Rx6vOyJd6pEm8HQINLGwVbwVUxJv3hdfbmfBj1luaN3mEECzp9R8G+
	 Q1krudnvC0831ssRGL/sE5PZmLu1hCd9SZaCgwUsdLA1fgsVVVJOFDhI6RwUh8IzTU
	 z9WUCzuJtPulDc0/CcI4zRy8us9zjI1Kj4etlhX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Morgan <macromorgan@hotmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 146/187] regulator: fixed: use dev_err_probe for register
Date: Mon,  1 Dec 2025 12:24:14 +0100
Message-ID: <20251201112246.494004045@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Morgan <macromorgan@hotmail.com>

[ Upstream commit d0f95e6496a974a890df5eda65ffaee66ab0dc73 ]

Instead of returning error directly, use dev_err_probe. This avoids
messages in the dmesg log for devices which will be probed again later.

Signed-off-by: Chris Morgan <macromorgan@hotmail.com>
Link: https://lore.kernel.org/r/20210721165716.19915-1-macroalpha82@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 636f4618b1cd ("regulator: fixed: fix GPIO descriptor leak on register failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/fixed.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index 2f0bed86467f9..529f401243245 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -244,8 +244,9 @@ static int reg_fixed_voltage_probe(struct platform_device *pdev)
 	drvdata->dev = devm_regulator_register(&pdev->dev, &drvdata->desc,
 					       &cfg);
 	if (IS_ERR(drvdata->dev)) {
-		ret = PTR_ERR(drvdata->dev);
-		dev_err(&pdev->dev, "Failed to register regulator: %d\n", ret);
+		ret = dev_err_probe(&pdev->dev, PTR_ERR(drvdata->dev),
+				    "Failed to register regulator: %ld\n",
+				    PTR_ERR(drvdata->dev));
 		return ret;
 	}
 
-- 
2.51.0



