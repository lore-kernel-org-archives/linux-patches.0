Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365C34A24;
	Mon, 14 Oct 2024 14:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916572; cv=none; b=o1Rfzu/1k3HVdzYzOkN8MfpACmNZqS9aJP28ZonRO6xpQt4Ljx/sP1SbCR8F9gA+frxJiaQmOTFBaH4r6zivoYKZfkurodm2G30/7dow7Pe+ZxDDSheBvJHMmyKlG8ILbI63nJOPg3KKUMup7CyqB7sZReYPmfY+ihbTlQAUekU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916572; c=relaxed/simple;
	bh=iqZj/In4aQ/xOJpVDn/dy0p9ZWMD5WxbAiueqUygDJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TuIp1YqOuHvJ0cXAxGLhPJEkawDvZ6jL5oTTpurzy4KLWIGPe8KiNJrSfwZMYlkF1sGlps5+MpgXhNH6AXjFS52ZxjxNC+rHvdR6AGfLlmQUOTDEsOJlEgg9a//xthM1koOlwaRzV5vMtQCBUJcuVhn6tMFfUliQcaKNRgHHJK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XAiGUFa9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XAiGUFa9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B29DC4CEC3;
	Mon, 14 Oct 2024 14:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916572;
	bh=iqZj/In4aQ/xOJpVDn/dy0p9ZWMD5WxbAiueqUygDJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XAiGUFa9qr3kpKJw1zwT0dmXOAezRoiw7SRwTz6PNGUiM6c/A4mFcRFLFvsb8oqEQ
	 zGsxjajV1URrhBJ4anPbgERQwyoxd9qR1O7jtoLfrDQzs+tuGQDs2hEeua2QxjFGAB
	 Zjp4018zCXGQnI1SHiXtU/cDUN82WOh3O5Tk3s/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anastasia Kovaleva <a.kovaleva@yadro.com>,
	Dmitry Bogdanov <d.bogdanov@yadro.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.11 193/214] net: Fix an unsafe loop on the list
Date: Mon, 14 Oct 2024 16:20:56 +0200
Message-ID: <20241014141052.508996783@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -892,6 +892,8 @@ static inline void sk_add_bind_node(stru
 	hlist_for_each_entry_safe(__sk, tmp, list, sk_node)
 #define sk_for_each_bound(__sk, list) \
 	hlist_for_each_entry(__sk, list, sk_bind_node)
+#define sk_for_each_bound_safe(__sk, tmp, list) \
+	hlist_for_each_entry_safe(__sk, tmp, list, sk_bind_node)
 
 /**
  * sk_for_each_entry_offset_rcu - iterate over a list at a given struct offset
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2136,8 +2136,9 @@ void __netlink_clear_multicast_users(str
 {
 	struct sock *sk;
 	struct netlink_table *tbl = &nl_table[ksk->sk_protocol];
+	struct hlist_node *tmp;
 
-	sk_for_each_bound(sk, &tbl->mc_list)
+	sk_for_each_bound_safe(sk, tmp, &tbl->mc_list)
 		netlink_update_socket_mc(nlk_sk(sk), group, 0);
 }
 


