Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2640863D5;
	Thu, 15 Aug 2024 14:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732246; cv=none; b=CFJhBIMWXs3R2S9G6z1s3Jm7qBOdSWefvkbED8cZXXceWWIj5kx5tu7UoJ4OOxnwSqL6f7qM6ODHV2QEQegntPgQOj9tW8Kqd/yXls+EtoKxmZgagqG75akGEA0tQtVy47Ip7s1D2rXP0T+FVJjJ4um9vnUJ5hdCIaFFMf3DFR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732246; c=relaxed/simple;
	bh=DqOhuGOd0Pn3VJpwSdCxWvBmO4HqtgNpLMefvwKvjck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lgiz6k1JbsECy53KnwBkqL442fH6liBVtGvSB6fY+3e/Q0yCiPia6ygepHViydYAOaWI8YgD9W7OIXdUkeQsL0LfSzIG3Wy6lp6OZK9p0iMOr/fwjtrFWyHkSo6whhuFOWXBnBr/pqK/S6UqUaKtJyyo0jfD3p2KiIb9vC5qiHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S80Xmx5I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S80Xmx5I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 966CBC32786;
	Thu, 15 Aug 2024 14:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732246;
	bh=DqOhuGOd0Pn3VJpwSdCxWvBmO4HqtgNpLMefvwKvjck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S80Xmx5ICurFuwewzL0RGtXoEqyBvs7aN4zNOq2n4OoF5RfmI9bXrjuWc/v2W3kHE
	 wqxHi/3tuRuio8x886LB1Etf0U0OU7dJyPTRbKVX1SG/YGDSjq8TBLEDrpBLCKjDm2
	 /cIil+zshpeh0azeZH+zliyoKmarFQnO5iVbas7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Nathan Hebert <nhebert@chromium.org>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Stanimir Varbanov <stanimir.k.varbanov@gmail.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 088/352] media: venus: flush all buffers in output plane streamoff
Date: Thu, 15 Aug 2024 15:22:34 +0200
Message-ID: <20240815131922.661427215@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dikshita Agarwal <quic_dikshita@quicinc.com>

[ Upstream commit e750a4b1224142bd8dd057b0d5adf8a5608b7e77 ]

For scenarios, when source change is followed by VIDIOC_STREAMOFF
on output plane, driver should discard any queued OUTPUT
buffers, which are not decoded or dequeued.
Flush with HFI_FLUSH_INPUT does not have any actual impact.
So, fix it, by invoking HFI_FLUSH_ALL, which will flush all
queued buffers.

Fixes: 85872f861d4c ("media: venus: Mark last capture buffer")
Signed-off-by: Dikshita Agarwal <quic_dikshita@quicinc.com>
Tested-by: Nathan Hebert <nhebert@chromium.org>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Stanimir Varbanov <stanimir.k.varbanov@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/vdec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index c437a929a5451..b6edfa812bb7d 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -1142,7 +1142,7 @@ static int vdec_stop_output(struct venus_inst *inst)
 		break;
 	case VENUS_DEC_STATE_INIT:
 	case VENUS_DEC_STATE_CAPTURE_SETUP:
-		ret = hfi_session_flush(inst, HFI_FLUSH_INPUT, true);
+		ret = hfi_session_flush(inst, HFI_FLUSH_ALL, true);
 		break;
 	default:
 		break;
-- 
2.43.0



