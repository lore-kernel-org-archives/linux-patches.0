Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E21E350A00;
	Wed,  3 Dec 2025 16:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778533; cv=none; b=S1YGCplcNTUPgZoi4kBlvkglRGm/HbDq5/5bdyCNqhYFX6fre+MXaALuicyLztQ0c5FpQomQDEoHxbd86JlqmKdDjq1j4+voyV0ShimrA/BZBXxoucFBu98xst+IQ1OSt3sP1d6B69sBmkuRGbEHM7BhJ9VRmQbwZhBr3P/tIRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778533; c=relaxed/simple;
	bh=77FhJCdW4+o79GEnTOeS3Tvyg494AoBlogM+gPEoHuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qayjxLwp1bI4aiplWbf59tdrK07oopz0ZY7YeoeIyIIkkzCo2g9CRpJc63H9HZruC7P+os74cLA0K4MZdZ+ZvaRHxFGO0ClQJjr9uJ2A2KdwQsR14B3+bLVQXy5Q1FncsqJAwOigweNdW1NKXp/hWaWx/6+YDrpfZcdRnYVM5Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AmCSc/Zr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AmCSc/Zr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AFD9C4CEF5;
	Wed,  3 Dec 2025 16:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778533;
	bh=77FhJCdW4+o79GEnTOeS3Tvyg494AoBlogM+gPEoHuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AmCSc/ZrgapuRr0DKXXW+KxWLlIlQvtn+tjuAB52RP/Jbopd880dJa37/8axDj1Dj
	 MeQP3OcmdYsQBXGXBoSIjdPrW7Kn8IubhtOQo9VP+O2FrJUNH/AAZKAqZq9DGwIe1b
	 2dXkE25kP5A6U2VF0/OeMg1zrUJJR7yQ64v7nVto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 347/392] mailbox: mailbox-test: Fix debugfs_create_dir error checking
Date: Wed,  3 Dec 2025 16:28:17 +0100
Message-ID: <20251203152426.936776750@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index abcee58e851c2..29c04157b5e88 100644
--- a/drivers/mailbox/mailbox-test.c
+++ b/drivers/mailbox/mailbox-test.c
@@ -267,7 +267,7 @@ static int mbox_test_add_debugfs(struct platform_device *pdev,
 		return 0;
 
 	tdev->root_debugfs_dir = debugfs_create_dir(dev_name(&pdev->dev), NULL);
-	if (!tdev->root_debugfs_dir) {
+	if (IS_ERR(tdev->root_debugfs_dir)) {
 		dev_err(&pdev->dev, "Failed to create Mailbox debugfs\n");
 		return -EINVAL;
 	}
-- 
2.51.0



