Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B291A6195;
	Tue, 30 Jul 2024 16:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358471; cv=none; b=PxlduF4KHYgMcc5cpdXm+o48k/j21nyLZAGEO6ra8G5yA7GEde74UhgNutN5FeNfLep18nmai4SJAeckKN3ain8jQBb8dNT6m93gw5zwRx/LAcXl18VKPFGRqYjNmM+l5hTi/r1tfftcKgj6v42nEbkvN12pyGLJt6uPXhaCwP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358471; c=relaxed/simple;
	bh=Hd3Jdqo8dupcR9uYXngVVChpPPnePU+NOuL9/eBKQTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=prdubS5ysVbXmTi1+Uo0jPamhKs5ld0O7yr/ULua6nYatyqaKC91h6MwKqIME82P4zTYCOFbx6GgXvUx7+IDGFWv+nCg+4lRu+ZdNCSQTCHzSvnlTLeozoajD8wpVuZpd9hS76Z4Tj8uEznJlVanXARmZLNMqvlSqbiEdy2GzOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u/TNxvdh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u/TNxvdh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7D13C32782;
	Tue, 30 Jul 2024 16:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358471;
	bh=Hd3Jdqo8dupcR9uYXngVVChpPPnePU+NOuL9/eBKQTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u/TNxvdhN8+algcCRlUBn5fDV/fHTGGUCPk23tual3nnt92JD3/2YrJfZ3ZLR7/Vx
	 ZgLSUbAUVJ6sxAks2iyqR4e4uO8Gq+2YcMjHvimTY8DnmTtpykrLYIylJWRn1aG6f0
	 fhIdCLObYA0YGJLHCOuKDKSQpjhBxa3yO+4Jk5CU=
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
Subject: [PATCH 6.10 362/809] media: venus: flush all buffers in output plane streamoff
Date: Tue, 30 Jul 2024 17:43:58 +0200
Message-ID: <20240730151738.947897084@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 29130a9441e70..0d2ab95bec0f6 100644
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



