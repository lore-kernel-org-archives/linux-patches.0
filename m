Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3670E332EA7;
	Sat, 30 May 2026 17:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161784; cv=none; b=Tp4v91VqtAst+AQONG3aZ2cHDgeVLl5zHoUSb5rIp4M2EG/yFEsaeGoXmoQi9z0kWOObfbJP5NV0tWn94v2M77Pw77hpuCG5AW7AtwBiqmaIdUrCBUWFl/4lkSIguTUrQsds63kZFRcN33aDKjrBhsjnWvwCBHDk2hdGGBDw6d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161784; c=relaxed/simple;
	bh=DE5pre0QbeL9N1JPf0hxzMatosNig02i8iuviD3bjhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VqxwpBV6nt0Txp/F5aYgy6aidi7I2L9BL5lKHgdPE94gP9UH4TdG3JSAdwGdwsj2Bn2MSZBVQnEBsOewH14MUzn4dcFQrp7P+8b8g00FjaUCDh5GmteRjJfLsQ3Q1RN8kh2yDz4XfRmEMzSeas9u77jtknAvKkTmlpH4rgU/ouY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W1WhYtWQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W1WhYtWQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BFD51F00893;
	Sat, 30 May 2026 17:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161782;
	bh=wOSPwq4pCL3QpJ0TD7U6GMfJVp0HX6WyIE8s6+9vtsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W1WhYtWQ2oGzcZX8pqhPJMMJ7w0YXhEfVK6L4N9y1D5+PU6GlvKNxFeXjfy5kiFew
	 y/lHkpgaTUjsOgS1Htw0yIvy0PiU3j0dqlGQqhw56RmvVF+Ty0ewD28rc0e7T+0oTQ
	 V2ZgUqJY0j0FD7w+/kbXqWWokQCVg9xTRddZVX90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 725/969] mailbox: mailbox-test: free channels on probe error
Date: Sat, 30 May 2026 18:04:09 +0200
Message-ID: <20260530160320.562482961@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



