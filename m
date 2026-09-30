Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3629C51123D;
	Wed, 30 Sep 2026 16:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787600; cv=none; b=iEiHMUYWyLk53GA5fQQnU4HHdXwXcE6xcX94y45UbBw8++wpi/XpbO49v087xgNu9vqKC6s+osfGz8tecIWCd+4UYqMs9LKPU3x+4Wid6Kk2wDS1tPKve6fZmlcL2m7xxI8MTUzIntTna8orjk1FdauFqNOQckDsNcuCH4BU4LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787600; c=relaxed/simple;
	bh=bKmUrtPZWICY9hFBP9gnHQYc7ff/1tcwRIzjeJ7dYcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lYSYcmkJJ6jFqQUrG17UIFJA7gHYo1oyiUFnl5sZ3cvLqtRCgWUGJ3pqQISFsQTVmYwswaR57Mn8ctKFMQXhf7bVDs2w/iHN6840SSI5Ff/YJuI4Zoj/6QTrgN37zdoeskY/AcsDEqdeYH46zsx7fKGfoLjuZJowPRBYJDtcfvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QD4fgVEQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QD4fgVEQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 904D01F000FF;
	Wed, 30 Sep 2026 16:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787599;
	bh=g53fSvmohvCNHLDtVI5y8ehrsXMljUWI7VwMCAPE+eI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QD4fgVEQyltdYwKF19N2MJJ+h2erTyYH/8hwF1HXm1LqXNt/Uap3a5IKk6fOCSU6z
	 tintKH9aUB1KgLyqB63ccqPV9UaRI6b2duZM3IIV1RsFo41VfvDR1nSndtuCerx+rg
	 q28xIKdd+I4MDVg7CBNBpk/ZbSIc1TD360i20DBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jesse.Zhang" <Jesse.Zhang@amd.com>,
	Sunil Khatri <sunil.khatri@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 286/457] drm/amdgpu/vcn4.0.3: fix video_timeout unit mismatch in jpeg reset wait
Date: Wed, 30 Sep 2026 17:26:31 +0200
Message-ID: <20260930152352.206369126@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sunil Khatri <sunil.khatri@amd.com>

commit 6b13ddbf5bb8deec337f9b4887f579097a953f6a upstream.

vcn_v4_0_3_reset_jpeg_pre_helper() passes adev->video_timeout directly
to amdgpu_fence_wait_polling(), whose timeout parameter is documented
and implemented in usecs (busy-wait loop decrementing by udelay(2)).

adev->video_timeout is set in jiffies by
amdgpu_device_get_job_timeout_settings(), via msecs_to_jiffies().
Passing it unconverted means the intended ~2s wait for outstanding
JPEG fences to complete before the JPEG queue is torn down actually
lasts only a couple of microseconds (HZ jiffies interpreted as usecs),
so pending jobs are almost never given a real chance to finish before
the reset path forces completion in the following helper.

Convert the jiffies value to usecs with jiffies_to_usecs() before
passing it to amdgpu_fence_wait_polling().

Fixes: d25c67fd9d6f ("drm/amdgpu/vcn4.0.3: rework reset handling")
Cc: Jesse.Zhang <Jesse.Zhang@amd.com>
Assisted-by: Claude:claude-sonnet-5
Signed-off-by: Sunil Khatri <sunil.khatri@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 5feabbd673c10ebee22b880e4d812f08974d2ef7)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
@@ -1672,7 +1672,8 @@ static int vcn_v4_0_3_reset_jpeg_pre_hel
 		/* if Jobs are still pending after timeout,
 		 * We'll handle them in the bottom helper
 		 */
-		amdgpu_fence_wait_polling(ring, wait_seq, adev->video_timeout);
+		amdgpu_fence_wait_polling(ring, wait_seq,
+					  jiffies_to_usecs(adev->video_timeout));
        }
 
 	return 0;


