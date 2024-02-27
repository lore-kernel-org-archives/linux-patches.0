Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3A313B2B8;
	Tue, 27 Feb 2024 14:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042515; cv=none; b=J4AvS492XrQKRvrK74p0jSfsvtkEtemmeNGJ09I1tnYzVyKV20nLM9T+GxxY/Oq39QVXZystsaQUy6MPoJC+i2hiKhHYlBbUJ75/Mci754DCrW4BaGQxszXZpwTRdjmlIqT+jYgVBkRhMX90j5bOLTmHcZFFF+Mg3qzjh1zTqxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042515; c=relaxed/simple;
	bh=tya4LxsV9uDs5dEHBAEEY5C49GOZDkUsh/ndyfPQy7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XA7BrNCObleBY0IqKB2E6ZGUvfuctZcNnSVGwsrkzSlhBeQfU7R4i5Q6p0s2yO/0VrflsBvESTStoMjd05RtJxDGCGcMfZZQfh9em016K+oxD2c8pN21hDwR6qbpDQZYE/frBpPwtyzonmTRF1EJ8cMFwpIlWyw0QUngqXmYfsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hnfnpymh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hnfnpymh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A0D1C433F1;
	Tue, 27 Feb 2024 14:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042514;
	bh=tya4LxsV9uDs5dEHBAEEY5C49GOZDkUsh/ndyfPQy7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hnfnpymh6EBwD+GgKSj/c7wGTsHX781ukYKRUXdZkYjWDUoH3xrApX+HunZzaDlMz
	 rJGu249D/EMPZL+6K6UByja0+/3mv/SrzB9OwKSv2rS8fasit2pGHgyw89RpfA5B+G
	 irNAdG9XGacN8wzv4+U4vqbMBieSlA4v0cICNDjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fullway Wang <fullwaywang@outlook.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 023/245] fbdev: savage: Error out if pixclock equals zero
Date: Tue, 27 Feb 2024 14:23:31 +0100
Message-ID: <20240227131615.870823935@linuxfoundation.org>
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
index 0ac750cc5ea13..94ebd8af50cf7 100644
--- a/drivers/video/fbdev/savage/savagefb_driver.c
+++ b/drivers/video/fbdev/savage/savagefb_driver.c
@@ -868,6 +868,9 @@ static int savagefb_check_var(struct fb_var_screeninfo   *var,
 
 	DBG("savagefb_check_var");
 
+	if (!var->pixclock)
+		return -EINVAL;
+
 	var->transp.offset = 0;
 	var->transp.length = 0;
 	switch (var->bits_per_pixel) {
-- 
2.43.0



