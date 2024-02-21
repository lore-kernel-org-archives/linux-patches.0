Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FCAC7641B;
	Wed, 21 Feb 2024 13:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521597; cv=none; b=jAnNjtwydKmHYSRp6dnkwCvLWY8jmaxa2XSFcwkD8ZqPXx2fqkUgS+FY+dxN172/h9XiW6ADGZi+JVNOcCBVtMhtc0n+dr0GS9Uc1Y96ooFIR5cRu5Ac2VcK4yM4mwGGQ3c/ar+EmBFbO23OlPxt4xuvcSZqQ2pfRXgmSkg5qkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521597; c=relaxed/simple;
	bh=w61/3o8sf/Yvo80GqiDjhjFWs+G12o2XJTDNpYLtFwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CjjIl7l+pYzozZ+/upFzy/KGv5Zvb6JEApmQThDASqbvOPyPcCupnQX7Cf23Ly/ktYL6LkX26W/QzSy64pBdhT94pUFsBeBx/mDysE0v4i6JPCumM/8EvIMXFxuFv5sZ9LZTwFQF5h7l/BS787FPFXrxWnmjGV3uRPw5+gJIq68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Z9kup1v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Z9kup1v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B572EC433F1;
	Wed, 21 Feb 2024 13:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521597;
	bh=w61/3o8sf/Yvo80GqiDjhjFWs+G12o2XJTDNpYLtFwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Z9kup1vzPNNBiSwxYQXcDB1tNIUFmDebXCbIiWKtMWIwHwRXisBtAZ2d7eeLSAz/
	 OXeV67ojtrDWxCIT9AYbmC+tX7j81TPaUUU7l8Ti/tLIvn4GzWId1vK1ZVA9yh5Eaf
	 kic5LUPtDqhEt69lsAlpvEsQaMUg+gN9L8LuZL04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shigeru Yoshida <syoshida@redhat.com>,
	Tung Nguyen <tung.q.nguyen@dektech.com.au>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+5142b87a9abc510e14fa@syzkaller.appspotmail.com
Subject: [PATCH 4.19 154/202] tipc: Check the bearer type before calling tipc_udp_nl_bearer_add()
Date: Wed, 21 Feb 2024 14:07:35 +0100
Message-ID: <20240221125936.669144685@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 4353968bc5a5..c7686ff00f5b 100644
--- a/net/tipc/bearer.c
+++ b/net/tipc/bearer.c
@@ -958,6 +958,12 @@ int tipc_nl_bearer_add(struct sk_buff *skb, struct genl_info *info)
 
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



