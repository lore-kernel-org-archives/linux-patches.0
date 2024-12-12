Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F314D1487CD;
	Thu, 12 Dec 2024 17:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023097; cv=none; b=HDpLS+nn9cMop5IOkneOc/C5GoE3vxYheB8B/WQL+nsSe5O34ugP9O3I/B0xsD9a89U3QQCryDqZ6opN+WRETmWQJo6q/hov9w657K3p84txrjnSZwzSomDfBAEQ2l5LWxg6wsr5xtug3lqRqRm0wgVJS9+47+HkYpUJJ73hH4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023097; c=relaxed/simple;
	bh=eKei7FCmYqXXTGok65qM6gt48Mc9NBwZRXoDAAIWJ5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rrilzTLWcBCFcCWIP+SeA7QiaCyQbZGEygO04ydXnBXhqBVGabidR3n1waCNo/YRREms3Y6W5u5icBGiRPx+aD2mBizQY3intOhMIknyC8xA8SBnIvncxV1sYj2YhWuQA7n7GEC34m4As2mwadw+MTzKOuJ8OdTJ4qSI6fJjbcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M6tsipaP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M6tsipaP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7687DC4CECE;
	Thu, 12 Dec 2024 17:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023096;
	bh=eKei7FCmYqXXTGok65qM6gt48Mc9NBwZRXoDAAIWJ5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M6tsipaPQlwaHhg9JYbrQLBZW/w9HCvbViberrZWOSJP8x4ixTpKhF6LUqLrWfC53
	 2cmj+bJggo+uRbstUGTntscrP3oCkexlHqeXx6Vkwr+vMec4iNBUyngczxBNXiPeVG
	 2bRnvJUT3nkWPRgDPvnSxY0WI/3I1YvXsxyZyq+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Solodovnikov <solodovnikov.ia@phystech.edu>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 415/565] dccp: Fix memory leak in dccp_feat_change_recv
Date: Thu, 12 Dec 2024 16:00:10 +0100
Message-ID: <20241212144328.063139978@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

From: Ivan Solodovnikov <solodovnikov.ia@phystech.edu>

[ Upstream commit 22be4727a8f898442066bcac34f8a1ad0bc72e14 ]

If dccp_feat_push_confirm() fails after new value for SP feature was accepted
without reconciliation ('entry == NULL' branch), memory allocated for that value
with dccp_feat_clone_sp_val() is never freed.

Here is the kmemleak stack for this:

unreferenced object 0xffff88801d4ab488 (size 8):
  comm "syz-executor310", pid 1127, jiffies 4295085598 (age 41.666s)
  hex dump (first 8 bytes):
    01 b4 4a 1d 80 88 ff ff                          ..J.....
  backtrace:
    [<00000000db7cabfe>] kmemdup+0x23/0x50 mm/util.c:128
    [<0000000019b38405>] kmemdup include/linux/string.h:465 [inline]
    [<0000000019b38405>] dccp_feat_clone_sp_val net/dccp/feat.c:371 [inline]
    [<0000000019b38405>] dccp_feat_clone_sp_val net/dccp/feat.c:367 [inline]
    [<0000000019b38405>] dccp_feat_change_recv net/dccp/feat.c:1145 [inline]
    [<0000000019b38405>] dccp_feat_parse_options+0x1196/0x2180 net/dccp/feat.c:1416
    [<00000000b1f6d94a>] dccp_parse_options+0xa2a/0x1260 net/dccp/options.c:125
    [<0000000030d7b621>] dccp_rcv_state_process+0x197/0x13d0 net/dccp/input.c:650
    [<000000001f74c72e>] dccp_v4_do_rcv+0xf9/0x1a0 net/dccp/ipv4.c:688
    [<00000000a6c24128>] sk_backlog_rcv include/net/sock.h:1041 [inline]
    [<00000000a6c24128>] __release_sock+0x139/0x3b0 net/core/sock.c:2570
    [<00000000cf1f3a53>] release_sock+0x54/0x1b0 net/core/sock.c:3111
    [<000000008422fa23>] inet_wait_for_connect net/ipv4/af_inet.c:603 [inline]
    [<000000008422fa23>] __inet_stream_connect+0x5d0/0xf70 net/ipv4/af_inet.c:696
    [<0000000015b6f64d>] inet_stream_connect+0x53/0xa0 net/ipv4/af_inet.c:735
    [<0000000010122488>] __sys_connect_file+0x15c/0x1a0 net/socket.c:1865
    [<00000000b4b70023>] __sys_connect+0x165/0x1a0 net/socket.c:1882
    [<00000000f4cb3815>] __do_sys_connect net/socket.c:1892 [inline]
    [<00000000f4cb3815>] __se_sys_connect net/socket.c:1889 [inline]
    [<00000000f4cb3815>] __x64_sys_connect+0x6e/0xb0 net/socket.c:1889
    [<00000000e7b1e839>] do_syscall_64+0x33/0x40 arch/x86/entry/common.c:46
    [<0000000055e91434>] entry_SYSCALL_64_after_hwframe+0x67/0xd1

Clean up the allocated memory in case of dccp_feat_push_confirm() failure
and bail out with an error reset code.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: e77b8363b2ea ("dccp: Process incoming Change feature-negotiation options")
Signed-off-by: Ivan Solodovnikov <solodovnikov.ia@phystech.edu>
Link: https://patch.msgid.link/20241126143902.190853-1-solodovnikov.ia@phystech.edu
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dccp/feat.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/dccp/feat.c b/net/dccp/feat.c
index 54086bb05c42c..f7554dcdaaba9 100644
--- a/net/dccp/feat.c
+++ b/net/dccp/feat.c
@@ -1166,8 +1166,12 @@ static u8 dccp_feat_change_recv(struct list_head *fn, u8 is_mandatory, u8 opt,
 			goto not_valid_or_not_known;
 		}
 
-		return dccp_feat_push_confirm(fn, feat, local, &fval);
+		if (dccp_feat_push_confirm(fn, feat, local, &fval)) {
+			kfree(fval.sp.vec);
+			return DCCP_RESET_CODE_TOO_BUSY;
+		}
 
+		return 0;
 	} else if (entry->state == FEAT_UNSTABLE) {	/* 6.6.2 */
 		return 0;
 	}
-- 
2.43.0



