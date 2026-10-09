Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C6E4E9C14;
	Fri,  9 Oct 2026 14:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557079; cv=none; b=UAsnn9lijuviy01r5plp78rBJKpajC0ARGm+h4bJ6RTQiFt4xMVwC3p8tzKeaYfy6YgoPTRLPaqS7xWrZ6OIL7FvAyg+wlA74QsnmP2K0qSo0vQikcKpDxE0dEhQDcQfDnWIs+Jr+HHKD0LSN2tyZIhqbrMBQon8haKEWBWO0vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557079; c=relaxed/simple;
	bh=pQH70aXqNVgix5RSew4ELqiGz2E8KeAEKm+aUcGPcdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dMFj7J28OIpgSl4c3no47gtceLmUh0Y0qndfUEcuPnwPWJoGLJ2BtymXeHzin/49WGx8r6PTZdo3RwyMSIqhBd6Vuj9nyDc3Fcs0xG2eb4O8NXK8ddXOPic282MZbjHKVkeHLc1+DKShtAlJNbstz/4u9nOCQwAQG0X1Pf52QQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fEIah/JQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fEIah/JQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF5DB1F000FF;
	Fri,  9 Oct 2026 14:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557078;
	bh=0N/czZAAOFB0ZhzOUot7P6PlGiQX+0s4BhtlEDmQnMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fEIah/JQg9UD1Zw18pPGqDWaEGjSwYQu5zLVJn/LiJjaCn/3m6jekEvWI/CGmzgsv
	 kYly/9siXU1quyYg+82xUjbd5ISkfUKGVjFvRA6A+InswF1fuUkGGboiEHlvKuH0db
	 pBR1+UwpidqZQ1Bif1N2UfxjmUQuC0gAT1Az0+RA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 343/403] pfcp: fix socket lifetime on netdevice registration failure
Date: Fri,  9 Oct 2026 16:11:44 +0200
Message-ID: <20261009141000.287134369@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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
[ sashal: Changed the NULL check from pfcp->sk to pfcp->sock. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/pfcp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/pfcp.c b/drivers/net/pfcp.c
index a6aa30ae0af76..c1c8eaea63fc3 100644
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



