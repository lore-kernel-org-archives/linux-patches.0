Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027587;
	b=MjTfV7n1sBkc4nYQOa3I0RwT3FzWTROR13nXVky5O5OjGkF5okG+JsPbiVz3KwsRenB6
	 ZnRsa3mb7dQdrDcWxxoV6uqTd3hkPBncR7GxLIAKSVO3j4Y+FsxT5vtD7TFky/riSb8Tc
	 G1H2r9miTHp4oR8RZQ6N4pT4dblpP0vUEhrD8vyyLF9LarZBZYMgxilkforSN2DAzbWmX
	 uMMs4gCQHrtNNAscABHiaahMpbU3+omVI6/30I+pAiGkHwXNkHebq0ADsOKgtkhl3jaM3
	 fzUGxoMBiL3/a5Bm+RBE9l0XCOp1imtYiXx9NCcWeAiLxRXlraHKVMyGmrZkuksh1KQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027587;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T2NGYTNBeiAa5ldYv+0evm1Mw9wkuW2OfiWixsdrNx8=;
	b=FE258Kkz7hthHKi5XBXeoLlfN6XyltuGcOOT4uoBl3mwcy2WxfJLJuWnoCTQXyiXTDsY
	 ib7YC1WzOE2ImtEsxAhXg2SM2fS0tFmN5XBxMzSnIjTI1nbIL1P65HGnyBM2hM87wfRWt
	 GvxT7qNLPPS0Rb0+eMuNx7PmFfzSCIEvbijLFNgmrq+8W+zKqkddKTJKkqKDhl58zpbDK
	 7qBCzo/YAwHd2uSqeK31emqPTxR1IR+OrjNPnJ4H4tWVf3j8lzx/vBw7W8UZxciZdbkqj
	 p3W/g+ao889JF2cMuYGHECxoBg0zCIG9vlLyRHJf4xsgebJFdfYXCzHZ2nva8MFz13A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=htIaob3M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D646606A336;
	Wed, 18 Nov 2026 18:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=htIaob3M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF991F000C4;
	Wed, 18 Nov 2026 18:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027587;
	bh=T2NGYTNBeiAa5ldYv+0evm1Mw9wkuW2OfiWixsdrNx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=htIaob3MVq/QFqdNaT1keIl6R9xCYqgyx+kMzFh2gvaWDpgTMKHbrrIu4hHmmV0ia
	 tFOwZyMmX7vi6wzPARSx1SAmykP0UgEJNn0kgC20ZMk7Osti0SAeEZTVJnz6kljTzg
	 qKU20LOiucEWPVBXW+FgBitMo2vyZ0J5FDyE0AlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot+sashiko@kernel.org>,
	Henry Hu <huhai@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1842/2151] ksmbd: fix iface_list use-after-free during server reset
Date: Wed, 18 Nov 2026 15:59:37 +0100
Message-ID: <20261118150228.897440423@linuxfoundation.org>
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
index 8fe04c03ce586..83ccf9224d555 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -658,10 +658,15 @@ static void ksmbd_tcp_stop_listener(struct interface *iface)
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



