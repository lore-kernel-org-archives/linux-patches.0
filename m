Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727493B52EE;
	Thu, 30 Jul 2026 14:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422544; cv=none; b=QonI1k2m31ga9WMwn4xr3yZkuDzL1bIt1ED6edFuTMLH8UZF9e19S0q4fxMGX/vZhTljOrYWsw4KR8wo0LKJ6pb5gQjkuvdBBwHdVrZ6YDE0vEfoo731g9lrI63UCDjXdZUQbmRQldqq9P3aEPhKxBLsO7TPB7R9bz/tRucxBVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422544; c=relaxed/simple;
	bh=PsgJWuZXTvmd/Jk4t8OuH8wtTZ1nZoVWi6j+Kw8hHuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tZpi5V+2NrpOsWJMf07VQj4gtIUPm2cj6+w6G9SHxOk/fGIc8BrIwtAQKNdXdc6h+GGsVzxQXSRvohvISIkqvKs1Iz5iFqnfrFmdwoMv3yIfKCY2oP4MNG24Igfnbuo7w0lb4jiBXGxNLdC9dB9yrkXC9taWEE8eWNtKaZx58+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lsNeGoYU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lsNeGoYU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD14F1F000E9;
	Thu, 30 Jul 2026 14:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422543;
	bh=UlI8itwZQzoO1cPUI5fyHCrykw7yF+tGZnV9CGbgNSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lsNeGoYUxBH4fGSO23bRlDeGRUnNsresDjZOx7alacw6rhRIv7aiz6qQWFh/KbJuM
	 ryTNQaDQrqptd0k3zMxZ8wuvf00XaNE7T8BlxeO3RjIEwVo+h3dw1IsVtj75XmNF8S
	 kKrgSUXl1b+GSQ54UOErWhJkNgdRSZ/NaqIwOCcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.1 476/744] media: aspeed: fix missing of_reserved_mem_device_release() on probe failure
Date: Thu, 30 Jul 2026 16:12:29 +0200
Message-ID: <20260730141454.413210265@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

commit 253c8ef7d57da0c74db251f385324faaa5ae2257 upstream.

aspeed_video_init() calls of_reserved_mem_device_init() to associate
reserved memory regions with the device. When aspeed_video_setup_video()
subsequently fails in aspeed_video_probe(), the error path frees the
JPEG buffer and unprepares the clocks but does not release the reserved
memory association, leaking the rmem_assigned_device entry on the global
list.

The normal remove path already calls of_reserved_mem_device_release()
correctly; only the probe error path was missing it.

Add the missing of_reserved_mem_device_release() call to the
aspeed_video_setup_video() failure cleanup.

Fixes: d2b4387f3bdf ("media: platform: Add Aspeed Video Engine driver")
Cc: stable@vger.kernel.org
Signed-off-by: David Carlier <devnexen@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/aspeed/aspeed-video.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/platform/aspeed/aspeed-video.c
+++ b/drivers/media/platform/aspeed/aspeed-video.c
@@ -2343,6 +2343,7 @@ static int aspeed_video_probe(struct pla
 	rc = aspeed_video_setup_video(video);
 	if (rc) {
 		aspeed_video_free_buf(video, &video->jpeg);
+		of_reserved_mem_device_release(&pdev->dev);
 		clk_unprepare(video->vclk);
 		clk_unprepare(video->eclk);
 		return rc;


