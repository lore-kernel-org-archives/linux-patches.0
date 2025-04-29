Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0063F23F405;
	Tue, 29 Apr 2025 17:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947106; cv=none; b=ru7Y4w8XePKvs7xxqAnndn+BY37g12/ijXEhcozwtI15f7sBR8xUYUGTXxa7Vy8bcpnAOjmIo2v5j61cOt6Mdwf8TW5TOQ4paZ4h85FZyjSxhf0eX3FsxO0ZBiew25PvT/NX5IhdRZJM8Dh2I+cPlS0HEgxfnoRAlNga3xdwz+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947106; c=relaxed/simple;
	bh=UT7hs6NVfPkbwywobVn5XufBunyZAXPycLxuuLJHNtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eJ0R4h0lfIP8p2Jl55D6Tr3y3P+ebQ8sFv87LJLLxzvivuHVRVtt/vC+N0cTFq5ImIE01mi4qPctTWms5Bh+FvYSqmQN10CpT0HU8U81fKkB9ugOR6F7c8Ez8TrqQpjs4gJaUya3rCzJQv2s7UwLieV+7CVq5J27S7ZmXO5S42Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WrvFuhkO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WrvFuhkO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85CC7C4CEE3;
	Tue, 29 Apr 2025 17:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947105;
	bh=UT7hs6NVfPkbwywobVn5XufBunyZAXPycLxuuLJHNtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WrvFuhkOlqqgmWuBGldUzJ+kYDaYZ4Gc3a6idyEEVVa6isxGiG10dId6JicrDllGG
	 G+bZ5c5OSlTDDpW3b3ZN9fnWbLd7onSgUyGmUHYop5gLThcA7ci9IMLXA4VNS+YYTo
	 kuA71yRlkMTvSwcK0yGkxsC+/kjMwTJhdGsi2/Cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Hanxiao <chenhx.fnst@fujitsu.com>,
	Julian Anastasov <ja@ssi.bg>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Cliff Liu <donghua.liu@windriver.com>,
	He Zhe <Zhe.He@windriver.com>
Subject: [PATCH 5.10 174/286] ipvs: properly dereference pe in ip_vs_add_service
Date: Tue, 29 Apr 2025 18:41:18 +0200
Message-ID: <20250429161115.053140617@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Chen Hanxiao <chenhx.fnst@fujitsu.com>

commit cbd070a4ae62f119058973f6d2c984e325bce6e7 upstream.

Use pe directly to resolve sparse warning:

  net/netfilter/ipvs/ip_vs_ctl.c:1471:27: warning: dereference of noderef expression

Fixes: 39b972231536 ("ipvs: handle connections started by real-servers")
Signed-off-by: Chen Hanxiao <chenhx.fnst@fujitsu.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Acked-by: Simon Horman <horms@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Cliff Liu <donghua.liu@windriver.com>
Signed-off-by: He Zhe <Zhe.He@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/ipvs/ip_vs_ctl.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -1384,20 +1384,20 @@ ip_vs_add_service(struct netns_ipvs *ipv
 		sched = NULL;
 	}
 
-	/* Bind the ct retriever */
-	RCU_INIT_POINTER(svc->pe, pe);
-	pe = NULL;
-
 	/* Update the virtual service counters */
 	if (svc->port == FTPPORT)
 		atomic_inc(&ipvs->ftpsvc_counter);
 	else if (svc->port == 0)
 		atomic_inc(&ipvs->nullsvc_counter);
-	if (svc->pe && svc->pe->conn_out)
+	if (pe && pe->conn_out)
 		atomic_inc(&ipvs->conn_out_counter);
 
 	ip_vs_start_estimator(ipvs, &svc->stats);
 
+	/* Bind the ct retriever */
+	RCU_INIT_POINTER(svc->pe, pe);
+	pe = NULL;
+
 	/* Count only IPv4 services for old get/setsockopt interface */
 	if (svc->af == AF_INET)
 		ipvs->num_services++;


