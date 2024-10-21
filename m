Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0A91F9437;
	Mon, 21 Oct 2024 10:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507828; cv=none; b=q8RHm1zZPT/b3cQYDWZpZG0bUcuS3xhOdkD1QjIkepSx3IJaNwshKyXm2eiDpOZl/vQLf1e6xMDPjpu6dl2NT6VwW5So1C5jfH5S2sDGkV6VLQflPdCG8zvENHZ0OfnmjmfzrFliagekag3TYxG4fasd3urH2eGOyQIVrvXQ3+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507828; c=relaxed/simple;
	bh=ezrB8lyNANDuHv5v8r3nZEvjDOmstPn7dvkZDZAc0Tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZXrvg4bNE/eajy7aSS964yv6mciJ+cxGucW+vpf5mwqjstBHL586oGq3kbgokKdybq2XSNyQYrUpTGHJ3q0TBHI88YylaUByWIbuPQhFR8sEUUjkjHtYCZ5vZKY+GfCWXXFaK5uzlCbLzHe3lQWW+47znNIAXyGxXPNTTebWR3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=la82CTeq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="la82CTeq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B055C4CEE5;
	Mon, 21 Oct 2024 10:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507828;
	bh=ezrB8lyNANDuHv5v8r3nZEvjDOmstPn7dvkZDZAc0Tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=la82CTeqeL1+3a1X50bS9z1wDewhCoRRNyEuE6lC/SMZhgvODVogM/mwKmZlfWVN2
	 ogDfU14zEB8Hy/0YUH0eccTgWoJQGKQvUfXDDVaishLIrGnYmnpRTLtlP2TZ/5CGFX
	 DeaReaBbA+IZ0URvfJFJ7mpaVORdrHzW8PZl2crE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Kuratov <kniv@yandex-team.ru>,
	Zack Rusin <zack.rusin@broadcom.com>
Subject: [PATCH 5.10 25/52] drm/vmwgfx: Handle surface check failure correctly
Date: Mon, 21 Oct 2024 12:25:46 +0200
Message-ID: <20241021102242.612681070@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102241.624153108@linuxfoundation.org>
References: <20241021102241.624153108@linuxfoundation.org>
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
@@ -1402,6 +1402,7 @@ static struct drm_framebuffer *vmw_kms_f
 		DRM_ERROR("Surface size cannot exceed %dx%d",
 			dev_priv->texture_max_width,
 			dev_priv->texture_max_height);
+		ret = -EINVAL;
 		goto err_out;
 	}
 


