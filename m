Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F5F37DEBE;
	Thu, 20 Aug 2026 15:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238102; cv=none; b=aU8UcpxRFxO+OuoRhE2bhh2uWVvsqPbFF6ik2pzAVQ+OTnhML/Nqy0EzaxC5R66jEuvKgPUoZs0V42qLTJbg1VRo2oWBz2/VeeSD10M9J1wPMIQelu7k/5+CHE/4R61oyiW2HdxQL44cYKF3TSENDMkKKLk9ISD9jeGUmar/KL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238102; c=relaxed/simple;
	bh=f5LT1Mx8QrnrM/9H+8LW2KGM4VCfKJbSAwrXZdA4vKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JrS80BXe4/mGThcJzPimAoolmrMEANRpkZY+jROM1R7tAx8ClNd98U0gY80tTsfW9NDnrDB9mhb7+jryi3FWURlGhfUDfkopXpbx0mqc3rFHICXDdJ7TgtAFqILauxdlnnZPcZ+O59hT5+ghbwn7SdoFD1ufNzy6SbCfZjoW+HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xY8S6ZwQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xY8S6ZwQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F37AB1F000E9;
	Thu, 20 Aug 2026 15:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238100;
	bh=HBJgiCelZtRtztvMlMlihwf7lVQc1zjBN4+kiJmVRe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xY8S6ZwQCdBz5JlFQO9bk7iX6vHVJjAbc2UHZNp2fh7zwi8S2ZHRM6fTy9Lekj9PF
	 Lz6XIroQqGAi1eboWXdpbWixcaraf4sKHT7NmVylrcnBobN0IE1DTcO0R/zbUx8BUz
	 FvjSoiLlEx4S2uCzoQGSGbLInJYgu0V6X2S7lM6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>
Subject: [PATCH 7.1 033/228] drm/amdgpu: fix JPEG v5.3.0 queue reset failure in DPG mode
Date: Thu, 20 Aug 2026 16:52:55 +0200
Message-ID: <20260820145245.464304193@linuxfoundation.org>
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

commit d2dc81ed5191e7e06a8aa3e153f665d36bae8eb6 upstream.

Like jpeg_v5_0_0, in DPG mode the ring reset path only clears the
JPEG_PG_MODE bit and never resets a hung JRBC, so the post-reset ring test
times out and the driver falls back to a full MODE1 reset.

Temporarily force the static power-gating path during the reset so the
stop/start sequence power-cycles the JPEG block (JMI soft reset + power
off/on), matching the jpeg_v4_0 reset.

Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit e93659cab11c48255dcac58af60203c99815586b)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v5_3_0.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v5_3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v5_3_0.c
@@ -631,15 +631,28 @@ static int jpeg_v5_3_0_ring_reset(struct
 				  unsigned int vmid,
 				  struct amdgpu_fence *timedout_fence)
 {
+	struct amdgpu_device *adev = ring->adev;
+	u32 pg_flags = adev->pg_flags;
 	int r;
 
 	amdgpu_ring_reset_helper_begin(ring, timedout_fence);
-	r = jpeg_v5_3_0_stop(ring->adev);
-	if (r)
-		return r;
-	r = jpeg_v5_3_0_start(ring->adev);
+
+	/*
+	 * The DPG stop path only clears the JPEG_PG_MODE bit and never resets a
+	 * hung JRBC, so the post-reset ring test times out and the driver falls
+	 * back to a full MODE1 reset. Temporarily force the static power-gating
+	 * path so the stop/start sequence actually power-cycles the JPEG block
+	 * (JMI soft reset + static power off/on), matching the working jpeg_v4_0
+	 * reset.
+	 */
+	adev->pg_flags &= ~AMD_PG_SUPPORT_JPEG_DPG;
+	r = jpeg_v5_3_0_stop(adev);
+	if (!r)
+		r = jpeg_v5_3_0_start(adev);
+	adev->pg_flags = pg_flags;
 	if (r)
 		return r;
+
 	return amdgpu_ring_reset_helper_end(ring, timedout_fence);
 }
 


