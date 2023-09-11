Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 407261170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:18:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B548AC433C8;
	Mon, 11 Sep 2023 14:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441909;
	bh=fMFQk2xA5ht0o7iEAvhQ+Eml2ROTqeAm3D9ekscxgQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E46e7DSfkjj7cnCQFECQzPwpD21Xfu8FC9KawDa9b2J77feih1FhI7YBck+O59C55
	 464zF1enzN72P0fuiQ7aM+2c+fprXSBC2J7RzwnKIdy7HETHbOTa5HfPB0cgymffI4
	 b3MkRlURQjKsyveuw0VEfZcU9yERJomtzIgIwN2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoqing Jiang <guoqing.jiang@linux.dev>,
	Bernard Metzler <bmt@zurich.ibm.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 578/739] RDMA/siw: Balance the reference of cep->kref in the error path
Date: Mon, 11 Sep 2023 15:46:17 +0200
Message-ID: <20230911134707.249583503@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guoqing Jiang <guoqing.jiang@linux.dev>

[ Upstream commit b056327bee09e6b86683d3f709a438ccd6031d72 ]

The siw_connect can go to err in below after cep is allocated successfully:

1. If siw_cm_alloc_work returns failure. In this case socket is not
assoicated with cep so siw_cep_put can't be called by siw_socket_disassoc.
We need to call siw_cep_put twice since cep->kref is increased once after
it was initialized.

2. If siw_cm_queue_work can't find a work, which means siw_cep_get is not
called in siw_cm_queue_work, so cep->kref is increased twice by siw_cep_get
and when associate socket with cep after it was initialized. So we need to
call siw_cep_put three times (one in siw_socket_disassoc).

3. siw_send_mpareqrep returns error, this scenario is similar as 2.

So we need to remove one siw_cep_put in the error path.

Fixes: 6c52fdc244b5 ("rdma/siw: connection management")
Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
Link: https://lore.kernel.org/r/20230821133255.31111-2-guoqing.jiang@linux.dev
Acked-by: Bernard Metzler <bmt@zurich.ibm.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_cm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
index da530c0404da4..a2605178f4eda 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -1501,7 +1501,6 @@ int siw_connect(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 
 		cep->cm_id = NULL;
 		id->rem_ref(id);
-		siw_cep_put(cep);
 
 		qp->cep = NULL;
 		siw_cep_put(cep);
-- 
2.40.1



