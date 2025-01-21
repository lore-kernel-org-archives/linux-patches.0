Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8041F76BE;
	Tue, 21 Jan 2025 17:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482160; cv=none; b=BhhbzsyuvDEykS/G49K1lRmTu9BNS5G9USUUNE2IYBei28m6K0/3PrmqzglXkQ1qaAORi6IaC+9cxPjYJLdVXoqXDCvyO2dXyFwrQLhVEBeQddhoCFHptmjP2t6OWrl5DvaLjVcoRWBBa8DTXT8T00fBoH/dH/6IdsGiDpxeZ6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482160; c=relaxed/simple;
	bh=6SnpA3vxnod8s10e47B4ZgBZgPrbCEeqhdvmH/IIYfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OvimwrkCeMHyKoRfwEjgvS2jwnpHL4TxzYcsCVa7Hq++uIyKDq8R7Lpq38LPhdP9Do6ctCNlK5Hv5OWUQGW3FGTio/C6Kzq9QbWlNQvPE3A81UtcwuNtRBtZmmAM0I8TSTC03n9M9EV7xzP4+uYLAmzrUg3sX6HNlGTXpcuz2uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WNa4/DtP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WNa4/DtP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A8BCC4CEE8;
	Tue, 21 Jan 2025 17:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482160;
	bh=6SnpA3vxnod8s10e47B4ZgBZgPrbCEeqhdvmH/IIYfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WNa4/DtPNHIDFt2xLILSuY5EbkxH02vC2D+SUC1BCWc4DKlKuN+NkT9Pz/rE87X61
	 1o0+kOfpl9lBT4xog5hsWCYeiu7KrYlAhT32NTkGl9wupzi+KHGC1BprY06bL9DSwF
	 3x9t75r+bKJ6Ub3TpKqBkDSySrdtgQ/OvEHottdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Shin <jaeshin@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 24/72] smb: client: fix double free of TCP_Server_Info::hostname
Date: Tue, 21 Jan 2025 18:51:50 +0100
Message-ID: <20250121174524.355766853@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174523.429119852@linuxfoundation.org>
References: <20250121174523.429119852@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit fa2f9906a7b333ba757a7dbae0713d8a5396186e ]

When shutting down the server in cifs_put_tcp_session(), cifsd thread
might be reconnecting to multiple DFS targets before it realizes it
should exit the loop, so @server->hostname can't be freed as long as
cifsd thread isn't done.  Otherwise the following can happen:

  RIP: 0010:__slab_free+0x223/0x3c0
  Code: 5e 41 5f c3 cc cc cc cc 4c 89 de 4c 89 cf 44 89 44 24 08 4c 89
  1c 24 e8 fb cf 8e 00 44 8b 44 24 08 4c 8b 1c 24 e9 5f fe ff ff <0f>
  0b 41 f7 45 08 00 0d 21 00 0f 85 2d ff ff ff e9 1f ff ff ff 80
  RSP: 0018:ffffb26180dbfd08 EFLAGS: 00010246
  RAX: ffff8ea34728e510 RBX: ffff8ea34728e500 RCX: 0000000000800068
  RDX: 0000000000800068 RSI: 0000000000000000 RDI: ffff8ea340042400
  RBP: ffffe112041ca380 R08: 0000000000000001 R09: 0000000000000000
  R10: 6170732e31303000 R11: 70726f632e786563 R12: ffff8ea34728e500
  R13: ffff8ea340042400 R14: ffff8ea34728e500 R15: 0000000000800068
  FS: 0000000000000000(0000) GS:ffff8ea66fd80000(0000)
  000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007ffc25376080 CR3: 000000012a2ba001 CR4:
  PKRU: 55555554
  Call Trace:
   <TASK>
   ? show_trace_log_lvl+0x1c4/0x2df
   ? show_trace_log_lvl+0x1c4/0x2df
   ? __reconnect_target_unlocked+0x3e/0x160 [cifs]
   ? __die_body.cold+0x8/0xd
   ? die+0x2b/0x50
   ? do_trap+0xce/0x120
   ? __slab_free+0x223/0x3c0
   ? do_error_trap+0x65/0x80
   ? __slab_free+0x223/0x3c0
   ? exc_invalid_op+0x4e/0x70
   ? __slab_free+0x223/0x3c0
   ? asm_exc_invalid_op+0x16/0x20
   ? __slab_free+0x223/0x3c0
   ? extract_hostname+0x5c/0xa0 [cifs]
   ? extract_hostname+0x5c/0xa0 [cifs]
   ? __kmalloc+0x4b/0x140
   __reconnect_target_unlocked+0x3e/0x160 [cifs]
   reconnect_dfs_server+0x145/0x430 [cifs]
   cifs_handle_standard+0x1ad/0x1d0 [cifs]
   cifs_demultiplex_thread+0x592/0x730 [cifs]
   ? __pfx_cifs_demultiplex_thread+0x10/0x10 [cifs]
   kthread+0xdd/0x100
   ? __pfx_kthread+0x10/0x10
   ret_from_fork+0x29/0x50
   </TASK>

Fixes: 7be3248f3139 ("cifs: To match file servers, make sure the server hostname matches")
Reported-by: Jay Shin <jaeshin@redhat.com>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/connect.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 20f303f2a5d75..dbcaaa274abdb 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1061,6 +1061,7 @@ clean_demultiplex_info(struct TCP_Server_Info *server)
 	/* Release netns reference for this server. */
 	put_net(cifs_net_ns(server));
 	kfree(server->leaf_fullpath);
+	kfree(server->hostname);
 	kfree(server);
 
 	length = atomic_dec_return(&tcpSesAllocCount);
@@ -1684,8 +1685,6 @@ cifs_put_tcp_session(struct TCP_Server_Info *server, int from_reconnect)
 	kfree_sensitive(server->session_key.response);
 	server->session_key.response = NULL;
 	server->session_key.len = 0;
-	kfree(server->hostname);
-	server->hostname = NULL;
 
 	task = xchg(&server->tsk, NULL);
 	if (task)
-- 
2.39.5



