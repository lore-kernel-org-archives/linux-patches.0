Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E742F2D;
	Tue, 27 Feb 2024 13:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041391; cv=none; b=ZR+wSV6GNT3Q0M/8zqx98tbyNwkqHIJFaiV5wNBv4aJSNNkdGXS0nXft6PtfTrWj0AUgbsmb2kcYecXzmsEvg4t3NF1kmdezWE+qajNbU3d75/Wmrehzh+Z2AXA7LGbcd1ruEjP3CjpuruSekGiKV2KibW2/COpIJpgl7RswJG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041391; c=relaxed/simple;
	bh=TsnonfW5RhqFDBLCUr3HhIaS+eDLsVf7wtV5wn4GOoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R5red+2r0OX0jUw0DQASksg94ChETI2v8XzNCLmL/SzjlyxYf2lKDFDjrkrSkGFaFnziW+4wt1J0PuQn7cFgy37UxHB3FOwTDJ2TiVGAX54b2QnrTThLl6Io0u10s0qXehvWcrPzJkZ0RuS/PBdOP1UxyuL286FCF1+cNYr2X8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZeF1HmTz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZeF1HmTz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 192C1C433C7;
	Tue, 27 Feb 2024 13:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041391;
	bh=TsnonfW5RhqFDBLCUr3HhIaS+eDLsVf7wtV5wn4GOoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZeF1HmTzJuZFSe4cQMA+fNIbROoQUR6lFZDUjMUQIsmryRepfp4icZ7DcfK8rKFhG
	 kjP58BCntoJRj+hNdSd80eCBL3ksUg6jCvPMU+pbXDHk+ZKDW82km/eHBGkFwQKPIT
	 OPrVpi7RR2knVDqL0KMiro+34qNGJ6YW/QHr0AIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erik Kurzinger <ekurzinger@nvidia.com>,
	Simon Ser <contact@emersion.fr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 324/334] drm/syncobj: handle NULL fence in syncobj_eventfd_entry_func
Date: Tue, 27 Feb 2024 14:23:02 +0100
Message-ID: <20240227131641.568941687@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Erik Kurzinger <ekurzinger@nvidia.com>

[ Upstream commit 2aa6f5b0fd052e363bb9d4b547189f0bf6b3d6d3 ]

During syncobj_eventfd_entry_func, dma_fence_chain_find_seqno may set
the fence to NULL if the given seqno is signaled and a later seqno has
already been submitted. In that case, the eventfd should be signaled
immediately which currently does not happen.

This is a similar issue to the one addressed by commit b19926d4f3a6
("drm/syncobj: Deal with signalled fences in drm_syncobj_find_fence.").

As a fix, if the return value of dma_fence_chain_find_seqno indicates
success but it sets the fence to NULL, we will assign a stub fence to
ensure the following code still signals the eventfd.

v1 -> v2: assign a stub fence instead of signaling the eventfd

Signed-off-by: Erik Kurzinger <ekurzinger@nvidia.com>
Fixes: c7a472297169 ("drm/syncobj: add IOCTL to register an eventfd")
Signed-off-by: Simon Ser <contact@emersion.fr>
Link: https://patchwork.freedesktop.org/patch/msgid/20240221184527.37667-1-ekurzinger@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_syncobj.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_syncobj.c b/drivers/gpu/drm/drm_syncobj.c
index b3433265be6ab..5860428da8de8 100644
--- a/drivers/gpu/drm/drm_syncobj.c
+++ b/drivers/gpu/drm/drm_syncobj.c
@@ -1380,10 +1380,21 @@ syncobj_eventfd_entry_func(struct drm_syncobj *syncobj,
 
 	/* This happens inside the syncobj lock */
 	fence = dma_fence_get(rcu_dereference_protected(syncobj->fence, 1));
+	if (!fence)
+		return;
+
 	ret = dma_fence_chain_find_seqno(&fence, entry->point);
-	if (ret != 0 || !fence) {
+	if (ret != 0) {
+		/* The given seqno has not been submitted yet. */
 		dma_fence_put(fence);
 		return;
+	} else if (!fence) {
+		/* If dma_fence_chain_find_seqno returns 0 but sets the fence
+		 * to NULL, it implies that the given seqno is signaled and a
+		 * later seqno has already been submitted. Assign a stub fence
+		 * so that the eventfd still gets signaled below.
+		 */
+		fence = dma_fence_get_stub();
 	}
 
 	list_del_init(&entry->node);
-- 
2.43.0



