Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A0713B7AA;
	Tue, 27 Feb 2024 13:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041632; cv=none; b=mqkIq3lbxLFHlDnWxmjKoJESi3wzS5VcgNXROf52IzUwoZwjUtMr0AzWuMO3ZcEEHRTCFUPvOCE3b93ZYd5D/TwWi+e8PL6W0F8C3iVP8oK3htGXLcxsIAY2VX2sCfXCWtGJlrNfNUBS9bDCYW8dtie41OU5FjGezcKUDk9q0Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041632; c=relaxed/simple;
	bh=gW0csiF4zA4XL2YlDEkKcaf87DOU8Vi/dZ6RJbykdd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FqiQ/Ki6IXVgtMHpEvxh08MaOZSMCIB/B0FdRhgMA+zlKwj2B7s19JiU5p76aiwLY3eoWDd8KEUfUmaY6oMErzajoGqp2LujWsVu0hsNM1oM3bPJwEPtQ0ZWGHuAsOJwE0rpKymt/Huw/Cv6FHycTEJ/iz+B2njK5iJ6SGKISOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZN+pvkwf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZN+pvkwf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4F5BC433C7;
	Tue, 27 Feb 2024 13:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041632;
	bh=gW0csiF4zA4XL2YlDEkKcaf87DOU8Vi/dZ6RJbykdd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZN+pvkwfg8lv4/3tvhCxIyLVrgZysPryZJKuIavziks38arW7xPYdQHBp0+jV+h6H
	 wNphzZGXjYc6mP56x/6QezXDU74lCsrnhTKBU6G1O827S4p7mtY13JmYN9DZjdvFBz
	 Cj5if6lXT8y/72SYVBK2qwSJZVxJ66j+D2fo2oQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fullway Wang <fullwaywang@outlook.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 017/299] fbdev: sis: Error out if pixclock equals zero
Date: Tue, 27 Feb 2024 14:22:08 +0100
Message-ID: <20240227131626.387373062@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0f5374f6ef055..6d524a65af181 100644
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



