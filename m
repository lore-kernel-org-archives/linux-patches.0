Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A40E13B2B4;
	Tue, 27 Feb 2024 14:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043796; cv=none; b=IA3wstrzRzo6bqH9i2iUqDzPnYbDkOlNx2OVTtByz3UYATTLG+Pi7/QQtG0qtgGQ/Hn5IF9mA4FA4C87/AoBBUmOQJswzE6h3OVM3Wr0dH0U547GbqkDacwSFU4uoeL+V+EffU0pWjWuM0TFqUvKSFYLmKZM7oOc9CTkOYEIeLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043796; c=relaxed/simple;
	bh=0pFJ21Iz9XeGQTgFJd77rbQWY4E/LP/+3m2LI/zaxAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qbO6DDysx9h/zcbpNJ+qCUc9krz9EQ1bR8XcrYUEY1f+Y0qJiVm77YxIeIPPEnjl2MBIje/pC6Dre66xCkEJQY6kM2jL+O/2pkw4yL9QoLe3+0AsWxHu5+veX/lP9tDHfgXrpXuDmmU1KicvlouHsVMs+p1DhZH0z/PYgHX8ve8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NbLeHL31; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NbLeHL31"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B43DC433F1;
	Tue, 27 Feb 2024 14:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043796;
	bh=0pFJ21Iz9XeGQTgFJd77rbQWY4E/LP/+3m2LI/zaxAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NbLeHL31RnImD2Sxu0QOb/2il+jPElpUzur7QmkyXdxAp7ruJ9WedCsc518Tal8SL
	 mh5epLbkCbnYi6adF6axnt1e3Jlg2ihu62mWmqke+UrtZccv0+6QJjW4F3xgXCvuc2
	 4Lmq2WA7iCLbVXF2qMkbXepBbTv+KBT7lK999X3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 38/84] pinctrl: rockchip: Fix refcount leak in rockchip_pinctrl_parse_groups
Date: Tue, 27 Feb 2024 14:27:05 +0100
Message-ID: <20240227131554.112437447@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131552.864701583@linuxfoundation.org>
References: <20240227131552.864701583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit c818ae563bf99457f02e8170aabd6b174f629f65 ]

of_find_node_by_phandle() returns a node pointer with refcount incremented,
We should use of_node_put() on it when not needed anymore.
Add missing of_node_put() to avoid refcount leak.

Fixes: d3e5116119bd ("pinctrl: add pinctrl driver for Rockchip SoCs")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20230102112845.3982407-1-linmq006@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-rockchip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index a44c2680c4230..9388d6fac7d40 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -2536,6 +2536,7 @@ static int rockchip_pinctrl_parse_groups(struct device_node *np,
 		np_config = of_find_node_by_phandle(be32_to_cpup(phandle));
 		ret = pinconf_generic_parse_dt_config(np_config, NULL,
 				&grp->data[j].configs, &grp->data[j].nconfigs);
+		of_node_put(np_config);
 		if (ret)
 			return ret;
 	}
-- 
2.43.0



