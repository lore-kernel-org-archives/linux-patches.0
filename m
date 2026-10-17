Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54CBD3AEF36;
	Sat, 17 Oct 2026 16:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256269; cv=none; b=h+b0suQIpKwWAWIZFFqZpWoFBSaGaqX0quz4NEq1IowUPWL/87OUT0GvxdgRT3bXrBzwS0INoQ2D5G+HLzHfDjlYjls95Bi9ns/cVkKihhMdFrdlfAB4u9nR1h7/gxoS1HwAdKQNdNXzMGf4AbyTg7cuMz7KVOswu/nHjdb67Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256269; c=relaxed/simple;
	bh=oYWejdly7dyoP97RKR5AKYUzV5NN8v+CFFnKN7XAOFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NiQ+dbSsJ7Fph4tPdbs1W6lG0YoyD9qz6+n5tApPZRkLthTB2nBphpNSopcr/Nl5YYldWRyid0EBAtYgaBVX2IV7gdIuCKYQNnhEKrsa38EKuZ/pDTn8fi+89E/e0QGOdOX0DASPCVrCpPZa+SAqPEL4cD8PRDDh7lwt0bC66F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hMTh0KcP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hMTh0KcP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A18BA1F000C4;
	Sat, 17 Oct 2026 16:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256268;
	bh=OhkoEWWcWn3RdBBVmqlobT/3GYoHKSw5lM81rrOvDpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hMTh0KcPes62+AmQt+DlWmIsJuaUNRsGxfOo0rNnoxvN07ZcQuqcRGoai3+mYR8RH
	 m5vg5fjhty/cTi+udxbVC5XqS80pjSsL006ltRg9VY9JhK2Jo8eQwOwGl7S37KQUv/
	 YzoBq3vNwyOZMODpDPqKrU0DDl8r/yx2TiWmm0bY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Maoyi Xie <maoyi.xie@ntu.edu.sg>,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0180/1674] rds_tcp: close NULL deref window in rds_tcp_set_callbacks
Date: Sat, 17 Oct 2026 17:40:52 +0200
Message-ID: <20261017160435.773118075@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maoyi Xie <maoyixie.tju@gmail.com>

commit d2bfdbb69cf87676981b1043010b6224d84c6d3a upstream.

rds_tcp_set_callbacks() links a new rds_tcp_connection onto
rds_tcp_tc_list under rds_tcp_tc_list_lock. It releases the
lock, then assigns tc->t_sock = sock outside the lock.

rds_tcp_tc_info() and rds6_tcp_tc_info() walk rds_tcp_tc_list
under the same lock. Both dereference tc->t_sock->sk without
a NULL check.

A reader can acquire rds_tcp_tc_list_lock between the writer's
spin_unlock and the t_sock store. It then sees a list entry
whose t_sock is NULL. The dereference of tc->t_sock->sk is a
NULL access.

Move tc->t_sock = sock inside rds_tcp_tc_list_lock, before
list_add_tail. A reader holding the lock then observes the
linkage and the t_sock store together.

The restore path is safe. rds_tcp_restore_callbacks() does
list_del_init inside the lock. The matching tc->t_sock = NULL
after unlink is harmless to readers holding the lock.

Fixes: 70041088e3b9 ("RDS: Add TCP transport to RDS")
Suggested-by: Simon Horman <horms@kernel.org>
Signed-off-by: Maoyi Xie <maoyi.xie@ntu.edu.sg>
Reviewed-by: Allison Henderson <achender@kernel.org>
Link: https://patch.msgid.link/20260512142807.1855619-1-maoyi.xie@ntu.edu.sg
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

[ achender: resolved context conflict; tc->t_rtn initialization is not
  present in this tree ]
Signed-off-by: Allison Henderson <achender@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/tcp.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index 8f3d09c541db7..245c4c48c56d7 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -231,16 +231,19 @@ void rds_tcp_set_callbacks(struct socket *sock, struct rds_conn_path *cp)
 	rdsdebug("setting sock %p callbacks to tc %p\n", sock, tc);
 	write_lock_bh(&sock->sk->sk_callback_lock);
 
-	/* done under the callback_lock to serialize with write_space */
+	/* done under the callback_lock to serialize with write_space.
+	 * Set t_sock inside rds_tcp_tc_list_lock so readers walking
+	 * rds_tcp_tc_list under the same lock cannot observe an
+	 * entry whose t_sock is NULL.
+	 */
 	spin_lock(&rds_tcp_tc_list_lock);
+	tc->t_sock = sock;
 	list_add_tail(&tc->t_list_item, &rds_tcp_tc_list);
 	spin_unlock(&rds_tcp_tc_list_lock);
 
 	/* accepted sockets need our listen data ready undone */
 	if (sock->sk->sk_data_ready == rds_tcp_listen_data_ready)
 		sock->sk->sk_data_ready = sock->sk->sk_user_data;
-
-	tc->t_sock = sock;
 	tc->t_cpath = cp;
 	tc->t_orig_data_ready = sock->sk->sk_data_ready;
 	tc->t_orig_write_space = sock->sk->sk_write_space;
-- 
2.53.0



