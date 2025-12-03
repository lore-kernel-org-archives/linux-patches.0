Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E91398F8E;
	Wed,  3 Dec 2025 16:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764781123; cv=none; b=QkVy+fPmQl8vhmfTgNvhVWNkuTXKKiQOqkqxJhb5Fb1Ycmyq3v6oGf5+i/4SxZSlheknEd7GzVTubMEGesAZfkgzHvjdjCLSTdVEP8B52ZtAgGSXd8s3IgUbI7gP4nBuvypSR33vLGr0Ey6UYqRNP3pcVu9Cl/T10Py1c/Vp3eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764781123; c=relaxed/simple;
	bh=vUXITbxY7snyLtM/i0Vv1dhiU/LtO+N69QPQj+L8Edc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sBLnMgIzrlWJJ7hyLoMoFLoCBBHe1jjjuJ6arRJYfvhVfLFVHc3GlD+S3H9+JxYYZlVxurKj3s1flEMnJI4K1KJrtdBrJ/CQMeyC1UQLcofPVmFtUrJDkKu2blbQh4OanKSeI4aZtxHNwZldeFRYOizexlPAtwZemeJsaPTB5/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o5b7lY3v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o5b7lY3v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28716C4CEF5;
	Wed,  3 Dec 2025 16:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764781122;
	bh=vUXITbxY7snyLtM/i0Vv1dhiU/LtO+N69QPQj+L8Edc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o5b7lY3vKKC4+6D52gffZn2X4zZwYezkwAB4wnJFdDKRiVdi9TLKdY3YJC5E6c5un
	 7+fv206tf0RshL1wkUhdu1t6JvMtTMJJs+KQI1saEUcTYTtrkT99NiFM0XGi9XGDWQ
	 +Fu4azSkXzKZVdo7oXkeCzwnMI2ZmBo+UHXqnV/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 23/93] mailbox: mailbox-test: Fix debugfs_create_dir error checking
Date: Wed,  3 Dec 2025 16:29:16 +0100
Message-ID: <20251203152337.370722269@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152336.494201426@linuxfoundation.org>
References: <20251203152336.494201426@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 22d6018ceec3c..6bdee87f30836 100644
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



