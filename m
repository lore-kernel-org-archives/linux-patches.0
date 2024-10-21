Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1136339FD6;
	Mon, 21 Oct 2024 10:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506623; cv=none; b=TSMywpYZ7PAUid85VNwNEFq9I9DjW3dG/osEagcjm476gK6ZmKmC2JcTwgl2aB2GoisdQsqVpmljbSR26/YyhJUwTlDsgJDl2Fn+tCsMlR9vxHCUEErNLTSusJ6d4noelNXGTnYaNXOsxawmRlLoLt+iU8f6Y+dth5rp40PylzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506623; c=relaxed/simple;
	bh=l7sZn7z5687bH6OR1z+dY6SXn6uk9cD8q/vTQD7d9JM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i9qiAcm1exjzx7epW0Mv14exV59opbZjA40JYmck+rVPL6DT2v3tj8HKSYKB+BV8WGxzXLlcdtezlYR3mFdFD/g9wp+cWXwfiuDYLu2WkB2/3IlJSDkrdcbmLCL+sWXMn8RiQ/VI2SS2NRxvQXiXmoK3qJNwBv+wV60a30CGNeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JInrPKYl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JInrPKYl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8351BC4CEC3;
	Mon, 21 Oct 2024 10:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506622;
	bh=l7sZn7z5687bH6OR1z+dY6SXn6uk9cD8q/vTQD7d9JM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JInrPKYl9VRgU0NaiEZrPScwdI8JqKxqJG9cjglabAcULrFswcivEeIqwfPRSN+Pg
	 akDxw/2VRj8y6jaOX81y6X9KS00Czc83pgslRGD0as8T9Rdxjr+ig4tyU8QiJbbHAV
	 a0ejIynRu/hMMCaQt3oEtTTvcGEIbjQjONLwy0r0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Kuratov <kniv@yandex-team.ru>,
	Zack Rusin <zack.rusin@broadcom.com>
Subject: [PATCH 6.11 065/135] drm/vmwgfx: Handle surface check failure correctly
Date: Mon, 21 Oct 2024 12:23:41 +0200
Message-ID: <20241021102301.874679304@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1510,6 +1510,7 @@ static struct drm_framebuffer *vmw_kms_f
 		DRM_ERROR("Surface size cannot exceed %dx%d\n",
 			dev_priv->texture_max_width,
 			dev_priv->texture_max_height);
+		ret = -EINVAL;
 		goto err_out;
 	}
 


