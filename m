Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F233187332;
	Sun, 26 Oct 2025 14:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761490215; cv=none; b=BKJKCVa4g9fBFeFS8bHYDUwTokfZ7wfi3Z5vcr2hm3iOtCdUJ0t66dqdB1Coj7AhTZxY1qQFLKeSvl0dM/aJg47Vm8nurcfvUIFDzE7WmK4xjOj6GqtAnrFgsGoZk0xs3DAqbrRJKA2VOPJYBZxBBY/vmZevf4wCQAPx8sH9zq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761490215; c=relaxed/simple;
	bh=TtyZHzbayl7S0EGoiGisxgsmlttFW3R2yF91ZkaewKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ol+Q+308tfPVlpZ8G/7/ujtIe3+kP5Vp6p6B2mJMrMulqUx+KpZZ6viZq7bqNEiuAEs5UJ8BUC5P+7O0hBSXRPB1Qu6xJHAlnrtJ/ckxx7w/RlKIOAbQQ6h3g/919eNyJvXeUdHiU21j46//aq0mkf/VvD2Wh9TOTf9Ws92cvXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BSlZlocT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BSlZlocT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18AC3C4CEFB;
	Sun, 26 Oct 2025 14:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761490215;
	bh=TtyZHzbayl7S0EGoiGisxgsmlttFW3R2yF91ZkaewKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BSlZlocTRJxJSbV4qvzSwwJxHwgztD6rPkMQVZtEhV6du4FM3KdtUzx1w0aImOFLS
	 gW9C2hP9X3gE5bOv1SQcZTlpdRaDhU6/0fLH6eFrNbSKQFqiGDIGx4/0GD1nzLL5BJ
	 6HD8idajUwL7ABZ8dD+pKlZDlNDj4asaxOlDa9DRjc9Od8PJ11NxFS4TU2VOiEZd+Q
	 zhQFudpbM6xlPg6UBZZd70GxqnbERr7V3Pyt1xsSLLLLc1UFrV6oCEUmNxDZanmQhd
	 +Aopv+WM3ckickaD63rKMFsme48D5H+ZU2l6b+HYpNkbMx/J6AdDS5bjekJZH13zqK
	 HGSf0q8rpmfMg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Albin Babu Varghese <albinbabuvarghese20@gmail.com>,
	syzbot+48b0652a95834717f190@syzkaller.appspotmail.com,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>,
	simona@ffwll.ch,
	soci@c64.rulez.org,
	alexander.deucher@amd.com,
	alexandre.f.demers@gmail.com
Subject: [PATCH AUTOSEL 6.17-5.4] fbdev: Add bounds checking in bit_putcs to fix vmalloc-out-of-bounds
Date: Sun, 26 Oct 2025 10:48:47 -0400
Message-ID: <20251026144958.26750-9-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251026144958.26750-1-sashal@kernel.org>
References: <20251026144958.26750-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

YES
- The added vertical guard in
  `drivers/video/fbdev/core/bitblit.c:163-166` stops the renderer before
  it touches rows past `info->var.yres`, directly preventing the off-
  screen writes that triggered the syzbot vmalloc-out-of-bounds report
  while leaving the rest of the rendering unchanged.
- The horizontal clipping in
  `drivers/video/fbdev/core/bitblit.c:182-191` is the crucial fix: it
  refuses to draw when the start X is already off-screen, clips
  `image.width` to the visible span, and—most importantly—shrinks `cnt`
  to match the clipped width. Without that `cnt` adjustment, the
  subsequent calls to `bit_putcs_aligned/unaligned`
  (drivers/video/fbdev/core/bitblit.c:200-205) would still iterate over
  the original character count and walk past the pixmap buffer that was
  sized for the smaller width, recreating the exact overflow syzbot
  caught.
- `bit_putcs` is the fbcon `putcs` hook
  (drivers/video/fbdev/core/bitblit.c:408), so this bug can be triggered
  by any console text write near the display edge; the overflow is real
  memory corruption, making this a high-priority stable fix.
- The patch is self-contained to console blitting, introduces no API or
  structural changes, and only adds straightforward bounds checks and
  bookkeeping, so regression risk is low while preventing a serious
  crash/security issue.

Backporting this minimal defensive fix aligns with stable policy: it
closes a user-visible bug (vmalloc OOB) reported by syzbot and does so
with tightly scoped changes. Recommendation: apply to stable.

 drivers/video/fbdev/core/bitblit.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/video/fbdev/core/bitblit.c b/drivers/video/fbdev/core/bitblit.c
index f9475c14f7339..a9ec7f488522c 100644
--- a/drivers/video/fbdev/core/bitblit.c
+++ b/drivers/video/fbdev/core/bitblit.c
@@ -160,6 +160,11 @@ static void bit_putcs(struct vc_data *vc, struct fb_info *info,
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
@@ -173,6 +178,18 @@ static void bit_putcs(struct vc_data *vc, struct fb_info *info,
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

