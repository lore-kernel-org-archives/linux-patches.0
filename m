Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97B93F86F4;
	Mon, 17 Aug 2026 15:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979391; cv=none; b=ix0sBVJxZugjtESeRlpzFIFo+3GTCiaN4MSFjnSP/u/gckN4P3w+bjnZi3sZw9by256Rtd1OhIRGp6oGEj0WDmhsj5AZsIKBU/rc8DsPkkdOJzr0EwLym/12UhsgoVk6wQJkIROuwaXi2yLUyS+RddEBsFRbDA/kX65X9I0TuCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979391; c=relaxed/simple;
	bh=GiPBnV0+KHhjKQTJGB7mNH3dDQ2fsQ19EjApU2J5Ekw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TAopM3byOhTL8h7DSO3iquvTFgyCATECXfjQCOUgjoqwNiHbbG/GpqnqOmmo6pgnz4fm0ZCFT/syZ8CcHI17fInLJ9LKyMXWZ0llSslCg9V7AhZ26SzP5+Zuiwqp0XyWLq9TZZ/90e/ydJzxrQkVF83HV3f5R90hDh84ekMnPYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qAkq09Wq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qAkq09Wq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A7FA1F000E9;
	Mon, 17 Aug 2026 15:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979389;
	bh=ZWrFOpirZeR8SqfxUCuddoAbl4E9o84Ytk6ul11lJAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qAkq09WqDnXUEnMnmjD/JO7G70d5BJdAQpbZXp1RyB1wV23pE2BQnOuE2BcZCMHee
	 63ElcUwvIFUJJn9nfg4LMQrKmbtr6W51u9guBGUDTdl6cOYuza9sJ6wBz92si4uWyT
	 WRUERwW8VoKBV012getgNzHS0/IlzbbAkPftEESg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel@sholland.org>,
	Andrey Skvortsov <andrej.skvortzov@gmail.com>,
	Paul Kocialkowski <paulk@sys-base.io>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 192/609] media: cedrus: Fix missing cleanup in error path
Date: Mon, 17 Aug 2026 15:28:08 +0200
Message-ID: <20260817132550.505254464@linuxfoundation.org>
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
@@ -381,6 +381,7 @@ static int cedrus_open(struct file *file
 err_ctrls:
 	v4l2_ctrl_handler_free(&ctx->hdl);
 err_free:
+	v4l2_fh_exit(&ctx->fh);
 	kfree(ctx);
 	mutex_unlock(&dev->dev_mutex);
 


