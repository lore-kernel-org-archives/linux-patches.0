Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7554D1F76BB;
	Tue,  3 Dec 2024 15:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240619; cv=none; b=VYmGSNKeAJ3NtoQv0Iry9Lf+mDSPnAt43fR4dSo8HUJuZE+cLNh4hvv5o8Z/WxB/2/VOdROBBT5hAZqGTyk2uP01WDsR98OXtJwPMrK7d1zNOSKYcE8DYf2lRuupgA2WonILi3tbyQPdQ9LlzLLyaOn4SqNVbcDjojQvRNx/79U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240619; c=relaxed/simple;
	bh=kU0g5Cwm9XsxSqFZf3u8X7blZM8obLqDyaBGvcH/+ig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LmNShvemkgD9XKCUhWhsEfPYHUKoZEI80g/wkReq9YpC779Qg1MI29yX23OTpBVe2oauuENdbt6i13ckt/D3Md0rbViwYWSdMgR5pcRUjWgY/ZgapKw8mb3bMcmyUU93qnP8zyKdcTKtsD0zSx8vpC+FL5azY2Z+JKGY39W4nDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=agvthce5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="agvthce5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2388C4CECF;
	Tue,  3 Dec 2024 15:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240619;
	bh=kU0g5Cwm9XsxSqFZf3u8X7blZM8obLqDyaBGvcH/+ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=agvthce5SZDvqLOrgQK+4Mg7j+5f7JPJ3OkJkkc8EVBOflF28reYEz72jelxPnpoZ
	 TIlSy/5TVxhdb0cd5r4/PhrMAl2lB9mTBHYG2tg2yT0kDy0tLbJdmTr9tBGHPQ+t9h
	 7GktGVseWRgRac6lCgtKkEBkO0iXymNkhUqW8peg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomasz Figa <tfiga@google.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Stanimir Varbanov <stanimir.k.varbanov@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 171/826] media: venus: fix enc/dec destruction order
Date: Tue,  3 Dec 2024 15:38:18 +0100
Message-ID: <20241203144750.402737096@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Senozhatsky <senozhatsky@chromium.org>

[ Upstream commit 6c9934c5a00ae722a98d1a06ed44b673514407b5 ]

We destroy mutex-es too early as they are still taken in
v4l2_fh_exit()->v4l2_event_unsubscribe()->v4l2_ctrl_find().

We should destroy mutex-es right before kfree().  Also
do not vdec_ctrl_deinit() before v4l2_fh_exit().

Fixes: 7472c1c69138 ("[media] media: venus: vdec: add video decoder files")
Suggested-by: Tomasz Figa <tfiga@google.com>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Stanimir Varbanov <stanimir.k.varbanov@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/vdec.c | 7 ++++---
 drivers/media/platform/qcom/venus/venc.c | 6 +++---
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index d12089370d91e..4af268e756883 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -1750,13 +1750,14 @@ static int vdec_close(struct file *file)
 	cancel_work_sync(&inst->delayed_process_work);
 	v4l2_m2m_ctx_release(inst->m2m_ctx);
 	v4l2_m2m_release(inst->m2m_dev);
-	vdec_ctrl_deinit(inst);
 	ida_destroy(&inst->dpb_ids);
 	hfi_session_destroy(inst);
-	mutex_destroy(&inst->lock);
-	mutex_destroy(&inst->ctx_q_lock);
 	v4l2_fh_del(&inst->fh);
 	v4l2_fh_exit(&inst->fh);
+	vdec_ctrl_deinit(inst);
+
+	mutex_destroy(&inst->lock);
+	mutex_destroy(&inst->ctx_q_lock);
 
 	vdec_pm_put(inst, false);
 
diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index 3ec2fb8d9fab6..56777d3d630a5 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -1517,14 +1517,14 @@ static int venc_close(struct file *file)
 
 	v4l2_m2m_ctx_release(inst->m2m_ctx);
 	v4l2_m2m_release(inst->m2m_dev);
-	venc_ctrl_deinit(inst);
 	hfi_session_destroy(inst);
-	mutex_destroy(&inst->lock);
-	mutex_destroy(&inst->ctx_q_lock);
 	v4l2_fh_del(&inst->fh);
 	v4l2_fh_exit(&inst->fh);
+	venc_ctrl_deinit(inst);
 
 	inst->enc_state = VENUS_ENC_STATE_DEINIT;
+	mutex_destroy(&inst->lock);
+	mutex_destroy(&inst->ctx_q_lock);
 
 	venc_pm_put(inst, false);
 
-- 
2.43.0



