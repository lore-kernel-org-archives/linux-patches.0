Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 604603B2FDC;
	Wed, 30 Sep 2026 18:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791515; cv=none; b=oIYT91D1GoOBDOqFBi/Lz0WqDVnwZ2EVuXF5n5mqA3trQtSBtB5lxCq4dszy5MHORhE73n9/bs0R72Hg71weL/JTI3K0cpVT0Kg9kjHiwgzqd8DB96ZGdeXcY7hAr2l/aMKro3Qdh89r8Y/XUyw1TGamcreE5Y6Q0GSCQA2cxYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791515; c=relaxed/simple;
	bh=kBJm7rbl/f3t/QUGs/uzRSeKt+IQMvMWzeZSXeujuAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uLAyz8XX70f1qDBSlWLGJpzKV326dKi9Ka/xwJCukEGGAi0Fr8YJj1qxaK/WH/K+A/sl4rQf76a9YhxRHSqIanN33oKCkoxbOf3jg5pN6oAdI/BYGfGq6eLvmKOvYq4uL4BCI5fCHIoW0N22c10hs+DvRcrrbcfzoRcW1oNNXVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TTMTh7OS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TTMTh7OS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D331F000FF;
	Wed, 30 Sep 2026 18:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791514;
	bh=g2HBQ2zlEz7QeU4k3nybiQoAdPhT98TnxCwhdLfW3nU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TTMTh7OSOzHEdtgqOanVfxBbX66IcgOnxWtjjr1RG1QAnQrFDpjMMCjRk41nyzWxs
	 AxAe2SkCCM+vipUoNLOQIeHuilTCxtHmrXtOKaz9BrAddZfKvv113TWOCTaN3dLYFE
	 L22Drra98H1G10Od08cu4woJrMQMKjAjWStrEzCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Zhang <yuz08559@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 330/752] vhost-vdpa: dont install the eventfd_ctx_fdget() error in config_ctx
Date: Wed, 30 Sep 2026 17:23:20 +0200
Message-ID: <20260930152405.437665632@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

From: Yu Zhang <yuz08559@gmail.com>

[ Upstream commit e74a9fa50749b9940b4fb13199652325e08d3c4a ]

vhost_vdpa_set_config_call() swaps the eventfd_ctx_fdget() return value
into v->config_ctx before checking it, so on failure the field briefly
holds an ERR_PTR:

	ctx = fd == VHOST_FILE_UNBIND ? NULL : eventfd_ctx_fdget(fd);
	swap(ctx, v->config_ctx);

	if (!IS_ERR_OR_NULL(ctx))
		eventfd_ctx_put(ctx);

	if (IS_ERR(v->config_ctx)) {
		long ret = PTR_ERR(v->config_ctx);

		v->config_ctx = NULL;
		return ret;
	}

Commit 0bde59c1723a ("vhost-vdpa: set v->config_ctx to NULL if
eventfd_ctx_fdget() fails") added that clearing, and spelled out the
invariant the rest of the file relies on: "we consider 'v->config_ctx'
valid if it is not NULL".  The window between the swap and the clearing
still breaks it.  vhost_vdpa_config_cb() only tests for NULL, so a config
interrupt delivered inside the window hands the ERR_PTR to
eventfd_signal().

Check the fd before installing it instead.  That closes the window and
matches how vhost_vring_ioctl() handles the same failure for the vq call
fd.

It also stops a rejected fd from tearing down a config interrupt that was
working: until now the swap replaced the live context and put it, so
after an EBADF the device silently stopped delivering config interrupts
until userspace installed a new fd.

Fixes: 776f395004d8 ("vhost_vdpa: Support config interrupt in vdpa")
Signed-off-by: Yu Zhang <yuz08559@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260807100025.19750-2-yuz08559@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vdpa.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 080413757eea3..08aaaaf488199 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -326,18 +326,14 @@ static long vhost_vdpa_set_config_call(struct vhost_vdpa *v, u32 __user *argp)
 		return  -EFAULT;
 
 	ctx = fd == VHOST_FILE_UNBIND ? NULL : eventfd_ctx_fdget(fd);
+	if (IS_ERR(ctx))
+		return PTR_ERR(ctx);
+
 	swap(ctx, v->config_ctx);
 
-	if (!IS_ERR_OR_NULL(ctx))
+	if (ctx)
 		eventfd_ctx_put(ctx);
 
-	if (IS_ERR(v->config_ctx)) {
-		long ret = PTR_ERR(v->config_ctx);
-
-		v->config_ctx = NULL;
-		return ret;
-	}
-
 	v->vdpa->config->set_config_cb(v->vdpa, &cb);
 
 	return 0;
-- 
2.53.0



