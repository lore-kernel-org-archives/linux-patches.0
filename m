Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B1E4F0526;
	Wed, 30 Sep 2026 16:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785814; cv=none; b=ezHJTbpJRn4/gaHWjqg3ZwN3a+2X75CHqTobuDWMWIfRIOISCqwq/L85CfVujOu18eA5i9qL3xDCZR78iISAig+VKejlzQmmAYUxUxgePY7RNXnTngCXSCkm7u7S3kmtq5TivHftcdGcbjQgjswyN6yT+lA2aoDMIvETsm6wB0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785814; c=relaxed/simple;
	bh=6mk4cYuKnss8J0J9A7P6Rwa1NV8pwQ5XwLpSWYmo7v0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kj6EmDTI559+IbP/wFa/xiy+WSwPXYajc2NMPe16tg+dWTOZp+BmT/bgSFalIb9iNBfaLoUIZmB31hcAeL0wnDIszmnb8SocX3vEhoNoBvhgbkIe27WWwxC+C5NbgU1KW8BMqtvLnW0bMCc5K5l8DbfoXN/rMrPTXj0NoDkucAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dbKEwJjO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dbKEwJjO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A914F1F000FF;
	Wed, 30 Sep 2026 16:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785813;
	bh=JwxZVhmERjnlSxyDYrj2axutUSCxB2gxj3fVEZQr19c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dbKEwJjO1ctrJ17Eol+zevKwtEO+DyD3C0MXBK39nXC3CygAkORLTtNorOVvA3kfV
	 i8WLdHDRYz3+QJqomC/M/RxoB/4TQbetmOlT1+JRh86AVbMn0pbORPPKkpucqFnr2V
	 4UlGgqCL0bsMe8N9Y5/WpZqWN23fzsTDmubpCVq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Guoqing Jiang <guoqing.jiang@linux.dev>,
	Bernard Metzler <bernard.metzler@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 596/982] RDMA/siw: Clear association under lock if siw_qp_modify fails in siw_accept
Date: Wed, 30 Sep 2026 17:22:12 +0200
Message-ID: <20260930152429.585115286@linuxfoundation.org>
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

From: Guoqing Jiang <guoqing.jiang@linux.dev>

[ Upstream commit 32cd87f54dd1070020e664ccb0312a9f0fea79b4 ]

We need to clear cep before release state_lock as siw_qp_llp_close and
siw_qp_modify->siw_qp_llp_close did.

Otherwise if siw_qp_modify() fails in siw_accept(), the QP's state_lock
is released before the error path cleanup. A concurrent ibv_modify_qp()
transitioning the QP to ERROR can race in this window:

  siw_accept()                       ibv_modify_qp(ERROR)
  ----------------------             ----------------------
  siw_qp_modify() fails
  up_write(&qp->state_lock)
                                     down_write(&qp->state_lock)
                                     nextstate_from_idle():
				     if (qp->cep)
                                       siw_cep_put(qp->cep) <- frees cep
                                       qp->cep = NULL
  goto error
    cep->qp = NULL                   <- UAF

Clear qp->cep and drop the association reference taken by siw_cep_get(),
all under the write lock held from the initial down_write(&qp->state_lock).
Thread B therefore sees qp->cep == NULL, skips its own put, and cannot free
the cep before siw_accept() is done with it.

Fixes: 6c52fdc244b5 ("rdma/siw: connection management")
Reported-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Link: https://lore.kernel.org/linux-rdma/d6fbe475-a5c2-f975-99b0-a0bd6b6d10e8@linux.dev/T/#m5876c1ff2de8686a9a1173b8f1aa0ff5363a785c
Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
Link: https://patch.msgid.link/20260827125553.12831-1-guoqing.jiang@linux.dev
Acked-by: Bernard Metzler <bernard.metzler@linux.dev>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_cm.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
index 629ed5e58473d..19932fc8856d7 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -1668,9 +1668,12 @@ int siw_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 			   SIW_QP_ATTR_STATE | SIW_QP_ATTR_LLP_HANDLE |
 				   SIW_QP_ATTR_ORD | SIW_QP_ATTR_IRD |
 				   SIW_QP_ATTR_MPA);
+	if (rv) {
+		qp->cep = NULL;
+		siw_cep_put(cep);
+		goto error_unlock;
+	}
 	up_write(&qp->state_lock);
-	if (rv)
-		goto error;
 
 	siw_dbg_cep(cep, "[QP %u]: send mpa reply, %d byte pdata\n",
 		    qp_id(qp), params->private_data_len);
-- 
2.53.0



