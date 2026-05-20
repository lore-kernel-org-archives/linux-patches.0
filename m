Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB613EF647;
	Wed, 20 May 2026 17:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296529; cv=none; b=rU2pKqh1xQCE4htlsqn6I36OYQ5KfioB4KwX69bsptyRJzaruB+iGWP7G6UeNr5nKJdv5J1FTCiNav7l9BT2KsTHYwuLpsXa5Vr5xRBp9n3o4p4H93SFhq+iM+HA/7mxbium2pgjRvRkCqadGytWJYmhnS70L3Zx8Lf3QqiT7vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296529; c=relaxed/simple;
	bh=OGdlTXPmA8i0uPey7Sv7SgWIgwpLd5xEZp1pA9h/jYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h4g8SuSwFE3/8PbRtlSJNy2TL3M73sYzQ9GWKC6vTwM6Omv4K7Wq9xN4LDfLFcG0H5ckBSAfFzPzBkYve1bK5X5JgqmQi1TGUy3SbwAyTnf3OY+quU5KWevA+MgJrxR0aOwqPyitxzXq99Qs4b/9q3A+4o/JK2jivwxlmJDn2Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MmFvzPtF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MmFvzPtF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADEFD1F000E9;
	Wed, 20 May 2026 17:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296527;
	bh=3oi3dK8gQr9K/ci2OTyvNGZpWzsdeM4L8mPL0Y8k0b0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MmFvzPtFhh+86yK+XZF0AjHC4/NljEkrghZAKtIJEjboJqACO6c0zRZQxRa0U133e
	 W/U2Pq2Kr+fm3X3AhthN1XSL6Gl/1/HpZy/WtY2F18Cxn+6wDcFOFe4A8EbWmxBq5U
	 XagFrs6JZ9AdnmfiOLvlRCCEL+PKYpzBXYNq7lFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Sharath Srinivasan <sharath.srinivasan@oracle.com>,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0834/1146] net/rds: zero per-item info buffer before handing it to visitors
Date: Wed, 20 May 2026 18:18:04 +0200
Message-ID: <20260520162207.104442682@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

[ Upstream commit c88eb7e8d8397a8c1db59c425332c5a30b2a1682 ]

rds_for_each_conn_info() and rds_walk_conn_path_info() both hand a
caller-allocated on-stack u64 buffer to a per-connection visitor and
then copy the full item_len bytes back to user space via
rds_info_copy() regardless of how much of the buffer the visitor
actually wrote.

rds_ib_conn_info_visitor() and rds6_ib_conn_info_visitor() only
write a subset of their output struct when the underlying
rds_connection is not in state RDS_CONN_UP (src/dst addr, tos, sl
and the two GIDs via explicit memsets). Several u32 fields
(max_send_wr, max_recv_wr, max_send_sge, rdma_mr_max, rdma_mr_size,
cache_allocs) and the 2-byte alignment hole between sl and
cache_allocs remain as whatever stack contents preceded the visitor
call and are then memcpy_to_user()'d out to user space.

struct rds_info_rdma_connection and struct rds6_info_rdma_connection
are the only rds_info_* structs in include/uapi/linux/rds.h that are
not marked __attribute__((packed)), so they have a real alignment
hole. The other info visitors (rds_conn_info_visitor,
rds6_conn_info_visitor, rds_tcp_tc_info, ...) write all fields of
their packed output struct today and are not known to be vulnerable,
but a future visitor that adds a conditional write-path would have
the same bug.

Reproduction on a kernel built without CONFIG_INIT_STACK_ALL_ZERO=y:
a local unprivileged user opens AF_RDS, sets SO_RDS_TRANSPORT=IB,
binds to a local address on an RDMA-capable netdev (rxe soft-RoCE on
any netdev is sufficient), sendto()'s any peer on the same subnet
(fails cleanly but installs an rds_connection in the global hash in
RDS_CONN_CONNECTING), then calls getsockopt(SOL_RDS,
RDS_INFO_IB_CONNECTIONS). The returned 68-byte item contains 26
bytes of stack garbage including kernel text/data pointers:

    0..7   0a 63 00 01 0a 63 00 02     src=10.99.0.1 dst=10.99.0.2
    8..39  00 ...                      gids (memset-zeroed)
    40..47 e0 92 a3 81 ff ff ff ff     kernel pointer (max_send_wr)
    48..55 7f 37 b5 81 ff ff ff ff     kernel pointer (rdma_mr_max)
    56..59 01 00 08 00                 rdma_mr_size (garbage)
    60..61 00 00                       tos, sl
    62..63 00 00                       alignment padding
    64..67 18 00 00 00                 cache_allocs (garbage)

Fix by zeroing the per-item buffer in both rds_for_each_conn_info()
and rds_walk_conn_path_info() before invoking the visitor. This
covers the IPv4/IPv6 IB visitors and hardens all current and future
visitors against the same class of bug.

No functional change for visitors that fully populate their output.

Changes in v2:
- retarget at the net tree (subject prefix "[PATCH net v2]",
  net/rds: prefix in the title)
- pick up Reviewed-by tags from Sharath Srinivasan and
  Allison Henderson

Fixes: ec16227e1414 ("RDS/IB: Infiniband transport")
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Reviewed-by: Sharath Srinivasan <sharath.srinivasan@oracle.com>
Reviewed-by: Allison Henderson <achender@kernel.org>
Assisted-by: Claude:claude-opus-4-7
Link: https://patch.msgid.link/20260418141047.3398203-1-michael.bommarito@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/connection.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/rds/connection.c b/net/rds/connection.c
index 412441aaa298e..c10b7ed06c49f 100644
--- a/net/rds/connection.c
+++ b/net/rds/connection.c
@@ -701,6 +701,13 @@ void rds_for_each_conn_info(struct socket *sock, unsigned int len,
 	     i++, head++) {
 		hlist_for_each_entry_rcu(conn, head, c_hash_node) {
 
+			/* Zero the per-item buffer before handing it to the
+			 * visitor so any field the visitor does not write -
+			 * including implicit alignment padding - cannot leak
+			 * stack contents to user space via rds_info_copy().
+			 */
+			memset(buffer, 0, item_len);
+
 			/* XXX no c_lock usage.. */
 			if (!visitor(conn, buffer))
 				continue;
@@ -750,6 +757,13 @@ static void rds_walk_conn_path_info(struct socket *sock, unsigned int len,
 			 */
 			cp = conn->c_path;
 
+			/* Zero the per-item buffer for the same reason as
+			 * rds_for_each_conn_info(): any byte the visitor
+			 * does not write (including alignment padding) must
+			 * not leak stack contents via rds_info_copy().
+			 */
+			memset(buffer, 0, item_len);
+
 			/* XXX no cp_lock usage.. */
 			if (!visitor(cp, buffer))
 				continue;
-- 
2.53.0



