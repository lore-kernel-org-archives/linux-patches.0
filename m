Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF17D3BF31F;
	Thu, 15 Jan 2026 17:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498380; cv=none; b=WivWXLE97CfU71jRX+ozN66EbdoOOp0lt5bSJBZGMT3/MApoq85B1nrenaBqnuwpH8bS8CPYX/a+c8kfC2K086zrQQ63KET4TugsZO30ykEhScHZhbFnnSGrnt6Khsvzq7dQt+SZqW3KDEiPG7EYQh9PSstcWBHxRuOrS3u5ILs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498380; c=relaxed/simple;
	bh=+/UIItA0ftOjDgAC93EBRljNofbHN3O56MQc55wn8hM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dTWIeDwudX7e4BX+AZMCYrGG+YJlWy7xQ1CCQoeWLTPM2zcCxUcKDjYMwlrwDxFxfDg8xpm2jVamXqtg/bhW6isuNyH/13K6K8w8hcAX7lYUMLMk93s2Xq7Bb5Ql0ygT15jU4jsSC6s9U9OhIsiRkfPzz6QQgaKTIU0GKGQXzGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lYGZH02A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lYGZH02A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47ABC16AAE;
	Thu, 15 Jan 2026 17:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498380;
	bh=+/UIItA0ftOjDgAC93EBRljNofbHN3O56MQc55wn8hM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lYGZH02AWQCa56r6SlN8M5N264aR2+jciro+HcIwqIGdIMmlvlel0ROQNb+a5Yr2N
	 /h76XjSz6mc4tty7PRLcKLOW8ZAHFyrai7nvHGRXs3W8ajRQyO6BT5t4p2qMFbLMNe
	 evSNrhGu4uPQHFKUYdFqCJFrXZzJf80DcSVVr2wk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lyude Paul <lyude@redhat.com>,
	Dave Airlie <airlied@redhat.com>
Subject: [PATCH 5.15 411/554] drm/nouveau/dispnv50: Dont call drm_atomic_get_crtc_state() in prepare_fb
Date: Thu, 15 Jan 2026 17:47:57 +0100
Message-ID: <20260115164301.111153303@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -565,7 +565,7 @@ nv50_wndw_prepare_fb(struct drm_plane *p
 	asyw->image.offset[0] = nvbo->offset;
 
 	if (wndw->func->prepare) {
-		asyh = nv50_head_atom_get(asyw->state.state, asyw->state.crtc);
+		asyh = nv50_head_atom_get_new(asyw->state.state, asyw->state.crtc);
 		if (IS_ERR(asyh))
 			return PTR_ERR(asyh);
 


