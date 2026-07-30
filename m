Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5997443F4C7;
	Thu, 30 Jul 2026 15:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424357; cv=none; b=uhwQUsWRpeBFUtn+POnHLmpS5Cc0w52luCmNWcFbtAYElv01XLRUaBGhrQ0Mlhbl77ZkmGUHHtYm3bt3SPxXxxpqRNfdnLJoSIhtAqmpb5moSi3OXX1nz2pnjzx6EDG7eRFWqXrzu49aFFdL845SuDKlifz1WNRg3j4eGJ/OvcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424357; c=relaxed/simple;
	bh=ABwzkEymRWP3nl/62qMyKsIj9GXxP8vWxt2wFRGbWKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eid89HOsK9OW+NLmJx3i768y+DwQOdwokP/zdfRczEyW0He1NLZ55r9TmJqkEOfV23Z2KyVyq6I4mOx1PEA4WwMkdEGXbae7OiUBmF3DyxCHkalqjWhJ0vCxERMH0gsOc01Pgcmeg3Nzt7g+n7fmK9cFTdX3rf6gvWy4dvZUomc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hOuzyIub; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hOuzyIub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 807401F000E9;
	Thu, 30 Jul 2026 15:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424356;
	bh=XyT4EuGWuKjIueZPoQi0z+ImAADdrSss6KxvmhO4Dw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hOuzyIubD6Y+VCNJYpTy+bAlFEk5lTMMbOT2PSbCbTMnpGobsljfWW06OpJ2YKHk3
	 MMS+mH4d2jcb5vWApv+8WzML/fRZACRa01QNZ5hRBpBSbCrroGQ2/82x10Gp6KdA2A
	 WyT0t48OEm6VsexvfMLEC/mvkndCJVTHf8zOxBSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Subject: [PATCH 6.18 320/675] drm/tidss: Fix missing drm_bridge_add() call
Date: Thu, 30 Jul 2026 16:10:50 +0200
Message-ID: <20260730141451.926983969@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

commit 83084bb36847cbd2b13743f7333aaca12613a72b upstream.

tidss encoder-bridge is not added with drm_bridge_add() call, which
leads to:

[drm] Missing drm_bridge_add() before attach

Add the missing call, using devm_drm_bridge_add() variant to get the
drm_bridge_remove() handled automatically.

The commit marked with the Fixes tag (from v6.6) is the commit that
added the encoder bridge without drm_bridge_add(). However, this fix is
not directly applicable there as devm_drm_bridge_alloc() was not used to
alloc the bridge, so using devm version for drm_bridge_add() wouldn't be
safe. Instead, drm_bridge_add() and drm_bridge_remove() would be needed
there, but that would require new plumbing code as we don't have a
separate cleanup function in the tidss_encoder.c, not in the tidss_kms.c
from which the encoder is created.

Also, there has been no reported bugs caused by the missing
drm_bridge_add(). The drm_bridge_add() initializes the bridge's
hpd_mutex, but HPD is not used for the encoder bridge. drm_bridge_add()
also adds the bridge to the global bridge_list, which is only used in
of_drm_find_bridge(), and again that is not used for the encoder bridge.

Thus, while the original commit is not right, there should be no bugs
caused by it, and for the time being I'm not sending a patch for the
stable kernels for the original commit.

This fix applies on top of commit 66cdf05f8548 ("drm/tidss: encoder:
convert to devm_drm_bridge_alloc()"), which changes the tidss_encoder.c
to use the devm variant (added in v6.17). The warning print was added in
v6.19, so applying this fix to v6.17+ gets rid of the warning for all
kernel versions.

Cc: stable@vger.kernel.org # v6.17+
Fixes: c932ced6b585 ("drm/tidss: Update encoder/bridge chain connect model")
Acked-by: Maxime Ripard <mripard@kernel.org>
Link: https://patch.msgid.link/20260311-tidss-minor-fixes-v2-2-cb4479784458@ideasonboard.com
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/tidss/tidss_encoder.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/tidss/tidss_encoder.c b/drivers/gpu/drm/tidss/tidss_encoder.c
index 81a04f767770..db467bbcdb77 100644
--- a/drivers/gpu/drm/tidss/tidss_encoder.c
+++ b/drivers/gpu/drm/tidss/tidss_encoder.c
@@ -106,6 +106,8 @@ int tidss_encoder_create(struct tidss_device *tidss,
 	enc = &t_enc->encoder;
 	enc->possible_crtcs = possible_crtcs;
 
+	devm_drm_bridge_add(tidss->dev, &t_enc->bridge);
+
 	/* Attaching first bridge to the encoder */
 	ret = drm_bridge_attach(enc, &t_enc->bridge, NULL,
 				DRM_BRIDGE_ATTACH_NO_CONNECTOR);
-- 
2.55.0



