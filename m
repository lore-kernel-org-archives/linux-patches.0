Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB8C46EF8D;
	Sat, 12 Sep 2026 11:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213916; cv=none; b=Nunkvvb5N5H9oQiX+Gsk+2H/cy++mbclrxV2V9Ob/DGLMUFivKs5GrjcCgzjOqtuVX1AIPA8z5GlBO3qPKDTZj6S0hwQon+Ic94An/hGPSpqcnL/BwikAyjwISHSewmhEQFlCaNp3AI+QdG94LEohCxfpUgtwH26bOSw+2oBZuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213916; c=relaxed/simple;
	bh=D3q6UbWOLktqSnCDbZMghwKQ+3Cl/9UU1/fjdx9PyAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VKsfPD3E+/+jguHm4rf5qOpchiAyMaSdi44juduyULO+u4yX4KNvau4MuHhKnA1tRDzYenN5AnsXzUDWrUDqMjebAq/WLPzoyp6YFJgiM6bhi03ylREAd2mgl18iVDSTT0SeNznS5iKCpyU6UEJqo5vXW80/QxOzP51JS1XsD1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bRmU74Vo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bRmU74Vo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59B7E1F00893;
	Sat, 12 Sep 2026 11:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213914;
	bh=0Xh3bPDfOYeSL2coafvcb5UBTIU+TT0jzlIUIA6iuxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bRmU74VoELVM3lW+AlQ+4YKkvAVZGCyjgq5Zwm8vWJunDu3GF/xLbVBvo0Fe0mlzw
	 NORfoVyYNypLusakO4ywvrof8bXKUBFjNq0NTxkDazuu/KwbpikNKUjb17f7NbhFWp
	 HMfe0WTd1s/B1iAJiUm5+ZDuONdmHBjBz2haMUN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 0218/1376] media: zoran: Avoid freeing a registered video_device twice
Date: Sat, 12 Sep 2026 08:44:04 +0200
Message-ID: <20260912065612.407100139@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


