Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1609C4F68C6;
	Tue, 13 Oct 2026 12:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895416; cv=none; b=k8tlEew5Pg3MfLjois9lmRsYMkZH7x1mxkYvl5yr6G3A5+xz2GSze6uFIGIa6tsohDETcY22b+R+hlfiVTOW3/otMryOFucMGne1ZSKoNPpISkF7+pQ/lAkLois7bXZH/JPQxlIEFbQBdbWx1hctx3JpKAxUCSanv5zp7NoGv4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895416; c=relaxed/simple;
	bh=PHUSCefAkQKoEoN2KOZgchrc6zxPy04clEFzwWn8jHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m/459uQTQoh6nZVkbjZhlnHlqHCTS0RZjfQsUUQgQgqorl6Arh4xt2mLur5mlQ9qVjA+q8xuwj0QhQeED3P2SiI25z1IbozuXDBVnQqNCSnjx0IHi325KF+9kKBkN5goFY+hmbOYHj+O1MWFBVlJw/zEFwHhaAUf2A2vRcHgi+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d9vHmCBt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d9vHmCBt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BDB11F000FF;
	Tue, 13 Oct 2026 12:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895414;
	bh=9ynoXGJJIfBPOpoKhuOO2GFhWyV3OMWvpJoMr1W+jcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d9vHmCBt93LRjfikXfaWrMxeuksfBlMn2ywyLBpDcYMo0aY4ytyXqlLd5/iAJqJfh
	 ypFKyY4YWLkTwHqQKgjaUuxaT6HQxYsK6FlIB8B0NQ4X11KjK+OscEyxalDYaJIlIL
	 RGzXoJnikZoWk/y4LnI4a36X2V5UQ7i8wxtQSXto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 265/497] pfcp: fix socket lifetime on netdevice registration failure
Date: Tue, 13 Oct 2026 13:37:12 +0200
Message-ID: <20261013112914.181021396@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

[ Upstream commit 0f17d2e3dd9cda3ee6d94033d5e5489af168920d ]

pfcp_newlink() creates the UDP socket before register_netdevice().
If registration fails after pfcp_dev_init() succeeds, the core calls
pfcp_dev_uninit(), which releases the socket and clears pfcp->sk.
The newlink error path then releases it again, causing a NULL pointer
dereference. This was observed with failslab fault injection:

  FAULT_INJECTION: forcing a failure.
  kobject: kobject_add_internal failed for pfcp0 (error: -12 parent: net)
  BUG: KASAN: null-ptr-deref in udp_tunnel_sock_release+0x1c/0x50
  Read of size 8 at addr 0000000000000120 by task ip/1037
  Call trace:
   show_stack+0x18/0x24 (C)
   dump_stack_lvl+0x78/0x90
   print_report+0x468/0x5cc
   kasan_report+0xa4/0xf0
   __asan_load8+0x7c/0xd0
   udp_tunnel_sock_release+0x1c/0x50
   pfcp_newlink+0x128/0x184
   rtnl_newlink+0x848/0xe44
   rtnetlink_rcv_msg+0x468/0x514
   netlink_rcv_skb+0xc0/0x1f0
   rtnetlink_rcv+0x18/0x24
   netlink_unicast+0x4b8/0x558
   netlink_sendmsg+0x2b8/0x584
   ...

Return from pfcp_del_sock() if pfcp->sk is NULL.

Fixes: 76c8764ef36a5 ("pfcp: add PFCP module")
Cc: stable@vger.kernel.org
Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260924055252.33488-1-xuanqiang.luo@linux.dev
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ sashal: Adapted the socket null check from pfcp->sk to pfcp->sock. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/pfcp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/pfcp.c b/drivers/net/pfcp.c
index b07517d4fe2db..01dbdcbcdc64d 100644
--- a/drivers/net/pfcp.c
+++ b/drivers/net/pfcp.c
@@ -104,6 +104,9 @@ static int pfcp_encap_recv(struct sock *sk, struct sk_buff *skb)
 
 static void pfcp_del_sock(struct pfcp_dev *pfcp)
 {
+	if (!pfcp->sock)
+		return;
+
 	udp_tunnel_sock_release(pfcp->sock);
 	pfcp->sock = NULL;
 }
-- 
2.53.0



