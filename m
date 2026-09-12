Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB632DBF75;
	Sat, 12 Sep 2026 14:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221958; cv=none; b=LFc77sy6BCx1TRJCjzg6QrdYFQ0qpZIE90xnmCXj09T3OopD9BNj+YmuXK7IRLR4pkfVRm5Bath/XHU3/GApX0xx8hS/e/HWw9ejdNNYV8oucUmiWPiAprZMqAMtoOWHnGi46LHNeXH3ebi9gf9eXcelx3ihYxK/WYJvcRjqbco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221958; c=relaxed/simple;
	bh=O3QIX8rZPCaPIHYgYQoOTBM4L69+tGcWSOsejjcRHZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PN8/ApoBVHWS2tfTF/KkqMQYKhvpBtLlj1xQMnzlng6Nk5rwcRg6ITumUATjhOsgAT6FrcccYbmP+OISroyamxHg6tb0QVQNwyrxhdwB9vZnqEuqMdJrP7NDHQFg6LJ9S4pHv2A/RI1RSPdL6atyf/ps1weAKtdqsSAOOf+IzEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e2Unj5Fv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e2Unj5Fv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97B7A1F000FF;
	Sat, 12 Sep 2026 14:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221957;
	bh=5G2qz+ZoedafdGyapjT98I4xy6ZsWKAEXR87Woxv3Cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e2Unj5FvuT6jKQTVP7QoSwWvnaCiPNBa1VHPXEIwGluWkNEzdy+zMoV0qDC1Fkagh
	 YmJMeR6ZkZz0/x2Iu2jjchoeTt7kOZLDoGiIrJbfzunDBLgTwAyihMKTsQ1OoEXKdF
	 1c1O3TvD3zQE/tHDnvUMTf2F9C9AIN0l0C+ashlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Dan Carpenter <error27@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 0445/1424] media: cedrus: fix memory leak in cedrus_init_ctrls()
Date: Sat, 12 Sep 2026 08:47:57 +0200
Message-ID: <20260912065617.251254511@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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


