Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590980;
	b=s1y68BQXyFrs5ulhKijzeQlueWqRnqd8n0FgtNc+Q4Y/JyYVxjck0yjrKM6sPT9a/nBz
	 q7XnObXgIUf6NV8mHOcNhQOI/X+P5OOO0Ias50rR7wZtSDWtNic0pNC7WEtZGHFWV/yF0
	 ptIaygdu0/6lQwWY6TJ1ij/Xr6OkQx5U+7hsnVOoSm3cqVmoyiNh5ymBiDR0yY1qV3xTn
	 Q9WcdBYKed/K/dKYgzRdLFqbbuZE5fCP3f4kvvGo7SM3nZb0QPfEDkFIKB3meuc0FAqf+
	 fOA82OTWzfzIEXppsYs5g24fMIFy5O3OB/ikAt4veLwLoDjzXDKGsHe3zQYSpINcpnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590980;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i3sNYxdL1m9gMYyzgj7W7fiSD9IuG9Cxm8uPqi4soYc=;
	b=KSapLIRor1k1NSc7+qTLgnc5nvkaKHXVmm3RQQKIOmcGHvTiczWimT8vwmYabkffxNsi
	 RCgg0/Ulxb/IR7IT3LPMeiNs8pDrqq0SvRqBrPajD6fN0jqeYlmkhdGysmX55qrDAxinG
	 6kaXN0mtmUeYgstM3zzPmBVQA9ZW+23jtklrkpJp1o2P+tb290Mr7cq/uKfvw0WcDeVGu
	 cH3qHnt4D1opLXWTWLb1Ydv0wyi9R6Jj6+y2WsXi9Uo8fXcTJqN2jJDUvQcAeabF3ptyS
	 PbclTmUAzpC2RQBgzYmSDR7p+twnrAOXkQ48QqXPb7lvh1rYgFiPUM8TMoNnba/gZFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sT3FDpBf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC1460703CB;
	Fri, 13 Nov 2026 17:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sT3FDpBf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C240D1F000C5;
	Fri, 13 Nov 2026 17:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590980;
	bh=i3sNYxdL1m9gMYyzgj7W7fiSD9IuG9Cxm8uPqi4soYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sT3FDpBftnDzD2NdbAR70VGelYk3t7FSaLIrdu9S4XT6fT++eFfod9lzpn875n13D
	 PTe7vHgl12v5oGrQiqXHDwOOjw+XSfB4bqIZsLN8SPZTeGYdlj+8huu+abQmRrc042
	 /8X4V+3FofI8/ePiDXemalUtQ+Bykxd5bVWeYsfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 157/670] rds: fix out-of-bounds conn_path walks via handshake exthdrs
Date: Fri, 13 Nov 2026 10:45:21 -0500
Message-ID: <20261113153817.454611789@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



