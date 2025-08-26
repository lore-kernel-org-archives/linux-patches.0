Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669F717332C;
	Tue, 26 Aug 2025 11:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207448; cv=none; b=LP5HX3/80SXPKhkitiHQHJR1GlmDcDUoXs8XE2lJszC8wrUyztvbDHqYDrEtUzL7+0AuT+tWtowZr5gT95a8PXCZ8qGahGIm4AhuseTO3SEAO9fpoSeIZFMS8kWQTrpDZvTnHjMubWKmLV7Gui7f2/YCNJOfLCDXSCBfigTnUpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207448; c=relaxed/simple;
	bh=y5ZdgUEiOeZ2+JrOyHp1Bnvbuj9Avk+n4S3qyrRyj7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mTMVrPgX0e/MAO4Q4VS3fAG2ODVV8/5EAiqpoGFOX76eeXYM+eaL+LAa23EQymdNBHf0REGjihtJFoXoxOSij0cfrwoK+XcvuubS79w29jJrERfoWohd1QnXld04VMH1qaJptcWu/ueCdu9BPyrOVDldQrJ1+1ByvA7K0MCq0gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wg7dJJRj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wg7dJJRj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A95C4CEF1;
	Tue, 26 Aug 2025 11:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207448;
	bh=y5ZdgUEiOeZ2+JrOyHp1Bnvbuj9Avk+n4S3qyrRyj7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wg7dJJRj9MpWBfL3wXYndyb+NVAsmk+7dD3AMiNvr+goznaLAEA/Kk2t3v15SDQmz
	 cX846TQ7Yjd6V0RaRKvctyNwH6qlgJwuMrSQ/ohADvtPrbj5Ye3qjHnD93M19G6o3M
	 kNSDH+1+oy139OkPgpUCZY6aRZKIsfas9y448hYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.16 154/457] media: iris: Fix buffer preparation failure during resolution change
Date: Tue, 26 Aug 2025 13:07:18 +0200
Message-ID: <20250826110941.180596795@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dikshita Agarwal <quic_dikshita@quicinc.com>

commit 91c6d55b477e1b66578c268214e915dff9f5ea57 upstream.

When the resolution changes, the driver internally updates the width and
height, but the client continue to queue buffers with the older
resolution until the last flag is received. This results in a mismatch
when the buffers are prepared, causing failure due to outdated size.

Introduce a check to prevent size validation during buffer preparation
if a resolution reconfiguration is in progress, to handle this.

Cc: stable@vger.kernel.org
Fixes: 17f2a485ca67 ("media: iris: implement vb2 ops for buf_queue and firmware response")
Reviewed-by: Vikash Garodia <quic_vgarodia@quicinc.com>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-QRD
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-HDK
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-QRD
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-HDK
Signed-off-by: Dikshita Agarwal <quic_dikshita@quicinc.com>
Tested-by: Vikash Garodia <quic_vgarodia@quicinc.com> # on sa8775p-ride
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/iris/iris_vb2.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/qcom/iris/iris_vb2.c b/drivers/media/platform/qcom/iris/iris_vb2.c
index cdf11feb590b..b3bde10eb6d2 100644
--- a/drivers/media/platform/qcom/iris/iris_vb2.c
+++ b/drivers/media/platform/qcom/iris/iris_vb2.c
@@ -259,13 +259,14 @@ int iris_vb2_buf_prepare(struct vb2_buffer *vb)
 			return -EINVAL;
 	}
 
-	if (vb->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE &&
-	    vb2_plane_size(vb, 0) < iris_get_buffer_size(inst, BUF_OUTPUT))
-		return -EINVAL;
-	if (vb->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE &&
-	    vb2_plane_size(vb, 0) < iris_get_buffer_size(inst, BUF_INPUT))
-		return -EINVAL;
-
+	if (!(inst->sub_state & IRIS_INST_SUB_DRC)) {
+		if (vb->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE &&
+		    vb2_plane_size(vb, 0) < iris_get_buffer_size(inst, BUF_OUTPUT))
+			return -EINVAL;
+		if (vb->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE &&
+		    vb2_plane_size(vb, 0) < iris_get_buffer_size(inst, BUF_INPUT))
+			return -EINVAL;
+	}
 	return 0;
 }
 
-- 
2.50.1



