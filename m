Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A183433C1B6;
	Fri,  9 Jan 2026 12:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960979; cv=none; b=HdsoCVVPdOVsVcyn8sdfpTuiRX4MwfbSfMQaLa1ltW6XXwzP0KDaL5qKMfkplvlEHPQpEAykiizRPSXUnGpFXPy29oMZEdsFDL8xuqlEp05hpg7symj9Dlq9mCJW7v2PLjojsk9lSeeeNEvF+dSOo1KUVtrBf7pA1nU9BpPCrfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960979; c=relaxed/simple;
	bh=wbXfi7QWty/ixCCu3lminBOKAhbywFU6jB+ARyQTrac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bBtmvTWGRz44bQG5wUmJYAU6+1fMsJ468nYZ6U303aaNp85sVyV0IYHviqUxWoq5+EVHDYBUEL0FUMcGrqz9k9CcB5492XD4h+MO0JQIuWX9iuVfCBUbLiqh1ZJT5hhTy16Fnnkp8cZ0PorWM+IGpG7aLnbYOBqxgGmdVxGgFgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NLjbYXwa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NLjbYXwa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3312FC4CEF1;
	Fri,  9 Jan 2026 12:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960979;
	bh=wbXfi7QWty/ixCCu3lminBOKAhbywFU6jB+ARyQTrac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NLjbYXwaDmzT+SS90y8OkJWzjmauhUen1ArfrzXMZJJbY0hoT9ShIzFAtWm7cNhbA
	 hYKpiSe9SHmUlPCLVaj9sq+BqkbpU4g0nv5w/v+nuvdQPBHdJ+vXx659VBMYptLdxh
	 kdrN6maVsFQjHGU8fAn5T6HCtTQA9M58fVqvz+Fk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@oss.nxp.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 592/737] media: amphion: Cancel message work before releasing the VPU core
Date: Fri,  9 Jan 2026 12:42:11 +0100
Message-ID: <20260109112156.272786719@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Ming Qian <ming.qian@oss.nxp.com>

commit ae246b0032146e352c4c06a7bf03cd3d5bcb2ecd upstream.

To avoid accessing the VPU register after release of the VPU core,
cancel the message work and destroy the workqueue that handles the
VPU message before release of the VPU core.

Fixes: 3cd084519c6f ("media: amphion: add vpu v4l2 m2m support")
Cc: stable@vger.kernel.org
Signed-off-by: Ming Qian <ming.qian@oss.nxp.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/amphion/vpu_v4l2.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/media/platform/amphion/vpu_v4l2.c
+++ b/drivers/media/platform/amphion/vpu_v4l2.c
@@ -682,15 +682,15 @@ static int vpu_v4l2_release(struct vpu_i
 {
 	vpu_trace(inst->vpu->dev, "%p\n", inst);
 
-	vpu_release_core(inst->core);
-	put_device(inst->dev);
-
 	if (inst->workqueue) {
 		cancel_work_sync(&inst->msg_work);
 		destroy_workqueue(inst->workqueue);
 		inst->workqueue = NULL;
 	}
 
+	vpu_release_core(inst->core);
+	put_device(inst->dev);
+
 	v4l2_ctrl_handler_free(&inst->ctrl_handler);
 	mutex_destroy(&inst->lock);
 


