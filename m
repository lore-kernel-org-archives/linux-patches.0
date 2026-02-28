Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0892175A60;
	Sat, 28 Feb 2026 17:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301386; cv=none; b=Bh+sKwp/oz70c3yD+AZ/KzUejMDkvXOAt/DC9fNDlYwbAa27RxnUBXiEC3ZflRnMOX/jN6Nv8df2QKpj46iTYHEX9swixCmnuwvJMG+c2AnFXqPd9JDj2CtATjQ+qdQabCmRzUdswQa8f3RpstH4TpHhuXrsT0FRC94JOpDr6Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301386; c=relaxed/simple;
	bh=lUk5O7eESbsqaWrLs1QVzAae7+Xwt4nGb9/uTpw8K34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aiRMw5DLvzLu07sqhO6yuwMkgVffMVMgZiBS6OwXyespt/V9AoZl/sLOKk8mp/8ZhFzzhXU9154+MwYhOqKZx+TJnyRqDFj0IvwaV4U30mwnJMPdeiFQtvZ/gNqc1iIZ7aiHbhOXN8xX+Yd3cOqoaNlOsJvDg9IPABRSC35VLmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hDsaSTqV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hDsaSTqV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6218C116D0;
	Sat, 28 Feb 2026 17:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301385;
	bh=lUk5O7eESbsqaWrLs1QVzAae7+Xwt4nGb9/uTpw8K34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hDsaSTqV94gsdToWXC7MoxBgmKpRMdgSufsxrQvTAYh+yJQomilM0rn0VZSN+oLLs
	 +TM3buMRoQpLUiw+u4MIJAcQ1nLcp/y4HK0UFPwNwUPLL4GJa/bf40MHzLQHXSfeIx
	 fvHt5+hdyXbe9aOKnhD8dwpC1QO6ufH7S8yA0D5BEtQQv6S48rVybqZ2ORe5DIzIwm
	 JHyT0OOEACFPQJBwhJd5UWCLepTq3Kg2aXnyxXDBaPRCxZ0C2lizGXAPAqqhlpclkX
	 OXre04pCnRIFnk36AdLOT7yIQAZMmNuMvT/PVCylJk6chPtq2PetJWybO6HS0P4Oku
	 X8E3xWkHZ8xPQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Vishnu Reddy <busanna.reddy@oss.qualcomm.com>,
	Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>,
	Vikash Garodia <vikash.garodia@oss.qualcomm.com>,
	stable@vger.kernel.org,
	Bryan O'Donoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 574/752] media: iris: Prevent output buffer queuing before stream-on completes
Date: Sat, 28 Feb 2026 12:44:45 -0500
Message-ID: <20260228174750.1542406-574-sashal@kernel.org>
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

From: Vishnu Reddy <busanna.reddy@oss.qualcomm.com>

[ Upstream commit 2c73cfd0cfc44ffe331ccb81f6ac45fc399d9ddb ]

During normal playback, stream-on for input is followed by output, and
only after input stream-on does actual streaming begin. However, when
gst-play performs a seek, both input and output streams are stopped,
and on restart, output stream-on occurs first. At this point, firmware
has not yet started streaming. Queuing output buffers before the firmware
begins streaming causes it to process buffers in an invalid state, leading
to an error response. These buffers are returned to the driver as errors,
forcing the driver into an error state and stopping playback.

Fix this by deferring output buffer queuing until stream-on completes.
Input buffers can still be queued before stream-on as required.

Fixes: 92e007ca5ab6 ("media: iris: Add V4L2 streaming support for encoder video device")
Signed-off-by: Vishnu Reddy <busanna.reddy@oss.qualcomm.com>
Signed-off-by: Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>
Reviewed-by: Vikash Garodia <vikash.garodia@oss.qualcomm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/iris/iris_vb2.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/qcom/iris/iris_vb2.c b/drivers/media/platform/qcom/iris/iris_vb2.c
index 139b821f7952f..bf0b8400996ec 100644
--- a/drivers/media/platform/qcom/iris/iris_vb2.c
+++ b/drivers/media/platform/qcom/iris/iris_vb2.c
@@ -193,10 +193,14 @@ int iris_vb2_start_streaming(struct vb2_queue *q, unsigned int count)
 	buf_type = iris_v4l2_type_to_driver(q->type);
 
 	if (inst->domain == DECODER) {
-		if (inst->state == IRIS_INST_STREAMING)
+		if (buf_type == BUF_INPUT)
+			ret = iris_queue_deferred_buffers(inst, BUF_INPUT);
+
+		if (!ret && inst->state == IRIS_INST_STREAMING) {
 			ret = iris_queue_internal_deferred_buffers(inst, BUF_DPB);
-		if (!ret)
-			ret = iris_queue_deferred_buffers(inst, buf_type);
+			if (!ret)
+				ret = iris_queue_deferred_buffers(inst, BUF_OUTPUT);
+		}
 	} else {
 		if (inst->state == IRIS_INST_STREAMING) {
 			ret = iris_queue_deferred_buffers(inst, BUF_INPUT);
-- 
2.51.0

