Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0C31ABEAB;
	Thu, 15 Aug 2024 14:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731300; cv=none; b=E5+4g7E8x2gdvfTD3cIYB2QzM5rYSN1E9J4YLVl8JBM102sD0nYuvEy83a2AgNueUBhB9MEZJmDcucvR5vsbMeGyqfZjhHtan2PzDj9pjoALFnGcc3Q1ymcYUBs93tcgd5+CL+gd9/bBISPRaNmGvUSjJi0We1gSIOPSHjTc4qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731300; c=relaxed/simple;
	bh=pGIT5Hl8UdAH88P/flt5O+fZsiVHxLi1C6e+U4oEPHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PgSpH9BfkNob+DcI7nJpvFvsktkP2hPpiQte5sil4tNynDaqVtiibJf9zVXT/D5lCI8JyFMzj9mArzAcI+NVKleu+vxhNRELXgnDwqErVnUXwFAzwllvs9rnu4S44+IqJotqiGQtYr7ZZImN9G56RqKFCvTj5j3SqwBpT4UQT08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xSaBHPYi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xSaBHPYi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8AA8C32786;
	Thu, 15 Aug 2024 14:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731300;
	bh=pGIT5Hl8UdAH88P/flt5O+fZsiVHxLi1C6e+U4oEPHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xSaBHPYiUp0/mgtc18GMZcmpGI2kxZAySzARYOlZXANK1/EVhBmT6YRVfGTbKjy31
	 LJod1HamXkoaGad6uoqcHdkgHZZxVem2kYZpqqppPGmYcKi7BFHGLuqh9zRvlzTfe3
	 k/KU8U3aAmTz/o6U7jeCmpiW0V+mBE/P/zpG08jY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 085/259] pinctrl: freescale: mxs: Fix refcount of child
Date: Thu, 15 Aug 2024 15:23:38 +0200
Message-ID: <20240815131906.083569696@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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



