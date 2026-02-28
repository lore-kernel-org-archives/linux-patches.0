Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC20175A60;
	Sat, 28 Feb 2026 17:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301384; cv=none; b=dAhJG3w65Jg0Jp/O7VsMKuYNwC8LhxANmoukU6lvw6sNU/d/2Oot9XisrKlA8Ym4qJNWNvez2fRt01ytoXQg1gSvjKc4/aKMUDSZQ6bgZcd5Yegsue3Okf9tu5DkycwkEdqJ8bGdlV/jauIhraJa5bcVujWWHUzAPNDi8oVQvcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301384; c=relaxed/simple;
	bh=qV7v9kS6m/6P8WMSZtxiz2ZUxQi/5k/g8YN3QHnzPus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m5oLkKtvFxj2VL5yGClZ5Y4rZQHIHV7NR7H8IH+cdx+TM7A7kkiiDydTQSomYFoczWuYQzc5qkThXJnGJh/RchNdLBTFbA/SprKhpwa9IY6uSRVqe2npQR0+J8bRgIviMzLRPpYo3xfJS3n4GtozCkgx6S058hFnDn5uxQ4wThc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tx0mDMrL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tx0mDMrL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0283C19423;
	Sat, 28 Feb 2026 17:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301384;
	bh=qV7v9kS6m/6P8WMSZtxiz2ZUxQi/5k/g8YN3QHnzPus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tx0mDMrLl/kcyJqpUd0v9o/qLZbLLrkvl54wm3IScDiGJjjDj8v2wd34L0zl6WWXY
	 dd4YU6fQeWOYSDQomX3O2T7wqBUxubP9bEavwDRY42ww4KoVzSq22dVP+Slx2aQIll
	 jR896tcb5ZM35nZtxsQA6+BpjvsRpXoMDnagdLd/tUEeZfnaN7U/t6stKDPn80Blk0
	 7YnxTgF5MAIrBneNnt5F3tEF6kWYlEFJCzFBkrN2eNmEc+YuxO9uTiI3+x4NNUb5gh
	 fF4/4KS7Ff7bpnNuLkfeSaAnZsqb6xNOFQHCfSgR2FwraTj9+oJOxLyQI6JHhAt0KL
	 04AAR9ojGKNdg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>,
	Vikash Garodia <vikash.garodia@oss.qualcomm.com>,
	stable@vger.kernel.org,
	Bryan O'Donoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 573/752] media: iris: gen2: Add sanity check for session stop
Date: Sat, 28 Feb 2026 12:44:44 -0500
Message-ID: <20260228174750.1542406-573-sashal@kernel.org>
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

[ Upstream commit 9aa8d63d09cfc44d879427cc5ba308012ca4ab8e ]

In iris_kill_session, inst->state is set to IRIS_INST_ERROR and
session_close is executed, which will kfree(inst_hfi_gen2->packet).
If stop_streaming is called afterward, it will cause a crash.

Add a NULL check for inst_hfi_gen2->packet before sendling STOP packet
to firmware to fix that.

Fixes: 11712ce70f8e ("media: iris: implement vb2 streaming ops")
Signed-off-by: Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>
Reviewed-by: Vikash Garodia <vikash.garodia@oss.qualcomm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/iris/iris_hfi_gen2_command.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/qcom/iris/iris_hfi_gen2_command.c b/drivers/media/platform/qcom/iris/iris_hfi_gen2_command.c
index 4ce71a1425083..5f6e2c9407e67 100644
--- a/drivers/media/platform/qcom/iris/iris_hfi_gen2_command.c
+++ b/drivers/media/platform/qcom/iris/iris_hfi_gen2_command.c
@@ -946,6 +946,9 @@ static int iris_hfi_gen2_session_stop(struct iris_inst *inst, u32 plane)
 	struct iris_inst_hfi_gen2 *inst_hfi_gen2 = to_iris_inst_hfi_gen2(inst);
 	int ret = 0;
 
+	if (!inst_hfi_gen2->packet)
+		return -EINVAL;
+
 	reinit_completion(&inst->completion);
 
 	iris_hfi_gen2_packet_session_command(inst,
-- 
2.51.0

