Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD4E17CA1F;
	Sun,  1 Sep 2024 16:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208696; cv=none; b=Xg7zRyiPPNR9FlonAySCGVNotmW+xO5x1VWThu6BTeUksV3iauqMqIvz/YN0DQYDbSkmhMgrOIAvVsrwm6xHyY70LMKEH73pNQMijN2fGsLt/JskIFvc4jqkJFiV+9sQBSwxoF6bd2lV3ThoCCtU6yW/G9b7ucFoyO4/vdlGXgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208696; c=relaxed/simple;
	bh=775453cZbTktHxyT0jWBxN3ceeoJmiSsW7Jz8QUstNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C++XWPHwb24pnMnY6v5HcGYcJUP4QUcJsHaNWR5gRqWq+5a2FwHYZtVF1ENfGHA97OkhY9oJq2HfGPJK3CGTH2DriI1bZlVCBHoFoEgw0gyY8NXcNp+Jde3qiwAmnMUMeHAiHMryKJAfJvUgf8AdnWKw9GXFoYdzrf5bP45ccVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y/comlBO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y/comlBO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CEC3C4CEC3;
	Sun,  1 Sep 2024 16:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208695;
	bh=775453cZbTktHxyT0jWBxN3ceeoJmiSsW7Jz8QUstNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y/comlBOceyajhRjOjWJtd0pwPut8/+jDHVWC/xy/5hoIltihH/xJ6f19DyaM0her
	 Bh+/e1K2ojWf0Tas7StXV8GpfWEK476ethtcBYd/FX9TMBsxoPY+8bWQcFyWV2lmdi
	 FyvCvEe8nb2eaW0VrMN3G1ziQ/hIG8cUdvEMQPME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 012/134] drm/amdgpu: Actually check flags for all context ops.
Date: Sun,  1 Sep 2024 18:15:58 +0200
Message-ID: <20240901160810.574658989@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

From: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>

commit 0573a1e2ea7e35bff08944a40f1adf2bb35cea61 upstream.

Missing validation ...

Checked libdrm and it clears all the structs, so we should be
safe to just check everything.

Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit c6b86421f1f9ddf9d706f2453159813ee39d0cf9)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
@@ -401,16 +401,24 @@ int amdgpu_ctx_ioctl(struct drm_device *
 
 	switch (args->in.op) {
 	case AMDGPU_CTX_OP_ALLOC_CTX:
+		if (args->in.flags)
+			return -EINVAL;
 		r = amdgpu_ctx_alloc(adev, fpriv, filp, priority, &id);
 		args->out.alloc.ctx_id = id;
 		break;
 	case AMDGPU_CTX_OP_FREE_CTX:
+		if (args->in.flags)
+			return -EINVAL;
 		r = amdgpu_ctx_free(fpriv, id);
 		break;
 	case AMDGPU_CTX_OP_QUERY_STATE:
+		if (args->in.flags)
+			return -EINVAL;
 		r = amdgpu_ctx_query(adev, fpriv, id, &args->out);
 		break;
 	case AMDGPU_CTX_OP_QUERY_STATE2:
+		if (args->in.flags)
+			return -EINVAL;
 		r = amdgpu_ctx_query2(adev, fpriv, id, &args->out);
 		break;
 	default:


