Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB2B446C08;
	Thu, 30 Jul 2026 15:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423937; cv=none; b=tb4NKJe8P7HGU1luSjfGilVwv5N6HqbISi5/7eiQrrF3IJuGdOYS6fFiDD1NNyv0y7MOz95YpphPKves53DbL5/hZOei2Pxxr2EPrZbcdtG4KRFhYLVRNuGtBKlIzO97991vV8I5V7HI4SXfh+Qv7nQZHuqpoojovfl4FdB1BXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423937; c=relaxed/simple;
	bh=KfLU1SBw0tP6lsKzdSYf+0rXjb5bygHI1JQAjCiDIxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MY3Bp5PB87AZNt8jDlUhvnDq1PH/O0L28bTb5da2uzT5gwpM4ksoDHjurAIF6IQrbj6zExxcOXSq1bFT/4Y9rumZVgka2ne+y5Cd4Lq3+S9bxN+m9rX01SMzkIm0E2X3/UFvNTnxrRbDXUdjwezLN5R3EQS8etsahceiWiQkqFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mWszPfXl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mWszPfXl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92D051F00ACF;
	Thu, 30 Jul 2026 15:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423936;
	bh=nv+fAnjlIvlkeRMAy6ES/txUculFCrqNYSIH3uJEVaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mWszPfXlbJiGAhqMDNKcGnZmPzxoZcppr59ckK0vYNsWRksuDXXXyXQdy9yb8nXU/
	 rJkFlB1STRHrHHGFMZ3hTiVr41rmE4GOngcmhO5uEQT5xCQ9BctYDgTsqOowtgejmU
	 IP021ZFVr42Fauloj7VNnZqlxw39Yvoi8LexM3WE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Allison Henderson <achender@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 216/675] rds: drop incoming messages that cross network namespace boundaries
Date: Thu, 30 Jul 2026 16:09:06 +0200
Message-ID: <20260730141449.734835873@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

[ Upstream commit 5521ae71e32a8069ed4ca6e792179dc57bc43ab2 ]

rds_find_bound() looks up the destination socket using a global
rhashtable keyed solely on (addr, port, scope_id).  Network namespaces
are not part of the key, so a sender in netns A can deliver an incoming
message (inc) to a socket that lives in a different netns B.

When this happens, inc->i_conn points to an rds_connection whose c_net
is netns A, but the receiving rs lives in netns B.  Once the child
process that created netns A exits, cleanup_net() calls
rds_loop_exit_net() -> rds_loop_kill_conns() -> rds_conn_destroy(),
freeing that connection.  If the survivor socket in netns B still holds
the inc, any subsequent dereference of inc->i_conn is a use-after-free.

There are two dangerous sites in rds_clear_recv_queue():
  1. inc->i_conn->c_lcong (offset 88 of freed rds_connection, size 200)
     read via rds_recv_rcvbuf_delta() -- confirmed by KASAN.
  2. inc->i_conn->c_trans->inc_free(inc) (function pointer at offset 80)
     called via rds_inc_put() when the inc refcount reaches zero -- same
     race window, potential call-through-freed-object primitive.

The bug is reachable from unprivileged user namespaces
(CLONE_NEWUSER + CLONE_NEWNET), available since Linux 3.8.

Fix this by rejecting the delivery in rds_recv_incoming() when the
socket returned by rds_find_bound() belongs to a different network
namespace than the connection that carried the message.  Use the
existing rds_conn_net() / sock_net() helpers and net_eq() for the
comparison.

Fixes: c809195f5523 ("rds: clean up loopback rds_connections on netns deletion")
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Reviewed-by: Allison Henderson <achender@kernel.org>
Tested-by: Allison Henderson <achender@kernel.org>
Signed-off-by: Allison Henderson <achender@kernel.org>
Link: https://patch.msgid.link/20260708024314.601139-1-achender@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/recv.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/net/rds/recv.c b/net/rds/recv.c
index 66205d6924bf3d..4b12fa4f1e7869 100644
--- a/net/rds/recv.c
+++ b/net/rds/recv.c
@@ -366,6 +366,21 @@ void rds_recv_incoming(struct rds_connection *conn, struct in6_addr *saddr,
 		goto out;
 	}
 
+	/*
+	 * rds_find_bound() uses a global (netns-agnostic) hash table.
+	 * An RDS connection created in netns A can match a socket bound
+	 * in the init netns, delivering inc cross-netns with inc->i_conn
+	 * pointing into netns A.  When cleanup_net() then frees that conn,
+	 * any subsequent dereference of inc->i_conn is a use-after-free.
+	 * Drop the inc if the receiving socket lives in a different netns.
+	 */
+	if (!net_eq(sock_net(rds_rs_to_sk(rs)), rds_conn_net(conn))) {
+		rds_stats_inc(s_recv_drop_no_sock);
+		rds_sock_put(rs);
+		rs = NULL;
+		goto out;
+	}
+
 	/* Process extension headers */
 	rds_recv_incoming_exthdrs(inc, rs);
 
-- 
2.53.0



