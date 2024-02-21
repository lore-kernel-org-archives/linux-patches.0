Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7D955E5E;
	Wed, 21 Feb 2024 13:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523586; cv=none; b=l8nlIPEZXEUA5UqL7oNo4dKrcB7nODsiittMJBpJGz41cIqNQYUz6SsA9m7Ms1uiOtgA0/r7AAhQUhHyidbzAaTD45qqJiRlec6hhEg1BgTBp1lJdXHJBj3SFiM7xrM1ZVEckidsls+/jKB9/751OfeQVr6EnqIfgsPrSw5fBvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523586; c=relaxed/simple;
	bh=HtvWoiVcmME0Vlta/gmj0yhBVBMVLg5PmWdA5RD/woQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NC1w4V7BwOo94VUmTKcB7vgR1r7QroBSatBwwRsXLX8v3aweX0T80sZXvhn2BPUEWjxz/s7GfqahC8az4N+HY4a1lA1vnx+o7UD7t617qfxdHQYQL5HURtb7TJ8KwaVeC2A9yI5Ltxhm0tiQU9NesZ2fq4MNunHn6cd8Rwf+REY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IhSJ+BqA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IhSJ+BqA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A512EC433F1;
	Wed, 21 Feb 2024 13:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523586;
	bh=HtvWoiVcmME0Vlta/gmj0yhBVBMVLg5PmWdA5RD/woQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IhSJ+BqAlF1lGTeXn40TnfvRAXe9/u+2NQvS6QntCgOaDfVmc6ddxzaMW9ItMTUj+
	 P63RLcjXj8Sq+fpqXOo5fN8yEpGYf5SBJE1TDJTrloCPtyEvQ2hZfeqWsDsFx+kWFb
	 2oOUk05EULJwQYRwHvaC4ZINZQEP7AG69STmNG0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 453/476] fbdev: flush deferred IO before closing
Date: Wed, 21 Feb 2024 14:08:24 +0100
Message-ID: <20240221130024.781028103@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

From: Nam Cao <namcao@linutronix.de>

[ Upstream commit 33cd6ea9c0673517cdb06ad5c915c6f22e9615fc ]

When framebuffer gets closed, the queued deferred IO gets cancelled. This
can cause some last display data to vanish. This is problematic for users
who send a still image to the framebuffer, then close the file: the image
may never appear.

To ensure none of display data get lost, flush the queued deferred IO
first before closing.

Another possible solution is to delete the cancel_delayed_work_sync()
instead. The difference is that the display may appear some time after
closing. However, the clearing of page mapping after this needs to be
removed too, because the page mapping is used by the deferred work. It is
not completely obvious whether it is okay to not clear the page mapping.
For a patch intended for stable trees, go with the simple and obvious
solution.

Fixes: 60b59beafba8 ("fbdev: mm: Deferred IO support")
Cc: stable@vger.kernel.org
Signed-off-by: Nam Cao <namcao@linutronix.de>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fb_defio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/core/fb_defio.c b/drivers/video/fbdev/core/fb_defio.c
index 7e76e53b83d5..1f12c2043603 100644
--- a/drivers/video/fbdev/core/fb_defio.c
+++ b/drivers/video/fbdev/core/fb_defio.c
@@ -300,7 +300,7 @@ static void fb_deferred_io_lastclose(struct fb_info *info)
 	struct page *page;
 	int i;
 
-	cancel_delayed_work_sync(&info->deferred_work);
+	flush_delayed_work(&info->deferred_work);
 
 	/* clear out the mapping that we setup */
 	for (i = 0 ; i < info->fix.smem_len; i += PAGE_SIZE) {
-- 
2.43.0



