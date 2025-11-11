Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550721D86FF;
	Tue, 11 Nov 2025 01:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824738; cv=none; b=ClZy5kh/OeKL1vgfV/+Z9K6B6R4RyCRizSOoGv0m/hAoU/6YkHOPiaR/ZTlZzjYUOT4cONMCcWRuBrNYJhQuqJq8euOKxKHesvGAHAcyfmtVuRpwUJt+KAZHpIMGFcrylZD6zIKlEQHhjrJlN2vzXR/HVdMhpR9BAhMRj5ZwbYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824738; c=relaxed/simple;
	bh=8evNlnGNjzIotd7rf50sSIoub0w4FbepamDhgxC3eMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qO8nTs2y/b9WfO6wuo0ZQ4aVxIXH8sKgK5EOKSwrjQmI4fufrkU6hIirMtldSrtpSJCUB/dRUURrVYC8xIAcUniB4mrtJ5CagfMqSzGBE0jmQPw4GTV6O3OPlJrvO3CaNn8Oqe8BQPdOTLdKNTsHDEHBvL6evR2NJN1lPs40DnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bmK/A6k8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bmK/A6k8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF641C19421;
	Tue, 11 Nov 2025 01:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824738;
	bh=8evNlnGNjzIotd7rf50sSIoub0w4FbepamDhgxC3eMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bmK/A6k8O0AC0KVf/P3yf17rQiT+febe78JA9Oo0Cjt4q9Tt5xjzp9rtibiRXwuEC
	 4hs0P9PatcdwO2hBYytH3Q++lT/CQ5Za7G71d2+615Q5Wkg+S2HrsAZmh33Xre3eRG
	 vjGNSpzYv/Mjp6/+L8eCi/nXuIVZH8/CpPQ/3jqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+48b0652a95834717f190@syzkaller.appspotmail.com,
	Helge Deller <deller@gmx.de>,
	Albin Babu Varghese <albinbabuvarghese20@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 486/565] fbdev: Add bounds checking in bit_putcs to fix vmalloc-out-of-bounds
Date: Tue, 11 Nov 2025 09:45:42 +0900
Message-ID: <20251111004537.861841101@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Albin Babu Varghese <albinbabuvarghese20@gmail.com>

[ Upstream commit 3637d34b35b287ab830e66048841ace404382b67 ]

Add bounds checking to prevent writes past framebuffer boundaries when
rendering text near screen edges. Return early if the Y position is off-screen
and clip image height to screen boundary. Break from the rendering loop if the
X position is off-screen. When clipping image width to fit the screen, update
the character count to match the clipped width to prevent buffer size
mismatches.

Without the character count update, bit_putcs_aligned and bit_putcs_unaligned
receive mismatched parameters where the buffer is allocated for the clipped
width but cnt reflects the original larger count, causing out-of-bounds writes.

Reported-by: syzbot+48b0652a95834717f190@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=48b0652a95834717f190
Suggested-by: Helge Deller <deller@gmx.de>
Tested-by: syzbot+48b0652a95834717f190@syzkaller.appspotmail.com
Signed-off-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/bitblit.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/video/fbdev/core/bitblit.c b/drivers/video/fbdev/core/bitblit.c
index 2e46c41a706a2..dc5ad3fcc7be4 100644
--- a/drivers/video/fbdev/core/bitblit.c
+++ b/drivers/video/fbdev/core/bitblit.c
@@ -168,6 +168,11 @@ static void bit_putcs(struct vc_data *vc, struct fb_info *info,
 	image.height = vc->vc_font.height;
 	image.depth = 1;
 
+	if (image.dy >= info->var.yres)
+		return;
+
+	image.height = min(image.height, info->var.yres - image.dy);
+
 	if (attribute) {
 		buf = kmalloc(cellsize, GFP_ATOMIC);
 		if (!buf)
@@ -181,6 +186,18 @@ static void bit_putcs(struct vc_data *vc, struct fb_info *info,
 			cnt = count;
 
 		image.width = vc->vc_font.width * cnt;
+
+		if (image.dx >= info->var.xres)
+			break;
+
+		if (image.dx + image.width > info->var.xres) {
+			image.width = info->var.xres - image.dx;
+			cnt = image.width / vc->vc_font.width;
+			if (cnt == 0)
+				break;
+			image.width = cnt * vc->vc_font.width;
+		}
+
 		pitch = DIV_ROUND_UP(image.width, 8) + scan_align;
 		pitch &= ~scan_align;
 		size = pitch * image.height + buf_align;
-- 
2.51.0



