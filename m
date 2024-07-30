Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C854C1A76A5;
	Tue, 30 Jul 2024 17:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359508; cv=none; b=Go2kG/ZhPkOW68P32BgM8XDtegFdbOtXafbExuGXY93PQzMqr60vAicwVszm0v2OwLIHkuh6po0f4puO2y1z0H50MN3zaIvzewGozf71XxTn9Ae6/dWv33yzSE6w1E94uP99Jl9fVnb+nWXt1bitdR4M7mmBafvp9tevi2xcBd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359508; c=relaxed/simple;
	bh=Hw2YM5c29vmFNx3+5r0KqHOsTdQ8ZgQ3yuknNG1F1Rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IFVDUQhrOChe28iVDZvtnARv1/0RpkxCS6zGyuWAJGncYa7zpnjS6+xzODgbhoy5j22NpqGNIe/N3UtQBoqChuPjXAIjsaBnwag0H3EFPoAu3IKXsfU9pD7nuilvyqWstILypRh0DqdO7V8fePSojOqXl2qUQP2w033OlhUFI/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZiXGT0io; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZiXGT0io"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F46EC4AF0F;
	Tue, 30 Jul 2024 17:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359508;
	bh=Hw2YM5c29vmFNx3+5r0KqHOsTdQ8ZgQ3yuknNG1F1Rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZiXGT0ionF6faZ302oRxmhJWLrzgkX2tusHAVUNiQRvpaDqOiEw6iBrTPpDlMOWD8
	 /sR4u8aK99iuhbuCy+ebIHV0mpd5lFoe+p91ncO6ZnLP3SSQ6sE4A8nt0ArHq+362g
	 8vKmVR+12ai55mvQLkebznumPOOGePRefvln6VTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 494/809] pinctrl: freescale: mxs: Fix refcount of child
Date: Tue, 30 Jul 2024 17:46:10 +0200
Message-ID: <20240730151744.250485813@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index e77311f26262a..4813a9e16cb3b 100644
--- a/drivers/pinctrl/freescale/pinctrl-mxs.c
+++ b/drivers/pinctrl/freescale/pinctrl-mxs.c
@@ -413,8 +413,8 @@ static int mxs_pinctrl_probe_dt(struct platform_device *pdev,
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



