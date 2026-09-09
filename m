Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F009B576EB5;
	Wed,  9 Sep 2026 14:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964400; cv=none; b=P9VbGgbq8Q/PDJ0MegrxoF3pbSkR/Zs4XB5FvpYSaonazmSDD8wcDSQ34eaIOipnv7UkOzxnzqU/mjf98f6HPceIe/akMhtijuIYb4bFS8z9v6QbaR2KxgkvyHfKyDAOwv3e2enllumohVOREDFuiT/yKY5K1dHc4OuV4zaH5Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964400; c=relaxed/simple;
	bh=ZFNhCQ1YFrFwr1CQ5pQLjqIaa3nHBLMrZy+qEyo7QdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DOn3MDhmfzd8SIAxdzKCnk6wsLlGS9yrAMzAvYUi6fzoTlp/y8m5kYlFwQYi5tsjMO7Hh6JuXu4IoP7gV1YpppUHgJFY/Kk6cDG4SXbVmPvOqTT0HH0OWb2ia7dxMEYqURdlYednG/mY9b9pu0R6DTsBdpUHGrlrIs6fTltSQwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2BVGTebF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2BVGTebF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51AD51F00ACF;
	Wed,  9 Sep 2026 14:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964398;
	bh=QcEPlbVQX4cTNF3mfcFlJPkLgXanSosi+IZLzP/U5VU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2BVGTebFM/b8G84MW2kVrVYIHyhCiON0nxZkyXIiOO0C+B5/YC+T4pXcUQ+MHtByb
	 JzGnPWfnhhOVAvIr6eIxHOtV/yolxF+XQYQdUtPvebvJrTEft5em8EnMVMs0x85JTl
	 wIzko3bDqg8nYWEAnEfD/Q30xGnKV7KLD1uyjPXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Czernohous <marek@czernohous.de>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 6.18 410/583] drm/nouveau: unsubscribe the channel-kill event before the fence context
Date: Wed,  9 Sep 2026 15:41:35 +0200
Message-ID: <20260909134252.182477570@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Marek Czernohous <marek@czernohous.de>

commit 511585987d27d8cb668acebd399fc4deda23404c upstream.

nouveau_channel_del() tears the fence context down first and only drops
the channel-kill subscription later, in the middle of the nvif object
teardown:

	if (chan->fence)
		nouveau_fence(chan->cli->drm)->context_del(chan);
	...
	nvif_object_dtor(&chan->vram);
	nvif_event_dtor(&chan->kill);

The subscribed handler is nouveau_channel_killed(), which calls
nouveau_channel_kill() and from there nouveau_fence_context_kill() on
chan->fence. A kill event delivered in that window takes fctx->lock and
walks fctx->pending on a fence context that context_del() has already
freed.

Nothing reaches this below Fermi today, because the subscription is
gated on FERMI_CHANNEL_GPFIFO and nothing kills a channel there. On
Fermi and newer the window is real but narrow, since a kill has to land
exactly while the channel is being destroyed. That is reason enough on
its own, which is why this carries a Fixes: tag. The last patch in this
series subscribes Tesla channels as well; nothing kills those today, so
it does not widen the exposure now, but it is the groundwork for a
recovery path that would, and the ordering is better fixed before that
lands than alongside it.

Drop the subscription before anything it depends on is torn down.

Fixes: ea13e5abf807 ("drm/nouveau: signal pending fences when channel has been killed")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: Marek Czernohous <marek@czernohous.de>
Fixes: ea13e5abf807 ("drm/nouveau: signal pending fences when channel has been killed")
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patch.msgid.link/20260812231330.705425-2-mczernohous@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_chan.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nouveau_chan.c
+++ b/drivers/gpu/drm/nouveau/nouveau_chan.c
@@ -90,6 +90,14 @@ nouveau_channel_del(struct nouveau_chann
 {
 	struct nouveau_channel *chan = *pchan;
 	if (chan) {
+		/*
+		 * Drop the kill-event subscription first.  Its handler
+		 * dereferences chan->fence, which the fence context teardown
+		 * below frees, so leaving it armed across the teardown leaves
+		 * a window for a use-after-free.
+		 */
+		nvif_event_dtor(&chan->kill);
+
 		if (chan->fence)
 			nouveau_fence(chan->cli->drm)->context_del(chan);
 
@@ -100,7 +108,6 @@ nouveau_channel_del(struct nouveau_chann
 		nvif_object_dtor(&chan->nvsw);
 		nvif_object_dtor(&chan->gart);
 		nvif_object_dtor(&chan->vram);
-		nvif_event_dtor(&chan->kill);
 		nvif_object_dtor(&chan->user);
 		nvif_mem_dtor(&chan->mem_userd);
 		nouveau_vma_del(&chan->sema.vma);


