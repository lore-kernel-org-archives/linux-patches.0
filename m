Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E96233E3
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:44:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE32C433EF;
	Mon,  8 May 2023 11:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683546260;
	bh=MadcbRIcGy7cFLfNucmmaRzOhkxL5sGm2T/Iikid0qA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VVNIBPvsSOO/e9sF7nxCIn87lh8nnWSsgjEavvRc1l0+b7xZTrmq644+j9qTOApmm
	 b5c5Pcm1MeG2foKrq3HqV+WqVSsF+mEZjk/f/bja5/LFGxtFGZ7YrVe1VZU99WxarU
	 CzKyRoC9AH4IpSVrLwZqlt4qmhbvarvsm8qy1xp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Zhang <markzhang@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 309/371] RDMA/cm: Trace icm_send_rej event before the cm state is reset
Date: Mon,  8 May 2023 11:48:30 +0200
Message-Id: <20230508094824.312787992@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mark Zhang <markzhang@nvidia.com>

[ Upstream commit bd9de1badac7e4ff6780365d4aa38983f5e2a436 ]

Trace icm_send_rej event before the cm state is reset to idle, so that
correct cm state will be logged. For example when an incoming request is
rejected, the old trace log was:
    icm_send_rej: local_id=961102742 remote_id=3829151631 state=IDLE reason=REJ_CONSUMER_DEFINED
With this patch:
    icm_send_rej: local_id=312971016 remote_id=3778819983 state=MRA_REQ_SENT reason=REJ_CONSUMER_DEFINED

Fixes: 8dc105befe16 ("RDMA/cm: Add tracepoints to track MAD send operations")
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
Link: https://lore.kernel.org/r/20230330072351.481200-1-markzhang@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 5c910f5c01b35..680c3ac8cd4c0 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -2914,6 +2914,8 @@ static int cm_send_rej_locked(struct cm_id_private *cm_id_priv,
 	    (ari && ari_length > IB_CM_REJ_ARI_LENGTH))
 		return -EINVAL;
 
+	trace_icm_send_rej(&cm_id_priv->id, reason);
+
 	switch (state) {
 	case IB_CM_REQ_SENT:
 	case IB_CM_MRA_REQ_RCVD:
@@ -2944,7 +2946,6 @@ static int cm_send_rej_locked(struct cm_id_private *cm_id_priv,
 		return -EINVAL;
 	}
 
-	trace_icm_send_rej(&cm_id_priv->id, reason);
 	ret = ib_post_send_mad(msg, NULL);
 	if (ret) {
 		cm_free_msg(msg);
-- 
2.39.2



