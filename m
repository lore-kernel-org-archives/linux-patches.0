Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656C1184101;
	Tue, 10 Sep 2024 09:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961764; cv=none; b=M9VN/WTmxCsgQXbaw6p9U12bF3Ts9celr46avY5sMR7sCFN+GyJI56MVU3pkRBIpI/uNwOgj4prfOcryJE7oibfc5TGQUQ04TPd+ZyWRy+URZbL1HuToQA8bc0KoUjx58XsF+gYej4SjteUsxLcDGmjowAX7B2akeWEqTI+vcIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961764; c=relaxed/simple;
	bh=uw/CsOYvAKuuzdxAA+hdloVLj/cNMdriULMo+Y8lg68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=haX8gpl0EfQkP2gVmuLGD9rEAcpA+kRwsuDcIhGTVFWPeNvEA2JehU7B69LVOXkTGWKmEoeBa6Rlg/T9QXLz95OnBZL+o1mdwAD3m6ol1oSjxuvIG1CzebjSymfyAsG/SRcq973KcIB7DTN6gFx9x5LRRLNPQjqUAZDgUwVnk38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rNvRpH2/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rNvRpH2/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFE78C4CECD;
	Tue, 10 Sep 2024 09:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961764;
	bh=uw/CsOYvAKuuzdxAA+hdloVLj/cNMdriULMo+Y8lg68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rNvRpH2/GvS0DbRaJ7fPaKrRK5rdELOZR44UeI0R3mV6X+Lz59nbfh/h+wtw2UJSl
	 gQuy/BJIoQFst8OCQFnSeJoShPZZA1aJSrOCx6MyTSUKw1FkwMKspAzD10zFUXWgog
	 qfA6dOm4D3g7LdvOJG6FsRTGvG4foXmYGSsSIFjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 163/375] spi: intel: Add check devm_kasprintf() returned value
Date: Tue, 10 Sep 2024 11:29:20 +0200
Message-ID: <20240910092627.960392544@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Han <hanchunchao@inspur.com>

[ Upstream commit 2920294686ec23211637998f3ec386dfd3d784a6 ]

intel_spi_populate_chip() use devm_kasprintf() to set pdata->name.
This can return a NULL pointer on failure but this returned value
is not checked.

Fixes: e58db3bcd93b ("spi: intel: Add default partition and name to the second chip")
Signed-off-by: Charles Han <hanchunchao@inspur.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Link: https://patch.msgid.link/20240830074106.8744-1-hanchunchao@inspur.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-intel.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/spi/spi-intel.c b/drivers/spi/spi-intel.c
index 3e5dcf2b3c8a..795b7e72baea 100644
--- a/drivers/spi/spi-intel.c
+++ b/drivers/spi/spi-intel.c
@@ -1390,6 +1390,9 @@ static int intel_spi_populate_chip(struct intel_spi *ispi)
 
 	pdata->name = devm_kasprintf(ispi->dev, GFP_KERNEL, "%s-chip1",
 				     dev_name(ispi->dev));
+	if (!pdata->name)
+		return -ENOMEM;
+
 	pdata->nr_parts = 1;
 	parts = devm_kcalloc(ispi->dev, pdata->nr_parts, sizeof(*parts),
 			     GFP_KERNEL);
-- 
2.43.0



