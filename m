Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C3033EB0B;
	Tue,  6 Jan 2026 18:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722598; cv=none; b=C7G6xG0Lcs5lR1Bn3WJQ6vSuw6sMDqlz8KEXj7PqCQkE6hL0kGj/LL8nB6gwR8qrmmNKDx9e9QQrFNeXX/9+8+YjUu5UyaU7r/fIQk4V30vXPBTjxNS1NN1pqEHlcvfuMCG2mjjTB2FPBzenBtudwFoAJKoFVF+FKFIqLSqaZ54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722598; c=relaxed/simple;
	bh=Dnk4z7mfVaTU0h38V1V8VNGur4qmgp40I/rVUrSut+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fQhlUd6uzNbUCWDg7NASlK/x54M43jLx2RAM3SMNc/hdlYqSI/a6Ohemy/w0uqOIyxaBQm1BTL5zb4fQVJDgSXnxntyfnKKbrghyJPAgQ73AwRmO9HeBCQj8Q0acdUe5vLdHyK5Nsc7VnH5ATgCKsD5EArj82lpPXJzgGiSQ1pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jWVFeKHr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jWVFeKHr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3365C116C6;
	Tue,  6 Jan 2026 18:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722598;
	bh=Dnk4z7mfVaTU0h38V1V8VNGur4qmgp40I/rVUrSut+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jWVFeKHrsgOYbiRCpXsLFg0tfrhQP+NgIJZW/KqmUjq96eF0mw73SAEe0U36zYs5q
	 G/BgRaIQLQs3J3TRMvFO2mIJYQqq2yZvrz/bXB2Li/B+Dn2/R/XTL2DjqMmRgnfatB
	 UEjLZmEuYZIWFp8ZF1KrB+WBDfdqQfWmW+M6rLuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lyude Paul <lyude@redhat.com>,
	Dave Airlie <airlied@redhat.com>
Subject: [PATCH 6.18 303/312] drm/nouveau/dispnv50: Dont call drm_atomic_get_crtc_state() in prepare_fb
Date: Tue,  6 Jan 2026 18:06:17 +0100
Message-ID: <20260106170558.822034877@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Lyude Paul <lyude@redhat.com>

commit 560271e10b2c86e95ea35afa9e79822e4847f07a upstream.

Since we recently started warning about uses of this function after the
atomic check phase completes, we've started getting warnings about this in
nouveau. It appears a misplaced drm_atomic_get_crtc_state() call has been
hiding in our .prepare_fb callback for a while.

So, fix this by adding a new nv50_head_atom_get_new() function and use that
in our .prepare_fb callback instead.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Reviewed-by: Dave Airlie <airlied@redhat.com>
Fixes: 1590700d94ac ("drm/nouveau/kms/nv50-: split each resource type into their own source files")
Cc: <stable@vger.kernel.org> # v4.18+
Link: https://patch.msgid.link/20251211190256.396742-1-lyude@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/dispnv50/atom.h |   13 +++++++++++++
 drivers/gpu/drm/nouveau/dispnv50/wndw.c |    2 +-
 2 files changed, 14 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/dispnv50/atom.h
+++ b/drivers/gpu/drm/nouveau/dispnv50/atom.h
@@ -152,8 +152,21 @@ static inline struct nv50_head_atom *
 nv50_head_atom_get(struct drm_atomic_state *state, struct drm_crtc *crtc)
 {
 	struct drm_crtc_state *statec = drm_atomic_get_crtc_state(state, crtc);
+
 	if (IS_ERR(statec))
 		return (void *)statec;
+
+	return nv50_head_atom(statec);
+}
+
+static inline struct nv50_head_atom *
+nv50_head_atom_get_new(struct drm_atomic_state *state, struct drm_crtc *crtc)
+{
+	struct drm_crtc_state *statec = drm_atomic_get_new_crtc_state(state, crtc);
+
+	if (!statec)
+		return NULL;
+
 	return nv50_head_atom(statec);
 }
 
--- a/drivers/gpu/drm/nouveau/dispnv50/wndw.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/wndw.c
@@ -583,7 +583,7 @@ nv50_wndw_prepare_fb(struct drm_plane *p
 	asyw->image.offset[0] = nvbo->offset;
 
 	if (wndw->func->prepare) {
-		asyh = nv50_head_atom_get(asyw->state.state, asyw->state.crtc);
+		asyh = nv50_head_atom_get_new(asyw->state.state, asyw->state.crtc);
 		if (IS_ERR(asyh))
 			return PTR_ERR(asyh);
 


