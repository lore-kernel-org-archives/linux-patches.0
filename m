Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E701DDCE;
	Tue, 16 Jul 2024 16:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146188; cv=none; b=hVPx+0ZL+t17K8w3W1zjBjK/5i5b/PpjoHLMsB/7smCIEFS1bC7XMWH5TDJoT22BccYwO3ApkhuwCmaeB/a6F4GX9GoPJ4U7tSJYvoyN2qG0eBDMHWiYJyqknEoJlJR07W/mJgm1n5Jy/Rv5pYTOMGafTt1Ad2X/pUptP4BKICs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146188; c=relaxed/simple;
	bh=f0u+gmIvfJpm776shrMwlGPuV9/7noZHjfWNHxKClZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W6N15HqS8OjKMGKhYmhES1oU3hR2PSnHdcYqUDtOq3hzWuIcMyjNXNDD0HPrj+TPulia5PadPmLmQu4MuiFGzg9U1saykbw5in1AFMsFIZKl20N9zCgbqelUzPpLtPoUh5Qib63LMr8fRNOxwy/JEBkPUmzwTBd7bE/3KDd/0lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UXraQsp6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UXraQsp6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC1DAC116B1;
	Tue, 16 Jul 2024 16:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146188;
	bh=f0u+gmIvfJpm776shrMwlGPuV9/7noZHjfWNHxKClZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UXraQsp61sNUO1MtaZfuegmBG8sDMn4uvxkWzfwph2zYOF44M3Whgk268tFTOe4jN
	 8Pem+lb9yVVF6vpD2kKzet4VkMdjFx04vbgksD3aCQUlqPNW1xUDaoswZRSF69QFlW
	 FELWZUQUkYlQ1qFUuokLakEGlDcsMOmAdW2SK/R0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Fastabend <john.fastabend@gmail.com>,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 084/144] skmsg: Skip zero length skb in sk_msg_recvmsg
Date: Tue, 16 Jul 2024 17:32:33 +0200
Message-ID: <20240716152755.771777197@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <tanggeliang@kylinos.cn>

[ Upstream commit f0c18025693707ec344a70b6887f7450bf4c826b ]

When running BPF selftests (./test_progs -t sockmap_basic) on a Loongarch
platform, the following kernel panic occurs:

  [...]
  Oops[#1]:
  CPU: 22 PID: 2824 Comm: test_progs Tainted: G           OE  6.10.0-rc2+ #18
  Hardware name: LOONGSON Dabieshan/Loongson-TC542F0, BIOS Loongson-UDK2018
     ... ...
     ra: 90000000048bf6c0 sk_msg_recvmsg+0x120/0x560
    ERA: 9000000004162774 copy_page_to_iter+0x74/0x1c0
   CRMD: 000000b0 (PLV0 -IE -DA +PG DACF=CC DACM=CC -WE)
   PRMD: 0000000c (PPLV0 +PIE +PWE)
   EUEN: 00000007 (+FPE +SXE +ASXE -BTE)
   ECFG: 00071c1d (LIE=0,2-4,10-12 VS=7)
  ESTAT: 00010000 [PIL] (IS= ECode=1 EsubCode=0)
   BADV: 0000000000000040
   PRID: 0014c011 (Loongson-64bit, Loongson-3C5000)
  Modules linked in: bpf_testmod(OE) xt_CHECKSUM xt_MASQUERADE xt_conntrack
  Process test_progs (pid: 2824, threadinfo=0000000000863a31, task=...)
  Stack : ...
  Call Trace:
  [<9000000004162774>] copy_page_to_iter+0x74/0x1c0
  [<90000000048bf6c0>] sk_msg_recvmsg+0x120/0x560
  [<90000000049f2b90>] tcp_bpf_recvmsg_parser+0x170/0x4e0
  [<90000000049aae34>] inet_recvmsg+0x54/0x100
  [<900000000481ad5c>] sock_recvmsg+0x7c/0xe0
  [<900000000481e1a8>] __sys_recvfrom+0x108/0x1c0
  [<900000000481e27c>] sys_recvfrom+0x1c/0x40
  [<9000000004c076ec>] do_syscall+0x8c/0xc0
  [<9000000003731da4>] handle_syscall+0xc4/0x160
  Code: ...
  ---[ end trace 0000000000000000 ]---
  Kernel panic - not syncing: Fatal exception
  Kernel relocated by 0x3510000
   .text @ 0x9000000003710000
   .data @ 0x9000000004d70000
   .bss  @ 0x9000000006469400
  ---[ end Kernel panic - not syncing: Fatal exception ]---
  [...]

This crash happens every time when running sockmap_skb_verdict_shutdown
subtest in sockmap_basic.

This crash is because a NULL pointer is passed to page_address() in the
sk_msg_recvmsg(). Due to the different implementations depending on the
architecture, page_address(NULL) will trigger a panic on Loongarch
platform but not on x86 platform. So this bug was hidden on x86 platform
for a while, but now it is exposed on Loongarch platform. The root cause
is that a zero length skb (skb->len == 0) was put on the queue.

This zero length skb is a TCP FIN packet, which was sent by shutdown(),
invoked in test_sockmap_skb_verdict_shutdown():

	shutdown(p1, SHUT_WR);

In this case, in sk_psock_skb_ingress_enqueue(), num_sge is zero, and no
page is put to this sge (see sg_set_page in sg_set_page), but this empty
sge is queued into ingress_msg list.

And in sk_msg_recvmsg(), this empty sge is used, and a NULL page is got by
sg_page(sge). Pass this NULL page to copy_page_to_iter(), which passes it
to kmap_local_page() and to page_address(), then kernel panics.

To solve this, we should skip this zero length skb. So in sk_msg_recvmsg(),
if copy is zero, that means it's a zero length skb, skip invoking
copy_page_to_iter(). We are using the EFAULT return triggered by
copy_page_to_iter to check for is_fin in tcp_bpf.c.

Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
Suggested-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/e3a16eacdc6740658ee02a33489b1b9d4912f378.1719992715.git.tanggeliang@kylinos.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skmsg.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index ec8671eccae0c..84824f715a2d1 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -434,7 +434,8 @@ int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
 			page = sg_page(sge);
 			if (copied + copy > len)
 				copy = len - copied;
-			copy = copy_page_to_iter(page, sge->offset, copy, iter);
+			if (copy)
+				copy = copy_page_to_iter(page, sge->offset, copy, iter);
 			if (!copy) {
 				copied = copied ? copied : -EFAULT;
 				goto out;
-- 
2.43.0



