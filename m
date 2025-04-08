Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDC6265CD3;
	Tue,  8 Apr 2025 12:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115204; cv=none; b=KyVOaK7PjTv15Q83Mh0O8LMD2S8B74lMIop79revj6H/AthBZUNylgLvfVGKF94tu8rLhRdMuSChmppKE9sHDsX7Hd9AJU1UVsgubvFja8yhUTjpjZ3BiEmmkfL63EMVyk1erAdwyQXwwWNujrIGtkC0aUmeyuVS3+Yri/x+Rh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115204; c=relaxed/simple;
	bh=LLRvg0iUED/aIFxj6zs9Muwv+nu3tq3MNlxb+KxsVNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FwlzKgGm2beh/RbjtYmf/ncy4J0T07X8/2uwW/aSYz7jFziSQaAl7Me9A12MfKrQctj+RJR1lQ4GDdAqKplhIpRDlxDQCEJ2I+4g3/HTTlORiommhrE1JvSh+LX7yGVA/LfME/xQ724SIvHJb7m0NgaaBsOKvuV38X2Yo6xavS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xI9fzQjh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xI9fzQjh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3D96C4CEE5;
	Tue,  8 Apr 2025 12:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115204;
	bh=LLRvg0iUED/aIFxj6zs9Muwv+nu3tq3MNlxb+KxsVNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xI9fzQjhue1LwCmwjZpA69UfQWJP1YOHT0n8l7xl0PiRJgENVCnue0mwTHrGN4Dbl
	 cljCguaJEuiPzaGU8hY4Jco76qFCcZ/LXAUNRFpvtb5IGFOKtCDuElqspB+uW742IT
	 p4sSaF5sAuZflSvsA3zuXHgoSEDlbWazQLDvfr4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+fae49d997eb56fa7c74d@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 389/499] sctp: add mutual exclusion in proc_sctp_do_udp_port()
Date: Tue,  8 Apr 2025 12:50:01 +0200
Message-ID: <20250408104900.930512319@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 10206302af856791fbcc27a33ed3c3eb09b2793d ]

We must serialize calls to sctp_udp_sock_stop() and sctp_udp_sock_start()
or risk a crash as syzbot reported:

Oops: general protection fault, probably for non-canonical address 0xdffffc000000000d: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000068-0x000000000000006f]
CPU: 1 UID: 0 PID: 6551 Comm: syz.1.44 Not tainted 6.14.0-syzkaller-g7f2ff7b62617 #0 PREEMPT(full)
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2025
 RIP: 0010:kernel_sock_shutdown+0x47/0x70 net/socket.c:3653
Call Trace:
 <TASK>
  udp_tunnel_sock_release+0x68/0x80 net/ipv4/udp_tunnel_core.c:181
  sctp_udp_sock_stop+0x71/0x160 net/sctp/protocol.c:930
  proc_sctp_do_udp_port+0x264/0x450 net/sctp/sysctl.c:553
  proc_sys_call_handler+0x3d0/0x5b0 fs/proc/proc_sysctl.c:601
  iter_file_splice_write+0x91c/0x1150 fs/splice.c:738
  do_splice_from fs/splice.c:935 [inline]
  direct_splice_actor+0x18f/0x6c0 fs/splice.c:1158
  splice_direct_to_actor+0x342/0xa30 fs/splice.c:1102
  do_splice_direct_actor fs/splice.c:1201 [inline]
  do_splice_direct+0x174/0x240 fs/splice.c:1227
  do_sendfile+0xafd/0xe50 fs/read_write.c:1368
  __do_sys_sendfile64 fs/read_write.c:1429 [inline]
  __se_sys_sendfile64 fs/read_write.c:1415 [inline]
  __x64_sys_sendfile64+0x1d8/0x220 fs/read_write.c:1415
  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]

Fixes: 046c052b475e ("sctp: enable udp tunneling socks")
Reported-by: syzbot+fae49d997eb56fa7c74d@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/67ea5c01.050a0220.1547ec.012b.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20250331091532.224982-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/sysctl.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
index 8e1e97be4df79..ee3eac338a9de 100644
--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -525,6 +525,8 @@ static int proc_sctp_do_auth(const struct ctl_table *ctl, int write,
 	return ret;
 }
 
+static DEFINE_MUTEX(sctp_sysctl_mutex);
+
 static int proc_sctp_do_udp_port(const struct ctl_table *ctl, int write,
 				 void *buffer, size_t *lenp, loff_t *ppos)
 {
@@ -549,6 +551,7 @@ static int proc_sctp_do_udp_port(const struct ctl_table *ctl, int write,
 		if (new_value > max || new_value < min)
 			return -EINVAL;
 
+		mutex_lock(&sctp_sysctl_mutex);
 		net->sctp.udp_port = new_value;
 		sctp_udp_sock_stop(net);
 		if (new_value) {
@@ -561,6 +564,7 @@ static int proc_sctp_do_udp_port(const struct ctl_table *ctl, int write,
 		lock_sock(sk);
 		sctp_sk(sk)->udp_port = htons(net->sctp.udp_port);
 		release_sock(sk);
+		mutex_unlock(&sctp_sysctl_mutex);
 	}
 
 	return ret;
-- 
2.39.5



