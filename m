Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43781E4DA
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 22:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=JMrOLqBblBfuXk+q4S5+9mk7xuUL4OAY5iCRONC3a9s=; b=ORXBjQLdXg5ueh0ftFlBOiakYq
	sIBCVRcvIsD9oCpjIfZULUv1PPM61KzLHOWlYCssy0yiQxhKBLzO1IzutXl6YtniOB+dXD8ecX8Ol
	bKna/AnveqTslVzmvOeFVE0qZce4UPeBlC4yy7TbJ7AKPFBOuvHWHzU1E14znz5DhfpDLu3RYpxAX
	qw6kC5273MAGBIeHtx93Q5BQdhasc7IwQWK8S+cQg0b8PnVwJzlY+eM4zDoULpuYvrDuCn/kDDvHh
	p2VTGvH0HCQy3Ue/IPSGM62LXYJfeT2m+anmO55FzoG+Jz0VF6ARF1OmGUSG8oennNf/LQ4CU8TAE
	TFb7OC9w==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1palbL-00GWqj-NU; Fri, 10 Mar 2023 22:52:39 +0000
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
Subject: [PATCH 3/5] sunrpc: simplify one-level sysctl registration for xs_tunables_table
Date: Fri, 10 Mar 2023 14:52:34 -0800
Message-Id: <20230310225236.3939443-4-mcgrof@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230310225236.3939443-1-mcgrof@kernel.org>
References: <20230310225236.3939443-1-mcgrof@kernel.org>
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
 net/sunrpc/xprtsock.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index aaa5b2741b79..46bbd6230650 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -77,7 +77,7 @@ static unsigned int xs_tcp_fin_timeout __read_mostly = XS_TCP_LINGER_TO;
 
 /*
  * We can register our own files under /proc/sys/sunrpc by
- * calling register_sysctl_table() again.  The files in that
+ * calling register_sysctl() again.  The files in that
  * directory become the union of all files registered there.
  *
  * We simply need to make sure that we don't collide with
@@ -157,15 +157,6 @@ static struct ctl_table xs_tunables_table[] = {
 	{ },
 };
 
-static struct ctl_table sunrpc_table[] = {
-	{
-		.procname	= "sunrpc",
-		.mode		= 0555,
-		.child		= xs_tunables_table
-	},
-	{ },
-};
-
 /*
  * Wait duration for a reply from the RPC portmapper.
  */
@@ -3174,7 +3165,7 @@ static struct xprt_class	xs_bc_tcp_transport = {
 int init_socket_xprt(void)
 {
 	if (!sunrpc_table_header)
-		sunrpc_table_header = register_sysctl_table(sunrpc_table);
+		sunrpc_table_header = register_sysctl("sunrpc", xs_tunables_table);
 
 	xprt_register_transport(&xs_local_transport);
 	xprt_register_transport(&xs_udp_transport);
-- 
2.39.1

