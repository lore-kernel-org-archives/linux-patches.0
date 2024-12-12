Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0185A223E69;
	Thu, 12 Dec 2024 17:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025614; cv=none; b=hMVu8yLIt1HYpG/F0MbRmLkJOvoFbM1XoHBAuPSFmlItlBNnl/AhYWZx841cpzyNkE7GXCWbcdmyC5hE78009AW1OH4n9b+GLHQn+pSFayX3vxeoQDxf+BebTJas8JlngJa6S/2bVbXqDhQ9I3HO4B2lTKxmOFW3FsxCl8yV7DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025614; c=relaxed/simple;
	bh=4WIXS27e7dcO08HI7B4MQagWKAAC29aCtvByWSTQpYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TkhyA2pKmVDgaYeMGz+I0ExKId5zPVt3jHZ1W/u2JNGRQOLISSV9xqgdF4a5l8SIqBgaqAhE9DoPw7hdAHbMBZN/PXkPTp2ELLIKWu/HDjQTYuUPKmhLlwU+BQaaow7rv08m0GWkRDKW1x+U89Z9fU81h82gtJFBm6G8C90nTvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zl+Xfw14; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zl+Xfw14"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83281C4CECE;
	Thu, 12 Dec 2024 17:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025613;
	bh=4WIXS27e7dcO08HI7B4MQagWKAAC29aCtvByWSTQpYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zl+Xfw14s/q6wzzXZCn7BO75iz33ht7nuBdoK6+WPfGpfh2iBv9RpjVGf9dfwC98J
	 /hjsjxkcS5nXNlLo2hDxqs+mWx1aNU6Z6SHxwHSMe+mwpG97OBzEhQZ+WBPviEO7dl
	 ucEU2/42y+E01+4v09AbeDv99W5xRaH86gmll7gM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Solodovnikov <solodovnikov.ia@phystech.edu>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 228/321] dccp: Fix memory leak in dccp_feat_change_recv
Date: Thu, 12 Dec 2024 16:02:26 +0100
Message-ID: <20241212144238.984118894@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 9c3b5e0562342..7647306802f1e 100644
--- a/net/dccp/feat.c
+++ b/net/dccp/feat.c
@@ -1156,8 +1156,12 @@ static u8 dccp_feat_change_recv(struct list_head *fn, u8 is_mandatory, u8 opt,
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



