Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86AF720C488;
	Tue, 29 Apr 2025 18:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950172; cv=none; b=XCeyCaDk7asuTBzlszzAyqi1HUy4XJU7spwnW1XEiJzX3oR0Vcpn7NLFDYbXaQ96BV1Q5l1feg41FNFpnV6SNd2n4vCbpA80FrGPePZ0rRw/VWK0AnQuDgzBvtaK0fNEob4JiNvIRgoERkXPv7jDOmmtw0S1lTxjZy33vP1TGkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950172; c=relaxed/simple;
	bh=4cOQ1uTfE2dYqM4596mA33RaOn3viq327blScGu4igY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GpnOYh/sL+d09J+cJo9rhAaqKzIK0Ggv6DPGsbIAFJE+BI03dDaAGbfIBUDz7/SC3U/JGd2SXfNAcU7eyt9hcDUH9/ggvwHTQvKwYgODUJK1QImdLVH8zhhE5gpSeTflvMo4hACKMtpdD5PA025niwIRknIcGrJ3s4TwUp2ieHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yBD0EKEN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yBD0EKEN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3FBC4CEE3;
	Tue, 29 Apr 2025 18:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950172;
	bh=4cOQ1uTfE2dYqM4596mA33RaOn3viq327blScGu4igY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yBD0EKENfp3uuFT4TX4xv2LzDJ3yeaZ3bYvfNS5CFJ2x0p7O/eEHg0rwcQK8zbQHQ
	 hlU95/tSBvxT2e5+z8Se4Ro9V9Xw4Q3nIPNTnO6gt+qhdabSfKp9asEdmjPzA4nH8R
	 rtR4UsmnPulM+U0OqHS7Ah8xtvjtWkvztRnHOsDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5bcd7c809d365e14c4df@syzkaller.appspotmail.com,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 011/204] media: vimc: skip .s_stream() for stopped entities
Date: Tue, 29 Apr 2025 18:41:39 +0200
Message-ID: <20250429161059.864008032@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

[ Upstream commit 36cef585e2a31e4ddf33a004b0584a7a572246de ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/test-drivers/vimc/vimc-streamer.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/test-drivers/vimc/vimc-streamer.c b/drivers/media/test-drivers/vimc/vimc-streamer.c
index 807551a5143b7..15d863f97cbf9 100644
--- a/drivers/media/test-drivers/vimc/vimc-streamer.c
+++ b/drivers/media/test-drivers/vimc/vimc-streamer.c
@@ -59,6 +59,12 @@ static void vimc_streamer_pipeline_terminate(struct vimc_stream *stream)
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
-- 
2.39.5



