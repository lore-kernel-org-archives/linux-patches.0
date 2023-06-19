Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF78AD26
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:59:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39BD8C433C8;
	Mon, 19 Jun 2023 10:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687172380;
	bh=Uhj/GLWd43QzEMU0YbmTGm/Om3uvwpTiKF1EUZbV8nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XA+O8IaCWUm5ZrjuRmunCyxkdW+rtmu5j4QVVCWHh6MlHPJ4JP9qgINx2DrCu6m9/
	 hRpZOvC0eWG9qJWYA4QKoR15fS+lKDMv+eR1QaPvSWU9qd7/5GeiPcC9VeJBPTZomU
	 6ulhCpQWrDNYH95YcuUhvvZTzt8paYLczAi4NWf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 5.15 047/107] RDMA/uverbs: Restrict usage of privileged QKEYs
Date: Mon, 19 Jun 2023 12:30:31 +0200
Message-ID: <20230619102143.768739121@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102141.541044823@linuxfoundation.org>
References: <20230619102141.541044823@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Edward Srouji <edwards@nvidia.com>

commit 0cadb4db79e1d9eea66711c4031e435c2191907e upstream.

According to the IB specification rel-1.6, section 3.5.3:
"QKEYs with the most significant bit set are considered controlled
QKEYs, and a HCA does not allow a consumer to arbitrarily specify a
controlled QKEY."

Thus, block non-privileged users from setting such a QKEY.

Cc: stable@vger.kernel.org
Fixes: bc38a6abdd5a ("[PATCH] IB uverbs: core implementation")
Signed-off-by: Edward Srouji <edwards@nvidia.com>
Link: https://lore.kernel.org/r/c00c809ddafaaf87d6f6cb827978670989a511b3.1685960567.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/uverbs_cmd.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1851,8 +1851,13 @@ static int modify_qp(struct uverbs_attr_
 		attr->path_mtu = cmd->base.path_mtu;
 	if (cmd->base.attr_mask & IB_QP_PATH_MIG_STATE)
 		attr->path_mig_state = cmd->base.path_mig_state;
-	if (cmd->base.attr_mask & IB_QP_QKEY)
+	if (cmd->base.attr_mask & IB_QP_QKEY) {
+		if (cmd->base.qkey & IB_QP_SET_QKEY && !capable(CAP_NET_RAW)) {
+			ret = -EPERM;
+			goto release_qp;
+		}
 		attr->qkey = cmd->base.qkey;
+	}
 	if (cmd->base.attr_mask & IB_QP_RQ_PSN)
 		attr->rq_psn = cmd->base.rq_psn;
 	if (cmd->base.attr_mask & IB_QP_SQ_PSN)


