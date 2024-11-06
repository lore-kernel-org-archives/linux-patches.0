Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB321DED49;
	Wed,  6 Nov 2024 12:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895621; cv=none; b=SIaIBTvHsYniGm1f+3sGpiEJfdcU5QnctgdlFd1/e1UFMmHswMhNYXnMNbik14htVwLQ7aqNLp861CNrhTI4yEtFRhewfQwjZX6q8k/I5tFIKJvf8OiHl7QIig85nq5zqlsLq90JfkeqqBBDPzN5+G1sWIz3+Qxnp3Worrso6L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895621; c=relaxed/simple;
	bh=YlP2E6xFY6vhHcFdw3pVf7irA320JHEUxZjalBtPuCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gfft7tWA1j8B3Pll/Lrvl/Hrxd9Lutjn7gqzgZ9PnfOuOlUme6QCFVVz9b33t9Ez9inwcjILcwRCXdIGJZPXhFInsGk7xOUH+uUONFrrOhFsfRy5DYX4FeTPidQpLGQ8L0kYZ6XX0Mg47DAnVXwn84gBY3Qh45B4oyGlqyypqMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PxH4dCQO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PxH4dCQO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 748C2C4CED3;
	Wed,  6 Nov 2024 12:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895620;
	bh=YlP2E6xFY6vhHcFdw3pVf7irA320JHEUxZjalBtPuCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PxH4dCQOMDYfFQn5zdD7gCdNLpvh0V0mmbpf8QgBDkgojb7iK2Vs4eRlAsY5xX+Yq
	 vmXMJhF1lwgtkxsH2T7lFImgdhpGHDKVPqqQuTASC3PCARXa5tRuxkMHX8VX1wttPq
	 fizTzSMtyuj+v2tfC0Yt53mm1GZSnTNCRvZaz5R8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Kuratov <kniv@yandex-team.ru>,
	Zack Rusin <zack.rusin@broadcom.com>
Subject: [PATCH 4.19 278/350] drm/vmwgfx: Handle surface check failure correctly
Date: Wed,  6 Nov 2024 13:03:26 +0100
Message-ID: <20241106120327.729855829@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1468,6 +1468,7 @@ static struct drm_framebuffer *vmw_kms_f
 		DRM_ERROR("Surface size cannot exceed %dx%d",
 			dev_priv->texture_max_width,
 			dev_priv->texture_max_height);
+		ret = -EINVAL;
 		goto err_out;
 	}
 


