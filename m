Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECFDB224AF3;
	Mon,  2 Jun 2025 14:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875073; cv=none; b=RRFJWFURaAeHgQiB69wDFXs5wjPlYSh9tjzNomqX8NNqV+kQ5wBET+B73oc+KjqqQyVQw1USyeIXWW6GTod8og+AOJUkbMQdqQXmt1EAe8m3q35qoTAXXXFE1+7m2+ba+jneThJHnHcYroV2QUCKeAE1r7iMA7dvDV15Nyhgys0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875073; c=relaxed/simple;
	bh=qyRzSzGrZ2U0xLt9B+baHqwi0yrVUvkNE178RgcaHDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a4oAH2Ds6gMNtPXWTCIeeJq+w8U/o/y0JnX6A+2fU17R/ob9rzBWoEkjlR3hu9nXDWLESI/VzDl0J3v7Z0B8+p32jyNu5m2aCPJwR7ph5Vl51Jl8MkPTS8sQNgrR1SJL9xeHNK7bqKRmxEb7ETScJ38lgibTQ3HCIJSe/tfChIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0le6U5sz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0le6U5sz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D7D0C4CEEB;
	Mon,  2 Jun 2025 14:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875072;
	bh=qyRzSzGrZ2U0xLt9B+baHqwi0yrVUvkNE178RgcaHDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0le6U5szvSUerkcxyP+n/9Z42MTdVFxs5H+pfuzXuBsNk1QfGoDxjT7xng2+EpuGW
	 gLiS7eZvT0yMdkRusQoaBPzF1rSW3cRhCW0+oL2jdSwWVSD0AhtyJ289cQMoBH5hoP
	 dlKqjIXpQ4C0Eb04ihlvS1mVAjweOrOMH9kFYuVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Philipp Stanner <phasta@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 5.10 002/270] drm/nouveau: Fix WARN_ON in nouveau_fence_context_kill()
Date: Mon,  2 Jun 2025 15:44:47 +0200
Message-ID: <20250602134307.297453124@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philipp Stanner <phasta@kernel.org>

commit bbe5679f30d7690a9b6838a583b9690ea73fe0e9 upstream.

Nouveau is mostly designed in a way that it's expected that fences only
ever get signaled through nouveau_fence_signal(). However, in at least
one other place, nouveau_fence_done(), can signal fences, too. If that
happens (race) a signaled fence remains in the pending list for a while,
until it gets removed by nouveau_fence_update().

Should nouveau_fence_context_kill() run in the meantime, this would be
a bug because the function would attempt to set an error code on an
already signaled fence.

Have nouveau_fence_context_kill() check for a fence being signaled.

Cc: stable@vger.kernel.org # v5.10+
Fixes: ea13e5abf807 ("drm/nouveau: signal pending fences when channel has been killed")
Suggested-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Philipp Stanner <phasta@kernel.org>
Link: https://lore.kernel.org/r/20250415121900.55719-3-phasta@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_fence.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nouveau_fence.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fence.c
@@ -95,7 +95,7 @@ nouveau_fence_context_kill(struct nouvea
 	while (!list_empty(&fctx->pending)) {
 		fence = list_entry(fctx->pending.next, typeof(*fence), head);
 
-		if (error)
+		if (error && !dma_fence_is_signaled_locked(&fence->base))
 			dma_fence_set_error(&fence->base, error);
 
 		if (nouveau_fence_signal(fence))


