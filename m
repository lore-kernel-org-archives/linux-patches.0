Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0B83438A6;
	Wed, 30 Sep 2026 17:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791089; cv=none; b=P7cmOUH7SGhI86D19xEjUaby/nyZF1ILyjDQlI5iyNZkdwaMv65gqL6SiAJ2mw88spPBb3Djkyk5MMTwhE0wJao7RqvBeVURMwLL6AFWvEfIjEKk9mmPacZOKJNcY25qKvB3nudSiWzhAGWMZo00EST2kKqvBCSx0VYlqb3h9bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791089; c=relaxed/simple;
	bh=pckph+sDh+H0VdaXkR5z5KJLpAmq2EwDw2D4VC0wcwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gdudkE86WzPAJuF9uyxXpUuVxgX2sojNuxKPlJCuyQzpHM8GSdUHdk8GYDH1f5XJ5T9rQJQ1/q1CPvX8kd9qlZU4o1t4qoiq6Hq3ixPBsCJDjX3ljzmyVA23p7bbHEcLROvV1O52t5RQoQJMtpfi8Gh+I1jMszmr3/S5ABLRYao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WVOjrB++; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WVOjrB++"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9CBB1F000FF;
	Wed, 30 Sep 2026 17:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791088;
	bh=p5M5CHdHTO6aNPZn5ziikQ/+n2hXAMWpHxzi3boBjBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WVOjrB++1PGssKJ1tkm5ILzT+0QveMjRXWQ9cIBD7+m7rN6sv+L3ZjjA/m8sQkluB
	 UnzbWO7iKY4VxtZDOaYrjond5Djz271zFi7zkrEhjTBVe1pUI/jnQoLM63gm+mZz3s
	 SWF5rhUDLHYcF3Ey0eU104gBju43BrIH167yeajc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurelien DESBRIERES <aurelien@hackers.camp>,
	Md Haris Iqbal <haris.iqbal@ionos.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 128/752] RDMA/rtrs-srv: Fix integer underflow in process_read and process_write
Date: Wed, 30 Sep 2026 17:19:58 +0200
Message-ID: <20260930152400.948938174@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b7f7e24807dfb..455d315dcebf5 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -1047,6 +1047,11 @@ static void process_read(struct rtrs_srv_con *con,
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
@@ -1054,7 +1059,6 @@ static void process_read(struct rtrs_srv_con *con,
 	id->dir		= READ;
 	id->msg_id	= buf_id;
 	id->rd_msg	= msg;
-	usr_len = le16_to_cpu(msg->usr_len);
 	data_len = off - usr_len;
 	data = page_address(srv->chunks[buf_id]);
 	ret = ctx->ops.rdma_ev(srv->priv, id, READ, data, data_len,
@@ -1100,6 +1104,11 @@ static void process_write(struct rtrs_srv_con *con,
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
@@ -1107,7 +1116,6 @@ static void process_write(struct rtrs_srv_con *con,
 	id->dir    = WRITE;
 	id->msg_id = buf_id;
 
-	usr_len = le16_to_cpu(req->usr_len);
 	data_len = off - usr_len;
 	data = page_address(srv->chunks[buf_id]);
 	ret = ctx->ops.rdma_ev(srv->priv, id, WRITE, data, data_len,
-- 
2.53.0



