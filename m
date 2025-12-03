Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D79C340279;
	Wed,  3 Dec 2025 16:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780084; cv=none; b=SVUYCwB2fOmFZdEt4y+Telm7rZGcwnGqoq+YZ0FwSRcaEBhB/NAYIW/lOX1QdzcVOeszc0H24GkQPiwsTIwYouPod34faGAXL3VejdqwsXV+qR3s0FyICbpOkXIuxJnOs+n58qJbEAe1LNlFcQ80ya+kbNOhlN8lqf8aKD5m8oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780084; c=relaxed/simple;
	bh=p1L1q2gXVuMlxHT02lST4BcJniVoCj5Roe2KfniQ07M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L/MNmrWGqQQO0CCMrxIluYe6FJpAnxTnyzRWLzLH3cHjv98glxVWt187zIblZIJKqkMI4fXiLPPcPTNez/GsgBGAR1tmXohfixzr6KCF0umFpq4IuUL+CwspqbYtFw/8XJS+N7WTwBTodnpInd9563TLY+XT1xw71bihGzpP31U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lx6+v+FM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lx6+v+FM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFC8DC116C6;
	Wed,  3 Dec 2025 16:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780084;
	bh=p1L1q2gXVuMlxHT02lST4BcJniVoCj5Roe2KfniQ07M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lx6+v+FMJM3SqNIlhfuKA+XatZRWdOPyTId5JCJtK/vRcHcU1VcpiocQDArGCzXH/
	 32rcuCv2ire2OnirD2xpENRexdt0HfE1nEnX+zXrm7+uxGYQEeZL3wWZyN//upF9fm
	 EeTxPyvOZ+SoYrTvzGCq9Ipp55lVrS1Drs8/uEow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Zha <Yifan.Zha@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 450/568] drm/amdgpu: Skip emit de meta data on gfx11 with rs64 enabled
Date: Wed,  3 Dec 2025 16:27:32 +0100
Message-ID: <20251203152457.188609462@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yifan Zha <Yifan.Zha@amd.com>

commit 80d8a9ad1587b64c545d515ab6cb7ecb9908e1b3 upstream.

[Why]
Accoreding to CP updated to RS64 on gfx11,
WRITE_DATA with PREEMPTION_META_MEMORY(dst_sel=8) is illegal for CP FW.
That packet is used for MCBP on F32 based system.
So it would lead to incorrect GRBM write and FW is not handling that
extra case correctly.

[How]
With gfx11 rs64 enabled, skip emit de meta data.

Signed-off-by: Yifan Zha <Yifan.Zha@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 8366cd442d226463e673bed5d199df916f4ecbcf)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -5392,9 +5392,9 @@ static void gfx_v11_0_ring_emit_ib_gfx(s
 		if (flags & AMDGPU_IB_PREEMPTED)
 			control |= INDIRECT_BUFFER_PRE_RESUME(1);
 
-		if (vmid)
+		if (vmid && !ring->adev->gfx.rs64_enable)
 			gfx_v11_0_ring_emit_de_meta(ring,
-				    (!amdgpu_sriov_vf(ring->adev) && flags & AMDGPU_IB_PREEMPTED) ? true : false);
+				!amdgpu_sriov_vf(ring->adev) && (flags & AMDGPU_IB_PREEMPTED));
 	}
 
 	if (ring->is_mes_queue)


