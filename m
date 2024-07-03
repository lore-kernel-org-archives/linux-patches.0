Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B63B1822C1;
	Wed,  3 Jul 2024 11:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006208; cv=none; b=p1AcQIi0AIQBqi57AgCcdN3XTDZi5KLrzAsl6j+CTlP//MGPoVBtF+oGEn8GCuOuIsBJpM0Z0YV4NGDVqxi+2N1TLUbEkevIb2JxJcmtwXEd6zH/x+zCtrD6Rj+aF0nKKUN+L3m1f01EhAjJ0A9PEi7eT9LxBsxwC4UupRJnZjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006208; c=relaxed/simple;
	bh=7j3qNIN14awc1djJgMFDfGV9ac4nTMSSlLQ1JnAOId8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CSI7MI3RJCXY2X4kTxU3Nq+aB9pbqKjC/vtgYTPvj/+D0YW3igMfURiFxoJrrslPa+InZYqppe/etOI50ZIj+MDweRYdxxfMoBLKrQomU6KZcBeqsLqtiuipih1j+NMaJPxp+VFGrPIrManuOEWJlAYBRMZOk5TgX46aXmCv9w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xi32E+ZN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xi32E+ZN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E56D4C2BD10;
	Wed,  3 Jul 2024 11:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006208;
	bh=7j3qNIN14awc1djJgMFDfGV9ac4nTMSSlLQ1JnAOId8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xi32E+ZNplucLTJ1/r1WaXWin2qWmk/w1MQ7IWVG7s4QjvKiXYzglI11LuHTFTgvx
	 Fz6Cd6+AqbRDxG8Hzq///4jAXAqr5lVjvEcnqlzsF4pVXNaKwXc5h0BEpO1QZrAGyB
	 Zd6Xih/Qza6+ZiNoxBWiwnCPB2DLpeEheKwQpBuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 5.15 336/356] drm/nouveau/dispnv04: fix null pointer dereference in nv17_tv_get_hd_modes
Date: Wed,  3 Jul 2024 12:41:12 +0200
Message-ID: <20240703102925.822092130@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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


