Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C52261FDF;
	Wed,  3 Jul 2024 10:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003890; cv=none; b=ScNoDE7iLTjfplhtljxIEHGhRBDk4seXgg6uZH9Su0Fxr/qVI9sqRdI12u1Kq4uGBo48w+8aQdd2TBQyZyDaQYqjg89CmmKVD1L/5UnMhe7lFrMnGCf/TdaPX93d7TdIUbEdz9IyTsXEZSVrqFrVsUXeZ2H7QqQ11x7/UGacSZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003890; c=relaxed/simple;
	bh=XM1YQu7Sl5b7FJpqmtZOg4CmOo6RFe2wxgrFqt4wOVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G3tjeLWLmthGlMRY3Cf8oPKsg/SvUHu17IEksEicbXNJHFDKmMJuKgQiGiXM6eJ00G1nrgvCY5H1WDrgHcc2IghsXMDki5KQnmrjm+6wOXGcfbpNmfktZRk4bxddKzpxizBJVlNWkq8wpCQU6rlqywv58lGmTLNZGQK3Uk08lDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=syXgFnu7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="syXgFnu7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D1BC2BD10;
	Wed,  3 Jul 2024 10:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003890;
	bh=XM1YQu7Sl5b7FJpqmtZOg4CmOo6RFe2wxgrFqt4wOVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=syXgFnu7MUuqCXfyu3K26FcqIlIxJzwtwCyp7uojfiYGmhwWRBVi5UpS096SBOEY9
	 2v82FKs5OyRzCrzG4s45ysPzWDzWCH43mndZezz+rasPbmn0FyNi7UGRDJspp/iA1F
	 qE6wYVjjH+/mvnd+o8pUrTb92WSseqr4Ahl93LlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5186630949e3c55f0799@syzkaller.appspotmail.com,
	Alan Stern <stern@rowland.harvard.edu>,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 053/189] HID: core: remove unnecessary WARN_ON() in implement()
Date: Wed,  3 Jul 2024 12:38:34 +0200
Message-ID: <20240703102843.515092673@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

[ Upstream commit 4aa2dcfbad538adf7becd0034a3754e1bd01b2b5 ]

Syzkaller hit a warning [1] in a call to implement() when trying
to write a value into a field of smaller size in an output report.

Since implement() already has a warn message printed out with the
help of hid_warn() and value in question gets trimmed with:
	...
	value &= m;
	...
WARN_ON may be considered superfluous. Remove it to suppress future
syzkaller triggers.

[1]
WARNING: CPU: 0 PID: 5084 at drivers/hid/hid-core.c:1451 implement drivers/hid/hid-core.c:1451 [inline]
WARNING: CPU: 0 PID: 5084 at drivers/hid/hid-core.c:1451 hid_output_report+0x548/0x760 drivers/hid/hid-core.c:1863
Modules linked in:
CPU: 0 PID: 5084 Comm: syz-executor424 Not tainted 6.9.0-rc7-syzkaller-00183-gcf87f46fd34d #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
RIP: 0010:implement drivers/hid/hid-core.c:1451 [inline]
RIP: 0010:hid_output_report+0x548/0x760 drivers/hid/hid-core.c:1863
...
Call Trace:
 <TASK>
 __usbhid_submit_report drivers/hid/usbhid/hid-core.c:591 [inline]
 usbhid_submit_report+0x43d/0x9e0 drivers/hid/usbhid/hid-core.c:636
 hiddev_ioctl+0x138b/0x1f00 drivers/hid/usbhid/hiddev.c:726
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:904 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:890
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
...

Fixes: 95d1c8951e5b ("HID: simplify implement() a bit")
Reported-by: <syzbot+5186630949e3c55f0799@syzkaller.appspotmail.com>
Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index e0820feb7e19a..2462be8c4ae65 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1439,7 +1439,6 @@ static void implement(const struct hid_device *hid, u8 *report,
 			hid_warn(hid,
 				 "%s() called with too large value %d (n: %d)! (%s)\n",
 				 __func__, value, n, current->comm);
-			WARN_ON(1);
 			value &= m;
 		}
 	}
-- 
2.43.0



