Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A7618801A;
	Tue, 30 Jul 2024 16:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358682; cv=none; b=tuiovJvZlpMf31bAEmtsalbCP+MhsZHbpsYTiGArWUJNz7ARiCQvfhIILKpaCyGTm+RfNH832r2qQnvQY1VH0sPiukhPm4mrfGBApPSS7z9pTzKRByKuW8e7XY+VCOEP8imHxD+z9gr9oiRc089r/j7iVZlzt0gxStmN8KMJ3I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358682; c=relaxed/simple;
	bh=FEimZ++kVNIDNcvbdXHm02Y22dYQhGjUAD1cK1y8jTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lbh+NVIzWCpEl3q3AxttsaD45CvquSfgKkAN0C8qMy21cXGs1XYus5XC8J+zGEwvThxw91XKy7D1H6QJdwmpKc04YXCntfJzBT64Muq1R4UJ3/M3IWYDlWndfgVVp9ZYSt1zO6f0R60RNG5fi728rKWuewMpi+BzQX3gae6QMZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UMZqAEUh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UMZqAEUh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 509C9C32782;
	Tue, 30 Jul 2024 16:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358681;
	bh=FEimZ++kVNIDNcvbdXHm02Y22dYQhGjUAD1cK1y8jTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UMZqAEUhaGHI9B9ZCjsJsYEO0h9JYMOZm8C0V7VAJCrAhHzTpSSDivs7YFOZFQHFF
	 1thYlPKsny/9nnSsQxLDlFAhiGkHPvaV7CIcMuWsOhN3Y1mswpPmc5Guk3VZnllvuX
	 pG4KSR1izWOeULI1qs6QL6mJ0V2ksbA4IsX2vobI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Subject: [PATCH 6.6 385/568] drm/gma500: fix null pointer dereference in cdv_intel_lvds_get_modes
Date: Tue, 30 Jul 2024 17:48:12 +0200
Message-ID: <20240730151654.914141080@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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


