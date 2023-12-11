Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4902B51C38;
	Mon, 11 Dec 2023 18:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hiuPWE0Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBC69C433C8;
	Mon, 11 Dec 2023 18:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320875;
	bh=JZ3so8KkjmpXUf83Gvlr93UDw0ym2kI6ssbXWlLf1iQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hiuPWE0Yvu7Y/W6WRA/IFhuabla+ucjd+VURCr+nkfvzNmdZU3Kp+TSYY3ftyTadv
	 pCH+0HHpN4YbxUxaowH5EQmHDkJEa1es3sZ5Syn3niM2s7dj1UIa0yYVTbC9810T/9
	 +LosAGDWs25OKOpqb8cpwIjEXF8Mgc0BVmpJivS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Vadim Pasternak <vadimp@nvidia.com>,
	Kunwu Chan <chentao@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 027/141] platform/mellanox: Add null pointer checks for devm_kasprintf()
Date: Mon, 11 Dec 2023 19:21:26 +0100
Message-ID: <20231211182027.717513113@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182026.503492284@linuxfoundation.org>
References: <20231211182026.503492284@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kunwu Chan <chentao@kylinos.cn>

[ Upstream commit 2c7c857f5fed997be93047d2de853d7f10c8defe ]

devm_kasprintf() returns a pointer to dynamically allocated memory
which can be NULL upon failure.

Compile-tested only.

Fixes: 1a218d312e65 ("platform/mellanox: mlxbf-pmc: Add Mellanox BlueField PMC driver")
Suggested-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Suggested-by: Vadim Pasternak <vadimp@nvidia.com>
Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Reviewed-by: Vadim Pasternak <vadimp@nvidia.com>
Link: https://lore.kernel.org/r/20231201055447.2356001-1-chentao@kylinos.cn
[ij: split the change into two]
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/mellanox/mlxbf-pmc.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/platform/mellanox/mlxbf-pmc.c b/drivers/platform/mellanox/mlxbf-pmc.c
index 2d4bbe99959ef..925bfc4aef8ce 100644
--- a/drivers/platform/mellanox/mlxbf-pmc.c
+++ b/drivers/platform/mellanox/mlxbf-pmc.c
@@ -1202,6 +1202,8 @@ static int mlxbf_pmc_init_perftype_counter(struct device *dev, int blk_num)
 	attr->dev_attr.show = mlxbf_pmc_event_list_show;
 	attr->nr = blk_num;
 	attr->dev_attr.attr.name = devm_kasprintf(dev, GFP_KERNEL, "event_list");
+	if (!attr->dev_attr.attr.name)
+		return -ENOMEM;
 	pmc->block[blk_num].block_attr[i] = &attr->dev_attr.attr;
 	attr = NULL;
 
@@ -1214,6 +1216,8 @@ static int mlxbf_pmc_init_perftype_counter(struct device *dev, int blk_num)
 		attr->nr = blk_num;
 		attr->dev_attr.attr.name = devm_kasprintf(dev, GFP_KERNEL,
 							  "enable");
+		if (!attr->dev_attr.attr.name)
+			return -ENOMEM;
 		pmc->block[blk_num].block_attr[++i] = &attr->dev_attr.attr;
 		attr = NULL;
 	}
@@ -1240,6 +1244,8 @@ static int mlxbf_pmc_init_perftype_counter(struct device *dev, int blk_num)
 		attr->nr = blk_num;
 		attr->dev_attr.attr.name = devm_kasprintf(dev, GFP_KERNEL,
 							  "counter%d", j);
+		if (!attr->dev_attr.attr.name)
+			return -ENOMEM;
 		pmc->block[blk_num].block_attr[++i] = &attr->dev_attr.attr;
 		attr = NULL;
 
@@ -1251,6 +1257,8 @@ static int mlxbf_pmc_init_perftype_counter(struct device *dev, int blk_num)
 		attr->nr = blk_num;
 		attr->dev_attr.attr.name = devm_kasprintf(dev, GFP_KERNEL,
 							  "event%d", j);
+		if (!attr->dev_attr.attr.name)
+			return -ENOMEM;
 		pmc->block[blk_num].block_attr[++i] = &attr->dev_attr.attr;
 		attr = NULL;
 	}
@@ -1283,6 +1291,8 @@ static int mlxbf_pmc_init_perftype_reg(struct device *dev, int blk_num)
 		attr->nr = blk_num;
 		attr->dev_attr.attr.name = devm_kasprintf(dev, GFP_KERNEL,
 							  events[j].evt_name);
+		if (!attr->dev_attr.attr.name)
+			return -ENOMEM;
 		pmc->block[blk_num].block_attr[i] = &attr->dev_attr.attr;
 		attr = NULL;
 		i++;
@@ -1311,6 +1321,8 @@ static int mlxbf_pmc_create_groups(struct device *dev, int blk_num)
 	pmc->block[blk_num].block_attr_grp.attrs = pmc->block[blk_num].block_attr;
 	pmc->block[blk_num].block_attr_grp.name = devm_kasprintf(
 		dev, GFP_KERNEL, pmc->block_name[blk_num]);
+	if (!pmc->block[blk_num].block_attr_grp.name)
+		return -ENOMEM;
 	pmc->groups[blk_num] = &pmc->block[blk_num].block_attr_grp;
 
 	return 0;
-- 
2.42.0



