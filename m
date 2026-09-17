Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716524B7A4D;
	Thu, 17 Sep 2026 15:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659712; cv=none; b=uT9KSTKtXCL3KR5sRhZkwJLyQirQGaZ+Gi7vvebD0YQBz84Yh7a0NaooXoiayD8EvqhCIY8oM/3n8f1qDZ05uFivIOGTwvm0MwOnYp3o876lPzOMQvZo8EM/geWcpiqYWfKCyd00sT2A3XDobkSiy3ypfLXSsPtMUFaAvet9d54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659712; c=relaxed/simple;
	bh=+nUZpWf38BR1z1Xq4GYiF8hhDXDOFr2KLt0+0bzfUlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tcHeU0ACdBdZ/gdYl7gsaW81p2bhoaCtNU+6Lj8MrxfAcuf4HmZK0dwygQ4KI8oWcicJkGkgKJU9Pa1+GbVsHjDBWcAscSh8YWQa2KWN+QB1gfx322357yequ3mztxPeROTzwMhCSXIdQkhbCKbkcTQ8GcFhERwnKY5qxC0a8HI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tafA+US8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tafA+US8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 179951F00899;
	Thu, 17 Sep 2026 15:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659699;
	bh=tSF2hhzx1YUhP+RIJ7WEBaZwjpAePGh3IhAH6nele0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tafA+US86KreoNjzYTfi3WwjI1DFk2YOEjCqe0mThrnuaYvHSiPlRRKqIQJO9kmlN
	 kfGbc8AM72F7MzDV5H+W6htN6mQXiAc/TOW0ptq7du8CMdthVOitiRHH4ozKm3oFxK
	 kyqr49AmTWf7EtacKaUyJ4vzbL8B9uORn2xOr41k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Zhang <yuz08559@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 345/733] vhost-vdpa: dont install the eventfd_ctx_fdget() error in config_ctx
Date: Thu, 17 Sep 2026 16:10:53 +0100
Message-ID: <20260917151400.157479126@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 4eb1eb5e5c79d..3e5165b7c094e 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -546,18 +546,14 @@ static long vhost_vdpa_set_config_call(struct vhost_vdpa *v, u32 __user *argp)
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



