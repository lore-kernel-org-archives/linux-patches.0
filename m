Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2A5183CD5;
	Tue, 30 Jul 2024 16:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357415; cv=none; b=ow1Sj5v5CK73OTB0f2XSWPcbgVLbp9d2ozsLNGte7ywR8vd1onb3e4nHDXXVa+HqwQN81pSLkZqGJ9p1pxev/4ifDY82K5KjaeuFHrGTekIJGejmh46ek504AZB5g+HRTrl54QQTmIuo1GHN4JS6OMbjSWHDhoXxw4rwKMGpFx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357415; c=relaxed/simple;
	bh=rKrLZpqolH+WMlyy3Jx+2jxnwiYddSa5jI0gLqwreBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ehmP80QR5MViP1k/0x+KBIcMF4OYGT0uBRaPldPac3mqO2QuYHjLHDLQdYs1spJuDd87QcGEsJEBIZpqx1mM30UH62rCqyQAbUKFCwz70dNqsZ/HwmZAWa6WbltuGHy1zg+z4c0+05DaUrY3yYrm507kYspcD/0dJ7vUHPSkIKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cdcGKZOz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cdcGKZOz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B12C4AF0A;
	Tue, 30 Jul 2024 16:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357414;
	bh=rKrLZpqolH+WMlyy3Jx+2jxnwiYddSa5jI0gLqwreBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cdcGKZOzG7KLqk5pHSHwTyaXPwgPKco9p+7lBFFcF8C5YnYhbP1XwOUuUZB9W5L28
	 p4Wfk87iA35JwxMQCi4q7extkzaLflWYv5dZz+5d/qGu+ByX+yxKqIGogM9CP/HWvg
	 83VlFnA7U3SHXsR7jGUDrhOeY5UUdiBc18yBiR68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Subject: [PATCH 6.1 290/440] drm/gma500: fix null pointer dereference in cdv_intel_lvds_get_modes
Date: Tue, 30 Jul 2024 17:48:43 +0200
Message-ID: <20240730151627.160149524@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -309,6 +309,9 @@ static int cdv_intel_lvds_get_modes(stru
 	if (mode_dev->panel_fixed_mode != NULL) {
 		struct drm_display_mode *mode =
 		    drm_mode_duplicate(dev, mode_dev->panel_fixed_mode);
+		if (!mode)
+			return 0;
+
 		drm_mode_probed_add(connector, mode);
 		return 1;
 	}


