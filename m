Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66D810E9
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:31:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EADAC433D2;
	Wed, 28 Dec 2022 16:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245090;
	bh=/WL07LK3cI0ugCJwgyw52PX4hwTm7I7iO8famkK5JNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CJDGpb1LdFKaGzGieb1lZzJvIsEeTdIzFs1i+ngZ7+Ui/6iMe//p/rKb2S5YV/NRq
	 FX1+wsQ9C7+iIEArGv+/u7h0XjFcQySdZCDoi4Ol3OuRcvQ6nsEAxcH5yI0L7It6Fz
	 VDExE2EWPVotqWQl618/h1gcMyxdbUyRZ8j4zqDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Guru Das Srinagesh <gurus@codeaurora.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0831/1073] mfd: pm8008: Fix return value check in pm8008_probe()
Date: Wed, 28 Dec 2022 15:40:19 +0100
Message-Id: <20221228144350.587244005@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 14f8c55d48e02157519fbcb3a5de557abd8a06e2 ]

In case of error, the function devm_regmap_init_i2c() returns
ERR_PTR() and never returns NULL. The NULL test in the return
value check should be replaced with IS_ERR().

Fixes: 6b149f3310a4 ("mfd: pm8008: Add driver for QCOM PM8008 PMIC")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Acked-by: Guru Das Srinagesh <gurus@codeaurora.org>
Signed-off-by: Lee Jones <lee@kernel.org>
Link: https://lore.kernel.org/r/20221125073626.1868229-1-yangyingliang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/qcom-pm8008.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/qcom-pm8008.c b/drivers/mfd/qcom-pm8008.c
index 4b8ff947762f..9f3c4a01b4c1 100644
--- a/drivers/mfd/qcom-pm8008.c
+++ b/drivers/mfd/qcom-pm8008.c
@@ -215,8 +215,8 @@ static int pm8008_probe(struct i2c_client *client)
 
 	dev = &client->dev;
 	regmap = devm_regmap_init_i2c(client, &qcom_mfd_regmap_cfg);
-	if (!regmap)
-		return -ENODEV;
+	if (IS_ERR(regmap))
+		return PTR_ERR(regmap);
 
 	i2c_set_clientdata(client, regmap);
 
-- 
2.35.1



