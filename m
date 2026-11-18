Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021433;
	b=SGLUB67KOxYUfDRx9jx1aImTSsy15JC5+MuYuyvFV+mh0lHq7roiJLX13HxLmi1q6l+Q
	 HGLMCJu/2+cU5/gWYvwBcmeDpg9FruPT/XZktUvJ52uFAMEp5d0U+z4y0x1dA1w09nIjE
	 9rCQlc+OKC7q0/itNQEJ5TwIxyq2qFCUpZgkBhYr9jtgCfa2p35wXXsNc+SO+1xrThdKp
	 GBKqritmTeFiyppop8PxJ0uczxzxGcaF7ldBqn5WuTNULyI9kVttBzKAbP7JoQIMHpnhm
	 I4O9ExZZEvRh22WtrYETn8VzCzmYMXdMHjERUrJyf42MBP9ZB0Cm/sywdaGIgXvJsAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021433;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Gi0eR4rURcw1GGBMFWVp+W0z0c+Lq1XseNb3UkNwWOA=;
	b=Q2+oYAdBLKGPE+HXN8FsqiBiq3Sha2kydSw2fA8QuoVb0CF/7JQuTGki2yfnfRRZAaKe
	 SYsf6bx4k0EYM+wxXJNmPqGHwEaf6wo2FWCPGE9gTrvIzbYSE4amHmyiPJ8BpzOD9mP5c
	 AlSp9sw5L1vkf0OBRq+B7W0EzzsIZh+2/FoTao6ONqV+Et0HCkpa353EKTHeWDwZ/sHHW
	 yPSOiIfTTAUh62J8DVlIpA1BI8LsglN5wdw7yhPX/uxJuifFd51ttTYrlOSJXsGKpciRP
	 9YO8Lvw4zcRWBVb30r/GsxMZi4yIPE91dmKb6u1+zQjyLyaX3kaLaMZkVNFPRtA4kXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WNTsLUwz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B62560A2627;
	Wed, 18 Nov 2026 17:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WNTsLUwz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 668991F000C8;
	Wed, 18 Nov 2026 17:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021432;
	bh=Gi0eR4rURcw1GGBMFWVp+W0z0c+Lq1XseNb3UkNwWOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WNTsLUwzO4LVYTXH43mbJXc96hhW7Hq26SqDOTdDihncOZRwKkpQDQOFfQZ88zA50
	 wkoeIsOI6JAeKikhTTDXmUE+s4FzCAFY9JRad8lK4+GRYAleuhO9RhCcL16L/EZ2zf
	 i/8IzBo1vNMra10rpggIPT6+/VMb+tXWzovbIUqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Kees Cook <kees@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Kurt Hackel <kurt.hackel@oracle.com>,
	Jia-Ju Bai <baijiaju1990@gmail.com>,
	jjzuming@gmail.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2304/2651] ocfs2: initialize status waiters before publishing them
Date: Wed, 18 Nov 2026 15:59:04 +0100
Message-ID: <20261118150408.217627860@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit f6bfa6c458288d72948af95391b205f3eb775721 ]

o2net_prep_nsw() publishes its stack waiter in nn_status_idr and
nn_status_list under nn_lock, then initializes the wait queue and
completion status after releasing the lock.  A concurrent disconnect can
find that waiter through o2net_complete_nodes_nsw() and call wake_up()
before the wait queue has a valid lock and list head.  The sender can also
overwrite a completion status with its initial value.

Initialize the wait queue and status before publishing the waiter.
nn_lock then orders publication against completion, and no reader can
observe a partially initialized object.  Leave the IDR allocation and its
failure handling unchanged.

A controlled case-modified test kernel used a synthetic connection to
enter the real send path and overlap publication with disconnect.  The
candidate completion and wake-up code were unchanged.  Its Oops includes:

  KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
  RIP: 0010:__wake_up_common+0xa0/0x1f0
  Call Trace:
   <TASK>
   __wake_up+0x36/0x60
   o2net_complete_nsw_locked+0x222/0x370
   o2net_set_nn_state+0x917/0xea0
   o2net_disconnect_node+0xd0/0x190
   o2net_validate_control_write+0x454/0x500
   full_proxy_write+0x11f/0x180
   vfs_write+0x25a/0x1010
   ksys_write+0x111/0x200
   do_syscall_64+0x114/0x620
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
   </TASK>
  Modules linked in:

Link: https://lore.kernel.org/pm-ocfs2-objects-candidate-0066-v1-437a0422801b292a2879@gmail.com
Fixes: 98211489d414 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Assisted-by: LLM
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Kurt Hackel <kurt.hackel@oracle.com>
Cc: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: <jjzuming@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/cluster/tcp.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 0ba26bd2eba11..0eaf2c4a6989e 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -301,6 +301,11 @@ static int o2net_prep_nsw(struct o2net_node *nn, struct o2net_status_wait *nsw)
 {
 	int ret;
 
+	/* Initialize all completion-visible state before publishing the waiter. */
+	init_waitqueue_head(&nsw->ns_wq);
+	nsw->ns_sys_status = O2NET_ERR_NONE;
+	nsw->ns_status = 0;
+
 	spin_lock(&nn->nn_lock);
 	ret = idr_alloc(&nn->nn_status_idr, nsw, 0, 0, GFP_ATOMIC);
 	if (ret >= 0) {
@@ -311,9 +316,6 @@ static int o2net_prep_nsw(struct o2net_node *nn, struct o2net_status_wait *nsw)
 	if (ret < 0)
 		return ret;
 
-	init_waitqueue_head(&nsw->ns_wq);
-	nsw->ns_sys_status = O2NET_ERR_NONE;
-	nsw->ns_status = 0;
 	return 0;
 }
 
-- 
2.53.0



