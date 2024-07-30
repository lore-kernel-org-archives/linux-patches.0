Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8E38BE8;
	Tue, 30 Jul 2024 16:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357259; cv=none; b=cgbjY/nWr/oCVcDBRmLH0mahRgRpDZWtinKfzbx2dmhyGFn9Zh2nQpByn331q92P6r/yKhM9EBFkcVrmDSSE9Wlu/YaYax8MtaOzXRJ6H12qa93E8y40uhRM5/O+xjXqgxqueoyZn0HpdY9mIplm0GfZM3iJDU3AypLKIkLce0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357259; c=relaxed/simple;
	bh=NsLgrLxXX3LaTlDWBQxijqzdwTMFai8LoUzzuCfMm0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ofT5QGkz+N18ad3xnoSpnB4eXehpqgv2YGFXd8NgAa3g/KDeyI20EENjJWmDR43yZTNPRF8QSRVYeYHZmrwKMfZiYptuAfQcYZK7v11Lxyy0Dq6BnV0TzuysP1hDDTpgt0m3WPjQ2ISvsIZAOZRg73OMIo7Ulkofc82i0R6670w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Egb2BBjO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Egb2BBjO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C98B2C32782;
	Tue, 30 Jul 2024 16:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357259;
	bh=NsLgrLxXX3LaTlDWBQxijqzdwTMFai8LoUzzuCfMm0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Egb2BBjO869gyBrYGDEEVVl03cfVTSTJRlQrhbPgWwVSVWKulP8xcH/FeX+MfzVWu
	 YMix9j0rE6z/ukMaNRHxzQohG9SvlRRG+1Y6Us4Ipb9cx2cUJFwg1GcgRd843/cL72
	 Rgfv/Vqgkw0x1XD/NOl871KBvE90qd8WnyJADZh0=
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
Subject: [PATCH 6.6 234/568] media: venus: flush all buffers in output plane streamoff
Date: Tue, 30 Jul 2024 17:45:41 +0200
Message-ID: <20240730151649.026101242@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index dbf305cec1202..c57187283b012 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -1255,7 +1255,7 @@ static int vdec_stop_output(struct venus_inst *inst)
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



