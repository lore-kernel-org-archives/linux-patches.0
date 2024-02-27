Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3833913EFF4;
	Tue, 27 Feb 2024 14:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043976; cv=none; b=lGqdpos46XaVoZh7KpUYdqemx+brQfLtYHwDiogR+7KtAE7bKAqEUvktbO1onJUSk6p3URgBVggjTO2hvC7cPO4ZVyvpTzGW+L7fp5kM7kAuNRptsIqWTNzzNa5rJfNao5cbQ42AZ2U9iRlTNgVHFbOM9dc8NkF8CCz2ITvwSec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043976; c=relaxed/simple;
	bh=UE6pKw1DPcltReTPQjQhE4MeEAAKsVDYf1dKmJUAH2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J/5Ho5erOVcVmik/A0xjSlZ11i4ykHeOELUQQPmzp74USPdA1lJ+mzPWQqa4Hl13C6L1akheN1fYhZLo5It0HD53Ldc1XTSEzNB1yF5WlRyBE7XTeX8otlY9riASqr/Re6pNIoOhN+Oxa4mgW21eHccBfm2C0kTF1btdA0Ri//s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X6ez7tNY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X6ez7tNY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8572C433C7;
	Tue, 27 Feb 2024 14:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043976;
	bh=UE6pKw1DPcltReTPQjQhE4MeEAAKsVDYf1dKmJUAH2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X6ez7tNYXo95GtMNuS+zBTqDd3y/8HdPZxDdrcHiUI/SPmohfWiTiD3kPCrxPgU5T
	 EYREEDHWS48f+Kf3KnLflS6TpPkUX8QqBnymMZ4uuoXvHaXqKkejjLp74YWCAvZKkV
	 p0LopxeCV2L1GP/VrQD8czjoBiV/Ic+a4aNoFAQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fullway Wang <fullwaywang@outlook.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 018/122] fbdev: sis: Error out if pixclock equals zero
Date: Tue, 27 Feb 2024 14:26:19 +0100
Message-ID: <20240227131559.302230674@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 03c736f6f3d08..e540cb0c51726 100644
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



