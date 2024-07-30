Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C8371A0724;
	Tue, 30 Jul 2024 16:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356171; cv=none; b=EymXcxoO/Aj+cI1y91X1MDJIuUXuXDgNI0Ow3YxwAVbbzhUmjhrH6hVgrXsic1Aoz5viGGIqkYTRwmsdsMe1hyZw04OZYQvvcio0NHTrADaU49yPHwxSSf0XP8nNUOor9hDSzZNUh2+JsVbZlkm+NeuSn8DxPnD3tOHFHFF3vvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356171; c=relaxed/simple;
	bh=KVexSoLEnKHpzM9ZYZ5kzb53SkGaYK6aUMAKhb47lDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KVIJEKA7p3jI/nBnilG+UyAGuaCCbwlBAAmzbtuB+xDbBpLgOHV0iSeuvsSdkhd0hvSyKWgzbQWuACd+08HYHQ/85FrPT5Jn5h/AMDGtgDaW8XDXVKBGAYW9HA8Ss60oooz+rN0/SghcR8+07tLw6S/i6feno8dN48C/HsH66DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b6CphrpU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b6CphrpU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C69CC32782;
	Tue, 30 Jul 2024 16:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356171;
	bh=KVexSoLEnKHpzM9ZYZ5kzb53SkGaYK6aUMAKhb47lDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b6CphrpUfcBW3InKtd0eQ27ok+50g1o2T1PO38cuzHm2hPpqDsI7dNf3bfG2PhKJZ
	 tIo0H+XuEmELpbEpYQpCZUM9TCV1o/ICku9VWA2GkjEYfFMN2Mq5vUylA80A2rUFOO
	 kXADpuFSi4seQCsVyVp0zpT3y/GiuPUpAtjcMeNU=
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
Subject: [PATCH 6.1 165/440] media: venus: flush all buffers in output plane streamoff
Date: Tue, 30 Jul 2024 17:46:38 +0200
Message-ID: <20240730151622.316468970@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1a52c2ea2da5b..9c00afd261aa3 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -1221,7 +1221,7 @@ static int vdec_stop_output(struct venus_inst *inst)
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



