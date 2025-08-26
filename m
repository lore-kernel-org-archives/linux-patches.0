Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B261299959;
	Tue, 26 Aug 2025 11:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207791; cv=none; b=oN5CnbJ+I/YgyG7EpPaI3FlZnp+n2H/Exg8G75XafZnwiiwbck+EG+8GjjYdbGt9M3Yu2qAMwPNl+KMdO/xljBYScpnsy1Zij45BfzRFDKFxbqvefUcNeRt4TwU8J9crd1XhgRXHpqFYiWutyKSGwCfB9KePwoG8ojmCdpEhUlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207791; c=relaxed/simple;
	bh=lANnqWj56TndussZWKWp+dbvIWO27NIl2plU+s0tTyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kk7FqQ286hNgtAo8XBbQkk4Q+aekGWg2Wu7c9PxHXuFR9Q6T703Tow+Fl2zT5zE591l6QlowJq2W11Pv7zoMTX0pJ83HK9r86CftozVMBR8z8hW2GKjPqDs1L1J0nF1FltiCLffo9t8AyNaW+bjMmzQ2NsqQRm4Bm9iF6gnNDK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b0R0ivn2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b0R0ivn2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0484C4CEF4;
	Tue, 26 Aug 2025 11:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207791;
	bh=lANnqWj56TndussZWKWp+dbvIWO27NIl2plU+s0tTyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b0R0ivn2toTXFy+TPd/0mBL1Bz9IT4ixaytKLwSGOFoIbGDUC3lJD8knGB5U0fYM+
	 5O2SvhhHs3jwoVcjn+Uuj64nmX63vjJi/DmUntgC5bYtTIjx8qhgGFS6K25/25oa94
	 QHrRP90YloaJxB95YqoQiTLJ1dQNxY2hh84o//HE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 288/457] signal: Fix memory leak for PIDFD_SELF* sentinels
Date: Tue, 26 Aug 2025 13:09:32 +0200
Message-ID: <20250826110944.500942028@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>

[ Upstream commit a2c1f82618b0b65f1ef615aa9cfdac8122537d69 ]

Commit f08d0c3a7111 ("pidfd: add PIDFD_SELF* sentinels to refer to own
thread/process") introduced a leak by acquiring a pid reference through
get_task_pid(), which increments pid->count but never drops it with
put_pid().

As a result, kmemleak reports unreferenced pid objects after running
tools/testing/selftests/pidfd/pidfd_test, for example:

  unreferenced object 0xff1100206757a940 (size 160):
    comm "pidfd_test", pid 16965, jiffies 4294853028
    hex dump (first 32 bytes):
      01 00 00 00 00 00 00 00 00 00 00 00 fd 57 50 04  .............WP.
      5e 44 00 00 00 00 00 00 18 de 34 17 01 00 11 ff  ^D........4.....
    backtrace (crc cd8844d4):
      kmem_cache_alloc_noprof+0x2f4/0x3f0
      alloc_pid+0x54/0x3d0
      copy_process+0xd58/0x1740
      kernel_clone+0x99/0x3b0
      __do_sys_clone3+0xbe/0x100
      do_syscall_64+0x7b/0x2c0
      entry_SYSCALL_64_after_hwframe+0x76/0x7e

Fix this by calling put_pid() after do_pidfd_send_signal() returns.

Fixes: f08d0c3a7111 ("pidfd: add PIDFD_SELF* sentinels to refer to own thread/process")
Signed-off-by: Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>
Link: https://lore.kernel.org/20250818134310.12273-1-adrianhuang0701@gmail.com
Tested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/signal.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 148082db9a55..6b1493558a3d 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -4067,6 +4067,7 @@ SYSCALL_DEFINE4(pidfd_send_signal, int, pidfd, int, sig,
 {
 	struct pid *pid;
 	enum pid_type type;
+	int ret;
 
 	/* Enforce flags be set to 0 until we add an extension. */
 	if (flags & ~PIDFD_SEND_SIGNAL_FLAGS)
@@ -4108,7 +4109,10 @@ SYSCALL_DEFINE4(pidfd_send_signal, int, pidfd, int, sig,
 	}
 	}
 
-	return do_pidfd_send_signal(pid, sig, type, info, flags);
+	ret = do_pidfd_send_signal(pid, sig, type, info, flags);
+	put_pid(pid);
+
+	return ret;
 }
 
 static int
-- 
2.50.1



