Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF24395ADB;
	Thu, 30 Jul 2026 16:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427628; cv=none; b=Lspnmee7x+0+0CVSS/04BdpjrhIofZ5Ra0K0oPQQGjTqwFzhM9LJUOT9p3ItauJo0LGDz1nn9N92Z/wjxVi5jN9aoQ5l17Cxq1uYprgKuKgvisRfKEdissaV2aYxAU8DbULVARGgWrl4+vDzudU0m1pqSPRYsxqqbGDlXql9Wq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427628; c=relaxed/simple;
	bh=JMEIuc2qYwg882Mydwa7Byloa5UPk3nWB06/L7Lat7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LToNu8HBtclYzirSafxd17ZgaUsmNE2V1LoiurpBdzdMglzKjnEKYcjoB8X5aHW/vBQJg2iAhzIBKOGOc8Bun4OiBnQEINO3phQbAAIR3dMZu5V4kJSx7WWh2ocUk89Os90TSA9rXjK6GVzPSfct0Q2nf6ajemDmQdL/w0XGITY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VjampKbq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VjampKbq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A847A1F000E9;
	Thu, 30 Jul 2026 16:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427627;
	bh=A7ylzQuZMvBYiCWboP5ge1MP0wDHxVx3YLFA7Z2Bx8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VjampKbqF1cvYngxgR48hhNyqBRZZ7NMkdfVWGQTZ7o0wZrhWJwDW0LzWLIm5U7AJ
	 XaLJtdx/E+drWY5sWVfqFdcxkxn15tNNbWeB92fRsSex59zH/oJzxA6FTWx8ONTrqZ
	 Vgnx2zeJJQEzLXaZ8lbiog5SkamN2zUV/UBhzrN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel@sholland.org>,
	Andrey Skvortsov <andrej.skvortzov@gmail.com>,
	Paul Kocialkowski <paulk@sys-base.io>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 238/484] media: cedrus: Fix missing cleanup in error path
Date: Thu, 30 Jul 2026 16:12:15 +0200
Message-ID: <20260730141428.648591775@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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
@@ -392,6 +392,7 @@ static int cedrus_open(struct file *file
 err_m2m_release:
 	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
 err_free:
+	v4l2_fh_exit(&ctx->fh);
 	kfree(ctx);
 	mutex_unlock(&dev->dev_mutex);
 


