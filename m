Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2458D5349A0;
	Thu, 17 Sep 2026 17:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664506; cv=none; b=UWdD0Wj3DWTlaxGpGZPYjYW+/29U53d4TmCUa2qCn1LuzftT30F401bwA0hdKK+LyNhKsx32RBuSndCLdaZQBOjruo+5p08pQv0rwlw0/a1Icxd55wC7FqcPVhcWFjddcaCp0M/aKAS0YVYVzma8e2yHWjCBG9DWe609nKxEhMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664506; c=relaxed/simple;
	bh=phg92k3AamO0q3CLGrGUN68MA57CW6wuu9PuAFl+j/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=paMC4u7STB0OkAAo60opu6oSQy1YAhPQ+NuRMV3+0DJkd4sZXvUxFYzODXbSphRfx5OO5n7gS1brDlVb9o+6aKSfyMZEsxUQFRNTqC5kcKYaY6UY0EfCsRzmiJIjZ27/0eFO7jsbz0lCl+mm97zf/dw497NepSC7GsLbFIVbGg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wVy5EBNT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wVy5EBNT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F05C1F00899;
	Thu, 17 Sep 2026 17:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664504;
	bh=IUVkgFYSbKcxvuWMAf19fPS/J6UrTmGxQLo4ELsydUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wVy5EBNToCJ6ptqrQcVENuMEOy2bZ+/pODDUcXTuERh11ORN8qU0C3V/oFoo1tYCz
	 hiouRSe5FtuWT6L9FrPQ7oGh+F7LH8FfL+7CeKr7BIJv9dHSnb4/5kG0eb7zTQFuHp
	 mHsSJ8HaNiHnXJ7j3kP3PlqiinZah2ZDsI4CI17c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurelien DESBRIERES <aurelien@hackers.camp>,
	Md Haris Iqbal <haris.iqbal@ionos.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0353/1250] RDMA/rtrs-srv: Fix integer underflow in process_read and process_write
Date: Thu, 17 Sep 2026 16:02:28 +0100
Message-ID: <20260917151601.635781797@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 1fc67fdff9fc2..12a9a888fe0ee 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -1049,6 +1049,11 @@ static void process_read(struct rtrs_srv_con *con,
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
@@ -1056,7 +1061,6 @@ static void process_read(struct rtrs_srv_con *con,
 	id->dir		= READ;
 	id->msg_id	= buf_id;
 	id->rd_msg	= msg;
-	usr_len = le16_to_cpu(msg->usr_len);
 	data_len = off - usr_len;
 	data = page_address(srv->chunks[buf_id]);
 	ret = ctx->ops.rdma_ev(srv->priv, id, data, data_len,
@@ -1102,6 +1106,11 @@ static void process_write(struct rtrs_srv_con *con,
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
@@ -1109,7 +1118,6 @@ static void process_write(struct rtrs_srv_con *con,
 	id->dir    = WRITE;
 	id->msg_id = buf_id;
 
-	usr_len = le16_to_cpu(req->usr_len);
 	data_len = off - usr_len;
 	data = page_address(srv->chunks[buf_id]);
 	ret = ctx->ops.rdma_ev(srv->priv, id, data, data_len,
-- 
2.53.0



