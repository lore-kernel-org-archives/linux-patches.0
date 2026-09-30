Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1277B4EF12D;
	Wed, 30 Sep 2026 19:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797159; cv=none; b=Rw+j8byvdo29WRkjnf6otYM+GLdJNv9zZfp/ucvxdy6f0Vn4uaPuKL5WzmyM7BHPSsKPz3xC5X2hGjzFO//fibdEs0J2ayyVrIn78OfF+EpYl1rYgN7Ho0bFpEM91Ie+n9jxJ7F9U+bhQ3apfh1vodCKUgmJsDHUA8LCN78WfjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797159; c=relaxed/simple;
	bh=VH0hj8NlLuTFM4W6s4Yn9eSfUjD/hzqWeUNeqd+pCxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kh8WL3vSYmIjSEDHrHslKADTwCChigicIM10ckpvgc4xz0xCCwnT9hzxW3+vjVafr+wGJ697I5aC7Y4PlXmRY6tC4ewsCNyO6ygjW0jflZ7MTI7WF0kdDvEIpSMxAmRv5PiiiJmFc5ZEbpvfIuvB51ql7cK15C9h1lqQPsy35YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UKlWKy9M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UKlWKy9M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA8A1F000FF;
	Wed, 30 Sep 2026 19:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797156;
	bh=SAK/rt5Fdrw4MHqXzY08Oh61Ba6vafhz0kRBS0bPBE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UKlWKy9MH261NzYqdxS6F3dGGLwxg8LT/pLVVATOkcVdngX+/imEy/T+5R4lWLYRk
	 xozvJCS1PaKBplf2rhIV1mFgkvFEEWzt/m3QcroHKRoWOkNLr80RtSHHGpcQsmljRx
	 Q6vnsv7zwJTGPimtgW1SgqlsBElWF8ujGy1Mzrt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chunguang Xu <chunguang.xu@shopee.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Artem Dinaburg <artem@trailofbits.com>
Subject: [PATCH 6.6 1167/1193] nvme-fabrics: use reserved tag for reg read/write command
Date: Wed, 30 Sep 2026 17:30:51 +0200
Message-ID: <20260930152500.172353162@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Chunguang Xu <chunguang.xu@shopee.com>

commit 7dc3bfcb4c9cc58970fff6aaa48172cb224d85aa upstream.

In some scenarios, if too many commands are issued by nvme command in
the same time by user tasks, this may exhaust all tags of admin_q. If
a reset (nvme reset or IO timeout) occurs before these commands finish,
reconnect routine may fail to update nvme regs due to insufficient tags,
which will cause kernel hang forever. In order to workaround this issue,
maybe we can let reg_read32()/reg_read64()/reg_write32() use reserved
tags. This maybe safe for nvmf:

1. For the disable ctrl path,  we will not issue connect command
2. For the enable ctrl / fw activate path, since connect and reg_xx()
   are called serially.

So the reserved tags may still be enough while reg_xx() use reserved tags.

Signed-off-by: Chunguang Xu <chunguang.xu@shopee.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/fabrics.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -179,7 +179,7 @@ int nvmf_reg_read32(struct nvme_ctrl *ct
 	cmd.prop_get.offset = cpu_to_le32(off);
 
 	ret = __nvme_submit_sync_cmd(ctrl->fabrics_q, &cmd, &res, NULL, 0,
-			NVME_QID_ANY, 0, 0);
+			NVME_QID_ANY, 0, BLK_MQ_REQ_RESERVED);
 
 	if (ret >= 0)
 		*val = le64_to_cpu(res.u64);
@@ -225,7 +225,7 @@ int nvmf_reg_read64(struct nvme_ctrl *ct
 	cmd.prop_get.offset = cpu_to_le32(off);
 
 	ret = __nvme_submit_sync_cmd(ctrl->fabrics_q, &cmd, &res, NULL, 0,
-			NVME_QID_ANY, 0, 0);
+			NVME_QID_ANY, 0, BLK_MQ_REQ_RESERVED);
 
 	if (ret >= 0)
 		*val = le64_to_cpu(res.u64);
@@ -270,7 +270,7 @@ int nvmf_reg_write32(struct nvme_ctrl *c
 	cmd.prop_set.value = cpu_to_le64(val);
 
 	ret = __nvme_submit_sync_cmd(ctrl->fabrics_q, &cmd, NULL, NULL, 0,
-			NVME_QID_ANY, 0, 0);
+			NVME_QID_ANY, 0, BLK_MQ_REQ_RESERVED);
 	if (unlikely(ret))
 		dev_err(ctrl->device,
 			"Property Set error: %d, offset %#x\n",


