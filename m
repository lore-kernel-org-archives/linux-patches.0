Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EAC5367B9C;
	Wed, 30 Sep 2026 16:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784602; cv=none; b=SWqBJ8kPu1CWz4lwfT8ghfR0zGtT5QXCd0UQspRwVDX3j6j9lAmQGyV/9IWZRwAtKp/rQ2CmTR3Aq9Bwx3JyHPWk/wy/4NEKy5xnLATi0wCWrUItzyIJ2SQulBe9pw4AirZ9yaGUYE8DsHG0/eGOrjzXiqSheYl3/Z/roY4sTx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784602; c=relaxed/simple;
	bh=N5CtXZ9gqzIzmynzdmVUQUGU/cw17ibUa0tvOy6IT7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pcw3kelo6rEEtRsU5vvqUS2LK/5EI6QNi69WCjKmEPJZOQ1OE+3wCprexTfhsBTpmfLqkMPDyY3gvlfewvoxdPzE9y74UEJQSd7BW+LckdcjdaKWZwcfnjNmgrxz6NwoDt+L22Hpt6SmBrzf7eBm1alEA0iddiPVNaFPnTd6t54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZOVNBd4B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZOVNBd4B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC7421F00898;
	Wed, 30 Sep 2026 16:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784595;
	bh=PoxF6EFMR+gF/z5t16GkRrZB2wuPza/2ppvGMFq0tCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZOVNBd4BwVFLDWCfScSfLRWcf0AuY1ZjjQhb2stlMUx2bsenDkmJ1FnBuEU83qC52
	 ki7vij7JQdvecyYIbnDUchmZeUene4ywmjrn0L7VSCbWv8j//EQVGDiHj84PvLigwI
	 Ev41ehSxzdaNUp0uP9UkrnGPUKDoancCdwf4N9+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurelien DESBRIERES <aurelien@hackers.camp>,
	Md Haris Iqbal <haris.iqbal@ionos.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 165/982] RDMA/rtrs-srv: Fix integer underflow in process_read and process_write
Date: Wed, 30 Sep 2026 17:15:01 +0200
Message-ID: <20260930152420.354636437@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aurelien DESBRIERES <aurelien@hackers.camp>

[ Upstream commit 54bf38b27afc08a0eb6b732f9c14eb8a4bcb66b5 ]

usr_len is read from a network-supplied message field (le16_to_cpu)
and used to compute data_len = off - usr_len without validating that
usr_len <= off. A malicious RDMA client can send usr_len > off causing
an integer underflow, resulting in data_len wrapping to a huge size_t
value which is then passed to the rdma_ev callback as a memory length,
leading to out-of-bounds memory access.

Fix by reading and validating usr_len <= off before rtrs_srv_get_ops_ids()
in both process_read() and process_write(), ensuring the early return
path acquires no reference and has no resource leak.

Link: https://patch.msgid.link/r/20260608134802.5019-1-aurelien@hackers.camp
Reported-by: Aurelien DESBRIERES <aurelien@hackers.camp>
Reviewed-by: Md Haris Iqbal <haris.iqbal@ionos.com>
Signed-off-by: Aurelien DESBRIERES <aurelien@hackers.camp>
Assisted-by: Claude <claude-sonnet-4-6>
Acked-by: Md Haris Iqbal <haris.iqbal@ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-srv.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index 086dba6b97c64..a7c0b7e513fea 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -1040,6 +1040,11 @@ static void process_read(struct rtrs_srv_con *con,
 			    "Processing read request failed, invalid message\n");
 		return;
 	}
+	usr_len = le16_to_cpu(msg->usr_len);
+	if (usr_len > off) {
+		pr_debug("rtrs-srv: Invalid usr_len %zu > off %u\n", usr_len, off);
+		return;
+	}
 	rtrs_srv_get_ops_ids(srv_path);
 	rtrs_srv_update_rdma_stats(srv_path->stats, off, READ);
 	id = srv_path->ops_ids[buf_id];
@@ -1047,7 +1052,6 @@ static void process_read(struct rtrs_srv_con *con,
 	id->dir		= READ;
 	id->msg_id	= buf_id;
 	id->rd_msg	= msg;
-	usr_len = le16_to_cpu(msg->usr_len);
 	data_len = off - usr_len;
 	data = page_address(srv->chunks[buf_id]);
 	ret = ctx->ops.rdma_ev(srv->priv, id, data, data_len,
@@ -1093,6 +1097,11 @@ static void process_write(struct rtrs_srv_con *con,
 			     rtrs_srv_state_str(srv_path->state));
 		return;
 	}
+	usr_len = le16_to_cpu(req->usr_len);
+	if (usr_len > off) {
+		pr_debug("rtrs-srv: Invalid usr_len %zu > off %u\n", usr_len, off);
+		return;
+	}
 	rtrs_srv_get_ops_ids(srv_path);
 	rtrs_srv_update_rdma_stats(srv_path->stats, off, WRITE);
 	id = srv_path->ops_ids[buf_id];
@@ -1100,7 +1109,6 @@ static void process_write(struct rtrs_srv_con *con,
 	id->dir    = WRITE;
 	id->msg_id = buf_id;
 
-	usr_len = le16_to_cpu(req->usr_len);
 	data_len = off - usr_len;
 	data = page_address(srv->chunks[buf_id]);
 	ret = ctx->ops.rdma_ev(srv->priv, id, data, data_len,
-- 
2.53.0



