Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D53A13B2B4;
	Tue, 27 Feb 2024 14:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042517; cv=none; b=s8YFSSU8tt/Gf2TC9C2WgvpkJDdf23fVHuZuLth61efsTRtCbG6X3fG1IMtu4OoeUM2oUBN36PAhsV+TcbiYXRw8Tggsh877EkyPVI5mEoBNs7pazCWBrvz12fGHlhzwbuQp4gpibmTHpzdC51/9UDjUY7wdjC3Ini9ZAAyDNJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042517; c=relaxed/simple;
	bh=Qq7CXOeqrHdkH1s6UTtbpQVfUMi21GtKZVONWFGdfJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HJtgzTW16i/IwMl3aBaPj/rjTMqpY5SgUu3Nj928Op9q5D/jaRloU27EKUHRXtyy8heGdo3k3JquxaccrTz5IHpn8cSRyiu4Cp7cWW2ajp5V62BdIe2W5Sx/Dtt2xOZHCalvlhzXSBRWFIPJbu1RbuzFtP9iI04SUN3rqnNg4ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0VNjbKLr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0VNjbKLr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B69FC433F1;
	Tue, 27 Feb 2024 14:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042517;
	bh=Qq7CXOeqrHdkH1s6UTtbpQVfUMi21GtKZVONWFGdfJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0VNjbKLrS7kFpsx/Fl6vE0Y8bF9i7rquwgHkZiKiDjVpRWKAqR1e7ObRRY9Z+brYo
	 Y3aAgFgx+yG7H6tAylxke77fBxL8gdw2/9OMcN77G01F6uyURPdMUSCUhHd7IaXiwS
	 xPe3pFiflgT8J+9hKLkwxxb4DFnr7pGhQ2hOhntQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fullway Wang <fullwaywang@outlook.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 024/245] fbdev: sis: Error out if pixclock equals zero
Date: Tue, 27 Feb 2024 14:23:32 +0100
Message-ID: <20240227131615.903205105@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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
index 266a5582f94d3..c6e21ba008953 100644
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



