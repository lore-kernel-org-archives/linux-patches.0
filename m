Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4931C3F19;
	Tue, 27 Aug 2024 15:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771138; cv=none; b=SFYFHgSx6SN5x7mYrDsZyhbXmPOceszIWBL1YY/OlEd9FN09oRKLosjpbiHJAFD8+KR/l/YxGutKzrP0Y5DCqK30WzxM1GpHl1RW/2rrFuzjcf8fj/rmbyvmGJupulMD5d7lniYyQZIsU4Zllpz6LVFiDiCb3OVg6zkE4gJekgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771138; c=relaxed/simple;
	bh=IUG7JbHXqTxvjb2ii4vBOJdwPMNGgUNLyOltG9MPrQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MMmGY2MM3V96Uff4UnQlobd6Jg3FQiYtfRi1mLbuypGtT4PYI8irZUz9NC7J2ysQZBGzTwHX3QNF+2Op05nKGRW78FFyd8juJYwDhhaPGt4zzoALTfbtdAjUreqnT2MAMJQEczVyAAU92nWDeWXbiJvxEpwuTeC64FNu7Fn2/7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hieIKo+6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hieIKo+6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DE4BC6106C;
	Tue, 27 Aug 2024 15:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771138;
	bh=IUG7JbHXqTxvjb2ii4vBOJdwPMNGgUNLyOltG9MPrQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hieIKo+6Te/H4pvqqIVsNaHADW69soSZNcHwenlHFxkjeG7+GoCm/GE5Xm6KA5Zty
	 QkCaMCcifiuGKbJU9XOZ4r7qynlPQ7oGguZ2exSb/xsLt98vnCY2r53Dd+s5/oaqKg
	 2GaYEYYx6tD1OkDI4z/vStJZF2VX2nG+Lf0af1A8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.10 067/273] drm/amdgpu: Actually check flags for all context ops.
Date: Tue, 27 Aug 2024 16:36:31 +0200
Message-ID: <20240827143835.965957172@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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
@@ -685,16 +685,24 @@ int amdgpu_ctx_ioctl(struct drm_device *
 
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
 	case AMDGPU_CTX_OP_GET_STABLE_PSTATE:


