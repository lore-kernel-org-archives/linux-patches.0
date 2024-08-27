Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201FE19EEA2;
	Tue, 27 Aug 2024 14:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769815; cv=none; b=lCy8Nnbaj0U+gAZhe1rVoUV9eQeF66rDdshHk3lCf270CaQr7HVr/eJsmiDEIZrzyTg/0bqKGmL6+xS0La24YsSO9XwcHk7Z8W9qD5DeeTKj6/C01fUVZCVU5MNWwPT+QmGBRFsGfn6cjz/kwQT4RvemR1pLzT/ih4euKzeRqXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769815; c=relaxed/simple;
	bh=c06FUpTPkgbuBlKy0x6GMnQsGlKfWW5Hj5K5Qvx/UIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cnZ4OAJ4J+9CKIsNxsV87tjwdplrR3H8PtbZyAR0KlNdkQNQcxZnoCCK3CPWfWGpaPxdoHZJ+00NoGsdeEcB2frsUg016fBTgozXC6BWGruqMMp9tPtjaR7B362NzmVCQDe30JF5/pROmt3hKk6GFr0KyFo5qmXsVPUtArQ4jjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AKUqF6gi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AKUqF6gi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 867C4C61052;
	Tue, 27 Aug 2024 14:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769815;
	bh=c06FUpTPkgbuBlKy0x6GMnQsGlKfWW5Hj5K5Qvx/UIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AKUqF6gizahdXoKcvWJxhGzco6LG/lkFC9jIjfMJgB5iZEXrzZlfiRW2vCMSXGyCw
	 aj3IRamiWkgYg0zVOcj5ouXveZUYOuMQoYZBBpbIAJN2pKe0IETGzJGqjeANNzNeYP
	 znFW3DBjlyHy2g4E8YLRsPlx5cHHeZ5lV8MtvKjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 043/341] drm/amdgpu: Actually check flags for all context ops.
Date: Tue, 27 Aug 2024 16:34:34 +0200
Message-ID: <20240827143845.055565387@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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
@@ -684,16 +684,24 @@ int amdgpu_ctx_ioctl(struct drm_device *
 
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


