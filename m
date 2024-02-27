Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3F313AA2F;
	Tue, 27 Feb 2024 13:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041469; cv=none; b=fpmWjXIqzRL5bsXuGw9TJ640pqTl/jyCNm4iDHD0/9fy9WLBJKZFLjKMhhJc6tUOK5ae6fjcxbRIDgSp5ysaTbAB/TP0IKlDRSeA236vf9Zi8f+rX6YtUtEW6Cp+osEbpNCaU0jRzpYmEKL1c+YJqVTcUHl9lfyTeDJvWmNfTt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041469; c=relaxed/simple;
	bh=UJmzfUG/H9x+6IDaSLroUTIiwtQPscAd/iLyNw/uXXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ivMqg8k6FGZvxuXD3/gjSp3pvE63VJbffK5HJTUb6YiSmx/neUAltDY9iJ+0tgQ9n6mA9xALcXay4FTbij1pQxqmpsnu/w/2PxawgtWWOtszJZPWbxS9sO1egCbh77qJG2ss2r0/vrA/3ihBsb3E9L+4mgEKezxdHLae22MXolA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ok0yknW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ok0yknW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF38C433F1;
	Tue, 27 Feb 2024 13:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041469;
	bh=UJmzfUG/H9x+6IDaSLroUTIiwtQPscAd/iLyNw/uXXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ok0yknWC/nE/h00NvuVhmZSDOFnnYIh0xk80i2V7Rxw2US+BkDEoP+pHGxfQb5Y1
	 +mAdS5oZxnOk7We1OmxIqHYYXm3UidbCFgrD4LmTwdYshTMcFnHxqzgN3stupndkh8
	 xNsRz6JaTuG/5VziiipSn1+Lda9GSf6aAHlYStms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fullway Wang <fullwaywang@outlook.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 16/52] fbdev: savage: Error out if pixclock equals zero
Date: Tue, 27 Feb 2024 14:26:03 +0100
Message-ID: <20240227131549.067573829@linuxfoundation.org>
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
index c09d7426cd925..d9eafdb89ceaf 100644
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



