Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26331332905;
	Fri, 17 Oct 2025 15:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715327; cv=none; b=LUHdBsSeed1m2tzp6uPG8GJcy6wF9+RlUrHi2HTr3WfWHrRA2Fm99DEYxzSuYHtaKDcehKE+v0VC2vLrOdz4ykuLmjgS1luHydlWoQpm59mI+UluDLzSHhjCHWvDsHxcBAzZ8ZrkZsTX15MeiEwxe/sHr6f0lcX8G+uDbdWYC2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715327; c=relaxed/simple;
	bh=T4f0W1Zf488WQqkxKJp+Obp15T8Ck2XA7DrDwHYnyHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VnaHyXwa3DLx/axizaEpW0ROLaBALuo/cpfEtqkYZ/2guk7jGtGzYBxssp4JRM3hDdp9NTfbycVAFRQNSBcrroRehUte9QaowVT4ydx7QV3zWxOBcLfcBxT+yPIWC7NZETZpK2IAvuDFsuhgiVlyPw8mh6LTRGGvFC89U6oMOi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FZGKnSoi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FZGKnSoi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C50C4CEE7;
	Fri, 17 Oct 2025 15:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715327;
	bh=T4f0W1Zf488WQqkxKJp+Obp15T8Ck2XA7DrDwHYnyHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FZGKnSoi3YoZbTab0+/ex37L8DbZTTUvSxY3psAZJmC08xZ3x44Aydq4HnJTtHtXt
	 3Mylym8n7VHToPNo9nPJ6Fwfv1SeZpw2GPHdvWFzQMqdiXm7tAbwWaatxoe2HKqbvv
	 596ZH4xe7rsak9E7txY4Ohq33Dr+nWS7YeTQHD58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Desnes Nunes <desnesn@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hansg@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.17 178/371] media: uvcvideo: Avoid variable shadowing in uvc_ctrl_cleanup_fh
Date: Fri, 17 Oct 2025 16:52:33 +0200
Message-ID: <20251017145208.368728783@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Desnes Nunes <desnesn@redhat.com>

commit f4da0de6b4b470a60c5c0cc4c09b0c987f9df35f upstream.

This avoids a variable loop shadowing occurring between the local loop
iterating through the uvc_entity's controls and the global one going
through the pending async controls of the file handle.

Fixes: 10acb9101355 ("media: uvcvideo: Increase/decrease the PM counter per IOCTL")
Cc: stable@vger.kernel.org
Signed-off-by: Desnes Nunes <desnesn@redhat.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans de Goede <hansg@kernel.org>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/uvc/uvc_ctrl.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -3307,7 +3307,6 @@ int uvc_ctrl_init_device(struct uvc_devi
 void uvc_ctrl_cleanup_fh(struct uvc_fh *handle)
 {
 	struct uvc_entity *entity;
-	int i;
 
 	guard(mutex)(&handle->chain->ctrl_mutex);
 
@@ -3325,7 +3324,7 @@ void uvc_ctrl_cleanup_fh(struct uvc_fh *
 	if (!WARN_ON(handle->pending_async_ctrls))
 		return;
 
-	for (i = 0; i < handle->pending_async_ctrls; i++)
+	for (unsigned int i = 0; i < handle->pending_async_ctrls; i++)
 		uvc_pm_put(handle->stream->dev);
 }
 


