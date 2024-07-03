Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB7216FF2A;
	Wed,  3 Jul 2024 11:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004549; cv=none; b=YLUmzqMgo4B0jf3hEuF5+Ku/n+rxxtglg7IIVTs7I3cRV/uomoKKIST3olmzVRFYPvmT2XFQ7CvOsKun17UPmDvhZ3AfDKidD2rLxeubqEp6hmB7R2PYO4liPGfJs35cdWscN8REvpq9EdwlU+pycozSl2GKySLrReIlay/2wZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004549; c=relaxed/simple;
	bh=WsUkJDOa7SoogRXkr5Gp1Xf9scAHAlRVleGiXtarJ08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R0pA4IL3Hcv+EznOsowrYmNkOcx7poCwnVh+n7CGopvG1Y7f+kCvPBWP2Gf62s7fZxrfRtWEchNoQyOEEw+NGqXK0tBBJLXx27mwBZlX/Bd+d+NdArDt6piK2eydYnNeUwCwVgBYROHUm8XA+20Jy08icGIQSpWnjKKbB2m+wZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rkgc6Ghj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rkgc6Ghj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68372C4AF0D;
	Wed,  3 Jul 2024 11:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004549;
	bh=WsUkJDOa7SoogRXkr5Gp1Xf9scAHAlRVleGiXtarJ08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rkgc6GhjgbZfdFJyzg/b4UskyzBEvXrU/lVDeDE0MVOIR9EqY/5fi6fdNtpDJGNDl
	 bYzw7KvCfyObf00AlFmPv4ybQCrP14Dc17dcqw2WIb22kWfVqPDdfBJp88OYIkybS6
	 yTCUqfPbzUiN0CYZqgOLwrry4o7qx4fdXWzCUYv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jani Nikula <jani.nikula@intel.com>,
	Inki Dae <inki.dae@samsung.com>
Subject: [PATCH 5.10 078/290] drm/exynos/vidi: fix memory leak in .get_modes()
Date: Wed,  3 Jul 2024 12:37:39 +0200
Message-ID: <20240703102907.142730632@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


