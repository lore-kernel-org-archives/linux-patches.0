Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D850330B03;
	Fri, 17 Oct 2025 15:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715768; cv=none; b=avDs4/CcuapL4yv1refAN6UBWUYHVf4Kl3LRmoDTnCzchN2w8e848dul3btwajEjN1l6A6HxhwTt8pcjrnxavt6sZIQSBgct14lmVrSrOAD59lHJXF5oKqM62yxWly4c2GVFNpkU0rU8ktuohNSXwjKspLZkaaM8UCeAq4SPXZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715768; c=relaxed/simple;
	bh=4nKA6rrBX0ejd5mj8k5g2kzeD9hMeKWRFjdo++ydCDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kVXkfF+830imwdqoYsJU4xlNwwPwvsVE0C1qXgjU8s/6xe0IJLsoBG6cGHxqFxghmRCmNHmu/MLG0nGHuwvax6CaJYQtCueuX3nJBjo0pzyfbU/2E9aE2Z144QPSYSe7PsiCxGsm+8Duc9nvWwXOk/Xds/G+fi+ue+CI4TaA5C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OE/xUVtG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OE/xUVtG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 995ABC4CEE7;
	Fri, 17 Oct 2025 15:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715768;
	bh=4nKA6rrBX0ejd5mj8k5g2kzeD9hMeKWRFjdo++ydCDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OE/xUVtGmZJdD1yUmzVKboRLj19b3h9T34tQBJpo1sdEDEyPqOA3zvT9vI4QTpkZ5
	 Uty/Qklf8BFwqQRrcR1+Cx1BeIGgYSvDmW6HUY9pzpKKiFGQiEHuc1jDnJwKPevnBU
	 d6KAAke2N2HEEIYmHBxR8hZn8D+OMIIdJCnVO+tc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Subject: [PATCH 6.17 330/371] media: iris: Allow substate transition to load resources during output streaming
Date: Fri, 17 Oct 2025 16:55:05 +0200
Message-ID: <20251017145214.017051441@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dikshita Agarwal <quic_dikshita@quicinc.com>

commit 65f72c6a8d97c0cbdc785cb9a35dc358dee67959 upstream.

A client (e.g., GST for encoder) can initiate streaming on the capture
port before the output port, causing the instance state to transition to
OUTPUT_STREAMING. When streaming is subsequently started on the output
port, the instance state advances to STREAMING, and the substate should
transition to LOAD_RESOURCES.

Previously, the code blocked the substate transition to LOAD_RESOURCES
if the instance state was OUTPUT_STREAMING. This update modifies the
logic to permit the substate transition to LOAD_RESOURCES when the
instance state is OUTPUT_STREAMING, thereby supporting this client
streaming sequence.

Fixes: 547f7b8c5090 ("media: iris: add check to allow sub states transitions")
Cc: stable@vger.kernel.org
Reviewed-by: Vikash Garodia <quic_vgarodia@quicinc.com>
Tested-by: Vikash Garodia <quic_vgarodia@quicinc.com> # X1E80100
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-HDK
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-HDK
Signed-off-by: Dikshita Agarwal <quic_dikshita@quicinc.com>
Tested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org> # x1e80100-crd
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/iris/iris_state.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/iris/iris_state.c b/drivers/media/platform/qcom/iris/iris_state.c
index 104e1687ad39..a21238d2818f 100644
--- a/drivers/media/platform/qcom/iris/iris_state.c
+++ b/drivers/media/platform/qcom/iris/iris_state.c
@@ -122,7 +122,8 @@ static bool iris_inst_allow_sub_state(struct iris_inst *inst, enum iris_inst_sub
 		return false;
 	case IRIS_INST_OUTPUT_STREAMING:
 		if (sub_state & (IRIS_INST_SUB_DRC_LAST |
-			IRIS_INST_SUB_DRAIN_LAST | IRIS_INST_SUB_OUTPUT_PAUSE))
+			IRIS_INST_SUB_DRAIN_LAST | IRIS_INST_SUB_OUTPUT_PAUSE |
+			IRIS_INST_SUB_LOAD_RESOURCES))
 			return true;
 		return false;
 	case IRIS_INST_STREAMING:
-- 
2.51.0



