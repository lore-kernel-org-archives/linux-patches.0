Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC43D30FC3A;
	Wed,  3 Dec 2025 15:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776704; cv=none; b=TltIdx7J1ItM+2DVAt1Z+fe9qvfBtzHtvuq3ibcYkVI7ctsdWmOgwJv3rgzyMfWevfSovn/DD5P71Rj7NRj2lVonrlgZ6c24ZlDdbmjSldo0lRmCsSLRBP0dvn45ZKo5hxqUx/hGbpMX6C6IGz3hATOo+Um8FD/6rgENd+eVsH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776704; c=relaxed/simple;
	bh=VYgisZ3wB4EZJ20LJtOAwzljpGhYCjhmKTHA4piY34s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RPFzLk4gFDNy9V/kYoWJeDdEZg/LBNQfEfPBfiA5hJEGXowJTb8orPnd7C/XQdm7ZgbiIA22i3+Xw1YETVOxDd6hIALO3fMwIdsgK64QgfNNNIw87I/3k0zckh1bxvg5XAeyv2kSoVXnVCmVxRpB72sgbhW08KN84Wu2pUdTOuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wtYzCl1n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wtYzCl1n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9B7BC4CEF5;
	Wed,  3 Dec 2025 15:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776704;
	bh=VYgisZ3wB4EZJ20LJtOAwzljpGhYCjhmKTHA4piY34s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wtYzCl1nx5xO0MeIEYJo7NRaZF/oiu3nzwYFAFeWZ891N62fCDe8td91JY2b6cmtZ
	 03qXD1UaCxNmbSvHVKFJGlv5jP8CPWFgsjjFyHR+7iKI+nhhdtXvGHhVqrI5Ij6zf1
	 IZT2uwa2diKGZLbdIye+bayok8RMQ5690Hh8uuJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 262/300] mailbox: mailbox-test: Fix debugfs_create_dir error checking
Date: Wed,  3 Dec 2025 16:27:46 +0100
Message-ID: <20251203152410.343939781@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



