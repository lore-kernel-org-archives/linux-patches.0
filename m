Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1D94F5E08;
	Thu, 17 Sep 2026 17:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666038; cv=none; b=d23//HjpIkyfBBavooPJYJdrln7RauYgaCIdbaiwkHmM9rkSdPv/99nNVQnluOX681fVdPkabydtc/5v7qgKUkTBy17S+fRwheOn771M7abLlafuFajM5iQhayUDrlS9iaPG6ePoV5RUtOt2KBMrSNhQufJIJ16AobWaRQVMKVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666038; c=relaxed/simple;
	bh=cq+9ISvm1wSXjeMp3KNxDlPFLx0S3aLFB2oxZNRkBmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uZDrbVGmYJDvjgjFUQ4CYri9gIwh3M1WCuRD/Xs/lLp6cCHg0JozEDbWDuDBGgd9sVSPaVT9OMUb6TEwhS3W55FzsVpKd/MT9p1MUD/9DBRDDGAQJecw2cRb+s7WQy/OD6+eh5vuJOaMZLpKAjsiI5LkWlNbsPgP0h/A3G5OWyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Flz5Z1RA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Flz5Z1RA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77AF31F000FF;
	Thu, 17 Sep 2026 17:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666037;
	bh=MKxifP2s9/028gSeVk58j8MbZcWJ07oOkDBoEmekq2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Flz5Z1RAh4c5pn4TQ2sBSlMlmokvNx3AurxTYxNpRpU0XR0T3RNvrDR9K68v5BZkw
	 PCRApmyw6LKc5U6sdfK2dI4p5KLRg3lSstlE7byF9pZA8Kksi5kTKrdmCx8RqkcPKl
	 5IgJOAK20Ppy+zzlAxl1SDZi03+K8EsjtBCxPI6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Zhang <yuz08559@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0855/1250] vhost-vdpa: dont install the eventfd_ctx_fdget() error in config_ctx
Date: Thu, 17 Sep 2026 16:10:50 +0100
Message-ID: <20260917151615.143515553@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 068fb6aa33fa7..0d0206862cced 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -539,18 +539,14 @@ static long vhost_vdpa_set_config_call(struct vhost_vdpa *v, u32 __user *argp)
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



