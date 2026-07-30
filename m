Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174B430C618;
	Thu, 30 Jul 2026 15:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424459; cv=none; b=HN/1gj7TFqpttPxUNUJdxtqfaEX8ef0po/NoezoeoPyVW0uPL2MyACJiDawf0HJLr18d+uYZ6gQIOkt+ohKqZM3fMgv08S2neVtM6rtbEnP+lAP6hwvOP/QP252zXx/PX0+cDZW/HgNS4JimziFY5pTouCQB2CJZTKNovBJvoIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424459; c=relaxed/simple;
	bh=HhJMWpkeQ0JJLSx1ACQo1+9PlXE8hROsmVpCKOcRkhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+TyCIgS0sQU1m8KgbM0joQCahWgKX15Kt5rvLdDLiwv7ORI6VV8XMqTXI9o1CqzGx/qwSkeE1JEdQO4HxkFr72+n/Uf5Qgc0Q697LrAkLfNi4pBS/yLkCWX/xZwqCbyHUvlgamf+zjEEH5ryc/UIM0FHGdKjshJIVbaOMZSEfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gdbBrl4K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gdbBrl4K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 726431F000E9;
	Thu, 30 Jul 2026 15:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424458;
	bh=YYm5p1nXiV1uZEeI0IaVazEFsBxfilEteWWU+6usDDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gdbBrl4K7GbQ/2xI3gc/hL6HbW0fK+Cs1x0jG3C5OZjX2cf46k+IgGs7PZh8Sb2PI
	 e6OPZggjUVDpl/AxFu8oSy1BIIO7RhvelPVsB5Weuayvu9cP86d3Hd1861Mh1bbacM
	 e1/x/gsp7On+93cF6u8nuq/pOT1vOHbmCj3hzGh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel@sholland.org>,
	Andrey Skvortsov <andrej.skvortzov@gmail.com>,
	Paul Kocialkowski <paulk@sys-base.io>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 399/675] media: cedrus: Fix missing cleanup in error path
Date: Thu, 30 Jul 2026 16:12:09 +0200
Message-ID: <20260730141453.616212950@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Holland <samuel@sholland.org>

commit d99732334aaf33b9f93926b70b6a11c2cef3de39 upstream.

According to the documentation struct v4l2_fh has to be cleaned up with
v4l2_fh_exit() before being freed. [1]
Currently there is no actual bug here, when v4l2_fh_exit() isn't called.
v4l2_fh_exit() in this case only destroys internal mutex. But it may
change in the future, when v4l2_fh_init/v4l2_fh_exit will be enhanced.

1. https://docs.kernel.org/driver-api/media/v4l2-fh.html

Signed-off-by: Samuel Holland <samuel@sholland.org>
Signed-off-by: Andrey Skvortsov <andrej.skvortzov@gmail.com>
Fixes: 50e761516f2b ("media: platform: Add Cedrus VPU decoder driver")
Cc: stable@vger.kernel.org
Acked-by: Paul Kocialkowski <paulk@sys-base.io>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/sunxi/cedrus/cedrus.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/media/sunxi/cedrus/cedrus.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus.c
@@ -391,6 +391,7 @@ static int cedrus_open(struct file *file
 err_m2m_release:
 	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
 err_free:
+	v4l2_fh_exit(&ctx->fh);
 	kfree(ctx);
 	mutex_unlock(&dev->dev_mutex);
 


