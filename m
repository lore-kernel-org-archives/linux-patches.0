Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165492F90E0;
	Sat, 30 May 2026 18:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164579; cv=none; b=RjVJJ4ezvEfOin0WJD5hn4bttfPKIqWXtGeLFGyaxOYodYn4PYSR2Zg8u256PmFDpiwKzNG1b193HijW67jt3con3bY0NeEMKrvXV8CPfZjmAGQONBCHI072OIK3Ph/VOpykwKD5AA6Nfhtgbu47KQyseNG0pJH2TvuXxFjx4R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164579; c=relaxed/simple;
	bh=AGGn5L+w9KRk/Ugf+OYDLmFsoP+y0upSskkYsUiTR0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RWGBDSDUG8BDRm+8ejKhMbE4bVk8ClTE/2s7yPboJrzLVKAWi4I8u4bhz6erqlLL7alr/roAJ+q31/JIs3KPadRoW3WQqqGkPBVP0lOFjA7lYS4x/0KMHMo5Kp96EcxnK2yboQX0DonznuXiuJW8buCTy2/s/UGdAHvwfSjNB84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RU6f1sUe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RU6f1sUe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B5A21F00893;
	Sat, 30 May 2026 18:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164578;
	bh=4QkgSoMRTh7CmsyHdgcO7JnyaTHQw3dQ8xsSHFq0MVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RU6f1sUes2EdlBrj0tCmKZR1bTnqFCOZ2BN/1clEgKDBOkuzhhoDkBgSVYfYtF9hs
	 lp6dwYxWxBNS0ox3U1iNgTImabsS8x8tK0QK9YCz/ugjAEEAuH9EvNqZxpKeQdHRNJ
	 9E/FoCHdSIhzszDHDWQ20m+qfXWxA8Ca6KgTGXNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 597/776] mailbox: mailbox-test: free channels on probe error
Date: Sat, 30 May 2026 18:05:11 +0200
Message-ID: <20260530160255.470191561@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit c02053a9055d5fdfd32432287cca8958db1d5bc5 ]

On probe error, free the previously obtained channels. This not only
prevents a leak, but also UAF scenarios because the client structure
will be removed nonetheless because it was allocated with devm.

Link: https://sashiko.dev/#/patchset/20260327151217.5327-2-wsa%2Brenesas%40sang-engineering.com
Fixes: 8ea4484d0c2b ("mailbox: Add generic mechanism for testing Mailbox Controllers")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mailbox-test.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/mailbox/mailbox-test.c b/drivers/mailbox/mailbox-test.c
index 29c04157b5e88..1d546cae922ce 100644
--- a/drivers/mailbox/mailbox-test.c
+++ b/drivers/mailbox/mailbox-test.c
@@ -405,18 +405,27 @@ static int mbox_test_probe(struct platform_device *pdev)
 	if (tdev->rx_channel) {
 		tdev->rx_buffer = devm_kzalloc(&pdev->dev,
 					       MBOX_MAX_MSG_LEN, GFP_KERNEL);
-		if (!tdev->rx_buffer)
-			return -ENOMEM;
+		if (!tdev->rx_buffer) {
+			ret = -ENOMEM;
+			goto err_free_chans;
+		}
 	}
 
 	ret = mbox_test_add_debugfs(pdev, tdev);
 	if (ret)
-		return ret;
+		goto err_free_chans;
 
 	init_waitqueue_head(&tdev->waitq);
 	dev_info(&pdev->dev, "Successfully registered\n");
 
 	return 0;
+
+err_free_chans:
+	if (tdev->tx_channel)
+		mbox_free_channel(tdev->tx_channel);
+	if (tdev->rx_channel)
+		mbox_free_channel(tdev->rx_channel);
+	return ret;
 }
 
 static int mbox_test_remove(struct platform_device *pdev)
-- 
2.53.0



