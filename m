Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B950210FB;
	Thu, 15 Aug 2024 14:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732343; cv=none; b=MKGCq5OCdF0GGEEd8SilcFEQO6gI8CHgRAtXXGV8pODh3RaEk6gMbahJ7QQGiqGMbQOwv6ZmGjBrF9lUUyXKVKwr7QGzPWVLVjQ0Fe6Zq+IVegCiyUrojHpRqHnzgTyEjPyHvxBHn1EHVLMn5rhzngnUTqw8tM5mijQD/dXQM+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732343; c=relaxed/simple;
	bh=Tu9MRo3PHV3rwQwgDzfqbvIL3kFX31j/g25oEmuMa1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nktFga3lJK1rMl3TkXiDWOk9r9mwoGIv6DHXdtgn1Rgb0SawsSVAXKOZclO6xPiohIA13mTJ6OrWXvWgR55sgGsyzSMPt77vABBnMrh/dYogqTgTNOIf6GgN5dNshAySBfx3NQrbtBzYYs2J2IDjSPYZPPOLTtfQepoKAwHKsSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AlFt7UGz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AlFt7UGz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 763DAC32786;
	Thu, 15 Aug 2024 14:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732342;
	bh=Tu9MRo3PHV3rwQwgDzfqbvIL3kFX31j/g25oEmuMa1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AlFt7UGzNeTmfqYtOk7W0LQvSFWVyte0yK0p6AWhu+F8W/nnPduPllaNCYRJijLmG
	 m0fyXBrdBBqpgGU54DxuScfu3js3z799BQg1kKGdSYYfnOgecV6j1y3Fl0Ws/xQWvq
	 HZ0vk4qs0VfqSsCqSSOjYo7yyoj0usdnUNKbPnxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 119/352] pinctrl: freescale: mxs: Fix refcount of child
Date: Thu, 15 Aug 2024 15:23:05 +0200
Message-ID: <20240815131923.852409671@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 735cedd0958a2..5b0fcf15f2804 100644
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



