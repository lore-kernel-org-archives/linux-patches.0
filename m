Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A67379EFC;
	Tue, 16 Jun 2026 16:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626393; cv=none; b=ebUAb9V71sFr8HH0J84T71iL3ag5e2/ZU6TNEd2K33qulpc/enNV7ZOKgIF+xWkQBaYnFc8b6VZVBh0fFbqeM+U2lEIL8RYQupQGOgND7iEe2R/Se2dffKRl8DVR87ydx9pfUAyFKnXylQ2fccjMew5rvu0xLi/1AwXInGNK5NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626393; c=relaxed/simple;
	bh=g4HfvXZwlZvcdJ1TuH1MXX4osMAZiKFMVL8XTpW9O7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HsrvKO7kCd2BRlwmMXrJJxIr4R6GEWkGBl0lLtbsehIAI6lapb6oDIVwoC5xVetK03mHHAbBtARJ5h2mPgWPtKhgibyMC8sKMO+7T07RSh9zMT0Vmkt3k6TLnZWQ1A2QEt7DKrjudi2hCcubVAdR4VTilmf/MOxy7CxMzACJxRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B/qUph1T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B/qUph1T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2513F1F000E9;
	Tue, 16 Jun 2026 16:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626392;
	bh=ye0QChmJADNXxsFehYAwgnoxdPTtW5+FAJc573OZNK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B/qUph1TZ7u3isuCz7As9gDKiMEcHisYpMyr8oodbnTkLlX8LZTqnlrCdI4fFqg6r
	 XYwSr++NE9kHM/ttTmNVzdCzAL5s+huD3CTHUvHaUMbP1mj2hwCmPEwtAXAoaeAka+
	 kGQZQMLWyEVQ9OPaRwXGVQ+do+jbqz4TrR+LWJTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 311/325] RDMA/umem: Add helpers for umem dmabuf revoke lock
Date: Tue, 16 Jun 2026 20:31:47 +0530
Message-ID: <20260616145114.525332186@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

From: Jacob Moroni <jmoroni@google.com>

[ Upstream commit 3a0b171302eea1732a168e26db3b8461f51cc1f9 ]

Added helpers to acquire and release the umem dmabuf revoke
lock. The intent is to avoid the need for drivers to peek
into the ib_umem_dmabuf internals to get the dma_resv_lock
and bring us one step closer to abstracting ib_umem_dmabuf
away from drivers in general.

Signed-off-by: Jacob Moroni <jmoroni@google.com>
Link: https://patch.msgid.link/20260305170826.3803155-5-jmoroni@google.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: badad6fad60d ("RDMA: During rereg_mr ensure that REREG_ACCESS is compatible")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/umem_dmabuf.c |   16 ++++++++++++++++
 include/rdma/ib_umem.h                |    4 ++++
 2 files changed, 20 insertions(+)

--- a/drivers/infiniband/core/umem_dmabuf.c
+++ b/drivers/infiniband/core/umem_dmabuf.c
@@ -276,6 +276,22 @@ struct ib_umem_dmabuf *ib_umem_dmabuf_ge
 }
 EXPORT_SYMBOL(ib_umem_dmabuf_get_pinned);
 
+void ib_umem_dmabuf_revoke_lock(struct ib_umem_dmabuf *umem_dmabuf)
+{
+	struct dma_buf *dmabuf = umem_dmabuf->attach->dmabuf;
+
+	dma_resv_lock(dmabuf->resv, NULL);
+}
+EXPORT_SYMBOL(ib_umem_dmabuf_revoke_lock);
+
+void ib_umem_dmabuf_revoke_unlock(struct ib_umem_dmabuf *umem_dmabuf)
+{
+	struct dma_buf *dmabuf = umem_dmabuf->attach->dmabuf;
+
+	dma_resv_unlock(dmabuf->resv);
+}
+EXPORT_SYMBOL(ib_umem_dmabuf_revoke_unlock);
+
 void ib_umem_dmabuf_revoke(struct ib_umem_dmabuf *umem_dmabuf)
 {
 	struct dma_buf *dmabuf = umem_dmabuf->attach->dmabuf;
--- a/include/rdma/ib_umem.h
+++ b/include/rdma/ib_umem.h
@@ -176,6 +176,8 @@ ib_umem_dmabuf_get_pinned_with_dma_devic
 int ib_umem_dmabuf_map_pages(struct ib_umem_dmabuf *umem_dmabuf);
 void ib_umem_dmabuf_unmap_pages(struct ib_umem_dmabuf *umem_dmabuf);
 void ib_umem_dmabuf_release(struct ib_umem_dmabuf *umem_dmabuf);
+void ib_umem_dmabuf_revoke_lock(struct ib_umem_dmabuf *umem_dmabuf);
+void ib_umem_dmabuf_revoke_unlock(struct ib_umem_dmabuf *umem_dmabuf);
 void ib_umem_dmabuf_revoke(struct ib_umem_dmabuf *umem_dmabuf);
 
 #else /* CONFIG_INFINIBAND_USER_MEM */
@@ -236,6 +238,8 @@ static inline int ib_umem_dmabuf_map_pag
 }
 static inline void ib_umem_dmabuf_unmap_pages(struct ib_umem_dmabuf *umem_dmabuf) { }
 static inline void ib_umem_dmabuf_release(struct ib_umem_dmabuf *umem_dmabuf) { }
+static inline void ib_umem_dmabuf_revoke_lock(struct ib_umem_dmabuf *umem_dmabuf) {}
+static inline void ib_umem_dmabuf_revoke_unlock(struct ib_umem_dmabuf *umem_dmabuf) {}
 static inline void ib_umem_dmabuf_revoke(struct ib_umem_dmabuf *umem_dmabuf) {}
 
 #endif /* CONFIG_INFINIBAND_USER_MEM */


