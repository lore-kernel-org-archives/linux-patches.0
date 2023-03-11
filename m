Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051876FC4
	for <patches@lists.linux.dev>; Sat, 11 Mar 2023 23:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=NH4tVoLA/Ab9gFvMSSGVxXB8I+Y2VZfuJjnFdVe1WZI=; b=VXh/mR/y5pwf08dqbPalVlOoGU
	5AG9RJuUAxKZHu/LPV+UlngpTX63/3U+3QmzrNHOtbfK2axmUHcE28JsQrFMK+l+c+sN1OPreUsH7
	am0VytJ3ZbV3vVHW3BTFfLqt0jaLEY4DoUJnAUx63nrBPrO7556OBUxMrKV8rhwIZjJdZHyaDuaMi
	FkTxfmquL2zrhyJSOGWYfgz7Xr/XPxW8XUAX/m6JNgveCZ/FWqDwX1Iw/FfEzfx7XOcNJAVJEGwlu
	TESJ8hbokO4HJkBjECdxwj5esXyf9kf0nxm3DujAExL9BGnQqaSNkmuJlM+Th9UFdIJdhfdJfQVYJ
	vZuMqBFg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1pb8oT-001UJk-0Z; Sat, 11 Mar 2023 23:39:45 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: chuck.lever@oracle.com,
	jlayton@kernel.org,
	trond.myklebust@hammerspace.com,
	anna@kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	kuba@kernel.org,
	linux-nfs@vger.kernel.org
Cc: ebiederm@xmission.com,
	keescook@chromium.org,
	yzaikin@google.com,
	j.granados@samsung.com,
	patches@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH v3 2/5] sunrpc: simplify one-level sysctl registration for xr_tunables_table
Date: Sat, 11 Mar 2023 15:39:41 -0800
Message-Id: <20230311233944.354858-3-mcgrof@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230311233944.354858-1-mcgrof@kernel.org>
References: <20230311233944.354858-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

There is no need to declare an extra tables to just create directory,
this can be easily be done with a prefix path with register_sysctl().

Simplify this registration.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 net/sunrpc/xprtrdma/transport.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index 10bb2b929c6d..29b0562d62e7 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -140,15 +140,6 @@ static struct ctl_table xr_tunables_table[] = {
 	{ },
 };
 
-static struct ctl_table sunrpc_table[] = {
-	{
-		.procname	= "sunrpc",
-		.mode		= 0555,
-		.child		= xr_tunables_table
-	},
-	{ },
-};
-
 #endif
 
 static const struct rpc_xprt_ops xprt_rdma_procs;
@@ -799,7 +790,7 @@ int xprt_rdma_init(void)
 
 #if IS_ENABLED(CONFIG_SUNRPC_DEBUG)
 	if (!sunrpc_table_header)
-		sunrpc_table_header = register_sysctl_table(sunrpc_table);
+		sunrpc_table_header = register_sysctl("sunrpc", xr_tunables_table);
 #endif
 	return 0;
 }
-- 
2.39.1

