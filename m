Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2ABA256C6C;
	Wed, 25 Feb 2026 01:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983495; cv=none; b=kcQbf3C034Skekak7wbZmX9P18tq1SvlEgAmNDX08pOZ+TSSpdT3Cdqw7o7Fcnrw2PYEPiD0bIswhpU8IytBk4VJ4LqfxVyIQV+YKmTTMn+2lNHZ4ZRRtj7Ogq2r2k+sGU9ElqBt7fSOavv04vMfLpGlIjQ/srgGC2w8z4woUDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983495; c=relaxed/simple;
	bh=IhWe3ctdStMJeRIcUowKctwaUIOOqcsXCNofpBP6GWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S8n9GzJvLy/q4mCmBJ36vx2lCyC4a1X/coRsm7r2WWq+t8cSKINKS/g9lE0rBeOdzGKwtfZ6uRiSS8B2dfahEG5ijCb7OMr/7NTynsHfJF3kmE79yqXG3pVUYXF5vAHt6TqZmY9xd3A8W//p3SmXNg3DgS2ojSAs4cBxFbc6Sns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bEJBP3BG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bEJBP3BG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 824C8C116D0;
	Wed, 25 Feb 2026 01:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983495;
	bh=IhWe3ctdStMJeRIcUowKctwaUIOOqcsXCNofpBP6GWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bEJBP3BGBr47ghPMvigE2LRiUXKSeX9yv+r5XsdgrzWnDdla1QvQANfFFRQTM4xR1
	 WaqCXCqbKM/PTveBlR/o96rbjWB4+zGgds4dbBsy4sZM8aYG8SxwUGa/nWoAJ91QrF
	 xxZ0QJDcxYRXFqGROgGxCjYO5clxFLHyTobRJIr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayu Du <jiayu.riscv@isrc.iscas.ac.cn>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 605/781] pinctrl: canaan: k230: Fix NULL pointer dereference when parsing devicetree
Date: Tue, 24 Feb 2026 17:21:54 -0800
Message-ID: <20260225012414.634455871@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayu Du <jiayu.riscv@isrc.iscas.ac.cn>

[ Upstream commit d8c128fb6c2277d95f3f6a4ce28b82c8370031f6 ]

When probing the k230 pinctrl driver, the kernel triggers a NULL pointer
dereference. The crash trace showed:
[    0.732084] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000068
[    0.740737] ...
[    0.776296] epc : k230_pinctrl_probe+0x1be/0x4fc

In k230_pinctrl_parse_functions(), we attempt to retrieve the device
pointer via info->pctl_dev->dev, but info->pctl_dev is only initialized
after k230_pinctrl_parse_dt() completes.

At the time of DT parsing, info->pctl_dev is still NULL, leading to
the invalid dereference of info->pctl_dev->dev.

Use the already available device pointer from platform_device
instead of accessing through uninitialized pctl_dev.

Fixes: d94a32ac688f ("pinctrl: canaan: k230: Fix order of DT parse and pinctrl register")
Signed-off-by: Jiayu Du <jiayu.riscv@isrc.iscas.ac.cn>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-k230.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-k230.c b/drivers/pinctrl/pinctrl-k230.c
index d716f23d837f7..20f7c0f70eb77 100644
--- a/drivers/pinctrl/pinctrl-k230.c
+++ b/drivers/pinctrl/pinctrl-k230.c
@@ -65,6 +65,7 @@ struct k230_pmx_func {
 };
 
 struct k230_pinctrl {
+	struct device		*dev;
 	struct pinctrl_desc	pctl;
 	struct pinctrl_dev	*pctl_dev;
 	struct regmap		*regmap_base;
@@ -470,7 +471,7 @@ static int k230_pinctrl_parse_groups(struct device_node *np,
 				     struct k230_pinctrl *info,
 				     unsigned int index)
 {
-	struct device *dev = info->pctl_dev->dev;
+	struct device *dev = info->dev;
 	const __be32 *list;
 	int size, i, ret;
 
@@ -511,7 +512,7 @@ static int k230_pinctrl_parse_functions(struct device_node *np,
 					struct k230_pinctrl *info,
 					unsigned int index)
 {
-	struct device *dev = info->pctl_dev->dev;
+	struct device *dev = info->dev;
 	struct k230_pmx_func *func;
 	struct k230_pin_group *grp;
 	static unsigned int idx, i;
@@ -596,6 +597,8 @@ static int k230_pinctrl_probe(struct platform_device *pdev)
 	if (!info)
 		return -ENOMEM;
 
+	info->dev = dev;
+
 	pctl = &info->pctl;
 
 	pctl->name	= "k230-pinctrl";
-- 
2.51.0



