Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056860;
	b=HggHcPTs+RrVxFPB/s1dlW/AVFj4s8ljHbO+5kBfS4F6n17+3ztS9BlPisBg/EG0Mt1A
	 qEf16u3J6rRROw8ovXRvfn9S7F7o5tDR8pnEtlhOOE9LyKdvjV68Wn+35rib8I7ZthW+c
	 IKGzSJGAh+IHA7p+RqKf+dJUY3WLtt+ePyfUp0fyfkwuV25rn8aVGiQ8AV77FHE02zFhs
	 qk8IljT2aGOdxWJD8LDdvd4CLzRlftvKEcURV83NU67c64T+gWmOmJTeLihKfOAE1JoNe
	 bedOEpmkV/St7s+CmfMKLL7n24vZRag82XpxYo7CSjgMjUfPzEdGxelztBFKF1byrvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056860;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LBxHl7ufcOTlwAghPhmTfZOQ9NxYucCLa488VaTo62M=;
	b=Q+Lv4SvZ75SbxKvMWtBQqjUE9p51ucgc3qQREUt7/x6+LTNEH2RAOavQyWS83UZmrT5+
	 0iQ9H/Y3k5/+806C5LgeI3AFoidV8+I2tZVl/oFOEgVc9wlXdEDnL9kbP2X1sTdNPf6l1
	 ym6MyFy9+RAZheYnyTIo8nCPCPhXyffVIQifUezatNoTQNKPVmoPazeg9X55CEIkwZqI3
	 9KwS42ke8SKjkcZIolbk0iExhTHeFc6ENGz58BLhwBEeLOT8B+l1HSQSgavhy7FyirXur
	 JEZFg8XQjTHsIZQT5ZuoEWnhkINxtV7wmMCb1sA8oTGMfOTqD41clBdmYOaaVdLKBBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="oX/HtwAn";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2BFD606A325;
	Thu, 19 Nov 2026 02:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oX/HtwAn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 201F41F000C4;
	Thu, 19 Nov 2026 02:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056860;
	bh=LBxHl7ufcOTlwAghPhmTfZOQ9NxYucCLa488VaTo62M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oX/HtwAn++lZD2aWI8BXXGT0xMKqNTm1CEaoyPcc2WMZZDooKl/lkHID6DLXyc29V
	 MRErErGAUL9yTgVYJONxx0BVdwCmZe63/MPU8WcuhfDLdg9uvfzn5D3Rs/FEWjoIU9
	 wb99HKgWBgahQI9yjebrHxW6d5qIY/+NyG55T53E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Allison Henderson <allison.henderson@oracle.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2139/2214] rds:Simplify the allocation of slab caches
Date: Wed, 18 Nov 2026 16:03:35 +0100
Message-ID: <20261118150136.079338999@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongfu Li <lihongfu@kylinos.cn>

[ Upstream commit 9f1f70dd850038b37e8b103ef0cc6f5eaeb6a8fc ]

Use the new KMEM_CACHE() macro instead of direct kmem_cache_create
to simplify the creation of SLAB caches.

Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: ffbbc315b8b8 ("net/rds: do not initialize transports after rds_init() failed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/tcp.c      | 4 +---
 net/rds/tcp_recv.c | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index 1d3fc063465bf..4f5d2e8a90c34 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -775,9 +775,7 @@ static int __init rds_tcp_init(void)
 {
 	int ret;
 
-	rds_tcp_conn_slab = kmem_cache_create("rds_tcp_connection",
-					      sizeof(struct rds_tcp_connection),
-					      0, 0, NULL);
+	rds_tcp_conn_slab = KMEM_CACHE(rds_tcp_connection, 0);
 	if (!rds_tcp_conn_slab) {
 		ret = -ENOMEM;
 		goto out;
diff --git a/net/rds/tcp_recv.c b/net/rds/tcp_recv.c
index f4ee13da90c70..dac500fd2bc84 100644
--- a/net/rds/tcp_recv.c
+++ b/net/rds/tcp_recv.c
@@ -335,9 +335,7 @@ void rds_tcp_data_ready(struct sock *sk)
 
 int rds_tcp_recv_init(void)
 {
-	rds_tcp_incoming_slab = kmem_cache_create("rds_tcp_incoming",
-					sizeof(struct rds_tcp_incoming),
-					0, 0, NULL);
+	rds_tcp_incoming_slab = KMEM_CACHE(rds_tcp_incoming, 0);
 	if (!rds_tcp_incoming_slab)
 		return -ENOMEM;
 	return 0;
-- 
2.53.0



