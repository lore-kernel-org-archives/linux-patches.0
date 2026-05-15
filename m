Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734643E0089;
	Fri, 15 May 2026 16:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862744; cv=none; b=KUKs6xqLXujcdKBQ52vwRYovoBhhiEHtPN9QzH0CBjhSNV00DL9sgv80LGvU4ySwTgLd1W5zfL0xdmey+yPRc69ddwS851O4lVVEZ7DwVn9DoKRqOIuG48ELPCKaTBBYgsPhGpQ2d0i9EwoS9SDNQNizZqDHHrL5nqvM0nYN0gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862744; c=relaxed/simple;
	bh=rYJPsT0yj2oPCq93152BO7YpcAiTXkPIdLlZgHJwM44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gAzNFmvx2GDCKGJ2uYYliDAh7sB900oxMQDeVduNzVy/2mdIAbXJ1ZNZVNIhKWjQStpCH5uMemSeVRJ/RRkA7Agoxef57LpOZ8MmY26jftAfIJTSLXkQu+dUqFL0DHQZ3Uz6heUYNCdkqFmI6yTztXhLnihjEqa0L2iopxJ/PsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zxF/qSPv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zxF/qSPv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08D37C2BCB0;
	Fri, 15 May 2026 16:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862744;
	bh=rYJPsT0yj2oPCq93152BO7YpcAiTXkPIdLlZgHJwM44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zxF/qSPv3+KvuO1KFXT62KyvtzX2o+Ow5jmD/tZH0v/J7LC2J9RcKy/jqLXbhSWD7
	 R+Cjw3TrhoQ0nSlU5Z2lldg2cYmXyO3Nmucwq2M7/tDNzkgiEQxMUn5rIkV6DcfKKG
	 Kb+tDSvqzS7rEfbvMnPXp40g5AGTf9K62URWKVoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	"John B. Moore" <jbmoore61@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.0 165/201] drm/amdgpu/sdma4: replace BUG_ON with WARN_ON in fence emission
Date: Fri, 15 May 2026 17:49:43 +0200
Message-ID: <20260515154702.148421587@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


