Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0AE1EF940;
	Mon, 21 Oct 2024 10:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507727; cv=none; b=fa3OUogNQKZk2XtGrar1coZyFFsDmJgjFmwDoD0T6S3CzwZ13+uAVcwokOl+cvUHtl3ulHq4FHl05IKX0V7w4BK/YSODlzVjxnDkVgOGvLOVR3QSdSq5FCL8ij7kANf+M153UOlAZ0xK9VXPeeAO2qUy9ll5N2wLOgNe67kCxCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507727; c=relaxed/simple;
	bh=aK58NI6ZjvI/QzgYzC1aNCl9cCK4bT3GCZy9y6hq21A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YJ7sgKNwiwwTNNKuyLRbKw85xuT8vs8qkOwgZQBS7tvbaup8lKZ68xTeYZ7KJjMNYMW62OOj+sjIwdMFCeqsaai0bl9jkk7mUeT1JKIwJ+7PciSKX1L0uVRZg9VH86x5Viar5dz/nk2mVCCYLynMy8jN19fF1SB30DKVC9gBVoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BULLUEr7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BULLUEr7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B6C9C4CEC3;
	Mon, 21 Oct 2024 10:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507726;
	bh=aK58NI6ZjvI/QzgYzC1aNCl9cCK4bT3GCZy9y6hq21A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BULLUEr753PskPcxnuNCFyrt5zwhjxRVYr8vuRNnfeZp1eElCe/1MI6O+hitSf9BE
	 LyuQ7G0IXwxUm59EZPNtCMVTYnSlg8jRIMM6czmWXsw9oQYTQ7NdHPGYlExpmGETmf
	 QqbH1wV2Dobj+WcJfCxFBTwPNq56wWh6bellewak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Kuratov <kniv@yandex-team.ru>,
	Zack Rusin <zack.rusin@broadcom.com>
Subject: [PATCH 5.15 50/82] drm/vmwgfx: Handle surface check failure correctly
Date: Mon, 21 Oct 2024 12:25:31 +0200
Message-ID: <20241021102249.219094457@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102247.209765070@linuxfoundation.org>
References: <20241021102247.209765070@linuxfoundation.org>
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
@@ -1417,6 +1417,7 @@ static struct drm_framebuffer *vmw_kms_f
 		DRM_ERROR("Surface size cannot exceed %dx%d\n",
 			dev_priv->texture_max_width,
 			dev_priv->texture_max_height);
+		ret = -EINVAL;
 		goto err_out;
 	}
 


