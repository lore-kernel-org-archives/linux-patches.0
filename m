Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC0F24EA90;
	Mon,  1 Dec 2025 11:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588624; cv=none; b=I+0GCbfgK1uhDeSrzMYsOsNb+W+kBLjbditZ78jM4B3zHFxjefPDdhp0SXjbHUBNU/wocAKgPQeoGreQJqIkD9wgWlnU+ewPobHKbyHVc3yYG83nCEy0Mla1v4dZdynnrahJoTlYSyo93VCFBDtaTW23dSajkNCWbB/SkEdBNTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588624; c=relaxed/simple;
	bh=0k6lTdUIyXiDnEAtRDSvZaCtYOc/nhi+S3cQoSPhMrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NsHZOPlvnnSSkLYi+xZbdmQNU/Xv1vEmVz2kc4rtthY8WWNx0yZXZIkJtkw+SfaBOCcwdHUMdGNpQUmmRhGu72kGfYiwg/51ADq8BiosS18K8P3NcldMCrvXEIxXN23c9hkfVN2mPEtZgWVOG2nBncxvyU+3If/KAPl+Lt2nVuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N9JwCwdo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N9JwCwdo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3664BC4CEF1;
	Mon,  1 Dec 2025 11:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588624;
	bh=0k6lTdUIyXiDnEAtRDSvZaCtYOc/nhi+S3cQoSPhMrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N9JwCwdoPw0yZOUfFJKYEbhFPqGu+icegKgaFGUULI+Ab+l6HNHve+UAC6yVi7EPX
	 nh6HJLyVUwOL0QuNTbgrknVWiEp3lzLIyVjyqQrvtHFgSY5Dtw0B+gN81CcXErvAo0
	 NFdvNEpfepiAm6mm5SoszNXviRC546fD/UGAr4ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+48b0652a95834717f190@syzkaller.appspotmail.com,
	Helge Deller <deller@gmx.de>,
	Albin Babu Varghese <albinbabuvarghese20@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 112/187] fbdev: Add bounds checking in bit_putcs to fix vmalloc-out-of-bounds
Date: Mon,  1 Dec 2025 12:23:40 +0100
Message-ID: <20251201112245.278694839@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 99a4f048b96ac..75c20f8e58e33 100644
--- a/drivers/video/fbdev/core/bitblit.c
+++ b/drivers/video/fbdev/core/bitblit.c
@@ -169,6 +169,11 @@ static void bit_putcs(struct vc_data *vc, struct fb_info *info,
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
@@ -182,6 +187,18 @@ static void bit_putcs(struct vc_data *vc, struct fb_info *info,
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



