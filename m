Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7FC132C94C;
	Wed,  3 Dec 2025 15:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777005; cv=none; b=O74IJ8b/h3j+CjHvPtHVUok6sZ3zWAJrEvFkud3hUO+P7IBujJtuGdlDDZ5Pnlyu41nIE0s+GAcxm+rBkS1lRPrf+VdsL58S/qdAUKZSRQ50FezffWQxgZMOeLxCV7rzVt3TndR4VBR3gcOibA12jNZ0+xk6jPBFm3rdTvcUX+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777005; c=relaxed/simple;
	bh=BpUpDgwBS9GDImFe9QJALAG2uDFIMf0nhUhG/vohyXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IT/gFeHVdbE44AbJvj8agAsE7JyA3WP48scDHeSviA4n/7q9KDqZKMbXtEa+XdoeXPC1vB6udjeRWBevi07kb+pCzY6Zznpy9LsY9gGFVpzYzDE5AtXwPGf+WAdYbsy0AxaXvz5vhp5naTDxG4DROUuA8G5YBeAwg7gfWOqgbEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k7upv4aI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k7upv4aI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E39D1C4CEF5;
	Wed,  3 Dec 2025 15:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777005;
	bh=BpUpDgwBS9GDImFe9QJALAG2uDFIMf0nhUhG/vohyXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k7upv4aIwMD/7qwmBZI4w4K15yxLdg83cbFgI4Ft8d927tQtKzdxycpiK+9Uiov+I
	 gEwQ4hvIju99ZVozZwn/N3N5QOS0Ermu5DgHQ2HMAfHNFfUpsL4IegchUTl7WGccem
	 72e8yVFGcH4FzQe6lK+5gY14Etf87ONXoJqvLaSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 036/146] mailbox: mailbox-test: Fix debugfs_create_dir error checking
Date: Wed,  3 Dec 2025 16:26:54 +0100
Message-ID: <20251203152347.795815257@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index c9dd8c42c0cdf..3a28ab5c42e57 100644
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



