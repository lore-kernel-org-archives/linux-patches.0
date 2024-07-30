Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1D51A76A9;
	Tue, 30 Jul 2024 17:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360042; cv=none; b=Jvs4Oj9q/QUnXHpHCtQvjJePMfeZKpGwQkUgdWoticehdhszAGdHNjjAztxWPEndMsIkQcYl79C/wqaKavYnEKCSvCLp0iM2OAaNJdSXLOr0XMyFSF1tPmu3fxGTmFLSj/DZVeAzW0aq1mpBMyRTzZe72n5PoVu2o6/AIXxRUsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360042; c=relaxed/simple;
	bh=6mn5b8b9nG/IXhcvH+EJ/u3N+Dmw/AQRcIOFCgFE+6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZBqwnXq+XkxQR4pqQN5lVK6BoL06PcZt/s64KMrlpaoHLWS6LWdK/Cscrl6Md7CdElNsHtaPGxPOARHRSB6X3C9h15xWwNZvOjn3ddwOr/kL0Apt9ih1BZK9mRDgScF9YYs0HY3WSywyfg6RgVOGDp9m5KdkrWcWAQm1rWeh52o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cgCBpD29; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cgCBpD29"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81246C32782;
	Tue, 30 Jul 2024 17:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360042;
	bh=6mn5b8b9nG/IXhcvH+EJ/u3N+Dmw/AQRcIOFCgFE+6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cgCBpD29XrVwh2suuiK+crW+PdM7UTw8xZaQJTFNVZmR53ozJBlF/BPK8Jno24B5t
	 ilalfPzcX7E8snP9U8RrfmYosoleZp9aZBwkdybQbQp5Um7RqXezQ23L+5ht8+FrNs
	 B5aFuLWOtq38FHHz/Zn5oHU/xqr+m2khjxdhuRao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Subject: [PATCH 6.10 578/809] drm/gma500: fix null pointer dereference in cdv_intel_lvds_get_modes
Date: Tue, 30 Jul 2024 17:47:34 +0200
Message-ID: <20240730151747.608320123@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit cb520c3f366c77e8d69e4e2e2781a8ce48d98e79 upstream.

In cdv_intel_lvds_get_modes(), the return value of drm_mode_duplicate()
is assigned to mode, which will lead to a NULL pointer dereference on
failure of drm_mode_duplicate(). Add a check to avoid npd.

Cc: stable@vger.kernel.org
Fixes: 6a227d5fd6c4 ("gma500: Add support for Cedarview")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240709113311.37168-1-make24@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/gma500/cdv_intel_lvds.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/gma500/cdv_intel_lvds.c
+++ b/drivers/gpu/drm/gma500/cdv_intel_lvds.c
@@ -311,6 +311,9 @@ static int cdv_intel_lvds_get_modes(stru
 	if (mode_dev->panel_fixed_mode != NULL) {
 		struct drm_display_mode *mode =
 		    drm_mode_duplicate(dev, mode_dev->panel_fixed_mode);
+		if (!mode)
+			return 0;
+
 		drm_mode_probed_add(connector, mode);
 		return 1;
 	}


