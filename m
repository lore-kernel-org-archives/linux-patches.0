Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E9C051B16C;
	Wed, 30 Sep 2026 16:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785018; cv=none; b=Lfd6uNw5hevIsZBx/e09O0m8HNhJaiQYEAb8JUCd/dJ1LfPgjC+by1lu3Bw7vg5soMoUO1gSJLtR4k7qyqd5odrlPRmnlY5LwSwhb7xe9EYRCtiaxYSQ3Lh+2QyLEtGzEp4/xbtwF7cqnOMeAh+I81zEzXO5KYuxTtuWY42KYhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785018; c=relaxed/simple;
	bh=tUTlzy/z8yPVzqkfxgGW2BIBFNbDZ/wiwDe7jNKq9Is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jV5B5jYZ7MuDhxjZ2C4J0K39eDn+lOFyK7Cnkfsht0ZMdNGdE+FlOLvR9CTNmMaQLOvg60AhuRrF4P/j8V7oy+ce2CIbDIWR4F2jjvUb1+20Q9kxkCRLWwt84TUuC0L2OpteJ2NjQrGkaU3bYOag/ldv4JJIzg9F5irie8SHRqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HUWRpAB8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HUWRpAB8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F37441F000FF;
	Wed, 30 Sep 2026 16:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785011;
	bh=P4mb0VJz/eYkRLif1xAJ8y6+JlG5iGVfxzK+Vv4a5Vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HUWRpAB8T03QRcdunY143oDnobRpYt8pwkanTpYt7X/7Vg5LkPXaAVRIGRsqzms7D
	 rDT4/Un/lSCYTywMzYWlUuYJPqzLiuy8UdYaFP83swHSlI/3+0h8DZxt7C1ZmImPP1
	 kEeaG1EFpnXwAFY0asJ2sOj4ZO0lP0/b8sHxuPRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+73df3f89e1e13089e466@syzkaller.appspotmail.com,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 359/982] af_packet: Dont cast tpacket_hdr.tp_len to int in tpacket_parse_header().
Date: Wed, 30 Sep 2026 17:18:15 +0200
Message-ID: <20260930152424.524415869@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 73e594c19b4f815d8343461cec7074c4713bbde7 ]

syzbot reported BUG() in sock_sendmsg_nosec(). [0]

The problem is that tpacket_parse_header() casts user-provided
tpacket_hdr.tp_len, which is u32, to int.

If the length is larger than INT_MAX, the following condition
in tpacket_parse_header() passes,

  if (unlikely(tp_len > size_max))

and any negative value can be returned to the caller, up to
sock_sendmsg_nosec().

The repro set tpacket_hdr.tp_len to 0xfffffdef, which is cast
to -EIOCBQUEUED (-529), triggering BUG() in sock_sendmsg_nosec().

  *(uint64_t*)0x200000000008 = 0xfffffdef;
  ...
  syscall(__NR_write, /*fd=*/r[0], /*buf=*/0x200000000000ul, /*count=*/1ul);

Let's define the local tp_len as u32 in tpacket_parse_header().

[0]:
kernel BUG at net/socket.c:803!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 0 UID: 0 PID: 5628 Comm: syz-executor176 Not tainted syzkaller #0 PREEMPT(full)
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
RIP: 0010:sock_sendmsg_nosec+0x145/0x180 net/socket.c:803
Code: 06 67 48 0f b9 3a eb 95 e8 e8 3a 22 f8 48 89 df 4c 89 f6 4c 89 e2 4d 89 fb 2e e8 32 a5 5c 16 e9 51 ff ff ff e8 cc 3a 22 f8 90 <0f> 0b e8 c4 3a 22 f8 48 83 c3 18 48 89 d8 48 c1 e8 03 42 80 3c 28
RSP: 0018:ffffc90003aefb48 EFLAGS: 00010293
RAX: ffffffff89a578d4 RBX: ffff8880764c67c0 RCX: ffff88807fb23e80
RDX: 0000000000000000 RSI: 00000000fffffdef RDI: 00000000fffffdef
RBP: 00000000fffffdef R08: ffffc90003aef747 R09: 1ffff9200075dee8
R10: dffffc0000000000 R11: fffff5200075dee9 R12: 0000000000000001
R13: dffffc0000000000 R14: ffffc90003aefbc0 R15: ffffffff8aac4310
FS:  000055559101b400(0000) GS:ffff888124ce0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000210 CR3: 0000000073dca000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 __sock_sendmsg net/socket.c:815 [inline]
 sock_write_iter+0x2de/0x3e0 net/socket.c:1266
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x612/0xba0 fs/read_write.c:687
 ksys_write+0x150/0x270 fs/read_write.c:739
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f173130ecb9
Code: c0 79 93 eb d5 48 8d 7c 1d 00 eb 99 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 d8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd67e44248 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000200000000000 RCX: 00007f173130ecb9
RDX: 0000000000000001 RSI: 0000200000000000 RDI: 0000000000000003
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffd67e44388
R13: 0000000000000002 R14: 00002000000000c0 R15: 0000000000000002
 </TASK>

Fixes: 69e3c75f4d54 ("net: TX_RING and packet mmap")
Reported-by: syzbot+73df3f89e1e13089e466@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6a946ffa.1d9ded08.62e62.0123.GAE@google.com/
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260830180915.260225-1-kuniyu@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/packet/af_packet.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 538fc4075292d..b0588d3e2e51c 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2723,7 +2723,8 @@ static int tpacket_parse_header(struct packet_sock *po, void *frame,
 				int size_max, void **data)
 {
 	union tpacket_uhdr ph;
-	int tp_len, off;
+	u32 tp_len;
+	int off;
 
 	ph.raw = frame;
 
@@ -2743,7 +2744,7 @@ static int tpacket_parse_header(struct packet_sock *po, void *frame,
 		break;
 	}
 	if (unlikely(tp_len > size_max)) {
-		pr_err("packet size is too long (%d > %d)\n", tp_len, size_max);
+		pr_err("packet size is too long (%u > %d)\n", tp_len, size_max);
 		return -EMSGSIZE;
 	}
 
-- 
2.53.0



