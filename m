Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58B614831F;
	Tue, 30 Jul 2024 16:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358178; cv=none; b=f7t5W04VkUjhxKZxbXmvKK0mOfCqWKas6dmSELgLk7k95opyPaW6Fbdub1rd1423B6KFYKqukfM54uSuZPT6itdsxEw6IZKwZdo6ATYzruLx+aiipdkZ6hJ1gBkW9/qC4Vxy4CJAfB8Kz1DoR1UzkOoUvJ13psczdIxhEN87hsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358178; c=relaxed/simple;
	bh=ZFsF/vOQedZ3U2Opq8kh3cgkUZSB6J2q0rq19uJr0c4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SqF231mwKSfxdVZvictbMkia5PS9XaqsaAYH6s6YI5WQrYAbY4T9+h3xZDVpzwiIF5PcsRoDPFoUGYE/OHqlE87rUo+1ixMAvpZfhz8ubVj3NqH/Uyi9K7r+WfPuTQ6+Z9qNOPnjWZ9xt2HhTHj+bFWHXmBc3/KV/jKzy0VmZ/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dU9TzFZc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dU9TzFZc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92910C32782;
	Tue, 30 Jul 2024 16:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358178;
	bh=ZFsF/vOQedZ3U2Opq8kh3cgkUZSB6J2q0rq19uJr0c4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dU9TzFZctwpdWhv0KB3AleSBGyyVR1Y2Uqiq2RX6xNeYDtYm4ITBwxshm1DRvwKvw
	 rbfY0SvrwVnZ8zcImdRauHkClFqnoLkeS0z5lJimvJVNSxE5NnB1K/zlB9OotTh433
	 Xk6/Ng/w/KlYkfwGd13L48W4/+TCgcMH3WxhICJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 330/568] pinctrl: freescale: mxs: Fix refcount of child
Date: Tue, 30 Jul 2024 17:47:17 +0200
Message-ID: <20240730151652.770887798@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index cf3f4d2e0c168..a53287aaa653d 100644
--- a/drivers/pinctrl/freescale/pinctrl-mxs.c
+++ b/drivers/pinctrl/freescale/pinctrl-mxs.c
@@ -408,8 +408,8 @@ static int mxs_pinctrl_probe_dt(struct platform_device *pdev,
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



