Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF283FF1A2;
	Fri, 15 May 2026 15:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860433; cv=none; b=JA5LuvKn62nxx2lvp+4Iq8sIKmx/5Gbp9BiKCPq5UHyUB+C9FT6paC8U8VjeqqT4445Rj2DyEHl7aB6ps3x1VaORyuT6nFBZ/EwKF6k+SQw0n3tAq0J7EPZdaw1iRDR79QCYzsKJpDACHJrAIXKG28jU8cF3r0F0Du7IJCKPHUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860433; c=relaxed/simple;
	bh=x1agzylPWcDo0n7peZSuS+1B32tEqQt1D0A1I5GXwZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=omumuVNDPKN3ZDu/FvD3fSQnqZCOuv99Oj6xpwqhdW+SLXqebV4WLo3evxAXMHcCv7eKPlER1VFiemcckFYygwDd6ku2OHwsfUvKv2ts1MsV9DF2C1BdBMfNij9MShSQuWFAL5YcwWqePWTvOFnvcaQ5dRn++vDWL/2G7ofh1wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tp1OK2Ap; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tp1OK2Ap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 060AEC2BCB0;
	Fri, 15 May 2026 15:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860433;
	bh=x1agzylPWcDo0n7peZSuS+1B32tEqQt1D0A1I5GXwZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tp1OK2ApYWIOj1HyPMzh6y8eZceeEQEZ5S1FjwjaX809MTAEe72snqN5aq4+VTHGM
	 N2X0jvb0JMFa5G8iZGxnbfvZeGmY/I47jjIisPdQpEwB3CDJqKEt0MuANu0h+3v7VA
	 cK9UomLSyir9o9OHyAqUt8LBMrp+TIghis7yOUf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	"John B. Moore" <jbmoore61@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 087/144] drm/amdgpu/gfx9: drop unnecessary 64-bit fence flag check in KIQ
Date: Fri, 15 May 2026 17:48:33 +0200
Message-ID: <20260515154655.540335951@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John B. Moore <jbmoore61@gmail.com>

commit 7bbfb2559bcec39d1a4e1182d931a2046112c352 upstream.

Remove the BUG_ON(flags & AMDGPU_FENCE_FLAG_64BIT) assertion from
gfx_v9_0_ring_emit_fence_kiq().  The KIQ hardware supports 64-bit
fence writes; the 32-bit writeback address constraint is an
upper-layer convention, not a hardware limitation.  The check serves
no purpose and should not be present.

Found by code inspection while investigating related BUG_ON
assertions in the GFX and compute ring emission paths.

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: John B. Moore <jbmoore61@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1b1101a46a426bb4328116bb5273c326a2780389)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -5637,9 +5637,6 @@ static void gfx_v9_0_ring_emit_fence_kiq
 {
 	struct amdgpu_device *adev = ring->adev;
 
-	/* we only allocate 32bit for each seq wb address */
-	BUG_ON(flags & AMDGPU_FENCE_FLAG_64BIT);
-
 	/* write fence seq to the "addr" */
 	amdgpu_ring_write(ring, PACKET3(PACKET3_WRITE_DATA, 3));
 	amdgpu_ring_write(ring, (WRITE_DATA_ENGINE_SEL(0) |


