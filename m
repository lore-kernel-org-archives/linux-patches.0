Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999A021576E;
	Thu, 12 Dec 2024 16:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020518; cv=none; b=IYc7DIZPsfHhyQEeK36e/6xHqfLkDSIVYiqecbhxt9ElQOa5L8VvseEab6CBrTGEc/Kkjy8pzLN9qNgzmZfQmeIazIRcnNh6uACDJElmfDMcFUOOgvDHiiM6IDn+oL9G/c7uZ9g02hwMoYLCEm42CAuNmEdNIUpKtGlgcVq5aNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020518; c=relaxed/simple;
	bh=d3NkqjA7Jvt3FrxXCL2A3iESOTioO+9CeFGIix/uGY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Li8rtAm84hV5dhi+5REUeixm9G0LAfoIHiVoilj+yECFtVEzQ1AF49niZJGg04UujoFHmQ2HuKIdOrVta/Rr/dn4Yjf7IK2fYbEcdUcKDDqISAZXM9tPFVQCf2ePUw7ONC4xtzAmPAMJjiLfsVO+tV/3kA+KT61w/e3H0MiOW6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AFXwA+BQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AFXwA+BQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF06C4CECE;
	Thu, 12 Dec 2024 16:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020518;
	bh=d3NkqjA7Jvt3FrxXCL2A3iESOTioO+9CeFGIix/uGY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AFXwA+BQ+3S3tGvzvXg9DmaMxijAu3fQMEF2zPhYL3YT8ksww/agVY+Nq9g9XWwYX
	 693ET32EzhAJUwJUKSC6vH22FL3sV5lWFfLX6C/7XJcyOrep2iWo8rFQeCwADtWj1d
	 7XLzZylj+7HjsJqaCJll+OB2P+TgoK4zW1xwLYho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@nxp.com>,
	TaoJiang <tao.jiang_2@nxp.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.1 457/772] media: amphion: Set video drvdata before register video device
Date: Thu, 12 Dec 2024 15:56:42 +0100
Message-ID: <20241212144408.811283841@linuxfoundation.org>
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
@@ -740,6 +740,7 @@ int vpu_add_func(struct vpu_dev *vpu, st
 		vfd->fops = vdec_get_fops();
 		vfd->ioctl_ops = vdec_get_ioctl_ops();
 	}
+	video_set_drvdata(vfd, vpu);
 
 	ret = video_register_device(vfd, VFL_TYPE_VIDEO, -1);
 	if (ret) {
@@ -747,7 +748,6 @@ int vpu_add_func(struct vpu_dev *vpu, st
 		v4l2_m2m_release(func->m2m_dev);
 		return ret;
 	}
-	video_set_drvdata(vfd, vpu);
 	func->vfd = vfd;
 
 	ret = v4l2_m2m_register_media_controller(func->m2m_dev, func->vfd, func->function);


