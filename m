Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C74C17BED0;
	Sat, 17 Oct 2026 16:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253316; cv=none; b=iZuvAmTEZq5Zlnh5NK0REq29fQRMK42g8MEYa3Kslt1OhTMYO0qVE2LYBnnrHCn4tk/h1CGGttbL8TIrdTndZkBnz+hZ5fnNnIAPv+C9UQXZu2d0Cqu9y8StjvYNOTmhw+bMlLu6QsHuuiwAsE3rkXxJTlVKDS6W4TeWps1WpB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253316; c=relaxed/simple;
	bh=1o9BeHRt54Qr0dfExuQQehWmVIlprklG0rcN7d8QjI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WecuNFZhkij/pOaHkg0skj+Ry88oY0ThQ2GQzqiV/nIk4t2ZmxrMYDHk3gxLz16WvPKxxQ175JSpkoJeJg1+vOtetGeDyHV7NRjM2QBHBzWsQuEP4Dj+Zq70i4Pk2hTJ8EOrDEsdjZl3WjeuPYFmJ17fAZ52pLQ94iSCmzNe4KE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JeaxLXb0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JeaxLXb0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607301F000C4;
	Sat, 17 Oct 2026 16:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253315;
	bh=qsx0/2fbDpDFrHLQPgi34B4hybGAivLgR0S+wMozgPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JeaxLXb0ox+pxF6W/loINkIaiDzKUHvoa0nuu5bzQ/TVedB2gUSHeqt9+E1kM/8iW
	 i5GUyeWTQpIQYzDPqMPcH0avXC16buOFYB/Bf1NnmAxGEgfrZ1fsMzrCK4emiAV1L1
	 +zjaBVvULbDgNl75o+Bf8Xj0Fp4fvIFa25H8yB3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhi Wang <zhiw@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 079/869] drm/nouveau: fix a use-after-free in r535_gsp_rpc_push()
Date: Sat, 17 Oct 2026 17:48:40 +0200
Message-ID: <20261017160039.054748201@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhi Wang <zhiw@nvidia.com>

[ Upstream commit 9802f0a63b641f4cddb2139c814c2e95cb825099 ]

The RPC container is released after being passed to r535_gsp_rpc_send().

When sending the initial fragment of a large RPC and passing the
caller's RPC container, the container will be freed prematurely. Subsequent
attempts to send remaining fragments will therefore result in a
use-after-free.

Allocate a temporary RPC container for holding the initial fragment of a
large RPC when sending. Free the caller's container when all fragments
are successfully sent.

Fixes: 176fdcbddfd2 ("drm/nouveau/gsp/r535: add support for booting GSP-RM")
Signed-off-by: Zhi Wang <zhiw@nvidia.com>
Link: https://lore.kernel.org/r/20250527163712.3444-1-zhiw@nvidia.com
[ Rebase onto Blackwell changes. - Danilo ]
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
index 3ad4f6e9a8ac2..801b0bc676ab2 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
@@ -734,12 +734,18 @@ r535_gsp_rpc_push(struct nvkm_gsp *gsp, void *argv, bool wait, u32 repc)
 	mutex_lock(&gsp->cmdq.mutex);
 	if (rpc_size > max_rpc_size) {
 		const u32 fn = rpc->function;
+		void *next;
 
-		/* Adjust length, and send initial RPC. */
-		rpc->length = sizeof(*rpc) + max_rpc_size;
-		cmd->checksum = rpc->length;
+		/* Send initial RPC. */
+		next = r535_gsp_rpc_get(gsp, fn, max_rpc_size);
+		if (IS_ERR(next)) {
+			repv = next;
+			goto done;
+		}
 
-		repv = r535_gsp_rpc_send(gsp, argv, false, 0);
+		memcpy(next, argv, max_rpc_size);
+
+		repv = r535_gsp_rpc_send(gsp, next, false, 0);
 		if (IS_ERR(repv))
 			goto done;
 
@@ -749,7 +755,6 @@ r535_gsp_rpc_push(struct nvkm_gsp *gsp, void *argv, bool wait, u32 repc)
 		/* Remaining chunks sent as CONTINUATION_RECORD RPCs. */
 		while (rpc_size) {
 			u32 size = min(rpc_size, max_rpc_size);
-			void *next;
 
 			next = r535_gsp_rpc_get(gsp, NV_VGPU_MSG_FUNCTION_CONTINUATION_RECORD, size);
 			if (IS_ERR(next)) {
@@ -777,6 +782,8 @@ r535_gsp_rpc_push(struct nvkm_gsp *gsp, void *argv, bool wait, u32 repc)
 		} else {
 			repv = NULL;
 		}
+		if (!IS_ERR(repv))
+			kvfree(cmd);
 	} else {
 		repv = r535_gsp_rpc_send(gsp, argv, wait, repc);
 	}
-- 
2.53.0



