Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214355;
	b=ThqPF6/AHepLVZXRCanfEaLRlttWgoC6ox4P9FXUnaxlPHe0RvEi7y8RBZ5GGi2ErkuR
	 rSVTTHAbhkTinahyjGog1LS4btkdFwi7Jca/lfHGgd/kXG9s77sUkUHer7sCAo5dwGHRs
	 QzEmOQRayqSYBGI/YAye9uMJcwAvo87mdB77YiElijsYQjFcdZYAKGOFdR6u74wCCkBAj
	 RnpghuVxbgBH3HU5yYAHzFfFDvQPvLpb21wPyFdKiYLFMwPzqb3ikTTA3TytBamSgEkhH
	 SKxGypK+GoKBZYE5D6wyw/iC+MsPcMzAQyYTU72NoljRXwbNKziNcp524kp0rON23aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214355;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=edCDqt/oM3JJdXGlEJaomnS9PysMGI+TTBsIeWXSkqY=;
	b=adlPQ1M59fdm87hU5EtmSrItNntuUWM9RB/QCXBjLMEdiT8wNQEuiy41qk3Kc/uHrSnW
	 58hLrW84LkzwTXMtTBEd/k5gchwuHobQE6Wjs+CLaX86gk4/R8qxVywcBqvKShdxSb7kP
	 IwAWHqYFVUa0rC7e3+m5/U8gvUI9oqeGgrRmcyCjAWaPjgkAuNGcgseGTqRqG1QtvWLCV
	 N5k4yQBUlDwKK9M5JoYWcKPorDC2fI0wx3Qp9lmqcQJIy8p2WQusWRRM/b5VhCJNCwx4y
	 zXuMolQrtgHNPFVZarX+XXoA7/7fD+k7UwbX6S6HNKIKeCuKiFkUYtyg4hBwzHHNTFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="AHnaD4/d";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CC660A2624;
	Wed, 28 Oct 2026 19:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AHnaD4/d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD4181F01828;
	Wed, 28 Oct 2026 19:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214354;
	bh=edCDqt/oM3JJdXGlEJaomnS9PysMGI+TTBsIeWXSkqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AHnaD4/daNmJQsoaeWaYcYgqUDd9WEy3SidSue8KLB8leNTutI6GVx03yCAuFtIxB
	 yrdjuweetmqlBiJTKkbJxCrfiQslhaqbEuctLejlt+Ik7W2VbskFbKOZPHdP7A4e7N
	 bz1gOQKFye6nf/sSXEYtvx/wmTkdL/Jd3kCQ8X48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomer Tayar <ttayar@habana.ai>,
	Oded Gabbay <ogabbay@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0829/1887] habanalabs: fix dma-buf release handling if dma_buf_fd() fails
Date: Wed, 28 Oct 2026 17:48:45 +0100
Message-ID: <20261028170518.289785579@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomer Tayar <ttayar@habana.ai>

[ Upstream commit 9b3d9f917f81aed559d19377c11d6fac3db89fd7 ]

The dma-buf private object is freed if a call to dma_buf_fd() fails,
and because a file was already associated with the dma-buf in
dma_buf_export(), the release op will be called and will use this
object.

Mark the 'priv' field as NULL in this case, and avoid accessing it from
the release op.

Signed-off-by: Tomer Tayar <ttayar@habana.ai>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Stable-dep-of: 33927f3d0ecd ("habanalabs: fix UAF in export_dmabuf()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/common/memory.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/habanalabs/common/memory.c b/drivers/misc/habanalabs/common/memory.c
index dcc496083f1c6..d18e111001844 100644
--- a/drivers/misc/habanalabs/common/memory.c
+++ b/drivers/misc/habanalabs/common/memory.c
@@ -1748,6 +1748,9 @@ static void hl_release_dmabuf(struct dma_buf *dmabuf)
 {
 	struct hl_dmabuf_priv *hl_dmabuf = dmabuf->priv;
 
+	if (!hl_dmabuf)
+		return;
+
 	hl_ctx_put(hl_dmabuf->ctx);
 	kfree(hl_dmabuf);
 }
@@ -1780,7 +1783,7 @@ static int export_dmabuf(struct hl_ctx *ctx,
 
 	fd = dma_buf_fd(hl_dmabuf->dmabuf, flags);
 	if (fd < 0) {
-		dev_err(hdev->dev, "failed to get a file descriptor for a dma-buf\n");
+		dev_err(hdev->dev, "failed to get a file descriptor for a dma-buf, %d\n", fd);
 		rc = fd;
 		goto err_dma_buf_put;
 	}
@@ -1793,6 +1796,7 @@ static int export_dmabuf(struct hl_ctx *ctx,
 	return 0;
 
 err_dma_buf_put:
+	hl_dmabuf->dmabuf->priv = NULL;
 	dma_buf_put(hl_dmabuf->dmabuf);
 	return rc;
 }
-- 
2.53.0



