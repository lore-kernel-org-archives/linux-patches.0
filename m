Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED16219303;
	Sat, 30 May 2026 18:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165473; cv=none; b=dQrUqo8c4HbH5AfHWgTOddyctr9N31CWuZIkCKlrO9Fx00NAn+M1juP1vr0ne6/TqPXT6XD+mNx9Xxdl7hrW9NuW8xvjx2Eviv1itU0ySkKeaAZwA/fwsBwN4Q8ZeVTVwpNwO8uretmu7Bh8lNepMvuIJ51Y3JDtJ8NbXdZO0p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165473; c=relaxed/simple;
	bh=jvv+EeKZepKh06hqNqNYqecilCxWPxxpj1W2vd/UYtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UhfumEOwa/O0KD+PsIbaKKsjwRY/nOVBeDcs4TykykFObz9F+Di4Looipm9hi0vAN1X+VIsAVrhyXNrzQ/DGlk1/at2ShKS036BgV76Q+/xQO5edWi4oXIEbAHZaK1Rmr0X8w8JmTCd78xLSp2fcnoqwQ9OxFf9+DZUNj3h0Ivg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NhtDSyZ4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NhtDSyZ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 017351F00893;
	Sat, 30 May 2026 18:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165472;
	bh=a9D/h0iRtZRgJmssc+P/t40FcUGAfPgrGgPG4TINKBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NhtDSyZ4bwY3sEK17e8kx1uk/9bA6Vt9Cqvw8KZcghRkc32T4xn4Glejmjiqkm9fs
	 vssJUHZrzRadiYXSN8x458Ck4YG9R87LqdD4A1tkOjrzerW8KvgQFN1Fsrt1yze+LE
	 pWPXzZ7xL+FqhC3tyLdHO546v1IO26M5rE3pDr+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Jian <liujian56@huawei.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 088/589] bpf, sockmap: Fix an infinite loop error when len is 0 in tcp_bpf_recvmsg_parser()
Date: Sat, 30 May 2026 17:59:29 +0200
Message-ID: <20260530160226.995489697@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Jian <liujian56@huawei.com>

commit d900f3d20cc3169ce42ec72acc850e662a4d4db2 upstream.

When the buffer length of the recvmsg system call is 0, we got the
flollowing soft lockup problem:

watchdog: BUG: soft lockup - CPU#3 stuck for 27s! [a.out:6149]
CPU: 3 PID: 6149 Comm: a.out Kdump: loaded Not tainted 6.2.0+ #30
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1 04/01/2014
RIP: 0010:remove_wait_queue+0xb/0xc0
Code: 5e 41 5f c3 cc cc cc cc 0f 1f 80 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 0f 1f 44 00 00 41 57 <41> 56 41 55 41 54 55 48 89 fd 53 48 89 f3 4c 8d 6b 18 4c 8d 73 20
RSP: 0018:ffff88811b5978b8 EFLAGS: 00000246
RAX: 0000000000000000 RBX: ffff88811a7d3780 RCX: ffffffffb7a4d768
RDX: dffffc0000000000 RSI: ffff88811b597908 RDI: ffff888115408040
RBP: 1ffff110236b2f1b R08: 0000000000000000 R09: ffff88811a7d37e7
R10: ffffed10234fa6fc R11: 0000000000000001 R12: ffff88811179b800
R13: 0000000000000001 R14: ffff88811a7d38a8 R15: ffff88811a7d37e0
FS:  00007f6fb5398740(0000) GS:ffff888237180000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000000 CR3: 000000010b6ba002 CR4: 0000000000370ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 tcp_msg_wait_data+0x279/0x2f0
 tcp_bpf_recvmsg_parser+0x3c6/0x490
 inet_recvmsg+0x280/0x290
 sock_recvmsg+0xfc/0x120
 ____sys_recvmsg+0x160/0x3d0
 ___sys_recvmsg+0xf0/0x180
 __sys_recvmsg+0xea/0x1a0
 do_syscall_64+0x3f/0x90
 entry_SYSCALL_64_after_hwframe+0x72/0xdc

The logic in tcp_bpf_recvmsg_parser is as follows:

msg_bytes_ready:
	copied = sk_msg_recvmsg(sk, psock, msg, len, flags);
	if (!copied) {
		wait data;
		goto msg_bytes_ready;
	}

In this case, "copied" always is 0, the infinite loop occurs.

According to the Linux system call man page, 0 should be returned in this
case. Therefore, in tcp_bpf_recvmsg_parser(), if the length is 0, directly
return. Also modify several other functions with the same problem.

Fixes: 1f5be6b3b063 ("udp: Implement udp_bpf_recvmsg() for sockmap")
Fixes: 9825d866ce0d ("af_unix: Implement unix_dgram_bpf_recvmsg()")
Fixes: c5d2177a72a1 ("bpf, sockmap: Fix race in ingress receive verdict with redirect to self")
Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: Liu Jian <liujian56@huawei.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/bpf/20230303080946.1146638-1-liujian56@huawei.com
[ kovalev: bp to fix CVE-2023-53133; applied only to tcp_bpf_recvmsg as the
  older kernel lacks tcp_bpf_recvmsg_parser, udp_bpf_recvmsg and
  unix_bpf_recvmsg (see upstream commits c5d2177a72a1, 1f5be6b3b063 and
  9825d866ce0d) ]
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_bpf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index bcd5fc484f777..76cd974887774 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -277,6 +277,9 @@ static int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	if (unlikely(flags & MSG_ERRQUEUE))
 		return inet_recv_error(sk, msg, len, addr_len);
 
+	if (!len)
+		return 0;
+
 	psock = sk_psock_get(sk);
 	if (unlikely(!psock))
 		return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
-- 
2.53.0



