Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80B4184549;
	Tue, 30 Jul 2024 16:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358615; cv=none; b=HDlvkhgcPlEcVXUOIrKLArXasmtfsIcGCbf3M3vN+DzW/7JIYc2iqiLSI/cbOyn8aI/GGvbnpXyF3QZXeoY2GVNyA3lo+Ke0WXZtIFcDAXEdQKyqQKCCabGEP2sL7dShE2JOUgcbOq22vjakrRZOGCmnsbC2BP5QW4qYq3pK6YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358615; c=relaxed/simple;
	bh=M1DvRi1PiKKvsLtaoemoYAG2gmDggzhXU0zbTGsTobU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MXkYZWSsdiwcYIWTw2bVZMNuAt6BrJPXZtn6tOWwARBUfYdFbuYAdF9Ms0IYbJZypMr+NSX2YWx9geAuoC1i9VPbG4vz93bduZu7JgG7bgbmeuJWopvTOtHXeRHP2RORBeUXjB43gihnMuoWSB4eOoJjBuhqD0I9Ht+YwMXQ17k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u2r7AiZC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u2r7AiZC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24609C4AF0F;
	Tue, 30 Jul 2024 16:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358614;
	bh=M1DvRi1PiKKvsLtaoemoYAG2gmDggzhXU0zbTGsTobU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u2r7AiZCy47d8LPmLwkJij07S/ffJHT9Mu2/ye2WujgxVCtMJWFQkNQ6hfgGWfVFO
	 4+9Pk74vGMT3dJ9Y89qJC3BEYlwjiE7zWxxKZK/RZmogqT8/ftkfdkb07xBxd+FziR
	 C0sbygGrxn9VAWkeefKWc6eiMzXLL0XX0/R4cJ04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Stanimir Varbanov <stanimir.k.varbanov@gmail.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.6 379/568] media: venus: fix use after free in vdec_close
Date: Tue, 30 Jul 2024 17:48:06 +0200
Message-ID: <20240730151654.680197290@linuxfoundation.org>
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

commit a0157b5aa34eb43ec4c5510f9c260bbb03be937e upstream.

There appears to be a possible use after free with vdec_close().
The firmware will add buffer release work to the work queue through
HFI callbacks as a normal part of decoding. Randomly closing the
decoder device from userspace during normal decoding can incur
a read after free for inst.

Fix it by cancelling the work in vdec_close.

Cc: stable@vger.kernel.org
Fixes: af2c3834c8ca ("[media] media: venus: adding core part and helper functions")
Signed-off-by: Dikshita Agarwal <quic_dikshita@quicinc.com>
Acked-by: Vikash Garodia <quic_vgarodia@quicinc.com>
Signed-off-by: Stanimir Varbanov <stanimir.k.varbanov@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/vdec.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -1747,6 +1747,7 @@ static int vdec_close(struct file *file)
 
 	vdec_pm_get(inst);
 
+	cancel_work_sync(&inst->delayed_process_work);
 	v4l2_m2m_ctx_release(inst->m2m_ctx);
 	v4l2_m2m_release(inst->m2m_dev);
 	vdec_ctrl_deinit(inst);


