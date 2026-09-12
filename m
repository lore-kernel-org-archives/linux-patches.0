Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0BC3B27D1;
	Sat, 12 Sep 2026 18:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237918; cv=none; b=JDG9wNn8GLkNWvPEIhnA6/nn3zeFYcHb4PUw0uSVIYkxs5vKw0npU8zYCHjqVJwqBE+HDGhQSpfpweQK9H6Vr/EFiojeVgu4r/Sj3uK5IyuwVaFhcc47XzKC6cU5eLbt/EU4kl27i9ewbEkOzqMUiVo7HUbxUsBJHXjpnt/DHjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237918; c=relaxed/simple;
	bh=9Bf2xwgC8PsM9RoTpRyXGvVHs7Qxu3BEkENIhcqAnPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqwVVlqWwORwNi65XzJ378Jt9WCxYadpMFCcuUJxDGvV4fa5pjv0S3x5IvZPrasewjgie+uoHIfik7eyCXcn3T/bCFeHZ0Y7Wjhc2ScDO4FfAdzMnt8AGAFZGuFQqX4zH2qSDLGUrBDzbagMjeDivWGjiKHumyx7bYfTJX0jpGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HemxLLM8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HemxLLM8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53DF71F00893;
	Sat, 12 Sep 2026 18:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237912;
	bh=EVcklKmrOq+ueVkvwDW5wiuXXXCYexxvNrsnleIKc80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HemxLLM8VM+3Rag07NPt8Z/lWZZeq0SQFjqMsfRX+o6dsTVXba+4Fp09y1PnU80J7
	 O1eSfpyfsUsF26dXoX7mI36aovh6wKiCP7yLbXhHvg60bD0fXZfWLN8LYQJav00XmC
	 ydzBs1gBxpIgKwT0V3oCb5+GgB4uRBHP9KNqzj3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Dan Carpenter <error27@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 311/935] media: cedrus: fix memory leak in cedrus_init_ctrls()
Date: Sat, 12 Sep 2026 08:55:41 +0200
Message-ID: <20260912065533.939817412@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

From: Dawei Feng <dawei.feng@seu.edu.cn>

commit 9df2fbe563194da1967a5db083442186c1323efe upstream.

In cedrus_init_ctrls(), the V4L2 control handler is initialized before
allocating memory for ctx->ctrls. If this allocation fails, the function
returns -ENOMEM without freeing the previously allocated handler
resources, leading to a memory leak.

Fix this by calling v4l2_ctrl_handler_free() on the ctx->ctrls allocation
failure path.

The bug was first flagged by an experimental analysis tool we are
developing for kernel memory-management bugs while analyzing
v6.13-rc1. The tool is still under development and is not yet publicly
available. Manual inspection confirms that the bug is still
present in v7.1.1.

An x86_64 allyesconfig build showed no new warnings. As we do not have an
Allwinner SoC or board with a Cedrus VPU available to test with, no
runtime testing was able to be performed.

Fixes: 50e761516f2b ("media: platform: Add Cedrus VPU decoder driver")
Cc: stable@vger.kernel.org
Signed-off-by: Dawei Feng <dawei.feng@seu.edu.cn>
Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Reviewed-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/sunxi/cedrus/cedrus.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/staging/media/sunxi/cedrus/cedrus.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus.c
@@ -195,8 +195,10 @@ static int cedrus_init_ctrls(struct cedr
 	ctrl_size = sizeof(ctrl) * CEDRUS_CONTROLS_COUNT + 1;
 
 	ctx->ctrls = kzalloc(ctrl_size, GFP_KERNEL);
-	if (!ctx->ctrls)
+	if (!ctx->ctrls) {
+		v4l2_ctrl_handler_free(hdl);
 		return -ENOMEM;
+	}
 
 	for (i = 0; i < CEDRUS_CONTROLS_COUNT; i++) {
 		ctrl = v4l2_ctrl_new_custom(hdl, &cedrus_controls[i].cfg,


