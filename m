Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419FC153BE8;
	Fri,  6 Dec 2024 15:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498522; cv=none; b=WxdZ8Ce5V/sWDGNqqSXONsYAbFX8ZUt5vC1Zxeyrnqpc2VuNA81QZtDKlBrE4ymlCjFnb1FYDHXQVXAC/55KK7Lfn1IbCehNGIZfe5HMMBSOsJJOKa+Oj+OG9z1sfz/SCjkGh4yNbhhesjoksiEH4ifQfZ3N1Ns2yBx9ah10SmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498522; c=relaxed/simple;
	bh=2y7/MaHkRkDoqnwf5/njwbwiBlgNpllw8NQbMHj6u2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IDDpDjmsTr4aJpxjSx8kUmOKTYIZfe/xGTs3a25GtpEu0KztiP0YOSVLsoTh58+LnAUlYC/2ITJjMn6ftGoal1zmdKlubDaKb3QkdMbAHkdsC0yp07ryhAWbI6Hj04lTz3LAU8pn1FsJIzVOvSi9PHgMANM9IM9kKICl+foVyJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0vJ/4AKz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0vJ/4AKz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A76FFC4CED1;
	Fri,  6 Dec 2024 15:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498522;
	bh=2y7/MaHkRkDoqnwf5/njwbwiBlgNpllw8NQbMHj6u2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0vJ/4AKzHjmnsnaT265JoyB67bxlI0nXWDlyurM8AnK/WHh8hfpYcK2nzsHG/lhbe
	 bkDuJ6qrVTDWKs+JjJB13ID2LMCrUhsQRi+LWdkztXqaS5liUkFNm8AXXnVDhBq4nH
	 DbH64rWVQzDtPBPk6rXfnRaw3dWozdFLf7aN0riQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@nxp.com>,
	TaoJiang <tao.jiang_2@nxp.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.6 609/676] media: amphion: Set video drvdata before register video device
Date: Fri,  6 Dec 2024 15:37:08 +0100
Message-ID: <20241206143717.161701652@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -825,6 +825,7 @@ int vpu_add_func(struct vpu_dev *vpu, st
 		vfd->fops = vdec_get_fops();
 		vfd->ioctl_ops = vdec_get_ioctl_ops();
 	}
+	video_set_drvdata(vfd, vpu);
 
 	ret = video_register_device(vfd, VFL_TYPE_VIDEO, -1);
 	if (ret) {
@@ -832,7 +833,6 @@ int vpu_add_func(struct vpu_dev *vpu, st
 		v4l2_m2m_release(func->m2m_dev);
 		return ret;
 	}
-	video_set_drvdata(vfd, vpu);
 	func->vfd = vfd;
 
 	ret = v4l2_m2m_register_media_controller(func->m2m_dev, func->vfd, func->function);


