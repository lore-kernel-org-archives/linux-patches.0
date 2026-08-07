Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2106E41836D;
	Fri,  7 Aug 2026 15:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115677; cv=none; b=hcyGMAlgNGBpqvLJkW9T8kIzNxkaYwdsnJRdxoUqEeV6Sk9pQaJJi+T1RaZP1pJ+69k05FF0O66wEsdgrF7wLec856fIDyfSwK2hv8qUBhsn6C3P53/rT3u/SwAh2yDaKO7XBVznU/OREcpmlaPz1HTBo/vXviUJaxOiOGAIWd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115677; c=relaxed/simple;
	bh=HBm/Z3WAEBJoe1CeIA4cLh+kw+xtkD0R70QkeNX/DGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=McvIqN3x6OheF+I9VXOLRXEah5oNXXXUDM39Zq4QiL8Z1IKGmx2hmXVqRHge4prhabYgTU0bcjg8FFmrWqMVQC//9jRRRpWeJH7MO5zs08qz5B1U//etl/tetv1KO03F+luW/3jQpU+/xXtlTgFR0kZ2Hu+1Gf4wKWvO3hictdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DLCgcrI3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DLCgcrI3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FDD11F000E9;
	Fri,  7 Aug 2026 15:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115676;
	bh=QDJdq9MzJpaDl/4yBW524S53ldYnh+S/4xmkSjOypZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DLCgcrI30YJfEsLvWpRcl2+1aUkNg+ySFPNSEK3IJJyG5qdidvi1FXZNiy23ve+WK
	 w4/ph4Yp9bn2UHCBt4Hvy0Dt+lVEHj/bakoKA1PojFzeRVBxOzT8cwBGlF7cpM1d5v
	 bkIs95DhF7OEWaHsyvJmJvfA0Ca1+hpRxVBjzhrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Wang Liang <wangliang74@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Wentao Guan <guanwentao@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 359/396] net/handshake: Fix null-ptr-deref in handshake_complete()
Date: Fri,  7 Aug 2026 16:38:39 +0200
Message-ID: <20260807143432.029181773@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Liang <wangliang74@huawei.com>

[ Upstream commit dabac51b8102e1643d8e297a8e6948dab190aa4c ]

A null pointer dereference in handshake_complete() was observed [1].

When handshake_req_next() return NULL in handshake_nl_accept_doit(),
function handshake_complete() will be called unexpectedly which triggers
this crash. Fix it by goto out_status when req is NULL.

[1]
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000005: 0000 [#1] SMP KASAN PTI
RIP: 0010:handshake_complete+0x36/0x2b0 net/handshake/request.c:288
Call Trace:
 <TASK>
 handshake_nl_accept_doit+0x32d/0x7e0 net/handshake/netlink.c:129
 genl_family_rcv_msg_doit+0x204/0x300 net/netlink/genetlink.c:1115
 genl_family_rcv_msg+0x436/0x670 net/netlink/genetlink.c:1195
 genl_rcv_msg+0xcc/0x170 net/netlink/genetlink.c:1210
 netlink_rcv_skb+0x14c/0x430 net/netlink/af_netlink.c:2550
 genl_rcv+0x2d/0x40 net/netlink/genetlink.c:1219
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x878/0xb20 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x897/0xd70 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg net/socket.c:742 [inline]
 ____sys_sendmsg+0xa39/0xbf0 net/socket.c:2592
 ___sys_sendmsg+0x121/0x1c0 net/socket.c:2646
 __sys_sendmsg+0x155/0x200 net/socket.c:2678
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x5f/0x350 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
 </TASK>

Fixes: fe67b063f687 ("net/handshake: convert handshake_nl_accept_doit() to FD_PREPARE()")
Reviewed-by: Chuck Lever <chuck.lever@oracle.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/kernel-tls-handshake/aScekpuOYHRM9uOd@morisot.1015granger.net/T/#m7cfa5c11efc626d77622b2981591197a2acdd65e
Signed-off-by: Wang Liang <wangliang74@huawei.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20251212012723.4111831-1-wangliang74@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>

(cherry picked from commit dabac51b8102e1643d8e297a8e6948dab190aa4c)
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/handshake/netlink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/handshake/netlink.c b/net/handshake/netlink.c
index 7b1d42607ae68..039344979de93 100644
--- a/net/handshake/netlink.c
+++ b/net/handshake/netlink.c
@@ -126,7 +126,8 @@ int handshake_nl_accept_doit(struct sk_buff *skb, struct genl_info *info)
 	}
 
 out_complete:
-	handshake_complete(req, -EIO, NULL);
+	if (req)
+		handshake_complete(req, -EIO, NULL);
 out_status:
 	trace_handshake_cmd_accept_err(net, req, NULL, err);
 	return err;
-- 
2.53.0



