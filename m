Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE9C175A69;
	Sat, 28 Feb 2026 17:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301377; cv=none; b=ND3Ms+npRhk7SU/XFl2VBVcTkltijiZcM4BtWPccPYgPlt+SUDUPHbnJy9VcCOAj/fuAGI/BNAN6J3oWDae5xBI3NFtpYEmsGQ+fjqwViFo6LGjPTnlRZgOm/iuC9iy7kj8f7tqg0naldQb9FHDB6bYbNeEtFiCRSRfAKJ8oA+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301377; c=relaxed/simple;
	bh=GVG2CccgbtedmWaGhiaA33rg9BGO31x0WCbImzpyZac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sz2ty7LRcI5zgrH4F/NfBOYHkWNPBO2Eg4lYvKzLIeqpp+xWje4b6jHr7wrxhGwQQ76Y1MrPI9sQwlWhFdJqvqnBrukmDRFtPQ/+92MzqkaBt+fXzdq5Kv+EuksYpuYT2IH7X4wKILMVT2VaWRBvvsoHDqbmQgdCRXow/iPykGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NtRRZ8X4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NtRRZ8X4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 675DEC19425;
	Sat, 28 Feb 2026 17:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301377;
	bh=GVG2CccgbtedmWaGhiaA33rg9BGO31x0WCbImzpyZac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NtRRZ8X47NRSx3JZnvSk7FCihXZIMUIi1NzY/RiJS4TYCvlAfML1HHxT2AetfIzqb
	 8s5AFDHmcpXIDaRYNj3VbOC8DqS26aQv0l03e0TnEn4vUpjHKRDMoD9e2FN+LbZ5Q5
	 uBqPn2suOyXjoRuGHSNqn6kSe95y8xGELKhruR3d8Ma8E83/YTTL3dD+4Z8TSW+ERG
	 kt+dgBTvK5P3nFZWPEowQOWJFFxoztJDG7jYqRm0AOnkouPby94VL/gzcyYaRkkXYF
	 HKGvTKSyWqVpyFcMO3o3tdQwlLhmbV2CsSmtHW+vyJ6U2GDWkJ1RRcTbNkgKr2QpbC
	 St9gtJA5af2IQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>,
	Vikash Garodia <vikash.garodia@oss.qualcomm.com>,
	stable@vger.kernel.org,
	Bryan O'Donoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 566/752] Revert "media: iris: Add sanity check for stop streaming"
Date: Sat, 28 Feb 2026 12:44:37 -0500
Message-ID: <20260228174750.1542406-566-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>

[ Upstream commit 370e19042fb8ac68109f8bdb0fdd8118baf39318 ]

This reverts commit ad699fa78b59241c9d71a8cafb51525f3dab04d4.

Revert the check that skipped stop_streaming when the instance was in
IRIS_INST_ERROR, as it caused multiple regressions:

1. Buffers were not returned to vb2 when the instance was already in
   error state, triggering warnings in the vb2 core because buffer
   completion was skipped.

2. If a session failed early (e.g. unsupported configuration), the
   instance transitioned to IRIS_INST_ERROR. When userspace attempted
   to stop streaming for cleanup, stop_streaming was skipped due to the
   added check, preventing proper teardown and leaving the firmware
   in an inconsistent state.

Fixes: ad699fa78b59 ("media: iris: Add sanity check for stop streaming")
Signed-off-by: Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>
Reviewed-by: Vikash Garodia <vikash.garodia@oss.qualcomm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/iris/iris_vb2.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/qcom/iris/iris_vb2.c b/drivers/media/platform/qcom/iris/iris_vb2.c
index db8768d8a8f61..139b821f7952f 100644
--- a/drivers/media/platform/qcom/iris/iris_vb2.c
+++ b/drivers/media/platform/qcom/iris/iris_vb2.c
@@ -231,8 +231,6 @@ void iris_vb2_stop_streaming(struct vb2_queue *q)
 		return;
 
 	mutex_lock(&inst->lock);
-	if (inst->state == IRIS_INST_ERROR)
-		goto exit;
 
 	if (!V4L2_TYPE_IS_OUTPUT(q->type) &&
 	    !V4L2_TYPE_IS_CAPTURE(q->type))
@@ -243,10 +241,10 @@ void iris_vb2_stop_streaming(struct vb2_queue *q)
 		goto exit;
 
 exit:
-	if (ret) {
-		iris_helper_buffers_done(inst, q->type, VB2_BUF_STATE_ERROR);
+	iris_helper_buffers_done(inst, q->type, VB2_BUF_STATE_ERROR);
+	if (ret)
 		iris_inst_change_state(inst, IRIS_INST_ERROR);
-	}
+
 	mutex_unlock(&inst->lock);
 }
 
-- 
2.51.0

