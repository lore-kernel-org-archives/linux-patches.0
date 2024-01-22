Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8AD7A705;
	Tue, 23 Jan 2024 02:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975549; cv=none; b=i8lFQ0qU/LVaFc/st6Yd1v5IoMAppq9gfcH/z07ZPLxM/jmt+zZ+T0yRY7CrbjN4FmIeGQ4PTSj70sQY4lS3U+776Tcmz7eZ8GWKbkaXkYu5fG0riqhCGuG5uceRjLQIqB90RgwDGbf6pqtSrV5dDBrZ7F69KUcCbbNWvXAcUSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975549; c=relaxed/simple;
	bh=evH1+6OjTDYSW0MtpfK18ZcUyKR3SzPc6zwBiFR4Kzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q9WLXyRB7728mBkDj3dsazPLv+Ti3WUr2An9ty03SXzCkRnwJ/AlvdPVx24Vpif95INJPLdEd1vlLLPLMEyQPAR9Nd+uIToJuNfehTi1WRLVulnp8kx4pu9xgevhAgCOAn0MlErmx/impqhPK66wExS6qC0y7ZoM6nR8kBN8wrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ylVjtb2L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ylVjtb2L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00B2DC433B1;
	Tue, 23 Jan 2024 02:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975549;
	bh=evH1+6OjTDYSW0MtpfK18ZcUyKR3SzPc6zwBiFR4Kzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ylVjtb2LpVY39M6lb97YEK7RjBm746XJxMIBzc6a6uw+W5jF3jH9/p4KI89gB5W0v
	 waFHS573ZjnduR18plalNZoScn8d4DpZFtIF9kd1P6SQmUAvgtmtT9/AspjaURf/LB
	 13KU1YPYvlhUIbQdrVckTH4/lFPgxzGyylUnc4kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 500/583] power: supply: Fix null pointer dereference in smb2_probe
Date: Mon, 22 Jan 2024 15:59:11 -0800
Message-ID: <20240122235827.335886353@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kunwu Chan <chentao@kylinos.cn>

[ Upstream commit 88f04bc3e737155e13caddf0ba8ed19db87f0212 ]

devm_kasprintf and devm_kzalloc return a pointer to dynamically
allocated memory which can be NULL upon failure.

Fixes: 8648aeb5d7b7 ("power: supply: add Qualcomm PMI8998 SMB2 Charger driver")
Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Link: https://lore.kernel.org/r/20231124075021.1335289-1-chentao@kylinos.cn
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/qcom_pmi8998_charger.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/power/supply/qcom_pmi8998_charger.c b/drivers/power/supply/qcom_pmi8998_charger.c
index 10f4dd0caca1..22c7c0e7c522 100644
--- a/drivers/power/supply/qcom_pmi8998_charger.c
+++ b/drivers/power/supply/qcom_pmi8998_charger.c
@@ -973,10 +973,14 @@ static int smb2_probe(struct platform_device *pdev)
 	supply_config.of_node = pdev->dev.of_node;
 
 	desc = devm_kzalloc(chip->dev, sizeof(smb2_psy_desc), GFP_KERNEL);
+	if (!desc)
+		return -ENOMEM;
 	memcpy(desc, &smb2_psy_desc, sizeof(smb2_psy_desc));
 	desc->name =
 		devm_kasprintf(chip->dev, GFP_KERNEL, "%s-charger",
 			       (const char *)device_get_match_data(chip->dev));
+	if (!desc->name)
+		return -ENOMEM;
 
 	chip->chg_psy =
 		devm_power_supply_register(chip->dev, desc, &supply_config);
-- 
2.43.0



