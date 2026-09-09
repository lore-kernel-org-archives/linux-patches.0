Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B055C25783C;
	Wed,  9 Sep 2026 14:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963116; cv=none; b=CkEiprQAUNGyDFAyliZfMpYWNTNy3dgZ7BctrZVzmyCNrCvdpYcCJRWwVfK+3jzZyeyLByEFP5hkpD5Fp7gizFw6vnqI38dn/egrzFcvVLbrXhNBky5QtuWDhlY0Iz6DH/TrZgRrbwmWgabvAIo2UH3r8sWAuCkV9pkRWMEUgpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963116; c=relaxed/simple;
	bh=kOrmZr4jn9Y9LcyNwxkMjS8/lxJOsm4IBV8b41BMo6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fxYRnjKLa3SlJU3JLIzD4wd22wMbIZvyp1JJ1HbgpY0dvn8LjKyvnCBryEVpMfUnfpuwQpsgLb8OJCiorV2rDAbCyE9p04W9+zUN8pu4kd46CLNSU/ZGnl2+xvdC5Eckc3KrbcuGFlSVkPiNIL7I7/EjI69Krl2SbJT4a4o57aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uApbANij; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uApbANij"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 133541F00A3A;
	Wed,  9 Sep 2026 14:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963115;
	bh=1G4YVS7eu5+KN9cIDMu3MXfEgRlck7Cm4o7nhRchalU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uApbANijW88iqhRm17lbgCe7mkftA4lGc6C0cfTWxBZAahgUrUsZO2RLv0wkny6Xk
	 OvkesWri+02NLSMZOXtJhutR3m/5y6Im0ndokBBY8K3ZxRVfUMIl6GfUutUtiZ0OI7
	 +5y8tiqiGvxeTrFou/HCcfWqVyLB4+AIHFLGLp3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Zhenhao Wan <whi4ed0g@gmail.com>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 7.2 526/556] drm/nouveau/dmem: fix callocated underflow on large folio split
Date: Wed,  9 Sep 2026 15:43:26 +0200
Message-ID: <20260909134248.922828183@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

From: Zhenhao Wan <whi4ed0g@gmail.com>

commit c2256c044a1df39c8aad4dd2d6f709b2533e2d7a upstream.

nouveau_dmem_folio_free() drops chunk->callocated once per freed folio,
while a large (compound) device-private folio is only counted once when
it is allocated.  When such a folio is split, the mm core invokes
->folio_split() (nouveau_dmem_folio_split()) once for each new
sub-folio, but the hook only fixes up the sub-folio metadata and leaves
chunk->callocated unchanged.

Each resulting sub-folio is later freed separately, so after a split
the single allocation (+1) is met by N frees (-N), leaving
chunk->callocated short by N-1.  On the first split/free cycle it
underflows: WARN_ON(!chunk->callocated) fires, the unsigned counter
wraps and never returns to zero, so the chunk can no longer be
reclaimed (nouveau_dmem_fini() also warns on the leaked count).

Account for the new sub-folio in the split hook, under the same lock as
nouveau_dmem_folio_free(), so the count stays balanced.

Fixes: c32287471077 ("gpu/drm/nouveau: enable THP support for GPU memory migration")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Signed-off-by: Zhenhao Wan <whi4ed0g@gmail.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Link: https://patch.msgid.link/20260811-b4-nouveau-dmem-thp-fixes-v1-2-2cdf9860af2a@gmail.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_dmem.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/gpu/drm/nouveau/nouveau_dmem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dmem.c
@@ -279,11 +279,25 @@ err:
 
 static void nouveau_dmem_folio_split(struct folio *head, struct folio *tail)
 {
+	struct nouveau_dmem_chunk *chunk;
+	struct nouveau_dmem *dmem;
+
 	if (tail == NULL)
 		return;
 	tail->pgmap = head->pgmap;
 	tail->mapping = head->mapping;
 	folio_set_zone_device_data(tail, folio_zone_device_data(head));
+
+	/*
+	 * The split hands out a new independently-freeable folio that will
+	 * later be released via nouveau_dmem_folio_free(); account for it so
+	 * chunk->callocated stays balanced.
+	 */
+	chunk = nouveau_page_to_chunk(&head->page);
+	dmem = chunk->drm->dmem;
+	spin_lock(&dmem->lock);
+	chunk->callocated++;
+	spin_unlock(&dmem->lock);
 }
 
 static const struct dev_pagemap_ops nouveau_dmem_pagemap_ops = {


