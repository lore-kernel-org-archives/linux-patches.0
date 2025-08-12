Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5AF2868AF;
	Tue, 12 Aug 2025 17:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021040; cv=none; b=RcE12UGVQ2Upsv42UeTKl8rkcZaRAewOfsVNdkAE8tQbYjMXAyFLXEiU34wWiUAnLPNcGEoYxKrJuB8GE6e/M2m9lW1EefVBqChyE2ENY6gxiHidryXmbVzNGOVJDHyYAzCGust6e6FaPUkglFdzNEl6EWXLYZ71PP/WeuLlhJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021040; c=relaxed/simple;
	bh=BnQq+Lqv84KuW/mNvp0tvQC7ABSLCrG97CK4gFNobc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mP+jNn309pBZpfFx3PM6Cb/wUfX4/00kkBVJ82+QhDzAS8X1Yfk3QSTFacVliC0sQESnaQ+ULWqgoYX9mmrMNcPCO3iQMGRkBAy4lIJC4YRgqoSWy6lcKxtQyxOvmR2I/tIaGiPnT3h+7PpX25zv4LV2+v1Zfpxt1rTBBw6W8pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OMuU7/PU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OMuU7/PU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29F2FC4CEF0;
	Tue, 12 Aug 2025 17:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021040;
	bh=BnQq+Lqv84KuW/mNvp0tvQC7ABSLCrG97CK4gFNobc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OMuU7/PUOrqbal3uUJqe21lK+C9mdg2+YVhIjLlAbJdk560DDX+mVH8baEaaWDXSY
	 GqXQ4YJfV5wQnzutsA9Fx/6Ox4SeO9cloZlkbYMWhLV8fSKoeY2YE8eyeEl3Lp207u
	 lYG7dY1YGNI0pqOZ/TdehHNse9vCNlRZHBqgMKlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Forbes <ian.forbes@broadcom.com>,
	Maaz Mombasawala <maaz.mombasawala@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 053/262] drm/vmwgfx: Fix Host-Backed userspace on Guest-Backed kernel
Date: Tue, 12 Aug 2025 19:27:21 +0200
Message-ID: <20250812172955.237958294@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ian Forbes <ian.forbes@broadcom.com>

[ Upstream commit 7872997c048e989c7689c2995d230fdca7798000 ]

Running 3D applications with SVGA_FORCE_HOST_BACKED=1 or using an
ancient version of mesa was broken because the buffer was pinned in
VMW_BO_DOMAIN_SYS and could not be moved to VMW_BO_DOMAIN_MOB during
validation.

The compat_shader buffer should not pinned.

Fixes: 668b206601c5 ("drm/vmwgfx: Stop using raw ttm_buffer_object's")
Signed-off-by: Ian Forbes <ian.forbes@broadcom.com>
Reviewed-by: Maaz Mombasawala <maaz.mombasawala@broadcom.com>
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Link: https://lore.kernel.org/r/20250429203427.1742331-1-ian.forbes@broadcom.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_shader.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_shader.c b/drivers/gpu/drm/vmwgfx/vmwgfx_shader.c
index 7fb1c88bcc47..69dfe69ce0f8 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_shader.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_shader.c
@@ -896,7 +896,7 @@ int vmw_compat_shader_add(struct vmw_private *dev_priv,
 		.busy_domain = VMW_BO_DOMAIN_SYS,
 		.bo_type = ttm_bo_type_device,
 		.size = size,
-		.pin = true,
+		.pin = false,
 		.keep_resv = true,
 	};
 
-- 
2.39.5



