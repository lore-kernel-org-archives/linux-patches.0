Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80D4749A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:06:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E18AC433D2;
	Thu, 12 Jan 2023 14:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532396;
	bh=E4Al1Qs1EkJoE+vFORwkdenlv6bAACzawFopY1376uY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L0UGC6lnYqxmK2nsnPFQ6cQolJ27nJm6oGVLLPieFWHwCJn8UQFtEinJxwlNJ+86U
	 Jho5+BY9rZ7wR3LVx/jPEp2BL32PHkWeIkt565ji0PKXQ5W2holT6MTJ8rEIlb/ddf
	 ktPq1fvbkbmhMwutbUPKIkVJt8kZE7VIxZN/+BeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 149/783] regulator: core: fix unbalanced of node refcount in regulator_dev_lookup()
Date: Thu, 12 Jan 2023 14:47:45 +0100
Message-Id: <20230112135531.249789150@linuxfoundation.org>
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

[ Upstream commit f2b41b748c19962b82709d9f23c6b2b0ce9d2f91 ]

I got the the following report:

  OF: ERROR: memory leak, expected refcount 1 instead of 2,
  of_node_get()/of_node_put() unbalanced - destroy cset entry:
  attach overlay node /i2c/pmic@62/regulators/exten

In of_get_regulator(), the node is returned from of_parse_phandle()
with refcount incremented, after using it, of_node_put() need be called.

Fixes: 69511a452e6d ("regulator: map consumer regulator based on device tree")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221115091508.900752-1-yangyingliang@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index eb083b26ab4f..876afa3919c1 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1775,6 +1775,7 @@ static struct regulator_dev *regulator_dev_lookup(struct device *dev,
 		node = of_get_regulator(dev, supply);
 		if (node) {
 			r = of_find_regulator_by_node(node);
+			of_node_put(node);
 			if (r)
 				return r;
 
-- 
2.35.1



