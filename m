Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F93557C704;
	Wed,  9 Sep 2026 14:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964023; cv=none; b=dmTOHS5E5P0dXr1jEYqTXXkK4lyJmwJ4eCFLayPivhybb+eC7jb1D+W3kMos9RRGIEshDDj1Jqk6VddE+ikQHPso1t51iDltess/aGkV7JB9qR6Bk1Umno9nGU9/jC4XmqZj1BcIIGhAFfqpgjOxQoFb4h3Pu4L+253Ntc/p1fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964023; c=relaxed/simple;
	bh=mZzzhTBGoLVG66NcOXhECp9mh215eJE+U511fxKLVR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rK7g+ipx7NZoGqsk9z0WsJvFDYaC3iKhBOrQgTb/eRDPRv7EM99jdujtLc2gy+WVpMl/n1aqhKgKq8USY3fCUGtduuINdT+JfiDTKAtnx/cSVFIfX7g4MNpTOXuvlZgp/kDLnnnmulNuholPPT+EetGFstcGDzfXDgWbFVGo0vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oh8WE0ob; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oh8WE0ob"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B668C1F00A3A;
	Wed,  9 Sep 2026 14:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964022;
	bh=Nv3e4DnoQ/WuL9itT+QM+ryeq5VKb8buGulekWeABIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oh8WE0obIkWKdFKwbWt/cujAT9vncidsDGl3G0RTKJdo+enyteusndlWYQiMGl4Gs
	 DvGDqBUgn4hSQHYMcVCGHks/knWJW2iMQ9w2dug6hQ3bG8tYhAq7z8GxAAuOJ6qfZC
	 WurW3mifgk01Xwh4eK7DXNCSN4bJpzbJiYhq3nJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Dan Carpenter <error27@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 281/583] media: cedrus: fix memory leak in cedrus_init_ctrls()
Date: Wed,  9 Sep 2026 15:39:26 +0200
Message-ID: <20260909134247.791410250@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -285,8 +285,10 @@ static int cedrus_init_ctrls(struct cedr
 	ctrl_size = sizeof(ctrl) * CEDRUS_CONTROLS_COUNT + 1;
 
 	ctx->ctrls = kzalloc(ctrl_size, GFP_KERNEL);
-	if (!ctx->ctrls)
+	if (!ctx->ctrls) {
+		v4l2_ctrl_handler_free(hdl);
 		return -ENOMEM;
+	}
 
 	j = 0;
 	for (i = 0; i < CEDRUS_CONTROLS_COUNT; i++) {


