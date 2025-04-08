Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084C627F4F9;
	Tue,  8 Apr 2025 12:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744117190; cv=none; b=eWWySIiPogpurS67C2QpB0IcQSYzi2aQrjPkkeV9NMO/rBUakRqK0P5STWBTzfC/PTg4BFQnH1JVtdHbjxcwjvl+dko0OwVzuhvRVpTKPWdx/V1DkyyKqwA968ln9tbzww0YIPrGKq2PpVhYYLQbaDFiRjnfi2ZSimVrmqO1/R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744117190; c=relaxed/simple;
	bh=vlulEneedjrElg9pItZlpSc4MztW9z/2l4LtSRHb9ZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ijXxLpqrJux+2CVdRqrQ3esvdJNPEVFYEFwUQGro9yDnM3IGKbO3C/V1z0B5QBSe/erBWV+aFzR4mL0Pn5/+HO5LjzZbptvYYm8o1q8pC66PtAKWlhuMTZpbmRCd4HaHhZIdL/hRruSoRN3NE3K0ejV2CLPFZJe3yYSkqUgT100=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=brpUHqCK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="brpUHqCK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE2DC4CEE5;
	Tue,  8 Apr 2025 12:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744117189;
	bh=vlulEneedjrElg9pItZlpSc4MztW9z/2l4LtSRHb9ZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=brpUHqCKu63swZ6xX1UIjlcLPIihHY+KrSgHc/r9QgzffKx6PDNlMBTGQrBtAviN5
	 m+ta2LTyAPkDmMGN9BGsC51TkREfdpcP3Z9xPpimruNRwk1x2oMDK7gtJFT5LgdH8o
	 5DLw7j7AMRKnZTks462OmO3HE4Imotzf1B6G2vV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5bcd7c809d365e14c4df@syzkaller.appspotmail.com,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 416/423] media: vimc: skip .s_stream() for stopped entities
Date: Tue,  8 Apr 2025 12:52:22 +0200
Message-ID: <20250408104855.612481744@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


