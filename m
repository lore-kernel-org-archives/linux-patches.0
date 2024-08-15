Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05AD919F473;
	Thu, 15 Aug 2024 14:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731457; cv=none; b=Ppqmqq4XbeF+sK7mk5vVsq51szF0gUpNwC6KTPAfrWN2Vmnjzznlgm8bKkYbVf3/wE9PtR3Vo91YncfGXia8PeP7vV3ZSC9mg3Vt+fHZtNR1RnFEa6q1I1DQnnR6/cEEl0OXUreETHDpnaTjM+FcCingHIaRCxFGpDUBiOiEdP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731457; c=relaxed/simple;
	bh=qq0K9JD4Qpt9DfDPDwD22iS5qTINQCgs1k98tcAKCHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jM2lJnON0IBI0nX6rt1MYuuO14POTxUlIt9USIV5UewUq5CT6ZwEzv6NYELt0HCL0E1f3d7Wosdd8jMSQHc1J65/TKeQHAw19QJiTYbPL8w2JyFUTuOF4xeYzjsI/BO/ilUSZg5SByLrl807fDKzPl9jy+pxslEVM4DtrpMwECU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I+mVtbGT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I+mVtbGT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C0C6C4AF0A;
	Thu, 15 Aug 2024 14:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731456;
	bh=qq0K9JD4Qpt9DfDPDwD22iS5qTINQCgs1k98tcAKCHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I+mVtbGTKylNDeQcCXABpiB1VEqX5Ut8ZO7CR6CQa/S+rgAVmyihiPxfbBji+/ZMF
	 fiUQt9Vpzke8+9fQS6aY3V0GD5ELhp0Usv60A10kZpVSGkjCGY5P6AatYfcmTrs2qL
	 c5qa3fK9vBY4ls4+Nm7Xcon/wZ/DUbPRkKOPO1Lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Stanimir Varbanov <stanimir.k.varbanov@gmail.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 5.4 094/259] media: venus: fix use after free in vdec_close
Date: Thu, 15 Aug 2024 15:23:47 +0200
Message-ID: <20240815131906.433400799@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1400,6 +1400,7 @@ static int vdec_close(struct file *file)
 {
 	struct venus_inst *inst = to_inst(file);
 
+	cancel_work_sync(&inst->delayed_process_work);
 	v4l2_m2m_ctx_release(inst->m2m_ctx);
 	v4l2_m2m_release(inst->m2m_dev);
 	vdec_ctrl_deinit(inst);


