Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174452E5B2A;
	Sat, 17 Oct 2026 17:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259821; cv=none; b=Wv5HgaSvTxLLxeEcQkD0JdQ3zmZ0Rx5gkioOEPYekl4P1i1ciLVruqahR1vferHArGbpkd+oe5Y34tBNtw8JwI9rFqdms5HosSuGJBRhCrMbw9MHZE6tKyMLJ36W+JzfUxYHDUvs05JfRi0MSwu2V80aeX119reYa1/ZoVyzGHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259821; c=relaxed/simple;
	bh=B8zH2bZXaPFaiUuWpxaoOdf9FSLhKS0zq4h51Wr3DfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u9Ox1WY2e7B0iqiEXfkY3otrvG4YQ5rdEkCzNVIJuG1ra5XGTJkbnuxepUaYHzxDhlJ3OfLEOOhoqxYckmrfQ8zB9vuDaNDUee+NsZs4GyPKnSJPYpovA0lGZDj3FU+xueGeRwvwg7kqsr7ikma8lgh6mNtJfYRvFBPPcoioRWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jtw01Tjk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jtw01Tjk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 640DF1F000C4;
	Sat, 17 Oct 2026 17:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259820;
	bh=/etpBl4RW310ImFOaJrJ1w4sp6bRJhaVd9DG8lD+oF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jtw01TjkILEEM77nCtjaXxcf3N4zsQSeLe17hZ6tP5sZOzs4NjkqHMmCtKwnjY2p0
	 aQBhHz9LHKteESmsffmOSl0lI7ikN59/2MdW+mu7mVvVpGur4HyXPS0/Sy5XSi3CGn
	 hBrxqSpATVN2wAUH9v30TcGeNm7ib2g1dxuvKaHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Czernohous <marek@czernohous.de>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1341/1674] drm/nouveau: unsubscribe the channel-kill event before the fence context
Date: Sat, 17 Oct 2026 18:00:13 +0200
Message-ID: <20261017160505.569142048@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Marek Czernohous <marek@czernohous.de>

[ Upstream commit 511585987d27d8cb668acebd399fc4deda23404c ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_chan.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_chan.c b/drivers/gpu/drm/nouveau/nouveau_chan.c
index b706b6dd9a88b..c6ee2bfe27873 100644
--- a/drivers/gpu/drm/nouveau/nouveau_chan.c
+++ b/drivers/gpu/drm/nouveau/nouveau_chan.c
@@ -90,6 +90,14 @@ nouveau_channel_del(struct nouveau_channel **pchan)
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
 
@@ -100,7 +108,6 @@ nouveau_channel_del(struct nouveau_channel **pchan)
 		nvif_object_dtor(&chan->nvsw);
 		nvif_object_dtor(&chan->gart);
 		nvif_object_dtor(&chan->vram);
-		nvif_event_dtor(&chan->kill);
 		nvif_object_dtor(&chan->user);
 		nvif_mem_dtor(&chan->mem_userd);
 		nvif_object_dtor(&chan->push.ctxdma);
-- 
2.53.0



