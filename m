Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0697E7464;
	Tue, 30 Apr 2024 10:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474726; cv=none; b=YrjYpxMd7eYNtpUn1x5KBxvzFkyfsXDhAZh8Oa2xa2ICbWppdC+yVHARaRFHfgvD2txZ57xtmXoCOQZdbES+vX+19F/ulDXTd5wqj0V4OoWJamUOD1siAXkHAryhKtmn66F4uwOMshJ+t4Xb7DPGPXuuQ6z99gu4PY1e4hs31KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474726; c=relaxed/simple;
	bh=wwNBXCo40lUufkNr5UauX3SgrXYBfb8wGLbXUu2nRTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kuE7KlK5FVWST+Dpr2WL7edVnscxG8nA/540X2uxGAScVNwWVuzwzrp+wueJT9hkCRHwoH3HJeLlpmTd/0oH87CHMLE/A3ZOVpms0Xfv6NcA432Q+Enz3Zhn+VoiiAUNKh/PMZP7ngT4LjhcaDAPbIunWlbhKuMZiNup6AIr8Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OJ0j1qM8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OJ0j1qM8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A559C2BBFC;
	Tue, 30 Apr 2024 10:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474725;
	bh=wwNBXCo40lUufkNr5UauX3SgrXYBfb8wGLbXUu2nRTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OJ0j1qM8UrRBoPJxCekVruAhsoLh50SYBeFktD/lSOWszKhl13WeAKV3bg5anccGe
	 25kSGwTZVgoa7PfVsPxqBxN07GrnVXVwnVXxOu7l523Wdb3mb6w3MMxB3DRXsJkz6N
	 ub3lS95PhBXSEpe9r7zUxw9ywxxLQPyY49oE2a/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Luczaj <mhal@rbox.co>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 017/138] af_unix: Fix garbage collector racing against connect()
Date: Tue, 30 Apr 2024 12:38:22 +0200
Message-ID: <20240430103049.934075900@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Luczaj <mhal@rbox.co>

[ Upstream commit 47d8ac011fe1c9251070e1bd64cb10b48193ec51 ]

Garbage collector does not take into account the risk of embryo getting
enqueued during the garbage collection. If such embryo has a peer that
carries SCM_RIGHTS, two consecutive passes of scan_children() may see a
different set of children. Leading to an incorrectly elevated inflight
count, and then a dangling pointer within the gc_inflight_list.

sockets are AF_UNIX/SOCK_STREAM
S is an unconnected socket
L is a listening in-flight socket bound to addr, not in fdtable
V's fd will be passed via sendmsg(), gets inflight count bumped

connect(S, addr)	sendmsg(S, [V]); close(V)	__unix_gc()
----------------	-------------------------	-----------

NS = unix_create1()
skb1 = sock_wmalloc(NS)
L = unix_find_other(addr)
unix_state_lock(L)
unix_peer(S) = NS
			// V count=1 inflight=0

 			NS = unix_peer(S)
 			skb2 = sock_alloc()
			skb_queue_tail(NS, skb2[V])

			// V became in-flight
			// V count=2 inflight=1

			close(V)

			// V count=1 inflight=1
			// GC candidate condition met

						for u in gc_inflight_list:
						  if (total_refs == inflight_refs)
						    add u to gc_candidates

						// gc_candidates={L, V}

						for u in gc_candidates:
						  scan_children(u, dec_inflight)

						// embryo (skb1) was not
						// reachable from L yet, so V's
						// inflight remains unchanged
__skb_queue_tail(L, skb1)
unix_state_unlock(L)
						for u in gc_candidates:
						  if (u.inflight)
						    scan_children(u, inc_inflight_move_tail)

						// V count=1 inflight=2 (!)

If there is a GC-candidate listening socket, lock/unlock its state. This
makes GC wait until the end of any ongoing connect() to that socket. After
flipping the lock, a possibly SCM-laden embryo is already enqueued. And if
there is another embryo coming, it can not possibly carry SCM_RIGHTS. At
this point, unix_inflight() can not happen because unix_gc_lock is already
taken. Inflight graph remains unaffected.

Fixes: 1fd05ba5a2f2 ("[AF_UNIX]: Rewrite garbage collector, fixes race.")
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://lore.kernel.org/r/20240409201047.1032217-1-mhal@rbox.co
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/garbage.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/net/unix/garbage.c b/net/unix/garbage.c
index 675fbe594dbb3..58525311e903a 100644
--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -235,11 +235,22 @@ void unix_gc(void)
 	 * receive queues.  Other, non candidate sockets _can_ be
 	 * added to queue, so we must make sure only to touch
 	 * candidates.
+	 *
+	 * Embryos, though never candidates themselves, affect which
+	 * candidates are reachable by the garbage collector.  Before
+	 * being added to a listener's queue, an embryo may already
+	 * receive data carrying SCM_RIGHTS, potentially making the
+	 * passed socket a candidate that is not yet reachable by the
+	 * collector.  It becomes reachable once the embryo is
+	 * enqueued.  Therefore, we must ensure that no SCM-laden
+	 * embryo appears in a (candidate) listener's queue between
+	 * consecutive scan_children() calls.
 	 */
 	list_for_each_entry_safe(u, next, &gc_inflight_list, link) {
+		struct sock *sk = &u->sk;
 		long total_refs;
 
-		total_refs = file_count(u->sk.sk_socket->file);
+		total_refs = file_count(sk->sk_socket->file);
 
 		BUG_ON(!u->inflight);
 		BUG_ON(total_refs < u->inflight);
@@ -247,6 +258,11 @@ void unix_gc(void)
 			list_move_tail(&u->link, &gc_candidates);
 			__set_bit(UNIX_GC_CANDIDATE, &u->gc_flags);
 			__set_bit(UNIX_GC_MAYBE_CYCLE, &u->gc_flags);
+
+			if (sk->sk_state == TCP_LISTEN) {
+				unix_state_lock(sk);
+				unix_state_unlock(sk);
+			}
 		}
 	}
 
-- 
2.43.0



