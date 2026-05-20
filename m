Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8A140DFDE;
	Wed, 20 May 2026 18:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779303054; cv=none; b=lDgOe5fMCwd8hG+1u5qe5pBi2pgI8jgBP5B2MRXjOr1XO7yn2rBEN7CGsH3vcrofAQ2xzHFBN7AiA0NCCESKIQPNUFIw1BxH6laXdl7VWGKBCOhLnygn38IT3xofDnRkR/NKD0P/g/5Y27O8AfbrthuILGUHgtiwLwTMR2B6xqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779303054; c=relaxed/simple;
	bh=0AjAOyFlpAY3ZeEu4gBUoMldYGLAit+xh0flllt/f70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PYXQKPUJOAcphe1q3a3uqHdQ/scKoaBunatHs+StpSrbkdmcyXE6gUrpP9ymQSRqhM6mVYvQ3INj1UVaUTo0pzQK+nICCZ8WEgk3ZKWY/A1NoNJJBcWHEJaKjroDtalVqU+Z5KYgyvzOtIYlNp/LAVR8Bk3aQL4OCO6HpN/4jcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ei3P9HfQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ei3P9HfQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1AA71F000E9;
	Wed, 20 May 2026 18:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779303051;
	bh=lALji4hn0cPDK4Dr2nzNqpPfmiOKh1PoLtRkNX3EveM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ei3P9HfQpglZAGSUMAsMuQBDZyuUjY20wBzWDEzBvKTmoGdQc9Oyg8vGtSW7KGfnR
	 3u4WUxYaKuTIHbWtNloJCdDdat1CtXJaXzc0DKBNIsUOzVCimhoaUPUZK6oqBS7Z/9
	 T7js6y1EZlMfAGOIJOnT1zqAmC/Hs1vzq+GIQo4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 500/508] RDMA/mana: Fix error unwind in mana_ib_create_qp_rss()
Date: Wed, 20 May 2026 18:25:23 +0200
Message-ID: <20260520162109.434720306@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 6aaa978c6b6218cfac15fe1dab17c76fe229ce3f ]

Sashiko points out that mana_ib_cfg_vport_steering() is leaked, the normal
destroy path cleans it up.

Cc: stable@vger.kernel.org
Fixes: 0266a177631d ("RDMA/mana_ib: Add a driver for Microsoft Azure Network Adapter")
Link: https://sashiko.dev/#/patchset/0-v1-e911b76a94d1%2B65d95-rdma_udata_rep_jgg%40nvidia.com?part=4
Link: https://patch.msgid.link/r/7-v1-41f3135e5565+9d2-rdma_ai_fixes1_jgg@nvidia.com
Reviewed-by: Long Li <longli@microsoft.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mana/qp.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/hw/mana/qp.c
+++ b/drivers/infiniband/hw/mana/qp.c
@@ -237,13 +237,15 @@ static int mana_ib_create_qp_rss(struct
 		ibdev_dbg(&mdev->ib_dev,
 			  "Failed to copy to udata create rss-qp, %d\n",
 			  ret);
-		goto fail;
+		goto err_disable_vport_rx;
 	}
 
 	kfree(mana_ind_table);
 
 	return 0;
 
+err_disable_vport_rx:
+	mana_disable_vport_rx(mpc);
 fail:
 	while (i-- > 0) {
 		ibwq = ind_tbl->ind_tbl[i];


