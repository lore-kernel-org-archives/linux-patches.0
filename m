Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021900;
	b=FX2yzqs8z+oGxfPVztEJDguCnuwgdOiiizm7d1zWBZMs56P5JMaZWxjbeAfP38hiZjR2
	 2BPTV6yYh2UpHSO5kzwe8iYexmJ2vK69sUF10X6sMn81zMSngqOe7/CaA7faIBqkqdDib
	 nKNEXdg38dDmLF1MNw0ttZ0ZoZ6x42lQLe9g6Q7+W5S5llhUKx5ychQsHUTr5sR4Fs0Mk
	 6igNaY9n6rSWb7R859fmtBsnA8tk35KmZw7ihW04SKv2NBizFqUoEJrCts0dAEdRATEE/
	 bVnJlkRZj6UuvlqvAkG9XuUuImuc9xuX2XwPbiBInFqrP6QCbxsHIW/y2HZPkdY4pzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021900;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4+OIOobbhIJ9T30csvtwpqwe19I7MiVZ5w4lWBLXz9g=;
	b=RuCtK2gmWNT51YdzLdddFZSqNpefDyLwNidU5bQN2LOgg7mYc/CY/DVm6G5Hrs2JVSqm
	 ndBUOWaftQaMCl+zAPcrIf4d13m3e5iLoMRMVDTAxJoG6jk5n2+R6YoSIPd7QcKiTFgTQ
	 CcFjIGaSEKbEBDNGPAEihhLz9PxGHXokclpoTsjT8bHYSfGuBvPEHH55WsMQszdCg1GDd
	 fE4FUI11y8lpryMD+VpHvkW8EZt1kgcWX+BlpXQ2zQlNPCr2pfU4AjZkKgjj7wc2aFL3j
	 QIin2cCvuBp+CRCXxD7CWrf2+tixsPHsGK26GSDkWgns7s52l7MOXyJUtI2MFAdTnXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0v4pNVds;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3511F606A320;
	Wed, 18 Nov 2026 17:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0v4pNVds
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83A1B1F000C4;
	Wed, 18 Nov 2026 17:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021900;
	bh=4+OIOobbhIJ9T30csvtwpqwe19I7MiVZ5w4lWBLXz9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0v4pNVdsWaCLoI7aBCDEaIjCrI61DAIdN6wPpZrt4WcMKZb+NsuQ1wB2kXLGrGHxD
	 PxlQHpZNSzNXMzvpGGkoRHivjaCHT6MlKfHNry2rAeb/Umg2iJA9C9MPTyn+R8Rl4q
	 6XgAAAE7DHZA0NmUTSSsEZLCVPtwU7gDdWOiaVmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Eric Dumazet <edumazet@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2471/2651] pppoe: wait for RCU readers before reusing a socket
Date: Wed, 18 Nov 2026 16:01:51 +0100
Message-ID: <20261118150413.946464605@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index bdaa8cf8404ba..9edf8151bd7d1 100644
--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -621,6 +621,10 @@ static int pppoe_connect(struct socket *sock, struct sockaddr_unsized *uservaddr
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



