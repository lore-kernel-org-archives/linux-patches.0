Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3EDA37CD47;
	Thu, 20 Aug 2026 15:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238754; cv=none; b=qYnARYPmopmgqtr21p5aES7kKWIguO9EGuhRZ+UtPWS3cp7xI2Y6hPNw6iVbV51PR3/IRiEEtm7aREKCx1eTeUDTtDH0gQXr/PvqHpS+RbLi9HCPXt1dnaSmHIQd+m7y79HAj4CCpPJxvcH2HPdJvfHcmmGilza8F8xdqXIj58k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238754; c=relaxed/simple;
	bh=grJnpDg7irYBVKD7UVVGpWJm13HeEjxcahS0SzgjUu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sI2aCr69Ua1AK7lP9pppIeXMkB7h8zlRuVe58x8qqXlK1KwrfURDceTy94rFFgvu/lBVWJ4WfO5Q0toRRGujPSdM927iiTR8GGT8pHgJ/FZg5vmayLO35kqe1IAnCozcl4DRxBWRLWVY7/gjS+yn2euyU5WBrPaESEs1kqr1bgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tIFcLnET; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tIFcLnET"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28EC81F000E9;
	Thu, 20 Aug 2026 15:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238753;
	bh=pCivslgMdMVBc8hv1C7KQZWSbgQgDs5FBu9Ik5GagEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tIFcLnETz+UeQ3IbDatlQplbn2q6RsqCfdJxXMbYF9ErK+EfNYgklc3ykQeHRNjPK
	 BTuEcC8VnYmf2411OYUb6kgl8qAr7gOyfzaYwcZkjT2mH9eV+vswD/kpiFcBxVO4K5
	 PfpwAV5F/zms2egcXyu1We/2Id4ds7BfocFtwJ0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>
Subject: [PATCH 6.18 029/217] drm/amdgpu: fix JPEG v4.0.5 queue reset failure in DPG mode
Date: Thu, 20 Aug 2026 16:53:17 +0200
Message-ID: <20260820145238.497761781@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


