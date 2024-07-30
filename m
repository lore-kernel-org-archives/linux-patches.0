Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355581A76BE;
	Tue, 30 Jul 2024 17:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360009; cv=none; b=fsgkrf29N0WEXue6rWtMmR4cdXxPPO9IviagRJtsZfeWP/A8aKA/+EjZstmrrYDACgk7fgkDAZgbYd0GKoIvwpeVMI3SvOvTX9jiAft5Vp/Wj3tKsHuQTUSRmppYxC+aPegPuxVEm7p5d3h2oW3IjicRNIPpfCSjXMqY3YXw+B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360009; c=relaxed/simple;
	bh=RnoX8hY+4bfXNTvT01CxTMsn54b55v6iU55pWQ0G0b8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iqGyanYdQBljH7Op+7ziCakf39zhwE/DxyseHDDhOvUdzyGFCpY+11kSvYsznPECHd+AYTVUBIg+PRaRs9nOA0CyB1+jZIZBwM5AsQE/F30Y6c2SvODpNAexZFTwvQeZloe5uNLdoKF4obxdZnHSBlCKXTvrpGxiM37llAJfrsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zjl0ky8J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zjl0ky8J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F8A3C32782;
	Tue, 30 Jul 2024 17:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360009;
	bh=RnoX8hY+4bfXNTvT01CxTMsn54b55v6iU55pWQ0G0b8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zjl0ky8JOJ68YmixMXdTiv6xJEc7oH7LFRBbEaK0EVbgKC/gky0nFE9OuBwXf3keI
	 HGdXkvjL8y01cBnHScJ/B6+mo2sMf6ZrvFeDFQ2tNUOdF81pupDv+sfetsbVAYXr3e
	 8TjN+5w+LzR+xreExsLf/LWwqdQ4z9Wp5jcxOi30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Stanimir Varbanov <stanimir.k.varbanov@gmail.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.10 569/809] media: venus: fix use after free in vdec_close
Date: Tue, 30 Jul 2024 17:47:25 +0200
Message-ID: <20240730151747.248834837@linuxfoundation.org>
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


