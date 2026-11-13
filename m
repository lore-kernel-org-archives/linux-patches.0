Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590154;
	b=c6Buaa8YZH5xr3D74huCSJElrURKnUGtJOqccBDYAN1A3+q9LuFCgXU7GWgN/su5OaFB
	 rpJy7BO0BdB2m46nkBYJRJdp1GRXOsutHJCe69aUNmQv2m7hs4dYoJbjN3B5xO4Yg+7oG
	 NUP1ZzWSKwKXV74reRlMMWhtx5EpmA9G6LVRO+/CwYrRoMNMey6Ij57O+xaYvT8y3wF0n
	 eGV1RQ2qH1o16k6mgsnL9G+OdNHkni0E1w/n/qyYxD6YpEQWl3N16heuaXiNEszyVEtP5
	 O8cSt+98LXkNos5WU4hZ9XNAScuVuYvXpz+uNrGDWd3wRxd5WpbQxPQBN/5gyd+2xBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590154;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xcEdPaU9UvfpXt6tqXKu0yyslVodGFI7m4LylsZETkE=;
	b=o9lDdOjg3vJJER+u6CFiKTooF/SHhy3FFO6IZwTONsY+a9YGb2eL4Pa2SP9tudb2K5/W
	 GEzBHamxprZgHXVpm3JAIaxaftyhQ+kMDavjrKu0KriEmReUgnGzBzzUagoC6UFjHmBP4
	 NQhluGaPj32Ulv0I05yQa6215Be4pgF3nWQC9cZTd++hTiLEx1BnunfVGi7pVLOewfkVj
	 5xjHWznZa/8q48s49iVX9C4ne+lf75XxGRPW+F5fV5ul5fShzAWhqKK274qZMWnAxHmzh
	 2F6mc+WAJ7vaxvcQPPD8VjKyFUbTtaBV0KdM4Y45zasNzYqSt4kzBLHUXpYhB4jYS8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K8OyOhSj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CB8606D4A1;
	Fri, 13 Nov 2026 17:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K8OyOhSj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0ED01F000C4;
	Fri, 13 Nov 2026 17:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590154;
	bh=xcEdPaU9UvfpXt6tqXKu0yyslVodGFI7m4LylsZETkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K8OyOhSjSjHXejKUCq7vTMlATTUOZuHV3Rl6lgR01c3Owa5cldTRfo7JkLFvxsZm8
	 hor2d1aL8bTGmpXzjCte3EDZuTxHQhvPIMIxHXfeJYaymMn5VLnDgJGuwhPMU/Eg6Z
	 TXSaF9fhVuBbsj9dj38Zg78jm5peAb7JjdYKG4EA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 167/686] rds: fix out-of-bounds conn_path walks via handshake exthdrs
Date: Fri, 13 Nov 2026 10:45:00 -0500
Message-ID: <20261113153826.553047247@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Henry Martin <bsdhenrymartin@gmail.com>

[ Upstream commit 50f2103fce43922b6e562937b2d2fc62089ff7ec ]

Both the lane and the connection-generation negotiation are driven by
extension headers in handshake packets, and both are processed
unconditionally, even on transports that are not multipath capable.
A non-MP connection (t_mp_capable unset) owns exactly one
rds_conn_path slot, so a peer claiming up to RDS_MPATH_WORKERS lanes
makes every subsequent fan-out walk conn->c_path[0..7] at 504-byte
strides past the single allocated slot (KASAN: "Read of size 8 in
rds_conn_path_connect_if_down"); the generation negotiation opens a
similar out-of-bounds walk on the same array.

Only process handshake extension headers when the connection's
transport is multipath capable, so a peer can never make us walk
lanes that do not exist.  Both call sites in rds_recv_incoming() are
gated.

This is a port of the Oracle UEK fix for the same issue, picked up
where Paula's series of the same change left off.

This issue was discovered by Tencent CodeBuddy Security.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/netdev/20260825120132.51636-1-pamoutafpro@gmail.com/
Link: https://github.com/oracle/linux-uek/commit/2fdeb0513f18
Fixes: 840df162b3eb ("rds: reduce memory footprint for RDS when transport is RDMA")
Fixes: 905dd4184e07 ("RDS: TCP: Track peer's connection generation number")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Reviewed-by: Allison Henderson <achender@kernel.org>
Link: https://patch.msgid.link/20261012025336.54756-1-bsdhenrymartin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/recv.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/rds/recv.c b/net/rds/recv.c
index 4b12fa4f1e786..c400cc5ea3605 100644
--- a/net/rds/recv.c
+++ b/net/rds/recv.c
@@ -343,7 +343,8 @@ void rds_recv_incoming(struct rds_connection *conn, struct in6_addr *saddr,
 		rds_stats_inc(s_recv_ping);
 		rds_send_pong(cp, inc->i_hdr.h_sport);
 		/* if this is a handshake ping, start multipath if necessary */
-		if (RDS_HS_PROBE(be16_to_cpu(inc->i_hdr.h_sport),
+		if (conn->c_trans->t_mp_capable &&
+		    RDS_HS_PROBE(be16_to_cpu(inc->i_hdr.h_sport),
 				 be16_to_cpu(inc->i_hdr.h_dport))) {
 			rds_recv_hs_exthdrs(&inc->i_hdr, cp->cp_conn);
 			rds_start_mprds(cp->cp_conn);
@@ -351,7 +352,8 @@ void rds_recv_incoming(struct rds_connection *conn, struct in6_addr *saddr,
 		goto out;
 	}
 
-	if (be16_to_cpu(inc->i_hdr.h_dport) ==  RDS_FLAG_PROBE_PORT &&
+	if (conn->c_trans->t_mp_capable &&
+	    be16_to_cpu(inc->i_hdr.h_dport) ==  RDS_FLAG_PROBE_PORT &&
 	    inc->i_hdr.h_sport == 0) {
 		rds_recv_hs_exthdrs(&inc->i_hdr, cp->cp_conn);
 		/* if this is a handshake pong, start multipath if necessary */
-- 
2.53.0



