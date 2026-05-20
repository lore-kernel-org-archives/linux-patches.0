Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D663E5ECF;
	Wed, 20 May 2026 18:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301305; cv=none; b=HfnHzdd1oQHukCcJbNRAfI3ln+KMO5Vo3pxPK3wKnZqs8hvDChWxYGKugmyddN7kLdljGXpKSgB09J3PgFBzbq5v200uFJnIisDCrxLTSVGiXbzCsZUNNKwOJbW9vEQyfE85UCLwnLNuh6XcwLGshXaLbZlrsPD5HAOEgpixAC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301305; c=relaxed/simple;
	bh=F9+Ml0tK15i+A8EnOYQ6t8CyF5u4sHipY1WHWfAgvIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OEc0vjk9aHC1Q2qy7ZFyAu29VST040FoGT+LEny5/CldcD1o4sAqAdI5hsAqEvYbXGV6MMhE7VEeXCD2TZIVznECBecFSXlEmFKzeoeOT7KYer+0a0baBXl0lFnMvdr/d43svocDx08aC3MgJJ1I/0GZ2NjT+SdX/uQqjgq5LPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jTLPkO4M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jTLPkO4M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F3F1F000E9;
	Wed, 20 May 2026 18:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301304;
	bh=JWpxECjMjhgvmoZ0IjtBxA6Xc8Q21HXFyP1mzEpNZoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jTLPkO4MPSU/9Le7ZY3lFEh2Cg283OAWn9Vc7nJqsz3F7HN6bnx/luo1yrIS870lz
	 au+PFjKfvxFlXBltkY1CcIgCnQC76IVW604MP/twRc95mmX/SnP2zTqxx20wcQDAl2
	 ue8I98wiEx4KfqniH7BzfITGpQBnXxrPngfiLc1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 504/666] mailbox: mailbox-test: free channels on probe error
Date: Wed, 20 May 2026 18:21:55 +0200
Message-ID: <20260520162122.185042309@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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
index e416ce9e2d674..2e0ce6c590485 100644
--- a/drivers/mailbox/mailbox-test.c
+++ b/drivers/mailbox/mailbox-test.c
@@ -404,18 +404,27 @@ static int mbox_test_probe(struct platform_device *pdev)
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
 
 static void mbox_test_remove(struct platform_device *pdev)
-- 
2.53.0



