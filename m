Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0807BAFB;
	Wed, 21 Feb 2024 13:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523014; cv=none; b=cxsnS8N6MYwYrqbTDPWz8Nd+JSlUsScH2pXV7t0f4yR1mJzyMFjSesETCCEbbUg+sT8KMy8r3TuaD94OaQblfnja0A82gWdbsmH+1KFPUAnlkevnJP+a9NdrsMaNmeIJ+CCeh+VIqKZ6qZ7aCYpm691oRHDmANqjyhax2Lu6oKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523014; c=relaxed/simple;
	bh=L8qt/g2W3Q+2A13ev7QbCYw9iEJBXlM8peRMy6917wQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CeDHyMr3Q1TGSRowbSWUso9TK+XoKyXHMrLsBOnVcxcweoXZ8NBS6XAWXqRHBp5QRQZ9i/maSB4KpKC+tc5bSiP2f+8lV5Iv0SC2eB9L9R/T5Icgq7oQfc3bekzzW++qZBOylTSY/7NwtybxH5cqdl5wirTzdHBvRu6L4hwP7ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2YfdFExY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2YfdFExY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56F9EC433C7;
	Wed, 21 Feb 2024 13:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523013;
	bh=L8qt/g2W3Q+2A13ev7QbCYw9iEJBXlM8peRMy6917wQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2YfdFExYTzSmJlCJWRm0fg2mz6zQQRu/PyayxOCWkNRfiPa5W3uT0vYQgmjyO1sCb
	 iQV1f2HB2Ccylwj8MXC0Qpz8cVl50mCfxx4pcx77elKNRE6KS7NTSSQgS1v7aY6Q7O
	 FzDMYrW6Un/q9gpvBGU1c8+cN8wtOHvIgyZZ72BM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shigeru Yoshida <syoshida@redhat.com>,
	Tung Nguyen <tung.q.nguyen@dektech.com.au>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+5142b87a9abc510e14fa@syzkaller.appspotmail.com
Subject: [PATCH 5.15 315/476] tipc: Check the bearer type before calling tipc_udp_nl_bearer_add()
Date: Wed, 21 Feb 2024 14:06:06 +0100
Message-ID: <20240221130019.665028677@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

From: Shigeru Yoshida <syoshida@redhat.com>

[ Upstream commit 3871aa01e1a779d866fa9dfdd5a836f342f4eb87 ]

syzbot reported the following general protection fault [1]:

general protection fault, probably for non-canonical address 0xdffffc0000000010: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000080-0x0000000000000087]
...
RIP: 0010:tipc_udp_is_known_peer+0x9c/0x250 net/tipc/udp_media.c:291
...
Call Trace:
 <TASK>
 tipc_udp_nl_bearer_add+0x212/0x2f0 net/tipc/udp_media.c:646
 tipc_nl_bearer_add+0x21e/0x360 net/tipc/bearer.c:1089
 genl_family_rcv_msg_doit+0x1fc/0x2e0 net/netlink/genetlink.c:972
 genl_family_rcv_msg net/netlink/genetlink.c:1052 [inline]
 genl_rcv_msg+0x561/0x800 net/netlink/genetlink.c:1067
 netlink_rcv_skb+0x16b/0x440 net/netlink/af_netlink.c:2544
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1076
 netlink_unicast_kernel net/netlink/af_netlink.c:1341 [inline]
 netlink_unicast+0x53b/0x810 net/netlink/af_netlink.c:1367
 netlink_sendmsg+0x8b7/0xd70 net/netlink/af_netlink.c:1909
 sock_sendmsg_nosec net/socket.c:730 [inline]
 __sock_sendmsg+0xd5/0x180 net/socket.c:745
 ____sys_sendmsg+0x6ac/0x940 net/socket.c:2584
 ___sys_sendmsg+0x135/0x1d0 net/socket.c:2638
 __sys_sendmsg+0x117/0x1e0 net/socket.c:2667
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0x40/0x110 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x63/0x6b

The cause of this issue is that when tipc_nl_bearer_add() is called with
the TIPC_NLA_BEARER_UDP_OPTS attribute, tipc_udp_nl_bearer_add() is called
even if the bearer is not UDP.

tipc_udp_is_known_peer() called by tipc_udp_nl_bearer_add() assumes that
the media_ptr field of the tipc_bearer has an udp_bearer type object, so
the function goes crazy for non-UDP bearers.

This patch fixes the issue by checking the bearer type before calling
tipc_udp_nl_bearer_add() in tipc_nl_bearer_add().

Fixes: ef20cd4dd163 ("tipc: introduce UDP replicast")
Reported-and-tested-by: syzbot+5142b87a9abc510e14fa@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5142b87a9abc510e14fa [1]
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
Reviewed-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
Link: https://lore.kernel.org/r/20240131152310.4089541-1-syoshida@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/bearer.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
index dcbae29aa7e0..17e8e6e3670a 100644
--- a/net/tipc/bearer.c
+++ b/net/tipc/bearer.c
@@ -1088,6 +1088,12 @@ int tipc_nl_bearer_add(struct sk_buff *skb, struct genl_info *info)
 
 #ifdef CONFIG_TIPC_MEDIA_UDP
 	if (attrs[TIPC_NLA_BEARER_UDP_OPTS]) {
+		if (b->media->type_id != TIPC_MEDIA_TYPE_UDP) {
+			rtnl_unlock();
+			NL_SET_ERR_MSG(info->extack, "UDP option is unsupported");
+			return -EINVAL;
+		}
+
 		err = tipc_udp_nl_bearer_add(b,
 					     attrs[TIPC_NLA_BEARER_UDP_OPTS]);
 		if (err) {
-- 
2.43.0



