Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E8034B437;
	Sat, 17 Oct 2026 16:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256399; cv=none; b=OnBDXZCfUN667q3kGCjf6i7qYUfJfqtPpHPUaWzm8AQAGWGTSmDYIv9cJebbUXukQwFb85/Bbtd0K3k+un28y0FlwX4h6cgHxcLV1Neu99wZAN/xByVbdPBgPvSunqtcgS5syht7MpmSsBUYs7zn3yhhHN4oxwZpNvhjCSakuPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256399; c=relaxed/simple;
	bh=3ekHhoJqM/Z2fPLsWljQhZRpom8iDoLFclhdJGD5yH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bIjpYL/sy8hJ+oR//2suQRzK6UKXFLU1NSB6bUvVxRtlWUcMquSutZlGM0YZ/6puRtyUMDubajCLbwBddXTbQDXuIK0YFoGsQNt7yZek0pVhWpZRT+Cr/QCfqhPj64vBw5E1CuR7bIGTBm4E6RI6J1UfGhyTR0C5MAB+hI+Xu9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=06/k6V6j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="06/k6V6j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 063FE1F000C4;
	Sat, 17 Oct 2026 16:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256397;
	bh=v+uhWlNUyP+CiPVG149paIjHoMX/UghahuZkZpEbfb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=06/k6V6jvyfseS4qT9aq0A1/B3z+0VinB6+l3ajKPI9R6mmIsKQr/0kupiass5AFy
	 9F9LpSrNxDUAWiyMGfVaxhbUGa5kpzuGqdxPaOhm7BnwUBIxrSn9Z3ZiE/26EQj1m+
	 DT3h5BwqVhHKq/F+l+NnH1T8dDUwmNAMgnVshofE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Deng <18983559317@163.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0206/1674] net/mctp: publish the mctp_dev only after it is initialised
Date: Sat, 17 Oct 2026 17:41:18 +0200
Message-ID: <20261017160436.437653685@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Binbin Deng <18983559317@163.com>

[ Upstream commit aadf655e8ea9a8ffa24bb8d69f504572e8d18181 ]

mctp_add_dev() links the new mctp_dev into dev->mctp_ptr before mdev->dev
is assigned, so a reader that picks the device up in that window
dereferences a net_device pointer that is still NULL:

KASAN: null-ptr-deref in range [0x00000000000000b0-0x00000000000000b7]
Call Trace:
 <TASK>
 ? __pfx_mctp_sendmsg (./include/linux/sockptr.h:49)
 ? __pfx_mctp_dst_output (net/mctp/route.c:41)
 ? selinux_socket_sendmsg (security/selinux/hooks.c:5278)
 ____sys_sendmsg (net/socket.c:775 (discriminator 1) net/socket.c:790
 (discriminator 1) net/socket.c:2684 (discriminator 1))
 ? __pfx_____sys_sendmsg (net/socket.c:1131)
 ? __pfx_copy_msghdr_from_user (net/socket.c:2590)
 ? update_cfs_rq_load_avg (kernel/sched/fair.c:5478)
 ___sys_sendmsg (net/socket.c:2738)
 ? __pfx____sys_sendmsg (net/socket.c:2625)
 ? perf_event_task_tick (./include/linux/rcupdate.h:838)
 ? sched_tick (kernel/sched/core.c:5818)
 ? clockevents_program_event (kernel/time/clockevents.c:372)
 ? fdget (./include/linux/rcupdate.h:873 fs/file.c:1100)
 __sys_sendmsg (net/socket.c:2770)
 ? __pfx___sys_sendmsg (net/socket.c:2751)
 do_syscall_64 (arch/x86/entry/syscall_64.c:63)
 entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
 </TASK>

Fix by publishing only once the object is fully initialised:
__mctp_dev_get() runs under rcu_read_lock() only and hands
this object to readers as soon as mctp_ptr is assigned, so
they must never observe mdev->dev == NULL.

Fixes: 583be982d934 ("mctp: Add device handling and netlink interface")
Signed-off-by: Binbin Deng <18983559317@163.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/729830b8.130.1a0c945579d.Coremail.18983559317@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mctp/device.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mctp/device.c b/net/mctp/device.c
index 67576cb2728ec..ee430b73b0976 100644
--- a/net/mctp/device.c
+++ b/net/mctp/device.c
@@ -344,13 +344,13 @@ static struct mctp_dev *mctp_add_dev(struct net_device *dev)
 
 	mdev->net = mctp_default_net(dev_net(dev));
 
-	/* associate to net_device */
 	refcount_set(&mdev->refs, 1);
-	rcu_assign_pointer(dev->mctp_ptr, mdev);
-
 	dev_hold(dev);
 	mdev->dev = dev;
 
+	/* Associate to net_device, publish the mdev. */
+	rcu_assign_pointer(dev->mctp_ptr, mdev);
+
 	return mdev;
 }
 
-- 
2.53.0



