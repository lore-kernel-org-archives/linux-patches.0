Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8EE14B084;
	Fri,  6 Dec 2024 14:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496101; cv=none; b=mLfQ2881fJtUNzMOd6UKU0pGOyopAJ24dzRHkxvWv7Z7ogFBtXmKCBBJRgLoVrcVXACURD+7cvWsTjnEkCOmezwtT5WJ5TDDFbFj8EUBwVyxXY92yEpTmHsi1T0WowMjL9uM58eOz4szb8G4jHYOTSxI9UMY4sw7wk6c7m0qQak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496101; c=relaxed/simple;
	bh=ChFrfg0u+ZyxtBXhWYHeojEgGGWcS9+XH4py3MwqE54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UbJUmSFpnPJZEO6z40rqebQmDRIm3xBYvp0n7KwwiN+t1C1/+Pajg/h4whENIlSgyLxDfnVe/uRFAiW0CqLCBh67oxWfM6wdIwsyEzry2fJruRret165F4BRwcCmZYyRgwrTkQtLNjMf52brE0On0rmD+9yOhlwSwelh2FSJDyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a3k6J2hr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a3k6J2hr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0584C4CED1;
	Fri,  6 Dec 2024 14:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496101;
	bh=ChFrfg0u+ZyxtBXhWYHeojEgGGWcS9+XH4py3MwqE54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a3k6J2hrmkhzm5A/2EZZKpAgfw5q3fwmW6gZpOR+7qw9tUiEsC67x1Qtm6U7Of08C
	 gmO9ihETw583AgoeCWh3RVWI6dTCZa6kuEeI3IwvAxykZqYTxG860YC1DXKN7q6E/I
	 wJAI2DKZtKC13X1sdC+IwdXzS5+T06mu8uNjo9iI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@nxp.com>,
	TaoJiang <tao.jiang_2@nxp.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.12 020/146] media: amphion: Set video drvdata before register video device
Date: Fri,  6 Dec 2024 15:35:51 +0100
Message-ID: <20241206143528.443375952@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Qian <ming.qian@nxp.com>

commit 8cbb1a7bd5973b57898b26eb804fe44af440bb63 upstream.

The video drvdata should be set before the video device is registered,
otherwise video_drvdata() may return NULL in the open() file ops, and led
to oops.

Fixes: 3cd084519c6f ("media: amphion: add vpu v4l2 m2m support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Reviewed-by: TaoJiang <tao.jiang_2@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/amphion/vpu_v4l2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/amphion/vpu_v4l2.c
+++ b/drivers/media/platform/amphion/vpu_v4l2.c
@@ -841,6 +841,7 @@ int vpu_add_func(struct vpu_dev *vpu, st
 		vfd->fops = vdec_get_fops();
 		vfd->ioctl_ops = vdec_get_ioctl_ops();
 	}
+	video_set_drvdata(vfd, vpu);
 
 	ret = video_register_device(vfd, VFL_TYPE_VIDEO, -1);
 	if (ret) {
@@ -848,7 +849,6 @@ int vpu_add_func(struct vpu_dev *vpu, st
 		v4l2_m2m_release(func->m2m_dev);
 		return ret;
 	}
-	video_set_drvdata(vfd, vpu);
 	func->vfd = vfd;
 
 	ret = v4l2_m2m_register_media_controller(func->m2m_dev, func->vfd, func->function);


