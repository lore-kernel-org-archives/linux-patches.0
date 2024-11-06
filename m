Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538F01CC89D;
	Wed,  6 Nov 2024 13:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898882; cv=none; b=H64lOwWYKUrd2h9P00m+7cRx/Uuo4khxefSFIZJ65EgaV4rgjoFIs59yOWfegJ5lBnuKQ+mrwCCtVJbRV1h9t+PlYkwW3zylDSTKlRe/cv5I/KFYJZ9Zngnkn5n5zmkRlbRkPQZcOWnGbkkPSxZFtXmA0k6ebxCb9FsCOMTZ6YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898882; c=relaxed/simple;
	bh=v6c0ZEWS0t1eM/q1n53BsUuNqryoDGaw8H+yWJlXWDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EEE5WzZbR/TbpQtqUQzUh91RIFYlL8SIYLlZbtTBjG8fYwRumqfwaxTuV6RtmI5864q0J1eKu0YKPhZbPLuGEa4vGWnyglMRr7MYy5Ep7Iy/g7hX2rVSpwtXYyZh4X2eNamAdRUKY/P0kG8Y1A5Fu+WLxZNEh9uNnoLJ5lqA3Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wA31l7fc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wA31l7fc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D02B9C4CECD;
	Wed,  6 Nov 2024 13:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898882;
	bh=v6c0ZEWS0t1eM/q1n53BsUuNqryoDGaw8H+yWJlXWDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wA31l7fc9kCRDzZa1tT5blD3gQ5AYkjAm2tKv4rbvqUuLh5eMgbmNIl/hvrnxbuab
	 28lZZQkRVTaAIkzT38vx7JezS09oSpT6GX3m6sNohsg88fYQ4JuFjfw48LnEhXYOFJ
	 swKIu/ZBdYegL27vXNp+uzpxJ4StGZxf9gp6TNTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anastasia Kovaleva <a.kovaleva@yadro.com>,
	Dmitry Bogdanov <d.bogdanov@yadro.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 350/462] net: Fix an unsafe loop on the list
Date: Wed,  6 Nov 2024 13:04:03 +0100
Message-ID: <20241106120340.175378291@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anastasia Kovaleva <a.kovaleva@yadro.com>

commit 1dae9f1187189bc09ff6d25ca97ead711f7e26f9 upstream.

The kernel may crash when deleting a genetlink family if there are still
listeners for that family:

Oops: Kernel access of bad area, sig: 11 [#1]
  ...
  NIP [c000000000c080bc] netlink_update_socket_mc+0x3c/0xc0
  LR [c000000000c0f764] __netlink_clear_multicast_users+0x74/0xc0
  Call Trace:
__netlink_clear_multicast_users+0x74/0xc0
genl_unregister_family+0xd4/0x2d0

Change the unsafe loop on the list to a safe one, because inside the
loop there is an element removal from this list.

Fixes: b8273570f802 ("genetlink: fix netns vs. netlink table locking (2)")
Cc: stable@vger.kernel.org
Signed-off-by: Anastasia Kovaleva <a.kovaleva@yadro.com>
Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20241003104431.12391-1-a.kovaleva@yadro.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/sock.h       |    2 ++
 net/netlink/af_netlink.c |    3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -766,6 +766,8 @@ static inline void sk_add_bind_node(stru
 	hlist_for_each_entry_safe(__sk, tmp, list, sk_node)
 #define sk_for_each_bound(__sk, list) \
 	hlist_for_each_entry(__sk, list, sk_bind_node)
+#define sk_for_each_bound_safe(__sk, tmp, list) \
+	hlist_for_each_entry_safe(__sk, tmp, list, sk_bind_node)
 
 /**
  * sk_for_each_entry_offset_rcu - iterate over a list at a given struct offset
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2153,8 +2153,9 @@ void __netlink_clear_multicast_users(str
 {
 	struct sock *sk;
 	struct netlink_table *tbl = &nl_table[ksk->sk_protocol];
+	struct hlist_node *tmp;
 
-	sk_for_each_bound(sk, &tbl->mc_list)
+	sk_for_each_bound_safe(sk, tmp, &tbl->mc_list)
 		netlink_update_socket_mc(nlk_sk(sk), group, 0);
 }
 


