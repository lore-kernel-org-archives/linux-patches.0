Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E691BE23B;
	Tue,  2 Jul 2024 17:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940626; cv=none; b=DRVS1mrp7SCJCrmOG1+FQRoT1N5ddr5B4dr/YZf3N737v6CxgAtgLuF/6ekdCt2KFbREsFEMEhxEOuFC7zW8POqPMCiyXnTj1yQH7rKp0DOzQvPZU9qyleK+mMKEmjSQk3CfzHUl/cxmLy07gGazh7zRW5OCV/XwrCsxaYFh/1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940626; c=relaxed/simple;
	bh=7ruAclCizTYX1jJuw5UF7LyRV5ZjA761zcrBeYTp21Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HDS5RxYZoMEnO/eL4SsLaZQuNEyuG8iuelynVPIkEsxk/MYxRnRujHohfXEYbTJRyQEhWpb85NZYgiWZ5CBG0EkGzQyW+3u1PgwPXrqJJJQt2iZhOP+Iif57nCCJw5c6L96AdJKq4U2nzW8KaNHp6w4/0lfHETrgWzYpPlYiBzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iced0Y7z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iced0Y7z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE198C116B1;
	Tue,  2 Jul 2024 17:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940626;
	bh=7ruAclCizTYX1jJuw5UF7LyRV5ZjA761zcrBeYTp21Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iced0Y7zvM9LK1viqXaLCPu2yzQQrp62W1JM9/SHcMyl/pmPg6jNb5qodWuUXKc4i
	 x1kbRgYjponOs18e/5+CCx9u4Pa+uUyMSX9DWxaKeoV2wh4yUXmbN6OLx4r9NunsNx
	 rQFqiMMlxOAFxAcdjyU+M4RQhFRZ9rualhI6jqeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 6.9 184/222] drm/nouveau/dispnv04: fix null pointer dereference in nv17_tv_get_hd_modes
Date: Tue,  2 Jul 2024 19:03:42 +0200
Message-ID: <20240702170251.015421614@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
@@ -260,6 +260,8 @@ static int nv17_tv_get_hd_modes(struct d
 		if (modes[i].hdisplay == output_mode->hdisplay &&
 		    modes[i].vdisplay == output_mode->vdisplay) {
 			mode = drm_mode_duplicate(encoder->dev, output_mode);
+			if (!mode)
+				continue;
 			mode->type |= DRM_MODE_TYPE_PREFERRED;
 
 		} else {
@@ -267,6 +269,8 @@ static int nv17_tv_get_hd_modes(struct d
 					    modes[i].vdisplay, 60, false,
 					    (output_mode->flags &
 					     DRM_MODE_FLAG_INTERLACE), false);
+			if (!mode)
+				continue;
 		}
 
 		/* CVT modes are sometimes unsuitable... */


