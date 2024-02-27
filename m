Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4AEE13AA55;
	Tue, 27 Feb 2024 13:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041471; cv=none; b=aP/L+dW1gQgBatD21/bw+406of63PP+5UHZ1Bmq6V2ZDxa/BtS4UrA7L+9nmdwYalZCODgfqIpAAsHnIt/YCWcs17zf+2Nu446jJxM6ldXNzIfEr0GH7VAv+2KxCcADnKxPbcyinSMbQLlJpZj/XGhuk7QjXwgHxNeu34Vr46uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041471; c=relaxed/simple;
	bh=3x3Y3rTK9K/hxopPk3O+7IAyEXr1+KZR2CBf1pv5sJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hZqmxlZB4WdqRkVYNHJ/tLulbwIIoM2jdZdKBSDiDjwcOI1PM+VduPiG9Hr7n4TizmWiDYMWbwmc+JpFfTscsNvEfXViQPVx4CvNP64vapkb0vVpgOvtZjlfZYNYnuuuxxDb28oHFeTh0Lu276BRCnRuDqWsDCvJXsqWI7LbomQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g631ifWS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g631ifWS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63AE9C433C7;
	Tue, 27 Feb 2024 13:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041471;
	bh=3x3Y3rTK9K/hxopPk3O+7IAyEXr1+KZR2CBf1pv5sJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g631ifWSn6kWxa4v8vegFWNbklqAkwx/BpGoeEFBuO/bqvJGTGv6UeVPZ9BOR9IYC
	 dK2StIZX2KHlCGszR5FBS9WzsYW+vTcthXYgpSnupAe5TvsNbw6D4sH9havbMg21KA
	 oZSNFA2kqKubQ5PyUFlH6pSyYOJ09MOThZPHQQiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fullway Wang <fullwaywang@outlook.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 17/52] fbdev: sis: Error out if pixclock equals zero
Date: Tue, 27 Feb 2024 14:26:04 +0100
Message-ID: <20240227131549.099771880@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131548.514622258@linuxfoundation.org>
References: <20240227131548.514622258@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 20aff90059781..b7f9da690db27 100644
--- a/drivers/video/fbdev/sis/sis_main.c
+++ b/drivers/video/fbdev/sis/sis_main.c
@@ -1488,6 +1488,8 @@ sisfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 
 	vtotal = var->upper_margin + var->lower_margin + var->vsync_len;
 
+	if (!var->pixclock)
+		return -EINVAL;
 	pixclock = var->pixclock;
 
 	if((var->vmode & FB_VMODE_MASK) == FB_VMODE_NONINTERLACED) {
-- 
2.43.0



