Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424301A680C;
	Mon, 13 Apr 2026 16:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098538; cv=none; b=LTmPsqGB4Ahm+RGOmBNbpujsbFQLuPoEajottv9noLV7dvumvWH+Z9W1WN+816F6lGMCMAS2g2ZkH408p/Kv6r7wNVtU1s9Cd8IZukfdgrNw0mam6eHUgN6wgMjmo3WGlWHp0h0+MoJpxwP+//tEXdYCaKx0UNCmZGzwwfswcCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098538; c=relaxed/simple;
	bh=7x0ur7BY21ARBf6x7DfLRVGCOYf5uemMYLz7NozY4Vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=smZmxIxZUZZFP0DiPvIcHsOGLl849uGFElodZa/h4UZmLWRAv+GIa/9I6c8lSob4yNg30bz2K4qE7AvNT5tISCPirE3A46QNEYV0k/6qbInT9XTQEdvMG/Y+eNXNql78cFal7CKxYruKkCkxYIkzY7xRpFyIlXTLJTJbiPsQSg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tUONqB+J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tUONqB+J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB831C2BCAF;
	Mon, 13 Apr 2026 16:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098538;
	bh=7x0ur7BY21ARBf6x7DfLRVGCOYf5uemMYLz7NozY4Vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tUONqB+Ja/DGeYkOMKuNwZVe02wsasBuJPI2/6dA8+1t6cGjxc4UYecpam7RVIGe6
	 pWEb1AkZIL53Jk77HdSKEXWypjTyEnP97hOY5VjgI5Qx7ucNRl1S8gK5HJP55nm2qJ
	 uZmM1qb/PZfSqANvgvelJdbImMAwkVFCs1KV2yRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Stitt <justinstitt@google.com>,
	Kees Cook <keescook@chromium.org>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 563/570] i2c: cp2615: replace deprecated strncpy with strscpy
Date: Mon, 13 Apr 2026 18:01:34 +0200
Message-ID: <20260413155851.564562695@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

From: Justin Stitt <justinstitt@google.com>

[ Upstream commit e2def33f9ee1b1a8cda4ec5cde69840b5708f068 ]

`strncpy` is deprecated for use on NUL-terminated destination strings [1].

We should prefer more robust and less ambiguous string interfaces.

We expect name to be NUL-terminated based on its numerous uses with
functions that expect NUL-terminated strings.

For example in i2c-core-base.c +1533:
| dev_dbg(&adap->dev, "adapter [%s] registered\n", adap->name);

NUL-padding is not required as `adap` is already zero-alloacted with:
| adap = devm_kzalloc(&usbif->dev, sizeof(struct i2c_adapter), GFP_KERNEL);

With the above in mind, a suitable replacement is `strscpy` [2] due to
the fact that it guarantees NUL-termination on the destination buffer
without unnecessarily NUL-padding.

Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings [1]
Link: https://manpages.debian.org/testing/linux-manual-4.8/strscpy.9.en.html [2]
Link: https://github.com/KSPP/linux/issues/90
Signed-off-by: Justin Stitt <justinstitt@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Stable-dep-of: aa79f996eb41 ("i2c: cp2615: fix serial string NULL-deref at probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-cp2615.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-cp2615.c
+++ b/drivers/i2c/busses/i2c-cp2615.c
@@ -298,7 +298,7 @@ cp2615_i2c_probe(struct usb_interface *u
 	if (!adap)
 		return -ENOMEM;
 
-	strncpy(adap->name, usbdev->serial, sizeof(adap->name) - 1);
+	strscpy(adap->name, usbdev->serial, sizeof(adap->name));
 	adap->owner = THIS_MODULE;
 	adap->dev.parent = &usbif->dev;
 	adap->dev.of_node = usbif->dev.of_node;


