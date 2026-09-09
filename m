Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B3856B852;
	Wed,  9 Sep 2026 14:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962770; cv=none; b=WsdhSeub+2C77WLwrE5uNw4tX3AHoxSMozKR6uOCWUYw5AotdYMk0Rtdg+OHeVo+/NnODagdhANCdGMSbKvA5iN4HIrsPt23XubsknM3DKFHLgS12ZJ8gxXV0anFgvhR0iA8eBU/akqyOnCHYwXWULQVXyg/vnM978mc7Pyb3l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962770; c=relaxed/simple;
	bh=QUC/QskHjzdLFgs/3Ydf1roaV19DgJEKRzO15D0mE4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iDV2isMDpBM+bBQ5HALDYVFghjkUI/X6NRq69qfkSbihp4qdI/zKU+EKw0+6V2DVXyDUglGa4nz8IKR8x7GdVP2kzWWKJIoPqZGzXtrUVCq+wqpdBcDIZOp4r6BND+RlxsmEYLO2PNgJTb67R+XDWYtqpNGvmrZvAxDOiVs+OkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LCgY520X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LCgY520X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28FC91F00A3A;
	Wed,  9 Sep 2026 14:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962768;
	bh=fNIRYfxAxl3Var6nOFKxAYv5TyS2gfMaNOKyhH0yGZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LCgY520XHfCqvexFpoNH7CBVdbljXZ6xdEJQjTb4hVr9R2rRwn5eTS+oZG7ubLrWK
	 xjmzwqSSohXlPHVz5awQZgJnSpLbjQd5h9OzT+9rNqbtoYL1AugQwL0H9xntPE27Mk
	 kPaw+j+Fz0mygW+MazVy4eyAaC/xTTeLvfjikQPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.2 405/556] media: zoran: Avoid freeing a registered video_device twice
Date: Wed,  9 Sep 2026 15:41:25 +0200
Message-ID: <20260909134244.876645932@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

commit 0735e0b5a96761a9ce277a238e834008ad92a0a5 upstream.

zoran_init_video_device() installs zoran_vdev_release() as the
video_device release callback through zoran_template. After
video_register_device() succeeds, video_unregister_device() drops the
registered video_device reference and the V4L2 core eventually invokes
that release callback, which kfree()s the video_device.

zoran_exit_video_devices() called video_unregister_device() and then
kfree(zr->video_dev), so device teardown could free the same
video_device twice.

Remove the direct kfree() and clear the cached pointer after
unregistering. The pre-registration failure path keeps its manual free
because the video_device was not registered there.

This issue was found by a static analysis checker and confirmed by
manual source review.

Fixes: 82e3a496eb56 ("media: staging: media: zoran: move videodev alloc")
Cc: stable@vger.kernel.org
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/zoran/zoran_card.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/pci/zoran/zoran_card.c
+++ b/drivers/media/pci/zoran/zoran_card.c
@@ -885,7 +885,7 @@ static int zoran_init_video_device(struc
 static void zoran_exit_video_devices(struct zoran *zr)
 {
 	video_unregister_device(zr->video_dev);
-	kfree(zr->video_dev);
+	zr->video_dev = NULL;
 }
 
 static int zoran_init_video_devices(struct zoran *zr)


