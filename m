Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE0C13B2B8;
	Tue, 27 Feb 2024 14:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043735; cv=none; b=lY7Q10AxdA3oE3krbgf09kJNOagWpzT5ZnLx1lvjaxiSuv9vqLXuDFjzIAJSTrmVLbc6Gn8LLcvYm0Jp1FkWS0e/j4xNuSLR3tQ6fdyCZCJj3Sn9RDVVEvQ2HAVHRmyjcThJGmC9Cipp9Iic4gfA+hMfqlHy8J3P80x6+hE5Ywo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043735; c=relaxed/simple;
	bh=R8JKXIlHkwuDze/yhoLPH8p0qmX3ZrVf9wJLBN9q3Ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZusFbl1xi9PlOpxuAKpvcIlLDrmRSbP/BxMaum6zSq+/+PfDxW8bpbkVGiZU2kOjh7X4dUUuKTj0KyRL0HxZE9tEw3MnUVUtiEptBAyeCeX7uIgW//v5sAnPO2wJwUp9HTi0GVtFt8OXqMvk139MrI1eNKml0Hqq0aRvf32YHyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ztqZltJ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ztqZltJ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE63C433C7;
	Tue, 27 Feb 2024 14:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043735;
	bh=R8JKXIlHkwuDze/yhoLPH8p0qmX3ZrVf9wJLBN9q3Ro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ztqZltJ6Omd17Q1bWQF5i/+O2X8ySZDOkHf+eio1ODnPGRI/o0tTQX6gEkSdzVTZE
	 xVLZy1/aqoD/rgESPTcBgE2vdV+owMYtWpbEU/py20l9gMROoY2i0oeXlypF/nNSw3
	 Uu/gta5s6jfACSXrwST5L27GSOFM4VSvPwhMjVB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fullway Wang <fullwaywang@outlook.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 18/84] fbdev: sis: Error out if pixclock equals zero
Date: Tue, 27 Feb 2024 14:26:45 +0100
Message-ID: <20240227131553.463289149@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131552.864701583@linuxfoundation.org>
References: <20240227131552.864701583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index b443a8ed46003..2fdd02e51f5fc 100644
--- a/drivers/video/fbdev/sis/sis_main.c
+++ b/drivers/video/fbdev/sis/sis_main.c
@@ -1474,6 +1474,8 @@ sisfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 
 	vtotal = var->upper_margin + var->lower_margin + var->vsync_len;
 
+	if (!var->pixclock)
+		return -EINVAL;
 	pixclock = var->pixclock;
 
 	if((var->vmode & FB_VMODE_MASK) == FB_VMODE_NONINTERLACED) {
-- 
2.43.0



