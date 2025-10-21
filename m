Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA07350A2A;
	Tue, 21 Oct 2025 19:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076738; cv=none; b=BkqpZN8QeSCz9iHh+CZNBmvaVjOUbwcfU1rUyUpuorcAmL2tHo41jPtZJHEb7QUmhFSeCcyKHTIp/pPvO1l1l/+mRgjOQ1hi+9rbSNiS2NhXdaP5eXrL8PuWGGfDo+zJDYgcZK+DZaCKRKGeB3b5z5u+TpawLIxe187g7hgvRgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076738; c=relaxed/simple;
	bh=p7EpDIzG+Cg/4SBzsJVJpXnelA2QTEvYvNhgULeOBgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ghpq8A+O40/eqkDMso0SRxCwCJ5gF8IZB+v8GLtJ+o76Nzt/eGR0Mq07TSXdqxcYguT0ZpYhdoxYv9AsgU7+0YAIvjhgC/wouuMq7B12w2nwa6VnDqajO7EQOFwIFEQMFXMTIKp8+bIRDz+Atw4equ/Pli8aBy2E9ayy8Hhq3Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a3vqsbfH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a3vqsbfH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A0D9C4CEF1;
	Tue, 21 Oct 2025 19:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076737;
	bh=p7EpDIzG+Cg/4SBzsJVJpXnelA2QTEvYvNhgULeOBgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a3vqsbfH4lU3KFgz1mb8bXPf5S+27VrxBdvpvzIsxJsZktSCZ9D53mOrk/f1JiJmt
	 sjuh0QxFBvqWP78CmV5p/k1NvbU0FIXrlATsKbm9y3n0vYR6yOTMVNl22+5qrSEks8
	 q6xIrXkVpFo/j8UsztOuv3sQK1hkDM5HSzBStywU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Kim <jonathan.kim@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 022/136] drm/amdgpu: fix gfx12 mes packet status return check
Date: Tue, 21 Oct 2025 21:50:10 +0200
Message-ID: <20251021195036.508383897@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Kim <jonathan.kim@amd.com>

commit d0de79f66a80eeb849033fae34bd07a69ce72235 upstream.

GFX12 MES uses low 32 bits of status return for success (1 or 0)
and high bits for debug information if low bits are 0.

GFX11 MES doesn't do this so checking full 64-bit status return
for 1 or 0 is still valid.

Signed-off-by: Jonathan Kim <jonathan.kim@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/mes_v12_0.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
@@ -224,7 +224,12 @@ static int mes_v12_0_submit_pkt_and_poll
 			pipe, x_pkt->header.opcode);
 
 	r = amdgpu_fence_wait_polling(ring, seq, timeout);
-	if (r < 1 || !*status_ptr) {
+
+	/*
+	 * status_ptr[31:0] == 0 (fail) or status_ptr[63:0] == 1 (success).
+	 * If status_ptr[31:0] == 0 then status_ptr[63:32] will have debug error information.
+	 */
+	if (r < 1 || !(lower_32_bits(*status_ptr))) {
 
 		if (misc_op_str)
 			dev_err(adev->dev, "MES(%d) failed to respond to msg=%s (%s)\n",


