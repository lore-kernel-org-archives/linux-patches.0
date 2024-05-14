Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510C21386D5;
	Tue, 14 May 2024 10:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683049; cv=none; b=X9I6YCXt/k0+D9Lg327BV2babHOPu0P9ZI9iPCYnImKzYiwno2VdNlGx84ITO1AQITG9YGnnqvfGsYRaA5UQJFaxRjq0HxN/AB+RZBt4dyHzz+lz/BBIQRC3gdCng8yd3hbuni3EynqOl5KE2KXPw2SoIT2CcF14ru6f9dkzKvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683049; c=relaxed/simple;
	bh=5WQEMFit5RSKZwJV0r5IN6rwcudOVZbfE3Su6QbCKFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i/0UeLpNpOyu0Kfd4JHnWeyNmHXCp7l60RH5Mq/POZWvPHcPUNKrm6utv5SZNsDb6aIS4ZRgSM5MI4gKTezvPAsKsrPEvbXLuB1eO+1sgXDptu7u/HUc0VEW2bCet/LY47tcU4xUM7rGWtfexF/QMBQ4iMKFBgHO8jmYFPSIUdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MELlfpXQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MELlfpXQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C33AC2BD10;
	Tue, 14 May 2024 10:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683049;
	bh=5WQEMFit5RSKZwJV0r5IN6rwcudOVZbfE3Su6QbCKFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MELlfpXQdJSzniNH7bjPB0mWwkVCSmbDGjGqzh/C+MnXmDqbl9+SPSPMnMPZ0P/9Z
	 L+zxRN1j7CCTiMU0Izv6662kGPmQUsn5hMEDQ2uQ2vVupNAr8htqduibLysGcH45Li
	 23Iszivjs7LNM2BjlhWHWFofUdHvdaQTfUtu8mnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	syzbot <syzkaller@googlegroups.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 158/336] nfc: llcp: fix nfc_llcp_setsockopt() unsafe copies
Date: Tue, 14 May 2024 12:16:02 +0200
Message-ID: <20240514101044.568808418@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
---
 net/nfc/llcp_sock.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
index 819157bbb5a2c..d5344563e525c 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -252,10 +252,10 @@ static int nfc_llcp_setsockopt(struct socket *sock, int level, int optname,
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
@@ -274,10 +274,10 @@ static int nfc_llcp_setsockopt(struct socket *sock, int level, int optname,
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
-- 
2.43.0



