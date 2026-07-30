Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA1340860A;
	Thu, 30 Jul 2026 15:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427196; cv=none; b=HFMf8kXFWs/M4gVfWSmUphwYHeRw+ejpdmj8nFPS+I+g4Gf5VUJWBxHMeksgZsm5loPSqxxOMQ0MtFmQXaHbMeHWL6YUViwJYPHGDugy/UX/G0+uE95cHNuk5h5sqH2d+OJHP8UpYnF54InyU3k1BSLNPZX/jykQRUMZHXSRv70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427196; c=relaxed/simple;
	bh=FKB7xqnsHP1nfRfQOFYlrInD7mxrTMrIg5aq27oM5eI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ttd0c1Xleq1Ib4Roq60nRD7Y85XYEhh8N49TntEReXHEK5Eqcm0rODCSkhWMmtruqEVuznKjJHmipnBo1GDjbOpTMq1SUwE8jQuZSvY0IXq76foW7D7THffZqhYUkoZSKpZAtwh76bINk/POQ1eMPHHwnCvF+22XTR+sJkErlh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r01hS+Xa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r01hS+Xa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65DBD1F000E9;
	Thu, 30 Jul 2026 15:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427194;
	bh=jh95UVm5FQCnhpvjczvRk1wWuABkA90i02uRiu3S/XQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r01hS+XaATElluXI90bsVXlfwE4AZGh7VuwVw6AYw5scZ6rsoliF1L1Lggm+AXY37
	 3IlBYpPTDfOJAkeyuB7Jn7x41d7diLrRqh3d0rcuQWwb716ng0M/23HeNrdFISAwRw
	 wYzSBwPXVbvzBZsmveiuuXBOq88MVC1/PbFQPS10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 040/484] RDMA/umem: Move umem dmabuf revoke logic into helper function
Date: Thu, 30 Jul 2026 16:08:57 +0200
Message-ID: <20260730141424.294283284@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

From: Jacob Moroni <jmoroni@google.com>

[ Upstream commit 797291a66ce346c96114b72222fc290d402da005 ]

This same logic will eventually be reused from within the
invalidate_mappings callback which already has the dma_resv_lock
held, so break it out into a separate function so it can be reused.

Signed-off-by: Jacob Moroni <jmoroni@google.com>
Link: https://patch.msgid.link/20260305170826.3803155-3-jmoroni@google.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: a846aecb931b ("RDMA/irdma: Prevent rereg_mr for non-mem regions")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/umem_dmabuf.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/core/umem_dmabuf.c b/drivers/infiniband/core/umem_dmabuf.c
index acb0922a786131..be5977daafa1de 100644
--- a/drivers/infiniband/core/umem_dmabuf.c
+++ b/drivers/infiniband/core/umem_dmabuf.c
@@ -198,6 +198,22 @@ static struct dma_buf_attach_ops ib_umem_dmabuf_attach_pinned_ops = {
 	.move_notify = ib_umem_dmabuf_unsupported_move_notify,
 };
 
+static void ib_umem_dmabuf_revoke_locked(struct dma_buf_attachment *attach)
+{
+	struct ib_umem_dmabuf *umem_dmabuf = attach->importer_priv;
+
+	dma_resv_assert_held(attach->dmabuf->resv);
+
+	if (umem_dmabuf->revoked)
+		return;
+	ib_umem_dmabuf_unmap_pages(umem_dmabuf);
+	if (umem_dmabuf->pinned) {
+		dma_buf_unpin(umem_dmabuf->attach);
+		umem_dmabuf->pinned = 0;
+	}
+	umem_dmabuf->revoked = 1;
+}
+
 static struct ib_umem_dmabuf *
 ib_umem_dmabuf_get_pinned_and_lock(struct ib_device *device,
 				   struct device *dma_device,
@@ -265,15 +281,7 @@ void ib_umem_dmabuf_revoke(struct ib_umem_dmabuf *umem_dmabuf)
 	struct dma_buf *dmabuf = umem_dmabuf->attach->dmabuf;
 
 	dma_resv_lock(dmabuf->resv, NULL);
-	if (umem_dmabuf->revoked)
-		goto end;
-	ib_umem_dmabuf_unmap_pages(umem_dmabuf);
-	if (umem_dmabuf->pinned) {
-		dma_buf_unpin(umem_dmabuf->attach);
-		umem_dmabuf->pinned = 0;
-	}
-	umem_dmabuf->revoked = 1;
-end:
+	ib_umem_dmabuf_revoke_locked(umem_dmabuf->attach);
 	dma_resv_unlock(dmabuf->resv);
 }
 EXPORT_SYMBOL(ib_umem_dmabuf_revoke);
-- 
2.53.0



