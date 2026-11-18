Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021365;
	b=vnpjbhlvUpVvvbFkQCjagb8G89gHbEtlmAhNOdh7hCWTFqLLBgbZ632N72U4exFtLMYW
	 st2IRc5U4GqsK8Yv6cNZZ+uX4E7GcXIO6Z4oeCWUHGgx7Np+WeB2ZM7jnue9CVtZrmho2
	 lcV7E7qOMaSsAUyYsTn1vmBXgpmZh9Qfa6sA8xd2jWBuLFZTUarmw9copC7zHRPT4yBmP
	 fkoc9hTJb9cuXdHvqA0tMqnjDjVg+LhaxmHpAGlyKLTAI172HVvaZLrLid2OjGzEF9utD
	 DYNG6tPzB3ZP0mS9J5iw+6oJXUoGyoDEDZKkelV8oNJ2ojI3hprYJ+f1waZbm7U58dA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021365;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=edEmiaiwrYcNyqD1zhDLMOz+yPqlV/3wc+qPfOSDAc4=;
	b=oGtZh7w6IK4b/IDicyG/dZqd5vrnRQmNQZOBOVigMPqPJ9hv6I/QyzD2PK+uCdXzMPT0
	 qK8ojtk/NGjQUVKJNsvNeq/Cm6YQtRy26cccqVChK0Kg8y9hOgiJjgTiYjKcdmf9Wh6j8
	 g9vySx9AHW9NwTQ8INZs846GxUDtQnYLj1kHL43jj7ql19RJqMRrHq2wqc3IJE2gqc6oF
	 bSoeUfWuni7vBllQ+TYeLe0xaGkl17UgNKJ5pRtaFWqkh5VCLoJQL/gBWJNSC36jkNyn+
	 STirs9qsF9XN31i7h4kiqyPuaOwXpK4HYfzILZZadYgtgAYKzZsIuJmcEIDYhDqgqaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qumDdcSW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11D5606A31C;
	Wed, 18 Nov 2026 17:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qumDdcSW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92BF1F000C4;
	Wed, 18 Nov 2026 17:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021364;
	bh=edEmiaiwrYcNyqD1zhDLMOz+yPqlV/3wc+qPfOSDAc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qumDdcSWHKTqcEt5KaOyIwWvFf5IIPSDj4Wz9OzDbBifzeYgLq0VBOE2jri/tnVL0
	 gtfIZqee1tWDJIgyAUsNBn24pS1aQrzB6w5t3i9vnfo/lqlviCGSYlHtrkDa1lBJZ0
	 o+evkw+LInoAs94fqVEkYB1/CxhWiVfx9MCiR2DA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot+sashiko@kernel.org>,
	Henry Hu <huhai@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2282/2651] ksmbd: fix iface_list use-after-free during server reset
Date: Wed, 18 Nov 2026 15:58:42 +0100
Message-ID: <20261118150407.460266176@linuxfoundation.org>
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

From: Henry Hu <huhai@kylinos.cn>

[ Upstream commit d34d38ab0c62fe4eb9e746420c554e6d0e6f54db ]

ksmbd_find_netdev_name_iface_list() walks iface_list for
fsctl_query_iface_info_ioctl(), which holds RTNL. But during server
reset, ksmbd_tcp_destroy() unlinks and frees the entries without RTNL,
and queued SMB requests can still be running at that point. So an
FSCTL_QUERY_NETWORK_INTERFACE_INFO request can therefore race with
interface destruction and dereference a freed entry. With debug-only
instrumentation to make the race deterministic, KASAN reports:

   BUG: KASAN: slab-use-after-free in
   ksmbd_find_netdev_name_iface_list

   ksmbd_find_netdev_name_iface_list
   fsctl_query_iface_info_ioctl
   smb2_ioctl
   handle_ksmbd_work

   Freed by:
   kfree
   ksmbd_tcp_destroy
   ksmbd_conn_transport_destroy
   kill_server_store

The fix is to detach iface_list to a temporary list under RTNL, then drop
RTNL before cleanup because the following cleanup may block and hold RTNL
for a long time.

Fixes: b2d99376c5d6 ("ksmbd: browse interfaces list on FSCTL_QUERY_INTERFACE_INFO IOCTL")
Reported-by: Sashiko <sashiko-bot+sashiko@kernel.org>
Link: https://sashiko.dev/#/patchset/20260911163516.6403-1-15815827059%40163.com
Assisted-by: LLM
Signed-off-by: Henry Hu <huhai@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/transport_tcp.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index af3b6a01862ba..7492aa08f9f31 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -945,10 +945,15 @@ static void ksmbd_tcp_stop_listener(struct interface *iface)
 void ksmbd_tcp_destroy(void)
 {
 	struct interface *iface, *tmp;
+	LIST_HEAD(iface_list_to_free);
 
 	unregister_netdevice_notifier(&ksmbd_netdev_notifier);
 
-	list_for_each_entry_safe(iface, tmp, &iface_list, entry) {
+	rtnl_lock();
+	list_splice_init(&iface_list, &iface_list_to_free);
+	rtnl_unlock();
+
+	list_for_each_entry_safe(iface, tmp, &iface_list_to_free, entry) {
 		ksmbd_tcp_stop_listener(iface);
 		list_del(&iface->entry);
 		kfree(iface->name);
-- 
2.53.0



