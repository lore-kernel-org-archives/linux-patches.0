Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71003264F4;
	Sat, 12 Sep 2026 15:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228444; cv=none; b=uWgxFGMxWmPRVmRT3VK5UkDYyu5rWXs3pkLA9ZSTpndTRIWmpASv0XDDYK/F/INsjXD3JK4L8y41SS701V7f2IgvylnjQjVVvyGiNqz9zuvI5/DnIZNcle02iTjDV3QyRRP7Kmq+vry1PbaRfy89Mrm7bSNuxaTCOuuK0VoMi5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228444; c=relaxed/simple;
	bh=sSyOoB2afaMi4lknXiUO5XO9QAXlRTfxNMp4xREdCGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2/RIzLfCWoNsAmLkT2ufbpj1tQ/MlYA2XcDNS+b41+5WN2l9cSitbrl/dGmaKqXGMDOYiWEBfRfQcN9ieieOc9PnjXOtxWO3DjbJBRFhUexYPrLlbzPIUavhUQb3tLXGFmkJ4do3ZNLqXFGD3tlYiG4FG0ZSeGzNWd85SE0mC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zP55/utg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zP55/utg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E28D31F000FF;
	Sat, 12 Sep 2026 15:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228441;
	bh=M6K5N18ZzB5iGVQKNaqhkN/U3xd6oyehKxTPDbyuyfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zP55/utg/DXaB2egk+70XVVy1nm874JlFO0f8R2jC9LyU7B5tSyTIMegNW4b21X+D
	 JvMc636bTjng6U9BL3vu8BxPY3NhzCneZ72StId+4IgnjzDQJKUV/y0lnzHa1uQoxK
	 o5iRrI6auiVNfo868cVYWtZ7R0+VFIvAenShGZLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 0387/1191] media: zoran: Avoid freeing a registered video_device twice
Date: Sat, 12 Sep 2026 08:51:55 +0200
Message-ID: <20260912065556.931645624@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -889,7 +889,7 @@ static int zoran_init_video_device(struc
 static void zoran_exit_video_devices(struct zoran *zr)
 {
 	video_unregister_device(zr->video_dev);
-	kfree(zr->video_dev);
+	zr->video_dev = NULL;
 }
 
 static int zoran_init_video_devices(struct zoran *zr)


