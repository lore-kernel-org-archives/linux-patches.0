Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7F3145341;
	Tue, 27 Feb 2024 14:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043174; cv=none; b=UUZaJ65ypwfVp86ZCP/E9yjdXM2aQ7bH6y9GG1U1kmks6FXrfY890XpVj0/l6/r8We4h9PjcewOICgvT/GafxhXy0DvKAzWl2EWWmvzco3OnFXaC3ZL/StPiK4b+0XWXMtly1GIIAvW/BM1J0qUdavZz5xoNM5lcxUdBgXboAjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043174; c=relaxed/simple;
	bh=cE/Jg+T0nLGewGBOt1Su3cajg9aSzVQATyQegCCP7ks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uJrJ7n/fcgE+6FyTLNA6vZoWSKpIKVPnuJvd/vxOrNIUtLJb4aWgBpV1lJWxYQRPDMSh+5s2keLKGpSNV79NsfkzL5sImckkcLhnWPrGCTWXhH8wZSL2ew5ws8kfyqKbT+PFKW6BX2vLaL0AAPGnfkU0XFjNtw9evOXRvGtcQnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m4yAdyPL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m4yAdyPL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D236AC43390;
	Tue, 27 Feb 2024 14:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043174;
	bh=cE/Jg+T0nLGewGBOt1Su3cajg9aSzVQATyQegCCP7ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m4yAdyPLGW9lR9+UoiKaoFxLKgnkxwPCLl6zhMq52wJ6a1VDzh3/PvB3Dy8Hrrhjk
	 2LCFrehOQMKIxUN50MVdKlYOi9vsxGaXb5wisNLzDVmbsKlu6HkslNkPDjuYPq3SOX
	 wnj0GflsobGs3+n11zDdo2YV0uAWvU1g2bbxlmX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fullway Wang <fullwaywang@outlook.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 015/195] fbdev: savage: Error out if pixclock equals zero
Date: Tue, 27 Feb 2024 14:24:36 +0100
Message-ID: <20240227131610.902852841@linuxfoundation.org>
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

[ Upstream commit 04e5eac8f3ab2ff52fa191c187a46d4fdbc1e288 ]

The userspace program could pass any values to the driver through
ioctl() interface. If the driver doesn't check the value of pixclock,
it may cause divide-by-zero error.

Although pixclock is checked in savagefb_decode_var(), but it is not
checked properly in savagefb_probe(). Fix this by checking whether
pixclock is zero in the function savagefb_check_var() before
info->var.pixclock is used as the divisor.

This is similar to CVE-2022-3061 in i740fb which was fixed by
commit 15cf0b8.

Signed-off-by: Fullway Wang <fullwaywang@outlook.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/savage/savagefb_driver.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/video/fbdev/savage/savagefb_driver.c b/drivers/video/fbdev/savage/savagefb_driver.c
index b7818b652698f..a7b63c475f954 100644
--- a/drivers/video/fbdev/savage/savagefb_driver.c
+++ b/drivers/video/fbdev/savage/savagefb_driver.c
@@ -869,6 +869,9 @@ static int savagefb_check_var(struct fb_var_screeninfo   *var,
 
 	DBG("savagefb_check_var");
 
+	if (!var->pixclock)
+		return -EINVAL;
+
 	var->transp.offset = 0;
 	var->transp.length = 0;
 	switch (var->bits_per_pixel) {
-- 
2.43.0



