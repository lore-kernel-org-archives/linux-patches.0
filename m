Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08001208A7;
	Sun,  1 Sep 2024 16:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209880; cv=none; b=DVQUes8Nh4d9CPx/DlU8fMgc/yxIz3f3PpNBxvUV5BeB3mf4hdoElvq9eRoV6MC0Pp/kNSsq//WWfCGhxRA8Kxcr5ofDAm+UUyJrf07K1RZtKzhwlPj4xg7J3EAIO3+Lm2zh4hML0B/JggJj8L3GBvrXCyewyrq/BiRA6ZBAImE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209880; c=relaxed/simple;
	bh=qVdatOM3tSyW2jUqzbxOivVb5KPa5UFvHSULSKkQA2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NZ7NcuU0QGEwds/05lQYb0EyV0nwnPRt4obv0ud9MEmKOOpzFO25ghqh/cXC4tuHSgVD76q8tLLlM2WvrzSbI+1At3bBDvqw8VPgP9RY0+1wkaZkRbIHUi7dq5ZC8jlRkWlj0Ll4Zxy9bGK28RhD+OQzsCg1JWST3V5UNdU8fi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=juj01Aoy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="juj01Aoy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F7D8C4CEC3;
	Sun,  1 Sep 2024 16:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209879;
	bh=qVdatOM3tSyW2jUqzbxOivVb5KPa5UFvHSULSKkQA2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=juj01AoyiRRQIgggTOJU8yVgdlqtC0/xlxDFGCxxs1U56/8816spgiwBJNSrjdpHe
	 2Hfo0i4pvv9iNmAo0eMRwzKBTb/jC39mvuOQdFVvf6XAdh6TaRMkgPFGGetd2ZJcTm
	 YMl4hJZuNlRcfeEpqubuVWboU1GMfNzG8+NcAZd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 021/215] drm/amdgpu: Actually check flags for all context ops.
Date: Sun,  1 Sep 2024 18:15:33 +0200
Message-ID: <20240901160824.062746003@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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
@@ -413,16 +413,24 @@ int amdgpu_ctx_ioctl(struct drm_device *
 
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


