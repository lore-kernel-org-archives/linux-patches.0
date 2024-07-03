Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CFC3188CDA;
	Wed,  3 Jul 2024 11:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005126; cv=none; b=FkbP+bbj6hNFIMBfyYu9zxnCDCuZqzelLkEzAi8pDguTkapaR3Sa+QGxw521VhPvbTOPdDajcQJcoAo6Xx+IdxwVu9xl2yTOqswR4CcjYuX4EhHlBdpdhf+iThXMisdZ2Dz8x2ZGGQB0qlQrg+dJpDdOqgaMujoLWtum6LxOR50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005126; c=relaxed/simple;
	bh=yRG5W8gWPbMcQjo48IMyYuI3otWWOTenPODn121SGKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Izm26xYijbC2pGWluQ7UeuWEJnEIselnJN9gY/3LGbG6YBdZs4O3kOngKOl4Z0zoxWWKiWsl8rV0Wqhlzh5FAwWJjExlqQPCvZim8QU3EYnn4auz1mBZqq79rWawXhmNQegKwEEroSPDDPZKfoyL85wcPIJTvTxY81eTauzPO+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0rIkX88r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0rIkX88r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F20C2BD10;
	Wed,  3 Jul 2024 11:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005126;
	bh=yRG5W8gWPbMcQjo48IMyYuI3otWWOTenPODn121SGKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0rIkX88r937+tviYXeS2R65Id8lbBG9VbszuBTkhKcPc8BsVFOD9ukSxWqV+cxIhj
	 2sLMU+3WZXe6pu+U3wqLAgzIgcWADxFw6lQWQzeC2WcuE8IP0mTWxKKWMYUp5c5eJ0
	 3zxRy5ZHiC1WYUHat87VvtgFBaYL3BfKAR8NyWK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 5.10 270/290] drm/nouveau/dispnv04: fix null pointer dereference in nv17_tv_get_hd_modes
Date: Wed,  3 Jul 2024 12:40:51 +0200
Message-ID: <20240703102914.350070455@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

From: Ma Ke <make24@iscas.ac.cn>

commit 6d411c8ccc0137a612e0044489030a194ff5c843 upstream.

In nv17_tv_get_hd_modes(), the return value of drm_mode_duplicate() is
assigned to mode, which will lead to a possible NULL pointer dereference
on failure of drm_mode_duplicate(). The same applies to drm_cvt_mode().
Add a check to avoid null pointer dereference.

Cc: stable@vger.kernel.org
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240625081029.2619437-1-make24@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/dispnv04/tvnv17.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/nouveau/dispnv04/tvnv17.c
+++ b/drivers/gpu/drm/nouveau/dispnv04/tvnv17.c
@@ -259,6 +259,8 @@ static int nv17_tv_get_hd_modes(struct d
 		if (modes[i].hdisplay == output_mode->hdisplay &&
 		    modes[i].vdisplay == output_mode->vdisplay) {
 			mode = drm_mode_duplicate(encoder->dev, output_mode);
+			if (!mode)
+				continue;
 			mode->type |= DRM_MODE_TYPE_PREFERRED;
 
 		} else {
@@ -266,6 +268,8 @@ static int nv17_tv_get_hd_modes(struct d
 					    modes[i].vdisplay, 60, false,
 					    (output_mode->flags &
 					     DRM_MODE_FLAG_INTERLACE), false);
+			if (!mode)
+				continue;
 		}
 
 		/* CVT modes are sometimes unsuitable... */


