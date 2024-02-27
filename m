Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6747B14037E;
	Tue, 27 Feb 2024 14:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043973; cv=none; b=YyLRPpyrAcPREsLu2h+jB1foI0yf7jTr5NjckbSy/rINBI/2sYce9tBv1XcrOuLoRq3Sk9l7n1W32kqxOS4O/BrkwHzVQ1x1VHuXiyawPtq8qpFai8fOaFfR0SVLlXH2bdKMliOc9btvH/FjKZ8zOqyGNgb1INh5e3K1zbMN98w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043973; c=relaxed/simple;
	bh=9bNCVwIfMSc21aliK2oXYVdX4JSHqvHOLOCPUdqTahA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HSXrt0yGglV8lNe1nxxqqlL8bdrEoKbEgmsMT0J4UzkZSeTNo36FP8NeNMXUrePaH7P2is+l6D4dnrnSFW5DBp3tY/z5J0xPVgxzjgRu5dv/gTU5uu9ZXcq404SaQPHWTeDey9oi+nVWy7UPcIkwLO48eqvrm8ru9cY7XkTuTyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ntEbmt3M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ntEbmt3M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E648EC433F1;
	Tue, 27 Feb 2024 14:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043973;
	bh=9bNCVwIfMSc21aliK2oXYVdX4JSHqvHOLOCPUdqTahA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ntEbmt3MG2bBD7YwsWd/zC+kCHtvUTPz0sMrCuPzUddTFFy6p16tl1Ed1u2lULs8x
	 mXUCoXQgNZbbwl0Pr+zKAbpFDDWDTPCynm22FWuS0bJes6FFN3/myzDdbqAAFYSYFV
	 jCaG0od7sVI46lmlFxE/D5cxWl05Ywr4o7vJRuwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fullway Wang <fullwaywang@outlook.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 017/122] fbdev: savage: Error out if pixclock equals zero
Date: Tue, 27 Feb 2024 14:26:18 +0100
Message-ID: <20240227131559.269210549@linuxfoundation.org>
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



