Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C8219EED0;
	Thu, 15 Aug 2024 13:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729466; cv=none; b=AjbzsgtE8WkXEc8fdOLT+G008yl4a9qmj1gx9iJH3p85LVc8UHlSggCkJFLuQZQgeZsfHhPDMlswAukg72QYQL3KVDHUINb9Tl8DWu0poqg9Yr5GSvgVhhhN6pONyQ2FKY8/HgLjy6NQZ/kb0fmQTc0N/ksRkI7VqcAd/ubycvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729466; c=relaxed/simple;
	bh=eH0oF00EQoM871yTlWqROie0vMRbV1tKtZ1Y0LhpTG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BgzGhlrNyEEB9ZQnxMrkH+jQm8nZ/pk6ceWB/LQWU4m5oY+wFQE/lg3LA7nwRB5pVhL5mJJrZdyBHxwtChSKxCd/AlbUSCcPzxu5H2wZtcJiKSHWd3a2FlTfTQ2GdQmgmsS6VPEY/y68uxhIrW7hToSmoWHPm0EgcOYKbopSkCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VWB/yDg8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VWB/yDg8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 653F1C32786;
	Thu, 15 Aug 2024 13:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729465;
	bh=eH0oF00EQoM871yTlWqROie0vMRbV1tKtZ1Y0LhpTG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VWB/yDg8Xfb5QtTw2mfwKS4+p9zZyo437c6lRrVeeiC6ssKcR7g7r7CcxmR5Thsd8
	 L9ISWsDVhCoHBSt73AciWY/jSCMnBTlMs9U+Nr3TIYrGa3ER4i0JkIy6efoyOTiT99
	 gn0W1gamCd/hCxNwgk1AHdd3g0JonnSaVO2Hp3hI=
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
Subject: [PATCH 5.15 107/484] media: venus: flush all buffers in output plane streamoff
Date: Thu, 15 Aug 2024 15:19:25 +0200
Message-ID: <20240815131945.427803640@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6e0466772339a..94fb20d283ea4 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -1165,7 +1165,7 @@ static int vdec_stop_output(struct venus_inst *inst)
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



