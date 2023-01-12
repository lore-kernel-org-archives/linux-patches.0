Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3CA2749A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:11:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38B13C433D2;
	Thu, 12 Jan 2023 14:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532664;
	bh=s+Ge5SdtkYFcVoaju7ddo2fTmyq5RTs1uz/CxDqe+aY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bxM962xTsunhDoVVlHPLg+uNz2llw5h+pZLTP90l/3HXv0OKj0wKOPE0i5DGYc9dg
	 rnM8NbKS5PK0p7AVwAkgfV2xCdD/8kddWBnQIErop6vL1egGo+vynYUC2w1RBaZSXl
	 h9h4gvOT2UpBt6h54xhlmDEnEr2hz0e5G5KDnc1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 205/783] regulator: core: fix module refcount leak in set_supply()
Date: Thu, 12 Jan 2023 14:48:41 +0100
Message-Id: <20230112135533.835944740@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

[ Upstream commit da46ee19cbd8344d6860816b4827a7ce95764867 ]

If create_regulator() fails in set_supply(), the module refcount
needs be put to keep refcount balanced.

Fixes: e2c09ae7a74d ("regulator: core: Increase refcount for regulator supply's module")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221201122706.4055992-2-yangyingliang@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 60c0be2ea5c5..830a9be4432e 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1472,6 +1472,7 @@ static int set_supply(struct regulator_dev *rdev,
 
 	rdev->supply = create_regulator(supply_rdev, &rdev->dev, "SUPPLY");
 	if (rdev->supply == NULL) {
+		module_put(supply_rdev->owner);
 		err = -ENOMEM;
 		return err;
 	}
-- 
2.35.1



