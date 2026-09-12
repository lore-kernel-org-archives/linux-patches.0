Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29AB38DC72;
	Sat, 12 Sep 2026 14:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224888; cv=none; b=Xn+i+i3ne8tTFwO1XJW5ya5SPmHT8g8lCQQVSzCQq6pIaikXLueyiGlg140tuh46tgxxyAdt8i693qhSjvhu4BG8FUYHMtrrsvmlim0Rd1nsPjHaTsO582drpchiMjD7B+e2mhO7tMVK59rVAwSBOtSA4ycgf6cqn/n0vHn0dzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224888; c=relaxed/simple;
	bh=avBKaNIkR01s3zHa+KLIoCS9ns1n7Ic3DCkSpvovM3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nr1W8kIvbwk3+CafoUKUFC3TPLdX8Zjk0PJZEASoUH6a+CAd6n1b3XOMMIMWA/N4TDqjlm1vXmgzayZQM9IwlnJbyctkxm8q/qWcF7RoD3/OLRb4PKQnoNE22Btp8ysu29NuzCP69ysEq0UPwS/FhdIB3C0COCX+YJ1EaPbu9Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JaOovjJu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JaOovjJu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43F671F000FF;
	Sat, 12 Sep 2026 14:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224886;
	bh=IxfabEz29Vafke8xYVzYXaOm4UEvX6v0JSse9ge8zuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JaOovjJujDvajhJWe3K4XGkUfgc0XV1c9k49MMTdqlCUl1EZRvTfObXPgz+qO5Izd
	 oVZmaExSNNhcMXpCqgJgtjN87ixx667uGyiagXaRKP0FBk4oWO1zussvHzWIJh7vcT
	 W/yeGZpcYNytb8wC2SRDk0KDffVbe9wX2etIcs9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1083/1424] RDMA/siw: Fix use-after-free in siw_accept()
Date: Sat, 12 Sep 2026 08:58:35 +0200
Message-ID: <20260912065631.559543973@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>

[ Upstream commit a9394971825933074032794a5feee5211509c774 ]

siw_accept() looks up the QP supplied by userspace. If that QP is
already in RTS, the function jumps to error cleanup before associating
the incoming CEP with it.

The cleanup tests whether qp->cep is non-NULL and assumes the current
call installed the association. However, qp->cep can point to the CEP
of an existing connection. The cleanup then drops a reference from the
incoming cep, not qp->cep. Once the incoming endpoint loses its
remaining references, this can free it before the subsequent cep->qp
store, causing a use-after-free. It also clears the existing QP
association.

Only release the association reference when qp->cep is the incoming
CEP. This preserves an existing association and avoids accessing the
freed endpoint.

Fixes: 6c52fdc244b5 ("rdma/siw: connection management")
Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Link: https://patch.msgid.link/20260801213632.1086548-1-shuangpeng.kernel@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_cm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
index 6ce8150278dd4..a04c1fcabfcc4 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -1717,7 +1717,7 @@ int siw_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 	cep->state = SIW_EPSTATE_CLOSED;
 
 	siw_free_cm_id(cep);
-	if (qp->cep) {
+	if (qp->cep == cep) {
 		siw_cep_put(cep);
 		qp->cep = NULL;
 	}
-- 
2.53.0



