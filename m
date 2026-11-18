Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028020;
	b=e5EmQASZs4+Vpx5i+AhTXxpGhR2LsVrUN/cf9byk+fvY1clf2W+A9qq9c7WzHRXnjlJA
	 JeWbO1MDJHvFzc00QMxwXbIHwYHQvV/TyaC6i0NU+XKa24WJCvPCQiKhk30/1LaJCefGf
	 PQUz0SrMbZXQYNDpJLpZ+5ih1A2uoD99RY4N5nomZ+a6ycWqfwpMfk0Iy46tmy+velrcC
	 r42E2Lv217W5p41ZM4ZPTh2TbbODVU5PI5BX8zJGBav5JpZNjMsaCege1IQ6W1ttW7aUg
	 dISB+g5RsRjZoDQeWkquqEfZ2UDik5YiXtTQpCuDkIhLT5kirnNRiHwh6woz2cWGgEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028020;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Sicotqzp6eCygj/FmZMdefybp/dA4IKtWwZOxwmgXfo=;
	b=GVLZcDuvHfZIlYRE2O+ixvHVLLUrRGSFeHJnQsYBKeFcOxNTsL7s9N0FQObR3RJgkoer
	 odxRRzwU6HLtPBGtsp/UcCxE5OgpGiQ+xJu8g7Strl/6nnMP6y6qNgGNMeW+OBOAJgPzw
	 PDQg6HDTvUrSJ5jy3qzEKhQcw9oI7BuTb+RFfBPRZX/1XFgOOKe92+AG6NTswsOFPg4Tp
	 geUc03Lwp+EvUpVRWhRH122ssZiiBOszk+2TuI9242F4lCfVKUQs7r6aGU5edmJ8W3Ypf
	 n5t/ifquX68ichXd7EGOxrelxx/A/rbR23URdQDaKeAgL0KO6qRUxxHOv5sXy3GLEwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=llfOdo3U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E07F6606A31C;
	Wed, 18 Nov 2026 18:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=llfOdo3U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41FE31F000C4;
	Wed, 18 Nov 2026 18:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028019;
	bh=Sicotqzp6eCygj/FmZMdefybp/dA4IKtWwZOxwmgXfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=llfOdo3UR7GVdsx/jBBHxaDRe11t8BsXQZQuIi5rtEm6/J3dSukLBpzBGFThDNiG7
	 HqiNniqSPh3Lgp5b1FolWVD08gfxGMpx1zqTwfYUAKlqRqGHEAQCZeij5Z7rypTBGf
	 oZcRTYxNlA8xXkO2HLa5r4aCFjPN70PTDzWEAkY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Eric Dumazet <edumazet@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1994/2151] pppoe: wait for RCU readers before reusing a socket
Date: Wed, 18 Nov 2026 16:02:09 +0100
Message-ID: <20261118150234.362419966@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qingfang Deng <qingfang.deng@linux.dev>

[ Upstream commit e7b01bc0202a57f1b7dcdf19b2ffab6b781d47f8 ]

When pppoe_connect() disconnects or reuses a socket, it removes the old
session from the hash table and resets the socket's fields. An RCU
reader that reached the entry before it was unlinked can still be using
its address, ifindex or next pointer.

If sockets A and B share a hash bucket with A preceding B, a concurrent
__get_item() looking for B can be traversing A when it is removed.
Clearing A->next then makes the lookup miss B and drop the packet.
Reinserting A can similarly redirect the reader into another hash chain.

Call synchronize_net() after unlinking the old session and before
clearing its fields. This allows existing receive-path and
/proc/net/pppoe readers to finish before the socket is cleared or reused.

This was found by Sashiko's static analysis, and reproduced on a VM
stress test with KCSAN.

 BUG: KCSAN: data-race in hash_item+0x1c/0x60

 race at unknown origin, with read to 0xffff888000a1c566 of 2 bytes by task 147 on cpu 2:
  hash_item+0x1c/0x60
  pppoe_seq_next+0x112/0x1b0
  seq_read_iter+0x595/0x700
  seq_read+0xb0/0xe0
  proc_reg_read+0xd0/0xf0
  vfs_read+0xbd/0x220
  ksys_read+0xa9/0x100
  __x64_sys_read+0x47/0x60
  x64_sys_call+0x98/0x1fd0
  do_syscall_64+0x5b/0x260
  entry_SYSCALL_64_after_hwframe+0x4b/0x53

 value changed: 0x0002 -> 0x0000

Fixes: 72cdc67e7fa7 ("pppoe: remove rwlock usage")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261020092118.47416-1-qingfang.deng@linux.dev
Signed-off-by: Qingfang Deng <qingfang.deng@linux.dev>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/20261026061300.256009-1-qingfang.deng@linux.dev
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ppp/pppoe.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
index f6ae4d8d84b0f..c666c1635c353 100644
--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -653,6 +653,10 @@ static int pppoe_connect(struct socket *sock, struct sockaddr *uservaddr,
 		pppox_unbind_sock(sk);
 		pn = pppoe_pernet(sock_net(sk));
 		delete_item(pn, po);
+
+		/* wait for concurrent readers before clearing the fields */
+		synchronize_net();
+
 		if (po->pppoe_dev) {
 			dev_put(po->pppoe_dev);
 			po->pppoe_dev = NULL;
-- 
2.53.0



