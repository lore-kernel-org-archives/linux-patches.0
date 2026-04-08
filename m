Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFEFB34AB06;
	Wed,  8 Apr 2026 18:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674544; cv=none; b=PF/o5HXl/uD/ja/Q4GUatVhSxPlmvKRMIxZcOAR6HcvgEYrIdYctBcYSUV5SWeLId9FiKM0EjKWUlW5kTW4NibdDFHfDdyHW54k3+xRoXMTg23YPtZg5EIXokBM+Er4pazsCrfrqRatP8VsK/wQ0eq5eQwYJfuFSziKTgPDK7so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674544; c=relaxed/simple;
	bh=ugL37jODfL3A5ogWd/rea1VYOQc6R4ZooW3jzJluwBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=haQTjZOuk1yYHXYQ3UB750BAvM6qpVbW+NpY/o7CkEsUmyWwo+Nnul9oB6m1WaQkamkZTsebZMHpJtA3TPbkckqz/5bgOO21lNb1BDXINciFfGcXuwXiiIYENiS2PclXhKVQqdjBLHiA/XB2BMGeHLuj+EezvbO1v7QcIThBo2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nN4RZhSH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nN4RZhSH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A0EDC19421;
	Wed,  8 Apr 2026 18:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674543;
	bh=ugL37jODfL3A5ogWd/rea1VYOQc6R4ZooW3jzJluwBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nN4RZhSH6iZQcb3sEqg/6n882+1FUoEKtRWcjfOdZdgtOf7oefX27OeMr+baL9sSx
	 Dh7Wh8i8RBGWXBmEbsiWafFXUCWXVNd8Jfh6KtEHuYu/yII4mxXO/9FI4yDQg1Q6ac
	 KBnK/orLF2QfMLD3XrG2W5YyrFeaOk3UOLVzwnWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 106/311] rds: ib: reject FRMR registration before IB connection is established
Date: Wed,  8 Apr 2026 20:01:46 +0200
Message-ID: <20260408175943.372353542@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit a54ecccfae62c5c85259ae5ea5d9c20009519049 ]

rds_ib_get_mr() extracts the rds_ib_connection from conn->c_transport_data
and passes it to rds_ib_reg_frmr() for FRWR memory registration. On a
fresh outgoing connection, ic is allocated in rds_ib_conn_alloc() with
i_cm_id = NULL because the connection worker has not yet called
rds_ib_conn_path_connect() to create the rdma_cm_id. When sendmsg() with
RDS_CMSG_RDMA_MAP is called on such a connection, the sendmsg path parses
the control message before any connection establishment, allowing
rds_ib_post_reg_frmr() to dereference ic->i_cm_id->qp and crash the
kernel.

The existing guard in rds_ib_reg_frmr() only checks for !ic (added in
commit 9e630bcb7701), which does not catch this case since ic is allocated
early and is always non-NULL once the connection object exists.

 KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
 RIP: 0010:rds_ib_post_reg_frmr+0x50e/0x920
 Call Trace:
  rds_ib_post_reg_frmr (net/rds/ib_frmr.c:167)
  rds_ib_map_frmr (net/rds/ib_frmr.c:252)
  rds_ib_reg_frmr (net/rds/ib_frmr.c:430)
  rds_ib_get_mr (net/rds/ib_rdma.c:615)
  __rds_rdma_map (net/rds/rdma.c:295)
  rds_cmsg_rdma_map (net/rds/rdma.c:860)
  rds_sendmsg (net/rds/send.c:1363)
  ____sys_sendmsg
  do_syscall_64

Add a check in rds_ib_get_mr() that verifies ic, i_cm_id, and qp are all
non-NULL before proceeding with FRMR registration, mirroring the guard
already present in rds_ib_post_inv(). Return -ENODEV when the connection
is not ready, which the existing error handling in rds_cmsg_send() converts
to -EAGAIN for userspace retry and triggers rds_conn_connect_if_down() to
start the connection worker.

Fixes: 1659185fb4d0 ("RDS: IB: Support Fastreg MR (FRMR) memory registration mode")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Reviewed-by: Allison Henderson <achender@kernel.org>
Link: https://patch.msgid.link/20260330163237.2752440-2-bestswngs@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/ib_rdma.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
index 6585164c70595..dd08ccc4246da 100644
--- a/net/rds/ib_rdma.c
+++ b/net/rds/ib_rdma.c
@@ -604,8 +604,13 @@ void *rds_ib_get_mr(struct scatterlist *sg, unsigned long nents,
 		return ibmr;
 	}
 
-	if (conn)
+	if (conn) {
 		ic = conn->c_transport_data;
+		if (!ic || !ic->i_cm_id || !ic->i_cm_id->qp) {
+			ret = -ENODEV;
+			goto out;
+		}
+	}
 
 	if (!rds_ibdev->mr_8k_pool || !rds_ibdev->mr_1m_pool) {
 		ret = -ENODEV;
-- 
2.53.0



