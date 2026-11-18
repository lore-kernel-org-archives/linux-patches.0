Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037410;
	b=qqBod7mXCC1htb8FLMl+BmkxIMsmeIodiBM0BBJp46M+bynhSK7g50zKVKCicTBie6j4
	 7CuK3srUBzSl24pXHFykiiLZ6idfQrhxQbgNP+L49NK7PFMZIXAUQ4ayCYdZUcHR3ixNb
	 PyJKASVIp8Y/XMDtSO4Sm+E0OwJGmMq9gz4cV4uDpwdFKDloYQqPrH2pMRFKaKNJ5835K
	 b8ZCtyBWEv7SGsi20EJgO1WQGCCwW0LfwAAorOQjzWTE3O7oFF2ILGYTc+kp/qQ2NuhYK
	 LnPb9fxBl5k4uWBGpUKOZUPMiUVtrJ12Znn9NDji0iJTYag1GgrqtWDQs/M90YZhW2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037410;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/QrrrvF5LsHegIaQ9t+YWAAuobbrctTFUZxPT19YtdY=;
	b=S2g8bMxI4MLh0sqr4ztbIH8nSKHy/yHb054qmWts7+TreDNFOQ2YgVXShgKxuF/27x/4
	 PDt7D413c5e25FgJBiW0R448XP4hyErvkAs3thrafgGV3JNAwt/d7nL3xAmDvszZ1Xayz
	 V0uWWXLx6HPCNZt5scqXw1GM+PzBJMbsbOSycTwpSD0Lm77jiGHAcZhnIsNTh4LS2BRnM
	 /jxV3kvvNMo0eC+SkVubKQu3krXCh8ut6+G4rZsVwMj7hBXfgdl9ayRYXKdxyqZ4CAQZ3
	 ZzWxl8xWZGS5FCIkxxMhPu/4wNgqwScq/6KYfg96ZtQHxDyPs2ka6+LZo2EpmKAPdUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cHuX3KZk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613C1606A32A;
	Wed, 18 Nov 2026 21:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cHuX3KZk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A19E1F000C4;
	Wed, 18 Nov 2026 21:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037410;
	bh=/QrrrvF5LsHegIaQ9t+YWAAuobbrctTFUZxPT19YtdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cHuX3KZkdwvNMaonEpedjoZfS6X5NpIdqmbSV4pdvCfFlG7sNm6iSUJJbhdprM9g3
	 jWRgZ13r/4R8KcK/y5YlL9jxa7Ihwq2/Tt5ZH3swC1utxZQo+LK0ne+6OHrKCqCsQ9
	 5QZBwUC2vwjaXPhqcZ3CJxwbCB6T/jhZMfSLRXBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1392/3318] rds: fix out-of-bounds conn_path walks via handshake exthdrs
Date: Wed, 18 Nov 2026 15:33:34 +0100
Message-ID: <20261118150402.343679171@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index bd9d00326e94f..110fb22c3e2e4 100644
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



