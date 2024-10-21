Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D149F1EABB6;
	Mon, 21 Oct 2024 10:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507031; cv=none; b=qli7EZCxnr9g2alzrsXqwk8EhQCqWyZBaq8Xw8eBV9PNAwSb8lakQRRuUHbqlGNDQWvrIjQbrq0ByfKjoU9bWXO0aVqMsOwKmvPYCjawe4X5xj7IvpcPQaKpKlathMRg0EHTaCKbG4vjk714gP123tDkT2GqyLzyuJ6Tazp+aAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507031; c=relaxed/simple;
	bh=uDoKHkzRX5ViTXoc0765LQXkIWRYvxpO/v5dRLN4BOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HuBs/WHnzCCmEpGdPis9UJk91Qko/EnxD0ajF7mJ2ol3+2DXo99ZWaw7SbpWydlvx5zf2b0biKrjFzrVZUJKLfIlb+cTARuTFGfqLDzipfeJ8LMaLDzqotp572KZewihERPLWIbjh3hz68uOnsON3HQJMzvQ8nJDCHb1ZhaeJ30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cYamFc26; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cYamFc26"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53929C4CEC3;
	Mon, 21 Oct 2024 10:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507031;
	bh=uDoKHkzRX5ViTXoc0765LQXkIWRYvxpO/v5dRLN4BOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cYamFc26oB2WNKecyiD9NaihvAXWwNKnLaqyQeHNJLD42QQWc1X1MSwlHiEqiexh7
	 oUo32M853YU+t/cYfUtNH2eWrkFRhI1Yj0DWIgEwOGJeLpS9O82d7UOgLYopkTUzZC
	 g0pYbID6oP6jEFJkMpElkRc8djwRMpaTNzfPNgnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Kuratov <kniv@yandex-team.ru>,
	Zack Rusin <zack.rusin@broadcom.com>
Subject: [PATCH 6.6 067/124] drm/vmwgfx: Handle surface check failure correctly
Date: Mon, 21 Oct 2024 12:24:31 +0200
Message-ID: <20241021102259.326434132@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
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

From: Nikolay Kuratov <kniv@yandex-team.ru>

commit 26498b8d54373d31a621d7dec95c4bd842563b3b upstream.

Currently if condition (!bo and !vmw_kms_srf_ok()) was met
we go to err_out with ret == 0.
err_out dereferences vfb if ret == 0, but in our case vfb is still NULL.

Fix this by assigning sensible error to ret.

Found by Linux Verification Center (linuxtesting.org) with SVACE

Signed-off-by: Nikolay Kuratov <kniv@yandex-team.ru>
Cc: stable@vger.kernel.org
Fixes: 810b3e1683d0 ("drm/vmwgfx: Support topology greater than texture size")
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241002122429.1981822-1-kniv@yandex-team.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -1659,6 +1659,7 @@ static struct drm_framebuffer *vmw_kms_f
 		DRM_ERROR("Surface size cannot exceed %dx%d\n",
 			dev_priv->texture_max_width,
 			dev_priv->texture_max_height);
+		ret = -EINVAL;
 		goto err_out;
 	}
 


