Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC131E492;
	Wed, 19 Jun 2024 13:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803869; cv=none; b=B1jL5N/LFvSSjk09WbhNlHXkKYPD3as7AvqJwVbdPZCZDzPXX+g2scLzltyEaSVqSu0TNGDdeT3HlPNmAQlhYWiHCvZlzuY9CqLX69D1G0zUOvuoQsFmYSyVUX9/dM8KhgcZ8fknEXxrXEfAY4+B+MDq4QHB8UPtfu3iyDBVNOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803869; c=relaxed/simple;
	bh=M8mKp0FFCIZY0vI86ZsmXpq0aVKMA75o9BVvEOZs8ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hnJi3YCrV9jKrXucYvW8KmVL8E5zSp4Ec/gw0i55MbXWOKl1m0wocT1Mje4LzG2ar2FID4Uh8+qk8pn5q0gL9awvvyODfwvU7tWX38ratBZhMN0zxkvFd/wyShTTPDrDB2mxDxhJu5uG7uP75tDssKYfWhs4qqqsePiYb+VMS54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1LT7wVpI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1LT7wVpI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16933C2BBFC;
	Wed, 19 Jun 2024 13:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803869;
	bh=M8mKp0FFCIZY0vI86ZsmXpq0aVKMA75o9BVvEOZs8ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1LT7wVpIpnYB1SeatxvcnJztS2EfATkjFAIpkdPw0FV7gUiEgS5x1QENBT0YTFx9I
	 6vmKTk9BgoLqUTPwuB2cnLX4BYOm1FKqbqKAg8i+RGIqTVWDzyUWlyBFlCLANuHwK8
	 Engq8tiC4yMJGb+pyW0POy1376TNm4Ed3oaAT8xQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5186630949e3c55f0799@syzkaller.appspotmail.com,
	Alan Stern <stern@rowland.harvard.edu>,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 130/217] HID: core: remove unnecessary WARN_ON() in implement()
Date: Wed, 19 Jun 2024 14:56:13 +0200
Message-ID: <20240619125601.705891091@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index cdad3a0662876..e2e52aa0eeba9 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1451,7 +1451,6 @@ static void implement(const struct hid_device *hid, u8 *report,
 			hid_warn(hid,
 				 "%s() called with too large value %d (n: %d)! (%s)\n",
 				 __func__, value, n, current->comm);
-			WARN_ON(1);
 			value &= m;
 		}
 	}
-- 
2.43.0



