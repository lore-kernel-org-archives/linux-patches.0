Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B6594E1D8;
	Tue, 23 Jan 2024 00:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969983; cv=none; b=m2a4n2axaWaZfY2TUkdoak150qwQkid/438uIW1mo8otSfuq3d2hG94+Kx5wnSl2z5TbhMA80S+UKp4RRwrfNN1kbeLP62fsbG92RAf46pHu/MwcYRJkrjwOfc8psLsNXXXHOzsOrxwg9hB7CEVfKplje6RUrzWtVjjHaj9SFVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969983; c=relaxed/simple;
	bh=77zxqxUR5h65KVON6jw943z8wZUnKoWNVRo7i9pP2Ms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fY3c/TFZ5ljtPwlWNHP0Qlw6+LUPYHxJr1lUyPe1wF2r7fMqHZjGYoKWpIFABzHX+Be2v3Vro/L2aUKKZWizwZGBv8e63D68pj5bXr2HxAz8cqzXuyIjB5nI0+w+OcOvTZ5eiIMSgC0hhiiLPNicuM2afERCZZudTAIW/lne/bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AHOogEKN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AHOogEKN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC066C433C7;
	Tue, 23 Jan 2024 00:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969982;
	bh=77zxqxUR5h65KVON6jw943z8wZUnKoWNVRo7i9pP2Ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AHOogEKNzjCHe7P1WZ6li9eKEy1lPL2c7ncgsjkn4YUaK6RGpIrGej6JgFTQlggeQ
	 6Yya2Dk7EmMpolbp2bJD26wtnW5ag546yp/jJRezc5iT2fvxrdnZsKcO821cc0lUof
	 +niyrZ8FiEBAwcPnUG2ULknyJci8EEkGOTFIxsn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 550/641] power: supply: Fix null pointer dereference in smb2_probe
Date: Mon, 22 Jan 2024 15:57:34 -0800
Message-ID: <20240122235835.356136298@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 8acf63ee6897..9bb777406013 100644
--- a/drivers/power/supply/qcom_pmi8998_charger.c
+++ b/drivers/power/supply/qcom_pmi8998_charger.c
@@ -972,10 +972,14 @@ static int smb2_probe(struct platform_device *pdev)
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



