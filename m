Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48722393DF3;
	Wed,  3 Dec 2025 16:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780709; cv=none; b=ZZqg6N26l77W407SxX6+W+qyiDkqJY6Fd0USenhBWv/xOcaAqZ1wLyuclhpvzV0zi84W3uZFitfR86IqeN44QkYAPNY4gHb0oP8svT3cflx/GiUZxIfCFkx3ZMnLxuANzh0TEv6EahpHU9EWGOq0J+SJaq6woT5DO2c/ObINKnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780709; c=relaxed/simple;
	bh=8scz4mH918d3q539Jm8a78LzLjmSoC44lJJtE9MOSJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IMTGpzUOefU7NnELW9PIKQVloCC66mWztAfPg1Twe0JfpTlx2wJ/Dk3Pd+d92dv+TGISEob+GAPmPhXQkV6k5Du0BiBlfWOPAqOYyDrvu7pBAvKLvhMbGNJ88V8x50Jp4yASTKvKUUMXbwXo/JKnzXdOnLj0wBXWKPWc6Z0m35k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VhyXI8Z1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VhyXI8Z1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A38D6C4CEF5;
	Wed,  3 Dec 2025 16:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780709;
	bh=8scz4mH918d3q539Jm8a78LzLjmSoC44lJJtE9MOSJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VhyXI8Z1tIjQn/iHy9vEQACf5poclLxc+ZEYbMP1tj4o0zGpF+UFGVP4aEMizkPhS
	 NTm1EQfNxnj2Mf7ivV5hhrsZeTZz0uIrFBw05Q7amnJSgIHHjoy1jBQDjputgcMTPp
	 WG1yz7FBaFbb0JxoVbio/WTkG8Pcm7riTdqrUlJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 034/132] mailbox: mailbox-test: Fix debugfs_create_dir error checking
Date: Wed,  3 Dec 2025 16:28:33 +0100
Message-ID: <20251203152344.561478193@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 3acf1028f5003731977f750a7070f3321a9cb740 ]

The debugfs_create_dir() function returns ERR_PTR() on error, not NULL.
The current null-check fails to catch errors.

Use IS_ERR() to correctly check for errors.

Fixes: 8ea4484d0c2b ("mailbox: Add generic mechanism for testing Mailbox Controllers")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mailbox-test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mailbox/mailbox-test.c b/drivers/mailbox/mailbox-test.c
index 3386b4e72551c..e416ce9e2d674 100644
--- a/drivers/mailbox/mailbox-test.c
+++ b/drivers/mailbox/mailbox-test.c
@@ -268,7 +268,7 @@ static int mbox_test_add_debugfs(struct platform_device *pdev,
 		return 0;
 
 	tdev->root_debugfs_dir = debugfs_create_dir(dev_name(&pdev->dev), NULL);
-	if (!tdev->root_debugfs_dir) {
+	if (IS_ERR(tdev->root_debugfs_dir)) {
 		dev_err(&pdev->dev, "Failed to create Mailbox debugfs\n");
 		return -EINVAL;
 	}
-- 
2.51.0



