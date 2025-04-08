Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3E21FCFF3;
	Tue,  8 Apr 2025 12:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115480; cv=none; b=NzqrkoE2yXBlMzs5Ge3TJPW3WPuHdBSMG/2k6ucQeK3gSuv6fLVH9mYd+mZ58TqhA64IyK03tVrViSzICjWiucmFo4pR6rnNbvIPz39reJMXexyb8Tqy/rwk4YXPsH17c11oiKLvDwaEZmRmMosRLDWKyPE1RkWRVCO6zy8kIkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115480; c=relaxed/simple;
	bh=rGlFVMorbyTLwjuO5/DxyDrRDeVQAIuOGvashP0vM6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cp2Yox0q3bv1/UOhHYeJ83ongy35aX7qz0AeNoYkPbx8G5Z+PI0RHPcj49OBkHLc9u7IQusqBFPAECBS2S9r7DIzwYPZkloHzIYEMQ8iReIwuDy7nRzBeQRAVbitVBTb9qW6zgJjalt/xGFYvUputebS03iHmyNo95tlceG722I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wQryQTBK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wQryQTBK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6472FC4CEE5;
	Tue,  8 Apr 2025 12:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115479;
	bh=rGlFVMorbyTLwjuO5/DxyDrRDeVQAIuOGvashP0vM6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wQryQTBK3q0HNUdYBfbmekVN6z+nWEknLKu/Tkxzpey5Iib8sIKl4iJPZszuSeleW
	 3SNaXqQmI6uC9DGtc9w01dGI835/yTj11EyPog1pLWyCJqxKIY57N/LLNDpNdAoXMh
	 PBAmN1REfvyTAY50b3woP7fvIHcfFSHXou1nKlyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5bcd7c809d365e14c4df@syzkaller.appspotmail.com,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.13 490/499] media: vimc: skip .s_stream() for stopped entities
Date: Tue,  8 Apr 2025 12:51:42 +0200
Message-ID: <20250408104903.578559589@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

commit 36cef585e2a31e4ddf33a004b0584a7a572246de upstream.

Syzbot reported [1] a warning prompted by a check in call_s_stream()
that checks whether .s_stream() operation is warranted for unstarted
or stopped subdevs.

Add a simple fix in vimc_streamer_pipeline_terminate() ensuring that
entities skip a call to .s_stream() unless they have been previously
properly started.

[1] Syzbot report:
------------[ cut here ]------------
WARNING: CPU: 0 PID: 5933 at drivers/media/v4l2-core/v4l2-subdev.c:460 call_s_stream+0x2df/0x350 drivers/media/v4l2-core/v4l2-subdev.c:460
Modules linked in:
CPU: 0 UID: 0 PID: 5933 Comm: syz-executor330 Not tainted 6.13.0-rc2-syzkaller-00362-g2d8308bf5b67 #0
...
Call Trace:
 <TASK>
 vimc_streamer_pipeline_terminate+0x218/0x320 drivers/media/test-drivers/vimc/vimc-streamer.c:62
 vimc_streamer_pipeline_init drivers/media/test-drivers/vimc/vimc-streamer.c:101 [inline]
 vimc_streamer_s_stream+0x650/0x9a0 drivers/media/test-drivers/vimc/vimc-streamer.c:203
 vimc_capture_start_streaming+0xa1/0x130 drivers/media/test-drivers/vimc/vimc-capture.c:256
 vb2_start_streaming+0x15f/0x5a0 drivers/media/common/videobuf2/videobuf2-core.c:1789
 vb2_core_streamon+0x2a7/0x450 drivers/media/common/videobuf2/videobuf2-core.c:2348
 vb2_streamon drivers/media/common/videobuf2/videobuf2-v4l2.c:875 [inline]
 vb2_ioctl_streamon+0xf4/0x170 drivers/media/common/videobuf2/videobuf2-v4l2.c:1118
 __video_do_ioctl+0xaf0/0xf00 drivers/media/v4l2-core/v4l2-ioctl.c:3122
 video_usercopy+0x4d2/0x1620 drivers/media/v4l2-core/v4l2-ioctl.c:3463
 v4l2_ioctl+0x1ba/0x250 drivers/media/v4l2-core/v4l2-dev.c:366
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:906 [inline]
 __se_sys_ioctl fs/ioctl.c:892 [inline]
 __x64_sys_ioctl+0x190/0x200 fs/ioctl.c:892
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f2b85c01b19
...

Reported-by: syzbot+5bcd7c809d365e14c4df@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5bcd7c809d365e14c4df
Fixes: adc589d2a208 ("media: vimc: Add vimc-streamer for stream control")
Cc: stable@vger.kernel.org
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/test-drivers/vimc/vimc-streamer.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/media/test-drivers/vimc/vimc-streamer.c
+++ b/drivers/media/test-drivers/vimc/vimc-streamer.c
@@ -59,6 +59,12 @@ static void vimc_streamer_pipeline_termi
 			continue;
 
 		sd = media_entity_to_v4l2_subdev(ved->ent);
+		/*
+		 * Do not call .s_stream() to stop an already
+		 * stopped/unstarted subdev.
+		 */
+		if (!v4l2_subdev_is_streaming(sd))
+			continue;
 		v4l2_subdev_call(sd, video, s_stream, 0);
 	}
 }


