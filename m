Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3988D2ECD23;
	Tue, 17 Jun 2025 16:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177510; cv=none; b=Pltou+iee5G2+6csxuz0674Z7E8jUNz0VLm+fRBJGJ2CEWdymMQJFWBB6mOCoQc73q1XDCLt1P83TApvx3stpyNNmVDe0NO3Knj8l147yzmM1fWQsX/iB840dJ/g2XanbA0KhXKrG/1x5sU0ctriudy2+YBpCS6GDwmMyKcpdvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177510; c=relaxed/simple;
	bh=FPbCxWyjGpnLHbDtbkHx8w8XjkFYosu9wVqYu8GowSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QCwIZgz10790CRNsE2M8Qy84Pz+0mizuh6cVMV6JiHm6iO6OEEeYOHM9fALbQqXYkPmNdLng3Uzqfy665DmN0hzpLcXjjzt66GiJvs43on6EBONrB/mZ4tZz9oFVr90+e8XcpETbtfjdkG1EDrRETbvs0qOy45HOjvVan4kM2QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0cG7WjkG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0cG7WjkG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F379C4CEE7;
	Tue, 17 Jun 2025 16:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177510;
	bh=FPbCxWyjGpnLHbDtbkHx8w8XjkFYosu9wVqYu8GowSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0cG7WjkGPcUU7+l5kaUhPV78kj9596pi+lgpxRAT6tJG6+81no33d2+GQfYEUbcWL
	 cOtjDfuQDnFFsNKekuppvU3u/Mh6CZbrWG70BvM6wKnD9oicNJXmbj398fFlVufqM/
	 7WAWwdS4hbz1CrFPQlDcbG0Y5tk9iEI/ejiPIbCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 317/780] octeontx2-af: Send Link events one by one
Date: Tue, 17 Jun 2025 17:20:25 +0200
Message-ID: <20250617152504.368098680@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Subbaraya Sundeep <sbhatta@marvell.com>

[ Upstream commit ba5cb47b56e5d89f0a5eb5163ffbfda1e3e7cef0 ]

Send link events one after another otherwise new message
is overwriting the message which is being processed by PF.

Fixes: a88e0f936ba9 ("octeontx2: Detect the mbox up or down message via register")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/1747823443-404-1-git-send-email-sbhatta@marvell.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c | 2 ++
 drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c    | 2 ++
 drivers/net/ethernet/marvell/octeontx2/af/rvu_rep.c    | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c b/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c
index 655dd4726d36e..0277d226293e9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c
@@ -143,6 +143,8 @@ static int mcs_notify_pfvf(struct mcs_intr_event *event, struct rvu *rvu)
 
 	otx2_mbox_msg_send_up(&rvu->afpf_wq_info.mbox_up, pf);
 
+	otx2_mbox_wait_for_rsp(&rvu->afpf_wq_info.mbox_up, pf);
+
 	mutex_unlock(&rvu->mbox_lock);
 
 	return 0;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index 992fa0b82e8d2..ebb56eb0d18cf 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -272,6 +272,8 @@ static void cgx_notify_pfs(struct cgx_link_event *event, struct rvu *rvu)
 
 		otx2_mbox_msg_send_up(&rvu->afpf_wq_info.mbox_up, pfid);
 
+		otx2_mbox_wait_for_rsp(&rvu->afpf_wq_info.mbox_up, pfid);
+
 		mutex_unlock(&rvu->mbox_lock);
 	} while (pfmap);
 }
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_rep.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_rep.c
index 052ae5923e3a8..32953cca108c8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_rep.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_rep.c
@@ -60,6 +60,8 @@ static int rvu_rep_up_notify(struct rvu *rvu, struct rep_event *event)
 
 	otx2_mbox_msg_send_up(&rvu->afpf_wq_info.mbox_up, pf);
 
+	otx2_mbox_wait_for_rsp(&rvu->afpf_wq_info.mbox_up, pf);
+
 	mutex_unlock(&rvu->mbox_lock);
 	return 0;
 }
-- 
2.39.5



