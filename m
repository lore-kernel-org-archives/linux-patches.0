Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F425381
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:41:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEFBAC433C8;
	Mon, 19 Jun 2023 10:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171270;
	bh=ClUy4DzBevV1UPFaRliO4Le/uBALyWHLlMsDiCw849o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rHGYODqVk+ZfyMd9GKfSTIBPdlDOXFewWEXR3OhLuo1oElXmYs8c1T1y3aL2ywuhX
	 OqZOst2bVx7MBvZ5HKcquYsydDG0DDlqgNCQvtdje6K8aY13VMtFEs+XeKlZq1kLAP
	 FxGOp9zRCkyMvkSFTI9znR7b0aHOsWOe8yrcqZGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 4.19 20/49] RDMA/uverbs: Restrict usage of privileged QKEYs
Date: Mon, 19 Jun 2023 12:29:58 +0200
Message-ID: <20230619102130.907026961@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102129.856988902@linuxfoundation.org>
References: <20230619102129.856988902@linuxfoundation.org>
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
@@ -2041,8 +2041,13 @@ static int modify_qp(struct ib_uverbs_fi
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


