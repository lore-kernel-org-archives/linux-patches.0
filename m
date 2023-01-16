Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1F46FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:04:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 946EBC433EF;
	Mon, 16 Jan 2023 17:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888681;
	bh=Ei/SPJrNQCrfJnf5oTItQXr9VMdxc+5cWGkIXnMumMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TZVaZNIlgE/5ocbF9CSK+8+OLMXVh1b+WLLCR9RmGvHsZq4NzeaMiWrCAatzm9pgm
	 +tN1xfEHjrJLLu+qYrCG6bIqwIBgpLAgmKpJfQ08rmEGNtrAPHsAfijlzCY/K2bzuy
	 zAbB25ugx54LOcJncJyyVGNhRlxUOSDbzh44r2Nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 098/338] regulator: core: fix module refcount leak in set_supply()
Date: Mon, 16 Jan 2023 16:49:31 +0100
Message-Id: <20230116154825.173375741@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
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
index d6cd8e6e69cf..871d657a161f 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1164,6 +1164,7 @@ static int set_supply(struct regulator_dev *rdev,
 
 	rdev->supply = create_regulator(supply_rdev, &rdev->dev, "SUPPLY");
 	if (rdev->supply == NULL) {
+		module_put(supply_rdev->owner);
 		err = -ENOMEM;
 		return err;
 	}
-- 
2.35.1



