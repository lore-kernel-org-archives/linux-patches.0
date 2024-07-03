Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8744418FDD6;
	Wed,  3 Jul 2024 11:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005638; cv=none; b=fVjz+DqLV+eTBbjJ5uESEDAop9zT9eBKvNk46VG8LEfSFaNJaCisuAcd7rGSu5ltHnyTtRzzaT01Txpagk3NjdZsIGGx0O6uhq5h5fIud3sizfOXkJlEAXQoDrylSkG/PDvJ7r2zIP31FtNO14rRKDRZPTshEJArwxY35s3+GWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005638; c=relaxed/simple;
	bh=01cjC0TUd0b7rmJLOCfuFFA8x5TINVQ1of6dMq+QRdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Js/XNcnpHO17cQMwSz/JnHjTCKOm5Q32gdjhKLGSUjXXo+euerFAtBq4TtXWEq/zLvvlHTmFL3PMNIgmQJZZlA4tZBEn7+sbb+8yRD6o3e4eq9DH9oHGdX68shwcAV0uaZbCjv51Q6A/arcdiBwrbIx7tMUyMCkp/QH1JBOKBD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nF5mZSAE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nF5mZSAE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C35AC32781;
	Wed,  3 Jul 2024 11:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005638;
	bh=01cjC0TUd0b7rmJLOCfuFFA8x5TINVQ1of6dMq+QRdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nF5mZSAElWvtqVNn5pl7AbPqP1byJoht4YF2HF/3Ko0eW/atHXyoIQDFRCBi0p6T9
	 Dvt8hRknUMHj5ntAGpK7ECIOJ1KGZzm3Nyia7ILSPGt6KcdYbvI5UY7J8dEkL7CFjK
	 KXk8OzL9mQSvqEBaz5HauicHuaZcWHCH49fu8MWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jani Nikula <jani.nikula@intel.com>,
	Inki Dae <inki.dae@samsung.com>
Subject: [PATCH 5.15 115/356] drm/exynos/vidi: fix memory leak in .get_modes()
Date: Wed,  3 Jul 2024 12:37:31 +0200
Message-ID: <20240703102917.448365719@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit 38e3825631b1f314b21e3ade00b5a4d737eb054e upstream.

The duplicated EDID is never freed. Fix it.

Cc: stable@vger.kernel.org
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/exynos/exynos_drm_vidi.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/exynos/exynos_drm_vidi.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_vidi.c
@@ -308,6 +308,7 @@ static int vidi_get_modes(struct drm_con
 	struct vidi_context *ctx = ctx_from_connector(connector);
 	struct edid *edid;
 	int edid_len;
+	int count;
 
 	/*
 	 * the edid data comes from user side and it would be set
@@ -327,7 +328,11 @@ static int vidi_get_modes(struct drm_con
 
 	drm_connector_update_edid_property(connector, edid);
 
-	return drm_add_edid_modes(connector, edid);
+	count = drm_add_edid_modes(connector, edid);
+
+	kfree(edid);
+
+	return count;
 }
 
 static const struct drm_connector_helper_funcs vidi_connector_helper_funcs = {


