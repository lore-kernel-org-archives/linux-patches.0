Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ACF11EEA3C;
	Mon, 23 Jun 2025 21:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714001; cv=none; b=UADiyEBEdshYcJgwSw227RN6+U3Lt2ygxJmfgWbGDAVIk8MPoMn/ye3aZ11nC++sv0BTlvlygvI8ZDb0jS1ZDeAklgBgotvJiEnnutiW1wR7bUBm5GMYh+YG620O0QxB/XrwNmJictFrtonh1Rp6y3fgH0LLICYIFHJhVaWa4Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714001; c=relaxed/simple;
	bh=pdBDjbCgOEOWyvlQko6vTKKEFW13fTq2sVntxFRK+RY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SoG+jUboHHZX9OKPZbZJhYCIPYE2Ll0HD3bl/vNiL8HFQFqcI9UjnN8JKQaFWClS87Y1FQKiqwshjZ4IWeb68OWd6vGQUUbeJsquNueeM8Gepm1YfA8PBEy7XwZz4HZfZp8xd9Ta6ACjezLz5bALWn3RTV2U1DGCg3eOSdett1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x2BqdT+B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x2BqdT+B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00079C4CEEA;
	Mon, 23 Jun 2025 21:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714001;
	bh=pdBDjbCgOEOWyvlQko6vTKKEFW13fTq2sVntxFRK+RY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x2BqdT+BE02nTZA5yzNVC0VWJSgYbX4I07rn//1uZPRAyoZ3ngifznQZBy2Fc+1kj
	 hKk6Q1rsuDKbkh6CcheAcEMIeEPOUVcf7kKyZkoLSWASN0UZiQJg38t/Uc+NNLnc98
	 i/RXuLxwkNMLfXuIZs9qjg+5q9BeZcA1ICrjK4Ig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+365005005522b70a36f2@syzkaller.appspotmail.com,
	Denis Arefev <arefev@swemel.ru>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 5.10 178/355] media: vivid: Change the siize of the composing
Date: Mon, 23 Jun 2025 15:06:19 +0200
Message-ID: <20250623130632.052013361@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Denis Arefev <arefev@swemel.ru>

commit f83ac8d30c43fd902af7c84c480f216157b60ef0 upstream.

syzkaller found a bug:

BUG: KASAN: vmalloc-out-of-bounds in tpg_fill_plane_pattern drivers/media/common/v4l2-tpg/v4l2-tpg-core.c:2608 [inline]
BUG: KASAN: vmalloc-out-of-bounds in tpg_fill_plane_buffer+0x1a9c/0x5af0 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c:2705
Write of size 1440 at addr ffffc9000d0ffda0 by task vivid-000-vid-c/5304

CPU: 0 UID: 0 PID: 5304 Comm: vivid-000-vid-c Not tainted 6.14.0-rc2-syzkaller-00039-g09fbf3d50205 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014

Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:489
 kasan_report+0x143/0x180 mm/kasan/report.c:602
 kasan_check_range+0x282/0x290 mm/kasan/generic.c:189
 __asan_memcpy+0x40/0x70 mm/kasan/shadow.c:106
 tpg_fill_plane_pattern drivers/media/common/v4l2-tpg/v4l2-tpg-core.c:2608 [inline]
 tpg_fill_plane_buffer+0x1a9c/0x5af0 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c:2705
 vivid_fillbuff drivers/media/test-drivers/vivid/vivid-kthread-cap.c:470 [inline]
 vivid_thread_vid_cap_tick+0xf8e/0x60d0 drivers/media/test-drivers/vivid/vivid-kthread-cap.c:629
 vivid_thread_vid_cap+0x8aa/0xf30 drivers/media/test-drivers/vivid/vivid-kthread-cap.c:767
 kthread+0x7a9/0x920 kernel/kthread.c:464
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>

The composition size cannot be larger than the size of fmt_cap_rect.
So execute v4l2_rect_map_inside() even if has_compose_cap == 0.

Fixes: 94a7ad928346 ("media: vivid: fix compose size exceed boundary")
Cc: stable@vger.kernel.org
Reported-by: syzbot+365005005522b70a36f2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?id=8ed8e8cc30cbe0d86c9a25bd1d6a5775129b8ea3
Signed-off-by: Denis Arefev <arefev@swemel.ru>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/test-drivers/vivid/vivid-vid-cap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/test-drivers/vivid/vivid-vid-cap.c
+++ b/drivers/media/test-drivers/vivid/vivid-vid-cap.c
@@ -962,8 +962,8 @@ int vivid_vid_cap_s_selection(struct fil
 			if (dev->has_compose_cap) {
 				v4l2_rect_set_min_size(compose, &min_rect);
 				v4l2_rect_set_max_size(compose, &max_rect);
-				v4l2_rect_map_inside(compose, &fmt);
 			}
+			v4l2_rect_map_inside(compose, &fmt);
 			dev->fmt_cap_rect = fmt;
 			tpg_s_buf_height(&dev->tpg, fmt.height);
 		} else if (dev->has_compose_cap) {


