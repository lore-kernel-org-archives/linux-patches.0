Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25FB2175A66;
	Sat, 28 Feb 2026 17:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301375; cv=none; b=ZSr2OWxVLVDxSmeQnaKNhQaHwtStvOUIKnLqxIJWLK/8oBhfmoZAZAObHIXJ7OI1d8ucN7gTHGiIMthk+dRAPAWapoY6HgqPjBDLgDcwyOiCXTdOtM3QxLFAaRk7MTtKB7hKTE0/fs8Ql5RVovSbpUDj9s3SndtGqZmpk9RuxJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301375; c=relaxed/simple;
	bh=3NghqsS5OpVK0C7E29HYkyKv7cngY4P93owtSeXWf7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JwqjswN1rtQLpuNiR+wS2Mmq9NZquqFJdYenMFC1pdeJhdyJnmn6Z3K9W3tZNomZddPEwUNVxAyQ8Kap1OSo2lluEQEf+LdLM3mMxDnPNOl3cAxiZuRiyBZDUeEr8DPSQhMPXRw1jGUMvObhaFtH+SqqqRAiPsrCy/1gRf1SaU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GFsH2c4m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GFsH2c4m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48D85C19424;
	Sat, 28 Feb 2026 17:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301375;
	bh=3NghqsS5OpVK0C7E29HYkyKv7cngY4P93owtSeXWf7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GFsH2c4mYGSb4uZRK/vwqJcWOncmyFP0Iy7sREq5PMlLY2Nz8j2H3E/ugCBbfKKFC
	 pD9jWG2dsPLnxjzFx7GnaV/xtklOZFovHi8hlXCtjRYitGOmQvthDpTvvNBJCx7mPS
	 uB3YLJMyVPmsUDZFzc8mZhuZby+58v67TzaPif9TcZcouHjhBSbkUTg5TOyvM25j2T
	 nWgSrdsbAZ8vQmEdiR8JXNnZF1hpJY3jVkvg4avMgnT6wJD9mbg//gdSASQi9xyuAA
	 AxPuE5EbWgD9egH6qZl57+34u4Elc2W44FVNmUvagIxXfUZQARiDmxL0XEIT5AndIn
	 49riVfHfGotqQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Renjiang Han <renjiang.han@oss.qualcomm.com>,
	Vikash Garodia <vikash.garodia@oss.qualcomm.com>,
	stable@vger.kernel.org,
	Bryan O'Donoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 564/752] media: venus: vdec: fix error state assignment for zero bytesused
Date: Sat, 28 Feb 2026 12:44:35 -0500
Message-ID: <20260228174750.1542406-564-sashal@kernel.org>
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

From: Renjiang Han <renjiang.han@oss.qualcomm.com>

[ Upstream commit 93ecd6ee95c38cb533fa25f48d3c1c8cb69f410f ]

When hfi_session_flush is issued, all queued buffers are returned to
the V4L2 driver. Some of these buffers are not processed and have
bytesused = 0. Currently, the driver marks such buffers as error even
during drain operations, which can incorrectly flag EOS buffers.

Only capture buffers with zero payload (and not EOS) should be marked
with VB2_BUF_STATE_ERROR. The check is performed inside the non-EOS
branch to ensure correct handling.

Fixes: 51df3c81ba10b ("media: venus: vdec: Mark flushed buffers with error state")
Signed-off-by: Renjiang Han <renjiang.han@oss.qualcomm.com>
Reviewed-by: Vikash Garodia <vikash.garodia@oss.qualcomm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/vdec.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index 55c27345b7d89..ba4d9087bff5d 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -1442,10 +1442,10 @@ static void vdec_buf_done(struct venus_inst *inst, unsigned int buf_type,
 				inst->drain_active = false;
 				inst->codec_state = VENUS_DEC_STATE_STOPPED;
 			}
+		} else {
+			if (!bytesused)
+				state = VB2_BUF_STATE_ERROR;
 		}
-
-		if (!bytesused)
-			state = VB2_BUF_STATE_ERROR;
 	} else {
 		vbuf->sequence = inst->sequence_out++;
 	}
-- 
2.51.0

