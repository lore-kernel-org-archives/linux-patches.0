Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69AC02FFDEA;
	Sat, 12 Sep 2026 14:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221880; cv=none; b=mIcuNjxcyY408Nhtxpn6KvN3XBJhMBBkiILDXXaKbFpsyrxl11PVZd+yAfzk6CVySaSjxToWHGXJhUZCY1a2Amd1kel/xk2/WWU7LZwceq1f1V7fLa56+7ORyHFCbgeIreWFjQILI3aMWrYBUvYVQ4Fdq5wIpf74MhMhTkSf8q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221880; c=relaxed/simple;
	bh=JnzHExpw3lGBPHFESAtmzgiQejRNyI+Hy7daKqb75Tk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q38iC+0jhFL1VBQDNkwVNqD4n3MOFAaqy2L0dkQEbF5dlYk46eULhhSiI+Umtg++lVFRdShGxiQbkfE1Zh2gF3d92WZmiYU3IYc5WTUU7zkZSqdsXp9545vu1hJcUUeKhx4X9+fqUApKLU7TtG/1Boh5eI0A8ng4d4zAcC2mGL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ODL0EXFR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ODL0EXFR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB1191F000FF;
	Sat, 12 Sep 2026 14:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221879;
	bh=YensBLWXOo1iOCsKqCjpEpTBo/lbfuLagrVgqzBVmMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ODL0EXFR0JQvRNwcUzTRif9I8iwKmAEx9ZDMXRQJR40AOMTDLvb2eOI6hNkFj9kR1
	 ZQxV8EvW6es1ittO62Dr6t8wiQNsy+rT1jFbXu5fziJDXpXP0jkg+S6b/imktQhARA
	 ava1FQyx6zihvqv3csjzR5CWKTMvD9SHo481rdVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 0472/1424] media: zoran: Avoid freeing a registered video_device twice
Date: Sat, 12 Sep 2026 08:48:24 +0200
Message-ID: <20260912065617.856965217@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


