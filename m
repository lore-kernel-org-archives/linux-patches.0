Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8919E2417DE;
	Thu, 20 Aug 2026 15:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238105; cv=none; b=qXgKI6dJouI+1kQdK5I2MEkeP6nI8V5xj1nLEkDrciuhGP5XldMUXsqA80b1N/YQcewH+t0qsPLhvjF1u4U53ZdqXtpoOIF1QqWpkkUqCh965sx70n+PCQpA5a/PmuCGZan5iX0gsMXU+pK5ielPpncnjw8vcIcP1a1NGlqaBi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238105; c=relaxed/simple;
	bh=jhn6P5B2AqCeUiHjZNStRq5l0bdieh6vSrLwG5VnIK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+peWALLXRtYlrInj1etK0KlkYQQwTVHF1jGxacyO+wXAOqPgWRFIwhsoBLtM7M2C417LM+ULP4oCqVCNR5WaxHiNxHORnbbxEEyi5SCvivohBNSN82Dltxz06QcE9smFH+hxB+gIoD/+PUJ7H54NAq8Vfs075bf6w4mjdINxJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jqqtTj2a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jqqtTj2a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A40DE1F000E9;
	Thu, 20 Aug 2026 15:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238104;
	bh=EMI+RiwICztsrhA9VCnVY+9/D4R6Unf8bLXwDgT0tjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jqqtTj2aCqP67A7kFvxuJ6LdCZ6PA2vU3ElUqurYThJgCyjrTZWDruB3sTrdtqk+c
	 deq1wGcrYdxj7XH7GqDcx4A6nWNk0BK5SNEmyTkZL4pPNJaWZCx9UPKo6pRe36TlSQ
	 V4is0LWryp+IWXCk1PN8vJudRR2OGQQYi0C9fGTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>
Subject: [PATCH 7.1 034/228] drm/amdgpu: fix JPEG v5.0.0 queue reset failure in DPG mode
Date: Thu, 20 Aug 2026 16:52:56 +0200
Message-ID: <20260820145245.493964060@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <Jesse.Zhang@amd.com>

commit c87801f545dac9fcbb84c96f280706572be00a85 upstream.

In DPG mode jpeg_v5_0_0_ring_reset() takes the DPG stop path, which only
clears the JPEG_PG_MODE bit and never resets the JRBC. A hung ring is not
recovered: the post-reset ring test times out and the driver falls back to
a full MODE1 reset.

Temporarily force the static power-gating path during the reset so the
stop/start sequence power-cycles the JPEG block (JMI soft reset + power
off/on), matching the jpeg_v4_0 reset which has no DPG path.

Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 79b3612827d1adcd2008cd585961fa35a6ff20f2)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_0.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_0.c
@@ -648,15 +648,28 @@ static int jpeg_v5_0_0_ring_reset(struct
 				  unsigned int vmid,
 				  struct amdgpu_fence *timedout_fence)
 {
+	struct amdgpu_device *adev = ring->adev;
+	u32 pg_flags = adev->pg_flags;
 	int r;
 
 	amdgpu_ring_reset_helper_begin(ring, timedout_fence);
-	r = jpeg_v5_0_0_stop(ring->adev);
-	if (r)
-		return r;
-	r = jpeg_v5_0_0_start(ring->adev);
+
+	/*
+	 * The DPG stop path only clears the JPEG_PG_MODE bit and never resets a
+	 * hung JRBC, so the post-reset ring test times out and the driver falls
+	 * back to a full MODE1 reset. Temporarily force the static power-gating
+	 * path so the stop/start sequence actually power-cycles the JPEG block
+	 * (JMI soft reset + ONO1 power off/on), matching the working jpeg_v4_0
+	 * reset.
+	 */
+	adev->pg_flags &= ~AMD_PG_SUPPORT_JPEG_DPG;
+	r = jpeg_v5_0_0_stop(adev);
+	if (!r)
+		r = jpeg_v5_0_0_start(adev);
+	adev->pg_flags = pg_flags;
 	if (r)
 		return r;
+
 	return amdgpu_ring_reset_helper_end(ring, timedout_fence);
 }
 


