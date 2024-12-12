Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EDFF22652A;
	Thu, 12 Dec 2024 16:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020568; cv=none; b=fNRP5sdWh6mAKyk2jHainhRKnAZRMuG2+aNvW+ib4xsrE2mrwc/G7Tb0qZjN4UTW3cfwcqVhExZCeU5k9/JGbcrSQTasRe6JBtKIEU+9I9LZDrz9FOF6vIGG6oOiDq9RssI91nClwHijCsETqfj8+epp8X3WReQ+WLtOCyacPyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020568; c=relaxed/simple;
	bh=mjUDnir5VS0T1sgR3yTbSLGui1Ma3RSkxowoJxiL9HM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YVfeGeFXLfbKRCLTpdmUR0R6TBuU0rG+aX1+9BJIaFh1Q9+VsU+vD1zLbCZBz26yWEJ5AeQtfTw+D9ytpC4r4Cr5Th8btBbz3zIYs65BRHLshoJbDKhjDkUhvBHFGER3IfoLfho+cLnvH4vhXXNoEic4iprPYJbZ//8ykWGl5+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vOVoGDhW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vOVoGDhW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75177C4CED0;
	Thu, 12 Dec 2024 16:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020568;
	bh=mjUDnir5VS0T1sgR3yTbSLGui1Ma3RSkxowoJxiL9HM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vOVoGDhW3ActHGst1yQBOHKKUx4aSmRkSrOjKOf4tJCiAU+EB/bMQNVnJ+kYYjb0O
	 3j8qjwAEAh86Q6g7Vz583wVnrfSdDo/c02KqQJzcbMj2ZhkN2S3alPsRGywFtNydRE
	 6sW8iNXu0gkmOfpkUwgHYScwhT/jGvvxzeww/lQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Alain Volmat <alain.volmat@foss.st.com>
Subject: [PATCH 6.1 502/772] drm/sti: avoid potential dereference of error pointers in sti_hqvdp_atomic_check
Date: Thu, 12 Dec 2024 15:57:27 +0100
Message-ID: <20241212144410.703025784@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

commit c1ab40a1fdfee732c7e6ff2fb8253760293e47e8 upstream.

The return value of drm_atomic_get_crtc_state() needs to be
checked. To avoid use of error pointer 'crtc_state' in case
of the failure.

Cc: stable@vger.kernel.org
Fixes: dd86dc2f9ae1 ("drm/sti: implement atomic_check for the planes")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Link: https://patchwork.freedesktop.org/patch/msgid/20240913090926.2023716-1-make24@iscas.ac.cn
Signed-off-by: Alain Volmat <alain.volmat@foss.st.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/sti/sti_hqvdp.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/sti/sti_hqvdp.c
+++ b/drivers/gpu/drm/sti/sti_hqvdp.c
@@ -1037,6 +1037,9 @@ static int sti_hqvdp_atomic_check(struct
 		return 0;
 
 	crtc_state = drm_atomic_get_crtc_state(state, crtc);
+	if (IS_ERR(crtc_state))
+		return PTR_ERR(crtc_state);
+
 	mode = &crtc_state->mode;
 	dst_x = new_plane_state->crtc_x;
 	dst_y = new_plane_state->crtc_y;


