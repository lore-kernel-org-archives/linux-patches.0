Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C3115AAC9;
	Mon, 29 Jan 2024 17:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548368; cv=none; b=QSL+dk19a7s0RofnAH1F0RZ+FxPedWcfgh141S9ymC9to4FXjDbVeFBG6dzpDSm6Hp3OGWSUSl1+LvHYAefO/XoU/tZE8ZK/eM5sURjUS/YXgw5npD+CHNH4StTdLHZGBFab7nTZfXZNPwNHN9jc7oZJHINuS53Z8lOUOT8Z03M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548368; c=relaxed/simple;
	bh=KLPBhn68Eq/UvmaCbFo34rzVsavxmtfa5bE8ahD/eQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tx/1VWBTL3SRYJrEGjBGdqs99Ru2Ufp2w5RV9KR6gHtth6qU3h8+r57vkJgt4HSdIBufcM1evSjeDbFu3XOFYOlYEh8lYt6lCdYn8cCMucfEib3XTdIZWJaKNVrHBaIUK1WbTXN2syKj+36avt25WOnu2HkGL3DkwxGjAfrhBxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hK6Gkqlm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hK6Gkqlm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED5CC433C7;
	Mon, 29 Jan 2024 17:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548368;
	bh=KLPBhn68Eq/UvmaCbFo34rzVsavxmtfa5bE8ahD/eQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hK6Gkqlmh2qc7xRnjC1JFEMVPs2EvanAcQmH6mXnF6WoxAkshwFbcHloQ7/6/Z5NX
	 bubvenp0BcazA1blyyZTaHT+HwDnrZXE3gX/6LTdPTnic/Zr7mrx9L/eQfYOPxmHTt
	 LlJce2huyWnrOLlyKz5+Cabaiv0t9GdAl3ib0dqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Javier Martinez Canillas <javierm@redhat.com>
Subject: [PATCH 6.1 133/185] drm: Dont unref the same fb many times by mistake due to deadlock handling
Date: Mon, 29 Jan 2024 09:05:33 -0800
Message-ID: <20240129170002.862270474@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit cb4daf271302d71a6b9a7c01bd0b6d76febd8f0c upstream.

If we get a deadlock after the fb lookup in drm_mode_page_flip_ioctl()
we proceed to unref the fb and then retry the whole thing from the top.
But we forget to reset the fb pointer back to NULL, and so if we then
get another error during the retry, before the fb lookup, we proceed
the unref the same fb again without having gotten another reference.
The end result is that the fb will (eventually) end up being freed
while it's still in use.

Reset fb to NULL once we've unreffed it to avoid doing it again
until we've done another fb lookup.

This turned out to be pretty easy to hit on a DG2 when doing async
flips (and CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y). The first symptom I
saw that drm_closefb() simply got stuck in a busy loop while walking
the framebuffer list. Fortunately I was able to convince it to oops
instead, and from there it was easier to track down the culprit.

Cc: stable@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231211081625.25704-1-ville.syrjala@linux.intel.com
Acked-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_plane.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/drm_plane.c
+++ b/drivers/gpu/drm/drm_plane.c
@@ -1382,6 +1382,7 @@ retry:
 out:
 	if (fb)
 		drm_framebuffer_put(fb);
+	fb = NULL;
 	if (plane->old_fb)
 		drm_framebuffer_put(plane->old_fb);
 	plane->old_fb = NULL;


