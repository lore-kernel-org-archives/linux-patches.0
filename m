Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E5B42586E;
	Mon, 17 Aug 2026 14:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976915; cv=none; b=BRICipSaTLI8PXG76ddfSXusovl1w/F40twogss5D/DoKxBagVzLuXi7aO/1yJgW0E2hc2gf2QcPMuUiJgjOdv6UNjYfvnFmiF2BeoiYebxRVDa+fT0UjnzcOhIJil8ZkNAa8yer/YkPZ6BT2JG9aIPTsLLHXc+MoJ3LqJZr/XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976915; c=relaxed/simple;
	bh=TS//Sx9aUDGddikzFNjkPVu7Kwr8zQhr4/CbjqAeUY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WPysom5VZEegyPsk8aba4dvdK4QY/jgIu2f5yaMGqqTC/ISgHd9aqdNvQwPgUy7OlPbtFrWzCtgbOTCulwJHcFxlUEGDs9H0211fRwVoz1N6sVKAzFxpKqWRHq84qvH4Rff/BzxAlMD4eAQ+teW2fOCpDmbWq5b8FaeGlHFcUT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uynT9V2b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uynT9V2b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FE7B1F00A3D;
	Mon, 17 Aug 2026 14:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976914;
	bh=01H4swl8+WWP4+4JKlaBCO3ZtzKh0pNHZjOoopjCHRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uynT9V2b4RVPXgP/PEmpk/EH371rBethldlOJCLIGD19/A00Cba+1J2peNaQEZUYI
	 st0TRLFdotop7Y1WzZnXuxEUFgeHQ7UXxAovfLTIbvlQJ651ymC8ClJIQ61my+AzP2
	 5tYYuVh/bCHTieWgdSDqo2kk56gRmUlgt/qTKGyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Allison Henderson <achender@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 099/456] rds: drop incoming messages that cross network namespace boundaries
Date: Mon, 17 Aug 2026 15:28:09 +0200
Message-ID: <20260817132543.970037215@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a316180d3c32ec..7fd77e1b4fe71c 100644
--- a/net/rds/recv.c
+++ b/net/rds/recv.c
@@ -365,6 +365,21 @@ void rds_recv_incoming(struct rds_connection *conn, struct in6_addr *saddr,
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



