Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FD71BE870;
	Wed, 20 Nov 2024 13:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107697; cv=none; b=h903eH1PWa1rg0aILnCQirE3Hy96fNljfu8EVWHO4vyl9KN2C0lN0Kez/coOHarq6l3yy1GX8/Nh7D5w4/eDTKp1XEfBhzcNytYiXuhzlgkaqsChQVm85/8oJCsX2z/1MNrk0iOkdpqFaL4fQUTM7pGPZ7hM15Y7NMZ/k3vJuNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107697; c=relaxed/simple;
	bh=WbA83DzP4mf8rrRpr63FQ6q7pVtjmuMz0OgaUxpzP1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ksATtQk+hC8a8LmZ1/qCuhZzz+dsVrPvuznztPCPvu3TOrN1nJWgLRzDV1KR7k38ngmA2EfZ24YSAw6pig39bAaptJbOqiOvXy8sDUuJnFl7Rvpy3yOBL2Idc0gi3mMtUkAqPyUSFT6BZTqhzJQ0ohjA2bNr5tRY4cdhXCEVUr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vRGG9LLF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vRGG9LLF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 190ACC4CECD;
	Wed, 20 Nov 2024 13:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107697;
	bh=WbA83DzP4mf8rrRpr63FQ6q7pVtjmuMz0OgaUxpzP1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vRGG9LLFZpBFbTxFvtNzpDZsmb3nDKrIargowpDiGdm4MAhTFvHnn70GmTnnVJH7W
	 rFobrXedCGjg1qf/YMxt8P82OBXlkrQSVlnYBaqrCZJaCNarc2KugkagV4GhYxUufQ
	 khmpai7TeAGTwx0nDA1xIRl+6bAqZk8CjI+WkMyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	syzbot <syzkaller@googlegroups.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Xiangyu Chen <xiangyu.chen@windriver.com>
Subject: [PATCH 6.1 56/73] nfc: llcp: fix nfc_llcp_setsockopt() unsafe copies
Date: Wed, 20 Nov 2024 13:58:42 +0100
Message-ID: <20241120125810.957785477@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
References: <20241120125809.623237564@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 7a87441c9651ba37842f4809224aca13a554a26f ]

syzbot reported unsafe calls to copy_from_sockptr() [1]

Use copy_safe_from_sockptr() instead.

[1]

BUG: KASAN: slab-out-of-bounds in copy_from_sockptr_offset include/linux/sockptr.h:49 [inline]
 BUG: KASAN: slab-out-of-bounds in copy_from_sockptr include/linux/sockptr.h:55 [inline]
 BUG: KASAN: slab-out-of-bounds in nfc_llcp_setsockopt+0x6c2/0x850 net/nfc/llcp_sock.c:255
Read of size 4 at addr ffff88801caa1ec3 by task syz-executor459/5078

CPU: 0 PID: 5078 Comm: syz-executor459 Not tainted 6.8.0-syzkaller-08951-gfe46a7dd189e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/27/2024
Call Trace:
 <TASK>
  __dump_stack lib/dump_stack.c:88 [inline]
  dump_stack_lvl+0x241/0x360 lib/dump_stack.c:114
  print_address_description mm/kasan/report.c:377 [inline]
  print_report+0x169/0x550 mm/kasan/report.c:488
  kasan_report+0x143/0x180 mm/kasan/report.c:601
  copy_from_sockptr_offset include/linux/sockptr.h:49 [inline]
  copy_from_sockptr include/linux/sockptr.h:55 [inline]
  nfc_llcp_setsockopt+0x6c2/0x850 net/nfc/llcp_sock.c:255
  do_sock_setsockopt+0x3b1/0x720 net/socket.c:2311
  __sys_setsockopt+0x1ae/0x250 net/socket.c:2334
  __do_sys_setsockopt net/socket.c:2343 [inline]
  __se_sys_setsockopt net/socket.c:2340 [inline]
  __x64_sys_setsockopt+0xb5/0xd0 net/socket.c:2340
 do_syscall_64+0xfd/0x240
 entry_SYSCALL_64_after_hwframe+0x6d/0x75
RIP: 0033:0x7f7fac07fd89
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 91 18 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff660eb788 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f7fac07fd89
RDX: 0000000000000000 RSI: 0000000000000118 RDI: 0000000000000004
RBP: 0000000000000000 R08: 0000000000000002 R09: 0000000000000000
R10: 0000000020000a80 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20240408082845.3957374-4-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Xiangyu Chen <xiangyu.chen@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/llcp_sock.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -252,10 +252,10 @@ static int nfc_llcp_setsockopt(struct so
 			break;
 		}
 
-		if (copy_from_sockptr(&opt, optval, sizeof(u32))) {
-			err = -EFAULT;
+		err = copy_safe_from_sockptr(&opt, sizeof(opt),
+					     optval, optlen);
+		if (err)
 			break;
-		}
 
 		if (opt > LLCP_MAX_RW) {
 			err = -EINVAL;
@@ -274,10 +274,10 @@ static int nfc_llcp_setsockopt(struct so
 			break;
 		}
 
-		if (copy_from_sockptr(&opt, optval, sizeof(u32))) {
-			err = -EFAULT;
+		err = copy_safe_from_sockptr(&opt, sizeof(opt),
+					     optval, optlen);
+		if (err)
 			break;
-		}
 
 		if (opt > LLCP_MAX_MIUX) {
 			err = -EINVAL;


