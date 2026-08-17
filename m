Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56A43F6C22;
	Mon, 17 Aug 2026 15:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979339; cv=none; b=AVRFrNi7+3Pxwu/8zHovYgdGl3uYif3phb9ni5RZSewKlfYPhbcSn+eC/T2OsNp6wzPboFffbUylU21q+vLUypPj2al4SZiA1FTWv1EaSMRaJzrOIfaWm9lWo5JXqJQwi76sU9Wt1ZgUy6Lir7v1P4eokiNANKVvmhCwraTiy+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979339; c=relaxed/simple;
	bh=FzKxkZdTeJYlJNXPE3UABGTWSqgMvwGHJ5kKwiXp8NA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MbPWW3J95ay3cEr6tL/7F882h9B1CtiJ+7TPNeepg+pERtBTu5tkBS7A/e4HSNe7pT1HjvkITmEsp/7/WTRbVUhRvXypzYkZGPrrZ2gHd+DVZhZIoVlWbauwcOHuDcJ/65QGJr/s8EXz1vswAIXWYO6F+RQS7BsEfSaZrQYMMAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L5/x3uac; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L5/x3uac"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 395861F000E9;
	Mon, 17 Aug 2026 15:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979337;
	bh=wuy7NVkSDkqawg9Afmqm1DWbzWQXrGFft1pNi3Jeehc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L5/x3uacnkb731alIKWsbh+bi0kccd5KrGl/S4EIlTgZxG4jJWr+w5985+U8mShJz
	 E6ROq6NZ/MRPSeW6DzCpxWdZ69eo1kTh/U3cz+M2Y/6jYZ/iAi1LVERCrTg3oZE+xv
	 Y74yy5ohNc0Mkuea2mDio01r2PmTOZWrZ70uQ2o4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 189/609] media: aspeed: fix missing of_reserved_mem_device_release() on probe failure
Date: Mon, 17 Aug 2026 15:28:05 +0200
Message-ID: <20260817132550.401631986@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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
@@ -1994,6 +1994,7 @@ static int aspeed_video_probe(struct pla
 	rc = aspeed_video_setup_video(video);
 	if (rc) {
 		aspeed_video_free_buf(video, &video->jpeg);
+		of_reserved_mem_device_release(&pdev->dev);
 		clk_unprepare(video->vclk);
 		clk_unprepare(video->eclk);
 		return rc;


