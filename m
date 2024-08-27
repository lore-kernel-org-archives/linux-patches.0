Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982691A072D;
	Tue, 27 Aug 2024 15:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772304; cv=none; b=RPzhWsJHCNl79OvTtn23Wx3r8l8QLaxDfG8e9NIukcDXBK3G65Kxu01pcxunrkXDPQ1GySudbp/+GEHchfXejpWZmNvRldA5y7WJCz0WLYUpZHzHfbu95UHq3g92k+XqluDk12gqxYzrDukOd58STniOtfXSmn3WZbQr0lk8ucs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772304; c=relaxed/simple;
	bh=A5YIl5fVS/cOGGeXQrUS2ETiJxBTbUHRyKTWPJM30og=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ipwnyi7riiS8SnCh+iqtGPBYpd4iNS459Q4IcpJUiWUEglrYHJ0lXDM7xkR5ackEadczJG5cvG3hD7NHBeZfAYnDdh+ftIKN7E0/o/4v2sG4vODXM9hR9vxgMz7WyXVm5zIQCK3SoUtlAXHbMK6cJbLHYOdqO7Peg8jItl95cdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ohqxaCW/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ohqxaCW/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07936C61071;
	Tue, 27 Aug 2024 15:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772304;
	bh=A5YIl5fVS/cOGGeXQrUS2ETiJxBTbUHRyKTWPJM30og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ohqxaCW/4Cs3wufFVB/+JI42fpkOzHJ+Tz+f+F4RIhxMme2a0M7sLJ0v2Zhcqg6Rv
	 8Xnpk67Q6AxPF8Gc5hr52Q2IYMBu1AkFv8J0dh1W81c+A+Q2IxxqHCnnUUyEhkpMrn
	 gyGKn0Ne+4aCf6mpyuAZTVBUau5x1FIzzqeoUzk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Airlie <airlied@redhat.com>,
	Philipp Stanner <pstanner@redhat.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 167/321] media: drivers/media/dvb-core: copy user arrays safely
Date: Tue, 27 Aug 2024 16:37:55 +0200
Message-ID: <20240827143844.587518518@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Philipp Stanner <pstanner@redhat.com>

[ Upstream commit 102fb77c2deb0df3683ef8ff7a6f4cf91dc456e2 ]

At several positions in dvb_frontend.c, memdup_user() is utilized to
copy userspace arrays. This is done without overflow checks.

Use the new wrapper memdup_array_user() to copy the arrays more safely.

Link: https://lore.kernel.org/linux-media/20231102191633.52592-2-pstanner@redhat.com
Suggested-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Philipp Stanner <pstanner@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-core/dvb_frontend.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index fce0e20940780..a1a3dbb0e7388 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2160,7 +2160,8 @@ static int dvb_frontend_handle_compat_ioctl(struct file *file, unsigned int cmd,
 		if (!tvps->num || (tvps->num > DTV_IOCTL_MAX_MSGS))
 			return -EINVAL;
 
-		tvp = memdup_user(compat_ptr(tvps->props), tvps->num * sizeof(*tvp));
+		tvp = memdup_array_user(compat_ptr(tvps->props),
+					tvps->num, sizeof(*tvp));
 		if (IS_ERR(tvp))
 			return PTR_ERR(tvp);
 
@@ -2191,7 +2192,8 @@ static int dvb_frontend_handle_compat_ioctl(struct file *file, unsigned int cmd,
 		if (!tvps->num || (tvps->num > DTV_IOCTL_MAX_MSGS))
 			return -EINVAL;
 
-		tvp = memdup_user(compat_ptr(tvps->props), tvps->num * sizeof(*tvp));
+		tvp = memdup_array_user(compat_ptr(tvps->props),
+					tvps->num, sizeof(*tvp));
 		if (IS_ERR(tvp))
 			return PTR_ERR(tvp);
 
@@ -2368,7 +2370,8 @@ static int dvb_get_property(struct dvb_frontend *fe, struct file *file,
 	if (!tvps->num || tvps->num > DTV_IOCTL_MAX_MSGS)
 		return -EINVAL;
 
-	tvp = memdup_user((void __user *)tvps->props, tvps->num * sizeof(*tvp));
+	tvp = memdup_array_user((void __user *)tvps->props,
+				tvps->num, sizeof(*tvp));
 	if (IS_ERR(tvp))
 		return PTR_ERR(tvp);
 
@@ -2446,7 +2449,8 @@ static int dvb_frontend_handle_ioctl(struct file *file,
 		if (!tvps->num || (tvps->num > DTV_IOCTL_MAX_MSGS))
 			return -EINVAL;
 
-		tvp = memdup_user((void __user *)tvps->props, tvps->num * sizeof(*tvp));
+		tvp = memdup_array_user((void __user *)tvps->props,
+					tvps->num, sizeof(*tvp));
 		if (IS_ERR(tvp))
 			return PTR_ERR(tvp);
 
-- 
2.43.0



