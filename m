Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86557DA78;
	Thu, 15 Aug 2024 13:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728624; cv=none; b=g3/gVb93NHf+xpeFjQaA2J9bCFF1aFxz3e6+467DhjLm7laS6LV0Ze2r61ZApuyYH6pDB4jK0hmLHav6pslPkNetlFqVTm476b3I4OISb1ae6k6Db5SI8eQFXOCbjI992R6On083CwRKfDeox2/g9QSDZ93+XfFma9zOr9ftbeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728624; c=relaxed/simple;
	bh=p4cjXYmh3uv3pIvNz2I+SomcSbll7QlIz8qFfgpdG9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IiJCrsLjeSD11sLz71V6dxvHLQVKb6ssqDz1ZNjCljI8f8ESzuDIeDfYRUq4I+cuzvIInJLt2CSK4uBxw5cMTZOAyyvoeaPYDyzsv3aJWoxWpabO5DKeM15ojqHmheoA0N0Iy2K0cbURGF0pCnAOVoFXzqs2mnRYiasx9AO0Hlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TA7t+421; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TA7t+421"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C6F0C4AF0C;
	Thu, 15 Aug 2024 13:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728624;
	bh=p4cjXYmh3uv3pIvNz2I+SomcSbll7QlIz8qFfgpdG9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TA7t+421uvnRyBK+Kr1/pOHWMiuC8MzBxWpgEoR0dnpSxXx214Y8C/XfBG48Nvqox
	 Bp5QYMc6Ml1hh/XQf3k/SfBrbBg3REIc1ojugl/1w7NuPxvCMKPtpjUceWQbwb2F/c
	 U+aBisPxG+kUH7EkWSUrwqX/CYEBiz2FMDblSOVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 059/196] pinctrl: freescale: mxs: Fix refcount of child
Date: Thu, 15 Aug 2024 15:22:56 +0200
Message-ID: <20240815131854.335141864@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 7f500f2011c0bbb6e1cacab74b4c99222e60248e ]

of_get_next_child() will increase refcount of the returned node, need
use of_node_put() on it when done.

Per current implementation, 'child' will be override by
for_each_child_of_node(np, child), so use of_get_child_count to avoid
refcount leakage.

Fixes: 17723111e64f ("pinctrl: add pinctrl-mxs support")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Link: https://lore.kernel.org/20240504-pinctrl-cleanup-v2-18-26c5f2dc1181@nxp.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/freescale/pinctrl-mxs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/freescale/pinctrl-mxs.c b/drivers/pinctrl/freescale/pinctrl-mxs.c
index a612e46ca51c0..c48b6fb5e8fe7 100644
--- a/drivers/pinctrl/freescale/pinctrl-mxs.c
+++ b/drivers/pinctrl/freescale/pinctrl-mxs.c
@@ -405,8 +405,8 @@ static int mxs_pinctrl_probe_dt(struct platform_device *pdev,
 	int ret;
 	u32 val;
 
-	child = of_get_next_child(np, NULL);
-	if (!child) {
+	val = of_get_child_count(np);
+	if (val == 0) {
 		dev_err(&pdev->dev, "no group is defined\n");
 		return -ENOENT;
 	}
-- 
2.43.0



