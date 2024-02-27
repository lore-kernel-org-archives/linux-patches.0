Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D32A13B7A0;
	Tue, 27 Feb 2024 14:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042413; cv=none; b=m9PppPseGoK/WTgwD3ejGQSfVJn6Ke0nlcLLbws/2LXWVYQla+enMzmuSOpWZrg1PQyHepVx7JE+P5aNqEKwCymrkc3Z/7ARcUg+LEQFym1ydSvBVtHKdCjBFDs/HdXv0w75phnm5jzC++Fkah+gBvhgw/phhDsJs/Jvm+pkNx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042413; c=relaxed/simple;
	bh=1VMwaL+M8AxAeSAgji3g+zwSQsF+ZWzKpof3Tl3ttSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EyVV9JYBm3u0MKfQdlOxvOjmWuqMgiQkC7enXowZmJ5taUiMyugWV1vkdUDYIBzbvpL2rSjP1LBlLtUMEaqpH2JVQZJUO//0cPJFv9zR2jbKsEthGcWqJNJyt7SVHWfmId2JWoZCIeQMAZ9EQ4tBJo6bRnAS/QtlPVXfoRbLmQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OnnyFNf9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OnnyFNf9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B802C433C7;
	Tue, 27 Feb 2024 14:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042413;
	bh=1VMwaL+M8AxAeSAgji3g+zwSQsF+ZWzKpof3Tl3ttSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OnnyFNf9ppgmIveAdGzUUmpX2XuqNWZ8ot2MQXVbC6vxP7XqyC5EC89Jlo/UXYSC2
	 4O6LBHnvhUMV+O3Nn2qGu8l/iCEMDblwp6OWIgNLnNwg2W//zvFMFjf8lidUbSHi/4
	 BBesx7b23tcti0Tjixj1HhAq4I8iHg+aWSmiWKhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erik Kurzinger <ekurzinger@nvidia.com>,
	Simon Ser <contact@emersion.fr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 287/299] drm/syncobj: handle NULL fence in syncobj_eventfd_entry_func
Date: Tue, 27 Feb 2024 14:26:38 +0100
Message-ID: <20240227131634.909449014@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



