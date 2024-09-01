Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB1E3B79C;
	Sun,  1 Sep 2024 17:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210159; cv=none; b=t5KRHCV1/0JoPLVVdw/S2hctERvapFHY1GxSx33e6bm9dnGTxMqjYgNglVB5ISt1FUty0YYd5Xi2ZsGsv6dLadB2MfDeOHl6wrrDkrB/1MWYDftANQD/WMC+AbyLD4I7VhC2Dk2UjcEUAhVAGENqtWcFN2a62jRiEQnHz71Y9/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210159; c=relaxed/simple;
	bh=oEwSBkNc9yRulwyvbeYwF0gzOMV27oJNVTEny2ZqIEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UYbW5YYO/47J5pUAXprq3Ld1lq1LA8FPC8QZ9BEqP3R7id3MVTm7Wq6A3OLe2I2vQyLn1yy7cwgMiA/Tosit+2ewDQez2w6Gq8w4qYfPqpqj7EZp2tgd4LgyPMBf4mhfXEUH3HK9NpH4QyfTmXafFqe/yugLldb28a9ygMs6Quc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a0MAVbmT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a0MAVbmT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 325D4C4CEC3;
	Sun,  1 Sep 2024 17:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210159;
	bh=oEwSBkNc9yRulwyvbeYwF0gzOMV27oJNVTEny2ZqIEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a0MAVbmTq6kbgVGctOAYA4DwoKNBNLdFPBqHQHIz37ivUaFRo+JpQkIpsjGQ1SRlh
	 dPPyrI48NmHTflRMLubVzQVPjkS7+zfwz2FtgulolAVbdzvj39MwbwP2uJ8eV8k4JL
	 aeujC5pG0rSQHhAGExti7Ph7P/UEfmoIichGXb/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Airlie <airlied@redhat.com>,
	Philipp Stanner <pstanner@redhat.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 075/215] media: drivers/media/dvb-core: copy user arrays safely
Date: Sun,  1 Sep 2024 18:16:27 +0200
Message-ID: <20240901160826.187838002@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index fea62bce97468..d76ac3ec93c2f 100644
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



