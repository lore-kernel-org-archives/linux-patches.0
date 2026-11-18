Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036746;
	b=W07rCrI/W2r2eHhBdJKs4V76e+/nRNOMp4iy7r87D6vVr9zR+pQDgowX5d+aZMlS91LF
	 VeSUnQvJy1OGKMtLdBk0MKfI708Ta5qP+gNC8j+tlCz44mHETlSlHOALYZnf6YwyEmCoN
	 cDqje5ci+gw78h9yoHmsd4I9jfW8i+LAn5SmDRbdfcLrXsrpy3AE4K7dcDMLk7U8TkU1E
	 rGSBj9xj1aWE7yHBwYen2DNgchindiIfvvfmgfuKQLgp+of8Ash1Q2JLPTerOJBJOPwzQ
	 VudA2Xf5WWJpL4Z+E07TE2Q25p6jvotn+kVb38ZY/1U23cXuqDKz0BW11a9BWEhNYtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036746;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T7ml6oecIzaTigyPe3yf33qMCUmuPKJU2iZ56BuzOLA=;
	b=CVH1usWzVddqKMfP2MVmTfVPG819tq1kP2l54jIom0r1mQizlsuJAPcfrG7H/KkyFn4+
	 WTjRpxWYK1iKsEsPB1t5YpjBC0384lurvyopIfC6l4XSKa7v7uvbPXqfEDMzh0v4vLBRe
	 OgQpSMuISUAMUZ/246qS5k6lukqNnsw/Xv8qsOk6XI5x2kSCbw/lHK+Jj8j6SRKvbr9e2
	 JnphqVl4oAuMhWURW+LCeBiRFIrj2vFc63Xwte93eCWgJZsIxKCF+IktHiz6pVCWFSueI
	 x+1zmx/PX8YMGaxo+UQh4qCQyf6tWFFag9AOLCCodVvt0HIvaw2wkgAZlupHrvHEnOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aithtMeR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61675606A325;
	Wed, 18 Nov 2026 21:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aithtMeR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B35881F000C4;
	Wed, 18 Nov 2026 21:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036746;
	bh=T7ml6oecIzaTigyPe3yf33qMCUmuPKJU2iZ56BuzOLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aithtMeR7B6nPJs4qi+rRGdEl77uRVXS8VJZDwu1RNLEu6adNRqxTxVs8wuOAHdV+
	 JeusjBQv02aQGUsZ16ChckTbkwljbKuo9xNIxfHEfzE7PkGnXhXpCYqreKu3Sn81Jc
	 mDZy2X22wEk4oVSyw4mzXVl7Vcndfdd/xn0Maino=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Maciej Kucharek <qchcio@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1170/3318] drm/amdgpu: reset CIK ASIC on Apple boards with VRAM at 0
Date: Wed, 18 Nov 2026 15:29:52 +0100
Message-ID: <20261118150355.225089398@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Kucharek <qchcio@gmail.com>

[ Upstream commit 095f634ea0aa5b9da19495520b5fc1a155b2c137 ]

On MacBookPros with switchable graphics, the firmware puts VRAM at MC
address 0 when the iGPU is enabled.  A later post (S3 resume, GPU
reset) moves VRAM back to the VBIOS default.  The SI fix resets and
posts the ASIC at load, so the driver uses the VBIOS layout from the
start:

  "drm/amdgpu: reset SI ASIC on MacBookPros with VRAM at 0"

No MacBookPro has a CIK GPU, and no affected CIK board is known.  Add
the same test to cik_need_reset_on_init(), so that SI, CIK and VI
handle this firmware layout in the same way.  gmc_v7_0 reads
MC_VM_FB_LOCATION once at init and does not reprogram it.  A CIK board
with VRAM at 0 therefore has the same problem as the SI boards.

After the reset, FB_BASE is not 0, so the new test does not fire again
on a module reload.

Only compile-tested.

Suggested-by: Alex Deucher <alexander.deucher@amd.com>
Assisted-by: Claude:claude-opus-5-5
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Maciej Kucharek <qchcio@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 6bb4b79d6a6c461b40750fd67cb4e2a070e20b67)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/cik.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/cik.c b/drivers/gpu/drm/amd/amdgpu/cik.c
index e63abdf52b6c2..54adda2b0b4f9 100644
--- a/drivers/gpu/drm/amd/amdgpu/cik.c
+++ b/drivers/gpu/drm/amd/amdgpu/cik.c
@@ -1947,6 +1947,16 @@ static bool cik_need_reset_on_init(struct amdgpu_device *adev)
 {
 	u32 clock_cntl, pc;
 
+	/*
+	 * MacBookPros with switchable graphics put VRAM at 0 when the iGPU
+	 * is enabled.  Any later post (S3 resume, GPU reset) moves it back to
+	 * the vbios default, so reset and post on load to start with the
+	 * vbios layout.
+	 */
+	if (adev->pdev->subsystem_vendor == PCI_VENDOR_ID_APPLE &&
+	    !(RREG32(mmMC_VM_FB_LOCATION) & MC_VM_FB_LOCATION__FB_BASE_MASK))
+		return true;
+
 	if (adev->flags & AMD_IS_APU)
 		return false;
 
-- 
2.53.0



