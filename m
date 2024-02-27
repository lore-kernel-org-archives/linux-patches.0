Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C0A13EFEC;
	Tue, 27 Feb 2024 14:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043177; cv=none; b=g3T75VZnWwja6iunnGo8NP8cVicFJiz80dDXt3Strzkd2+uEkq2ePXSqIAJChfMh0/HMxl9iERbjuEQVJ9C1wUJEKJqoxnBo0ZzDyr6M1ZdHjIp3xJj5NhyPnFvxbr56IobI7ScYdg8P+7BTFLoiBB7D6SbhK8gcSNo4VlO5F1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043177; c=relaxed/simple;
	bh=EeEMErnMcGa030Y/CFvSwxrlDrL1ZZQA3XC/3K5zBaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jf7uNdGhSu0UKMOJM57yTsHFefvlwMBnBFWR51u+sgdN9fznxysD8F+Rmh9BiL2hxLCMXswKq5vusfwIGCQcvMSR8KLN5EqXLjbaJJaAshY9AfyadUKKerrkYZ8R6GETSxEBlqh0lff++7qAx5HCxBviO7pg01116Sci3w9CDLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ciSuNNvJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ciSuNNvJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A8AC433F1;
	Tue, 27 Feb 2024 14:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043177;
	bh=EeEMErnMcGa030Y/CFvSwxrlDrL1ZZQA3XC/3K5zBaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ciSuNNvJqMpC08otuk0rDT0ZQg7LNKXJ/dC3Ax90PzFnOW/4uxYkqpJsBExVz6EoH
	 B+RKn89/Xwicw5zYwJ0pnhHCoFlxagtnM6lu2CvM0qUU8IcSN2S/kpn20w4ljXd2yL
	 9qtXsQUP1d5ygg1p1k/iX88C7hCbaUgm+odLbOFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fullway Wang <fullwaywang@outlook.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 016/195] fbdev: sis: Error out if pixclock equals zero
Date: Tue, 27 Feb 2024 14:24:37 +0100
Message-ID: <20240227131610.934395408@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

From: Fullway Wang <fullwaywang@outlook.com>

[ Upstream commit e421946be7d9bf545147bea8419ef8239cb7ca52 ]

The userspace program could pass any values to the driver through
ioctl() interface. If the driver doesn't check the value of pixclock,
it may cause divide-by-zero error.

In sisfb_check_var(), var->pixclock is used as a divisor to caculate
drate before it is checked against zero. Fix this by checking it
at the beginning.

This is similar to CVE-2022-3061 in i740fb which was fixed by
commit 15cf0b8.

Signed-off-by: Fullway Wang <fullwaywang@outlook.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/sis/sis_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/video/fbdev/sis/sis_main.c b/drivers/video/fbdev/sis/sis_main.c
index 1c197c3f95381..fe8996461b9ef 100644
--- a/drivers/video/fbdev/sis/sis_main.c
+++ b/drivers/video/fbdev/sis/sis_main.c
@@ -1475,6 +1475,8 @@ sisfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 
 	vtotal = var->upper_margin + var->lower_margin + var->vsync_len;
 
+	if (!var->pixclock)
+		return -EINVAL;
 	pixclock = var->pixclock;
 
 	if((var->vmode & FB_VMODE_MASK) == FB_VMODE_NONINTERLACED) {
-- 
2.43.0



