Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D9D145335;
	Tue, 23 Apr 2024 21:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908655; cv=none; b=tOugSx83+OXXsAj4bu6rRmj7OOzN8gnDaGvdPJ7Jw67UvJX//uIfied2pcZISL/L36ejlxWHZ38kuH36vTO9AEdz1gLv1heQ7tcMmPqfyv6PI1epMKK3EJepDJh6DqlPe9trS2eaJnnPjZ5RCz8XA8+VSkc8FIzjDFwJaZ5lcF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908655; c=relaxed/simple;
	bh=lIt6A7pXU3CaNX42C5oZocoMxqbTli/2ubo7orE+p88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A0/48y4IYZVA5T6eQgjWbUcX7Ew0T75V6qmN+L7iO6K4AVN6EfTLVLb6fRlsjO8U2gX4t/b53zUxuFMj12J3Yhj++LCb4grQxSOfJYrEzl0h316MpsQUjMpOcM03VYNu0MD2cf2TPY5+K5q1zI8v54k4MsPM4SyLJwDV+KDv930=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cle/FF7o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cle/FF7o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BCBAC4AF0A;
	Tue, 23 Apr 2024 21:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908655;
	bh=lIt6A7pXU3CaNX42C5oZocoMxqbTli/2ubo7orE+p88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cle/FF7oLdz2syHlpDLDsq1ExStq+EfKnfx4VIh4vDwvOQh6RA1jdVATIGEnvSaPO
	 Ap4xdY26Ln7FUldxwhqae01gfe/eVrddWNxDCHwy142ZQ6yFBjWtvN1iROYfLsrYWC
	 PSxzMienyiZiVeNphr0nFGK+XNyyFJhJq9wqJDZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zack.rusin@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	dri-devel@lists.freedesktop.org,
	Ian Forbes <ian.forbes@broadcom.com>,
	Martin Krastev <martin.krastev@broadcom.com>
Subject: [PATCH 6.6 146/158] drm/vmwgfx: Fix crtcs atomic check conditional
Date: Tue, 23 Apr 2024 14:39:43 -0700
Message-ID: <20240423213900.426478772@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

From: Zack Rusin <zack.rusin@broadcom.com>

commit a60ccade88f926e871a57176e86a34bbf0db0098 upstream.

The conditional was supposed to prevent enabling of a crtc state
without a set primary plane. Accidently it also prevented disabling
crtc state with a set primary plane. Neither is correct.

Fix the conditional and just driver-warn when a crtc state has been
enabled without a primary plane which will help debug broken userspace.

Fixes IGT's kms_atomic_interruptible and kms_atomic_transition tests.

Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Fixes: 06ec41909e31 ("drm/vmwgfx: Add and connect CRTC helper functions")
Cc: Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v4.12+
Reviewed-by: Ian Forbes <ian.forbes@broadcom.com>
Reviewed-by: Martin Krastev <martin.krastev@broadcom.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240412025511.78553-5-zack.rusin@broadcom.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -926,6 +926,7 @@ int vmw_du_cursor_plane_atomic_check(str
 int vmw_du_crtc_atomic_check(struct drm_crtc *crtc,
 			     struct drm_atomic_state *state)
 {
+	struct vmw_private *vmw = vmw_priv(crtc->dev);
 	struct drm_crtc_state *new_state = drm_atomic_get_new_crtc_state(state,
 									 crtc);
 	struct vmw_display_unit *du = vmw_crtc_to_du(new_state->crtc);
@@ -933,9 +934,13 @@ int vmw_du_crtc_atomic_check(struct drm_
 	bool has_primary = new_state->plane_mask &
 			   drm_plane_mask(crtc->primary);
 
-	/* We always want to have an active plane with an active CRTC */
-	if (has_primary != new_state->enable)
-		return -EINVAL;
+	/*
+	 * This is fine in general, but broken userspace might expect
+	 * some actual rendering so give a clue as why it's blank.
+	 */
+	if (new_state->enable && !has_primary)
+		drm_dbg_driver(&vmw->drm,
+			       "CRTC without a primary plane will be blank.\n");
 
 
 	if (new_state->connector_mask != connector_mask &&


