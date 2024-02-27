Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D1E13B2B8;
	Tue, 27 Feb 2024 14:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043813; cv=none; b=qpnItfenieMkz7cqyGUcOkyQhnXBwlKIaQJls3+kvZ8Awgn0o9kBu41eWiFDBwUCjQtNucDzi9jxzeWoq3wQlZ2j+oNt9yP1NFgDix6R/tZ2vbZe6ZWl/E4liXpyzPUcSu/JkSkZcsKyyIBehpAg5H+J9DrAEg9K8ObZmwcpZpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043813; c=relaxed/simple;
	bh=1P7pTEY6BqHsh0DmLNhWMMfJdJ0MFEvGkTl+INouWeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGKzQR/g8hxAz9x+PvKyOvDkywKvRX3kRq8MnrR7bNPHvBzVZYfviRAPUTZj/lT2wHaFq3OnT4+w1nSo7YzbZILhvhnyJ7YXf1cDs0QHkHO9G+U+NBHyUyvXyCmkOcDWkZZKej84h2VSKYCG0oyJPjQV4h86SfoVo2LqvDm73WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TXGdZE3b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TXGdZE3b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8990AC433C7;
	Tue, 27 Feb 2024 14:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043812;
	bh=1P7pTEY6BqHsh0DmLNhWMMfJdJ0MFEvGkTl+INouWeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TXGdZE3b8qIAn4DZISX0PzkrPCD01GS+F7ZSHlSd70CJYqbzaw3OVe1oDO65ksWb2
	 MNzzqZH8hfXICgQUkHyZ7Y4ucQvIPL1xT98g1i73yH8jMmTG4fOoKuuW9hT3PPOTFZ
	 0vMIljaM7FkRFXu4yhxW1Az8wO1vw4X9JnnuhypE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fullway Wang <fullwaywang@outlook.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 17/84] fbdev: savage: Error out if pixclock equals zero
Date: Tue, 27 Feb 2024 14:26:44 +0100
Message-ID: <20240227131553.431213697@linuxfoundation.org>
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
index d5d22d9c0f562..368500c401402 100644
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



