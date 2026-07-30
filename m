Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E38438468;
	Thu, 30 Jul 2026 14:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422215; cv=none; b=SgPUssH6e7tHIIgkPOzfhzyf5lFDm8qOq1Ydb/VLqJR388hEnogwqh1ImZfsXfxxPLcBmQ9bvpSDuw+QFSyMyfsQbp9XkMDpnWUU9o4Zvsp2MYCtaCuhcTF+smDZhd7PiLg8MxjmDLN4wuSO1qjgb/361NLECVWPrWrWx/lWm9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422215; c=relaxed/simple;
	bh=c/DogLW4IEkYigmWC8g6bs6lbDIl5ecZtKvRvydZHLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+eeuyK7QYd005s9hoP+4LG2QS1GXqga8RBU64eN69rwEARJ9HDvUcm/0nn2yOOduWajJXrJ839iYjhNAvzNnU8g0YcqBGsHODDsPm3XqovIgMRog+TtopZtAo0iajYWC6y6hA+Xe5EeTtCaabhEfmJZ831s7wJpXjVxLN0M4Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fjA5430o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fjA5430o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97511F000E9;
	Thu, 30 Jul 2026 14:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422214;
	bh=nRTQipy2oodNj17DAZL09R8eLJ9UTjZUX7T2np3zaVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fjA5430oGvtp0OZL7wOvXwXHGQ6v+reVKdzjzY1XmAHaHjjA8y0Qd9CLsCDSZIWLq
	 5BG1VStqvnG0DdKJNowOukSOI49itlpaxj9ctQEQ2OkV/+GNp4Tw3e9jx2e/1Lizsw
	 ZPKv3q4O/+BsjWsRyCfxgsUwiYv13O5E2HMtl2cI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Subject: [PATCH 7.1 361/744] drm/tidss: Fix missing drm_bridge_add() call
Date: Thu, 30 Jul 2026 16:10:34 +0200
Message-ID: <20260730141451.959573283@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/gpu/drm/tidss/tidss_encoder.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/tidss/tidss_encoder.c
+++ b/drivers/gpu/drm/tidss/tidss_encoder.c
@@ -106,6 +106,8 @@ int tidss_encoder_create(struct tidss_de
 	enc = &t_enc->encoder;
 	enc->possible_crtcs = possible_crtcs;
 
+	devm_drm_bridge_add(tidss->dev, &t_enc->bridge);
+
 	/* Attaching first bridge to the encoder */
 	ret = drm_bridge_attach(enc, &t_enc->bridge, NULL,
 				DRM_BRIDGE_ATTACH_NO_CONNECTOR);


