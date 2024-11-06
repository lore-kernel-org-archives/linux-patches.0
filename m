Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91BEF1DFD9D;
	Wed,  6 Nov 2024 13:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898819; cv=none; b=V8WUutCp6KRZXEGT+QrLghSq4DgjXYBp8si2fH6ASy8sS1hEBFX//gIIReLjcbwvlcTfk66sUZn7MMItSrrUrJ+/sF4TJZjk1uh1IuqwKKNf9/ocLxSyokZocda0YcwgGP+3cBgKA4btDchfTZt63QBTYsidWK6t1HYswZfLPx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898819; c=relaxed/simple;
	bh=HpU8QtGdBw64HfhMEEhco3qPVEDX5R5w4E1bMncUXks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=imPkxwXnRlG3RtSFa5lSZ6/RajhiOCblnU4hplNNsnbSCtzBbnCi2lZCiukLOvvAo0GeDHuKmwFJaKM6RqkvZIZqq82uKNf1V/GiZ2d1CQDt0D3dapfTCE5O1D5H7LUYBTSxijhpeBZPZgz0/Na4S0Q4fkP5US3/eI9IgZtJYBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g/Sz/9Qg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g/Sz/9Qg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A50C4CECD;
	Wed,  6 Nov 2024 13:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898819;
	bh=HpU8QtGdBw64HfhMEEhco3qPVEDX5R5w4E1bMncUXks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g/Sz/9Qgl5QXnY65D+xyeVQduhHdWEJWzpkICoahDwSJ+cPcEkdjhXAVxeA/wtHTf
	 oGiRVs9/XgRkptpx9SMAglEkGcKTymawF0SOxW/VzjUfZuoOyJLwx6ybUS6o6kuVlT
	 N5HyiQ3uFt8m1gKXgx56pF+TgqyQbK9QNloPKMLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Kuratov <kniv@yandex-team.ru>,
	Zack Rusin <zack.rusin@broadcom.com>
Subject: [PATCH 5.4 366/462] drm/vmwgfx: Handle surface check failure correctly
Date: Wed,  6 Nov 2024 13:04:19 +0100
Message-ID: <20241106120340.570772368@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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
@@ -1410,6 +1410,7 @@ static struct drm_framebuffer *vmw_kms_f
 		DRM_ERROR("Surface size cannot exceed %dx%d",
 			dev_priv->texture_max_width,
 			dev_priv->texture_max_height);
+		ret = -EINVAL;
 		goto err_out;
 	}
 


