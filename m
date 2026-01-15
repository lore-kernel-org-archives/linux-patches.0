Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2EF33993;
	Thu, 15 Jan 2026 17:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499755; cv=none; b=pMZ0Ux+BrgJC5fAJAioDYD1W7f/wOj13A7ucze1MtSUVIbpFlKVlFfdgttD10f/TZN1aVreBh/PxvVIF/jmzPB0LSezKpCxTiZfgeBQfHIeouUpFBL718ksV+OQWRM8Sf0JvO+IuZCbSyuCDpKgZrXhRA/f/heCdPg0k/vzVL2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499755; c=relaxed/simple;
	bh=2dVUocc8QoTF9fcMMSWqbHfPvAdfhcLP2EK27WyBf8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l8B0xUh4EMqsppaJByXXXynWetvDZcdwimLO9JWLhLqqjNggIDz1haC28/E7opzPTvLsePUMF+8knp1My2qpbKxZmLIrlRpJJOnPv0N5AF40XwF6re6yIHyUz5RPl3ru5ZKKjQv/9UG0TGnvNkBmPbg8OZZxkTYZZm8YOqY3pjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OnySKU5b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OnySKU5b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8BB2C116D0;
	Thu, 15 Jan 2026 17:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499755;
	bh=2dVUocc8QoTF9fcMMSWqbHfPvAdfhcLP2EK27WyBf8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OnySKU5bFKujvs5JFnV4rKBGkcKpgUFc6xGle4M3ClI+8U2ZRUPAAeeIu6wJoRjKg
	 VsBn1X41cPYVLbKGfOOuhVrL4y7S+R3fHRUZ2Airj1S5MmbZXOQjZ0w2Q1S6guxsWk
	 99d4NubfmmCPYqgftgE/C4TLC9fNdxcRKt8+T15o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lyude Paul <lyude@redhat.com>,
	Dave Airlie <airlied@redhat.com>
Subject: [PATCH 5.10 337/451] drm/nouveau/dispnv50: Dont call drm_atomic_get_crtc_state() in prepare_fb
Date: Thu, 15 Jan 2026 17:48:58 +0100
Message-ID: <20260115164243.086124676@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -561,7 +561,7 @@ nv50_wndw_prepare_fb(struct drm_plane *p
 	asyw->image.offset[0] = nvbo->offset;
 
 	if (wndw->func->prepare) {
-		asyh = nv50_head_atom_get(asyw->state.state, asyw->state.crtc);
+		asyh = nv50_head_atom_get_new(asyw->state.state, asyw->state.crtc);
 		if (IS_ERR(asyh))
 			return PTR_ERR(asyh);
 


