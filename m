Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37088439343;
	Thu, 30 Jul 2026 14:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422556; cv=none; b=uAYhg6ujuEC3UbwsY5j8P8RLENn+wm6dlpIOb9eMsEn43qjlACw+bKe9DniBo2ypmM4i1BjoBhIOYcvo2HNXGNK4L8YWGAElEpIw714pNw9arGgkn3Oo9ADqgBnKy34MV3U+7DkDPpJ/7xlBTkMTBbtF808OIwouMA8V2wdFfPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422556; c=relaxed/simple;
	bh=vVe9lOehxk4FYYlX6SRfQtHRlHtBzJnkxpMEUG0RgGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J/7JCEgLU6mWv/1VqqM67BvjmxdP+IyNE2KvkL8KGfsdiv/xaYGwZITDak2WHmbFhMXpTe7Y+Ym94svKlHJCzcVkTH4gFniQEj87Hm4e75wWA8/9cPoM70GpVlgYI7OE3mFzZhUsdoAEGDCEGvQdOoSk7DG61mBURbAknEYxVv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bMwXqX0I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bMwXqX0I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FB4D1F000E9;
	Thu, 30 Jul 2026 14:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422554;
	bh=uwo9rCO+i4WbxMb/eTeY3YebOlal6IctabHRcZT/Vrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bMwXqX0IDWucKcvMWXGrFyAa4JuiaBgiCHwIpYq6R9LDD3FIz8h2Iq1Jr4ONnhBsP
	 NCc5SzIE1eLxxjUwkDfvdgJEfTCq8bau//Sn9UPi2rFg8FgESdjj96xJv4Ec4DKbUF
	 hrHyu6X8zngUkvrBSBDz5+VGvrziSd0v1hrpBjhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel@sholland.org>,
	Andrey Skvortsov <andrej.skvortzov@gmail.com>,
	Paul Kocialkowski <paulk@sys-base.io>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.1 479/744] media: cedrus: Fix missing cleanup in error path
Date: Thu, 30 Jul 2026 16:12:32 +0200
Message-ID: <20260730141454.475886999@linuxfoundation.org>
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
 


