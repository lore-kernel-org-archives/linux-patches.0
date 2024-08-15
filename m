Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58DED3214;
	Thu, 15 Aug 2024 14:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731423; cv=none; b=jByJ+zFp0Sm1+kO2X5YNuWgFvtQCUAoZYe6Rox+pOk9VZhCwDhiKHcOzWWV4kO8iDLZY4HoWHzbPzEkHkR8ESRD7QtXZnsB3sTqaWY9QacCEO1xB+L486y7qTEFj1TQ5CBL0BRsS6wm/LX/ngmswIyqzM78U0b4mAYRq15gih08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731423; c=relaxed/simple;
	bh=Pa6qSY038yoAm4mmT1ArWo3ZkXAni2vwC+/2cxZsBNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZjBG2XwWVKOEJQl59QUwIILxczw//1iHMnPEupjImS4h2OwM6HPIIA78SPJKtvQHvebOZ0nNK3InmmWbk6MGzKOa93Z2p506Gr+7eFbEZmICvBx+jsZRTdnG5EGSKVxa+fZDsN0L0TmmELh1TsNdd3cabmaZrbjUIgJbGOqcMl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kbQfJwnN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kbQfJwnN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4521C32786;
	Thu, 15 Aug 2024 14:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731423;
	bh=Pa6qSY038yoAm4mmT1ArWo3ZkXAni2vwC+/2cxZsBNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kbQfJwnNQDq8+jYRdJxrGzGpAF1Fu/Tt4QhYlIrl5zjTDqisxhfSxH51sf4+Dwxhk
	 ah8iHzo/Nl4Sx6neNQBsUs25JwOvIfpz57Fm3LmmQzGYCmoc3wtGspOrTao7GgHNyk
	 fCU37TNBaO/kyiWRY/q0D2/Ec+rnPgMyYxDVkaMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Subject: [PATCH 5.4 097/259] drm/gma500: fix null pointer dereference in psb_intel_lvds_get_modes
Date: Thu, 15 Aug 2024 15:23:50 +0200
Message-ID: <20240815131906.548214598@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit 2df7aac81070987b0f052985856aa325a38debf6 upstream.

In psb_intel_lvds_get_modes(), the return value of drm_mode_duplicate() is
assigned to mode, which will lead to a possible NULL pointer dereference
on failure of drm_mode_duplicate(). Add a check to avoid npd.

Cc: stable@vger.kernel.org
Fixes: 89c78134cc54 ("gma500: Add Poulsbo support")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240709092011.3204970-1-make24@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/gma500/psb_intel_lvds.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/gma500/psb_intel_lvds.c
+++ b/drivers/gpu/drm/gma500/psb_intel_lvds.c
@@ -506,6 +506,9 @@ static int psb_intel_lvds_get_modes(stru
 	if (mode_dev->panel_fixed_mode != NULL) {
 		struct drm_display_mode *mode =
 		    drm_mode_duplicate(dev, mode_dev->panel_fixed_mode);
+		if (!mode)
+			return 0;
+
 		drm_mode_probed_add(connector, mode);
 		return 1;
 	}


