Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749C63EFFD4;
	Fri, 15 May 2026 16:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862157; cv=none; b=aADlgBMDa44KVdfc7fZM+HCQASRNHSoqVQJiib6RGZo/5HKSH9xaiWJdSLIb9M90LEBDRrf3XJC+/dYZkp7loNrTKg+olRGU07ABoEOS4a7jDvdhVJ5YGKV0kynQ1nHyQoWO8MSlg/9u9ESTCLvXb9lqTeVa7ga2SugZ02JjNNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862157; c=relaxed/simple;
	bh=UyUFt0+bVbu6fzQvuVhlqJv+gRk/qcmkJitx7A1vxjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=auaAOx9SwaBjLIS4rMHwMkQ+M6zr1v/Xuh4kJn1zmVYy2zNKdXYK1QZTNBFxy0APePPUSDIHy1bug/q2Q4mGrk7hxx4Y13o9wOVkd3VNMPuHg6rgDZO4dz1QbSi6ObNHA5d+fMWpfZ/SmCWbZU1T/V33Gu8+bf0C1heLd9vDBY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K4xFl4Tn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K4xFl4Tn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08CF0C2BCC9;
	Fri, 15 May 2026 16:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862157;
	bh=UyUFt0+bVbu6fzQvuVhlqJv+gRk/qcmkJitx7A1vxjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K4xFl4TnyzzvA92A/9pMuMqXpmUGXylZt6skvF/b8oRJ2y7RVjhxU7Oqh9dqR/OKk
	 XEjcUAIwx758oAfSx9/qnNrFhUVth12/hgOTqmx6DNdVD+NmG88ydWNaJfvQSxEov+
	 QV3sxrY4Y/P9TYkPsNL1A+srh1kkZbL0dur2ztC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	"John B. Moore" <jbmoore61@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 130/188] drm/amdgpu/sdma4: replace BUG_ON with WARN_ON in fence emission
Date: Fri, 15 May 2026 17:49:07 +0200
Message-ID: <20260515154700.149055758@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John B. Moore <jbmoore61@gmail.com>

commit 78d2e624fa073c14970aa097adcf3ea31c157a66 upstream.

sdma_v4_0_ring_emit_fence() contains two BUG_ON(addr & 0x3) assertions
that verify fence writeback addresses are dword-aligned.  These
assertions can be reached from unprivileged userspace via crafted
DRM_IOCTL_AMDGPU_CS submissions, causing a fatal kernel panic in a
scheduler worker thread.

Replace both BUG_ON() calls with WARN_ON() to log the condition without
crashing the kernel.  A misaligned fence address at this point indicates
a driver bug, but crashing the kernel is never the correct response when
the assertion is reachable from userspace.

The CS IOCTL path is the correct place to filter invalid submissions;
the ring emission callback is too late to do anything about it.

Fixes: 2130f89ced2c ("drm/amdgpu: add SDMA v4.0 implementation (v2)")
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: John B. Moore <jbmoore61@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit b90250bd933afd1ba94d86d6b13821997b22b18e)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
@@ -890,7 +890,7 @@ static void sdma_v4_0_ring_emit_fence(st
 	/* write the fence */
 	amdgpu_ring_write(ring, SDMA_PKT_HEADER_OP(SDMA_OP_FENCE));
 	/* zero in first two bits */
-	BUG_ON(addr & 0x3);
+	WARN_ON(addr & 0x3);
 	amdgpu_ring_write(ring, lower_32_bits(addr));
 	amdgpu_ring_write(ring, upper_32_bits(addr));
 	amdgpu_ring_write(ring, lower_32_bits(seq));
@@ -900,7 +900,7 @@ static void sdma_v4_0_ring_emit_fence(st
 		addr += 4;
 		amdgpu_ring_write(ring, SDMA_PKT_HEADER_OP(SDMA_OP_FENCE));
 		/* zero in first two bits */
-		BUG_ON(addr & 0x3);
+		WARN_ON(addr & 0x3);
 		amdgpu_ring_write(ring, lower_32_bits(addr));
 		amdgpu_ring_write(ring, upper_32_bits(addr));
 		amdgpu_ring_write(ring, upper_32_bits(seq));


