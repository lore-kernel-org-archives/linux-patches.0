Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063088;
	b=pdQKbG81H+l5EwLUpWEUwUOp97J9ciT9rhr7chV0DTAAxmsGKmzz10zYqM0yVrWfm3Qn
	 EY3luZ2ekrkqZox7cDbVOntSx4iaOF5d4vr++88hsnszcPTRxIMMA7NbUtNI99bWqczYF
	 GXGsypG+ajG+YJohwVvqHCTr8ovdNCh3JzR2EOaZeNYwTv+ts7XevTTA+5a5mced1Jdhk
	 tqYNvNvhH4H+qm23NVPNWhkeP9M8skeb13S3cFb2q8hTDKlqdIREQ/oXElgt10verS9LX
	 YGuOnYZugFuvXBJCu7B2MalO8RTmSWz7letyiLTcX/MiTNyuIfLFxQIBMq76aK/YOWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063088;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CbSQJK4Aah5XhWL48Ge9t42frOX0hFul4A/C08diM14=;
	b=rb6ko6wNwdK+p/0XtS4+GrvhwoDMuG4rFVi+ou2zoR4Az09hCmpjMitlgjDWEGbtMW5h
	 m7bEm+fenl1uQSAoZXiYccl7A4Nhp0hSTUfO/O1n1QHQDaxk0l2bUhtIB3ykQzg80ZOOy
	 +n01K+FmE4NxAC0Rodc/L789TgROjbo9NfbokTwaZyOb3UDMfAvltL+apzaSaPzONDrXQ
	 5tdUXhZXGbH51R76YwE4ENXq0ysT4/Bu0zSB6zkSJkexBUv02zyGJbOVqdk18hiVPBYnW
	 IfPll+g6CyBADqTMmdE7Yji9z8W8ytUNFWlI3O40izc8sY4jMJkd8aZTguBdUtB/SDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nORvJfUU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59523606D814;
	Sat,  7 Nov 2026 14:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nORvJfUU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 073171F0089F;
	Sat,  7 Nov 2026 14:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063088;
	bh=CbSQJK4Aah5XhWL48Ge9t42frOX0hFul4A/C08diM14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nORvJfUUbx1BfHs5EF8eHdbk/FuUcQ9odhFglk2SmOnGbGSBCodne+ujBgsU+g76K
	 qdbuE05+RhdcWtea81HI1+EVqx+NbLhfeFpXsuVnToQR9ugFQaS53REgm5ECw78cCl
	 MzuIAlpw45xxmbJSmhCF4M/EZiarUi0w//PqxwNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Jie Law <98lawweijie@gmail.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 326/869] media: uvcvideo: Fix NULL deref on events for uninitialized controls
Date: Sat,  7 Nov 2026 08:50:08 -0500
Message-ID: <20261107134903.503749825@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Jie Law <98lawweijie@gmail.com>

[ Upstream commit daa379e2b74d6c10ba4e3b56eeca5aa8c8704fca ]

A null-ptr-deref exists in v6.12.105 and upstream. KASAN crash log:

  KASAN: null-ptr-deref in range [0x0000000000000080-0x0000000000000087]
  Workqueue: events uvc_ctrl_status_event_work
  RIP: 0010:uvc_ctrl_status_event+0x105/0x280
   uvc_ctrl_status_event_work+0x82/0x240
   process_one_work+0x66f/0x10b0

XU controls are initialized lazily, on the first UVCIOC_CTRL_MAP or
UVCIOC_CTRL_QUERY.  Until then ctrl->info is all zeroes, so
info.mappings is not a valid list head, list_empty() returns false, and
uvc_ctrl_status_event() walks it from a NULL next pointer.

Fixes: e5225c820c05 ("media: uvcvideo: Send a control event when a Control Change interrupt arrives")
Cc: stable@vger.kernel.org
Signed-off-by: Wei Jie Law <98lawweijie@gmail.com>
Assisted-by: LLM
Reviewed-by: Ricardo Ribalda <ribalda@chromium.org>
Link: https://patch.msgid.link/20260907121844.2592492-1-98lawweijie@gmail.com
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Signed-off-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_ctrl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index 2738ef74c7373..7fd2e03f92e6c 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -2010,7 +2010,7 @@ bool uvc_ctrl_status_event_async(struct urb *urb, struct uvc_video_chain *chain,
 	struct uvc_device *dev = chain->dev;
 	struct uvc_ctrl_work *w = &dev->async_ctrl;
 
-	if (list_empty(&ctrl->info.mappings))
+	if (!ctrl->initialized || list_empty(&ctrl->info.mappings))
 		return false;
 
 	w->data = data;
-- 
2.53.0



