Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C1D0381AFB;
	Thu, 20 Aug 2026 15:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239563; cv=none; b=Iyf2UAmHn+OXOlSky4eYp9DEAIRPcKFWbpWaA1P6m11AZ0/lbHOUnJHTp8f8wqEO3gpMIWV1K1u3v/uV5N9JfW0DmY9FU8cbtwqQYe5WykQjGFNlQROm6j9yYE2sNdmX+rebM0rGXN+10BivADm+jXuE01K3RUjU8tYPKDQ1WiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239563; c=relaxed/simple;
	bh=O81upD8znAcfI7uZsEseh1QBAr/9b6cQC7bUZuU6uN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L9xwrosi4BSAtFo165hOcXOiDn7bTZKZ3Ce/9TCuS24M3xKHAUdet8+GfRStS2zj+dht/LGjmz20sDMXmnXryQtpsgmP+eUbHS68traHGrEEVpHa1sma38O50v1ASPkRJNYweEpVc1aPsL2ym39PF2HOH1RIXlzWa2LK3m/TQqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aCFPytDk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aCFPytDk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 910D41F00A3A;
	Thu, 20 Aug 2026 15:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239562;
	bh=lREXVB3gfkCq2X8mC6B99b0K5unCKNCDCtZsoB8VNl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aCFPytDkergsNz1a3aljvyeuodH5W0RugHKWqgO9yw/oTjK0kx/l5ooejuktm2Jjx
	 6DbGEGeqWaSdcQD7Sk+gWXmcorELFxsj3K0o+hAOvn9AI+TNR4v8aJyYc7FXsDrahi
	 p8nrP22g2LZbxMANpkoxMX++XSvdHnK9ycVs62vE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 091/220] drm/amdgpu: disallow multiple FENCE chunks in one submit
Date: Thu, 20 Aug 2026 16:54:41 +0200
Message-ID: <20260820145226.213930049@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

From: Junrui Luo <moonafterrain@outlook.com>

commit 931cd1d1baeae68e8eb2c23bc1f3d8934dca6241 upstream.

amdgpu_cs_pass1() dispatches on chunk_id once per chunk without
rejecting repeated ids. p->uf_bo is a single-slot field, so a
submission carrying two AMDGPU_CHUNK_ID_FENCE chunks runs
amdgpu_cs_p1_user_fence() twice, and the second run overwrites
p->uf_bo with a freshly referenced BO without dropping the reference
taken by the first.

amdgpu_cs_parser_fini() only unrefs the final p->uf_bo, so every FENCE
chunk but the last leaks a BO reference. The leaked BO outlives handle
close and process exit.

Reject duplicate FENCE chunks the same way commit fec5f8e8c6bc
("drm/amdgpu: disallow multiple BO_HANDLES chunks in one submit") did
for p->bo_list.

Fixes: d38ceaf99ed0 ("drm/amdgpu: add core driver (v4)")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 665b1fc2a1845206408f9a2c6da67101789edb82)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -273,6 +273,10 @@ static int amdgpu_cs_pass1(struct amdgpu
 			if (size < sizeof(struct drm_amdgpu_cs_chunk_fence))
 				goto free_partial_kdata;
 
+			/* Only a single user fence is allowed to simplify handling. */
+			if (p->uf_bo)
+				goto free_partial_kdata;
+
 			ret = amdgpu_cs_p1_user_fence(p, p->chunks[i].kdata,
 						      &uf_offset);
 			if (ret)


