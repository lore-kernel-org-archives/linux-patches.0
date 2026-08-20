Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52ABE258EE9;
	Thu, 20 Aug 2026 15:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238111; cv=none; b=vGm4dzcMAPuI6CrXXppsR1ibOvZgM6HQmw0+G0jaHmwG99/WWKkb4YcVbBvPVUqg5oSTtEi9WrzJDbhc1a+HbRT0S9znveudZGwX7IygjoDq3ezApFCt/q4zfqopUkxSxPFA6mxriSHihYTybkIQIJx9rPX/rzSJpNZ6/kVs21c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238111; c=relaxed/simple;
	bh=26ZDPK4/7oOGzARAI22ltxUP4/X+fDmDO9pbpAyQnw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hy8JK4EBs+dxgZJECdokLrqOUmqgXkkLY2LpZd1DvmFNemaNiv5M28M6QqtpYrNRpYEwcjFpse6ZZIJEDE1rheSMricJ6sFHOasKyt60SvX8C4kYsM8kl0ujli12DkRwiBLyF4GR7OGbdIn+MQouh3CiAqWzMd1pshmZjWaaen4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aq5MKYRu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aq5MKYRu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6285C1F000E9;
	Thu, 20 Aug 2026 15:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238109;
	bh=qRoUMLC3Ji0FCa7YYn5Kiqr3L0gJyaR4vloI4FyccY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aq5MKYRuRLp5Srax1bhCGN1fiY3rzeRyfsmazO9uTxCQaHAQgLWdl6XQJOuicGpNm
	 FgZmTQRPRrNSN6BULraG6ff3fevYLV2gilhwgANMGguVX0y9nH2k4E0L7CXKr9mz84
	 zzxixO1axwTm0XdIGr43x3mZPg3ghGwFk2o4OWDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>
Subject: [PATCH 7.1 035/228] drm/amdgpu: fix JPEG v4.0.5 queue reset failure in DPG mode
Date: Thu, 20 Aug 2026 16:52:57 +0200
Message-ID: <20260820145245.529972485@linuxfoundation.org>
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

commit 4301e60e406c613aea06fdc0c36bf0675b0b8a2e upstream.

Like jpeg_v5_0_0, in DPG mode the ring reset path only clears the
JPEG_PG_MODE bit and never resets a hung JRBC, so the post-reset ring test
times out and the driver falls back to a full MODE1 reset.

Temporarily force the static power-gating path during the reset so the
stop/start sequence power-cycles the JPEG block (JMI soft reset + power
off/on), matching the jpeg_v4_0 reset.

Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 75a308eef4503a9d2bf297bef5a9317d2209e696)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_5.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_5.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_5.c
@@ -772,15 +772,28 @@ static int jpeg_v4_0_5_ring_reset(struct
 				  unsigned int vmid,
 				  struct amdgpu_fence *timedout_fence)
 {
+	struct amdgpu_device *adev = ring->adev;
+	u32 pg_flags = adev->pg_flags;
 	int r;
 
 	amdgpu_ring_reset_helper_begin(ring, timedout_fence);
-	r = jpeg_v4_0_5_stop(ring->adev);
-	if (r)
-		return r;
-	r = jpeg_v4_0_5_start(ring->adev);
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
+	r = jpeg_v4_0_5_stop(adev);
+	if (!r)
+		r = jpeg_v4_0_5_start(adev);
+	adev->pg_flags = pg_flags;
 	if (r)
 		return r;
+
 	return amdgpu_ring_reset_helper_end(ring, timedout_fence);
 }
 


