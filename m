Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865AB1FECAB;
	Tue, 26 Aug 2025 11:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208464; cv=none; b=HdFv1/49klDTb9lV0rVuQH3FrsyscfaC+uDkSDbiU2veDiWhwJ163i4sUxfhLtQP0Nsvpr/5qOwi+4zcsrQW6odD8jLJynQb/fxcL1lN7SzqzO+CWFvnjNEi6oBb0hSVBYDr32R92feVh+YwnrU03OCg22g1tmqV/roz/mxxPQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208464; c=relaxed/simple;
	bh=SqXTZnkwnFlDWSW1V25f72fh52nz2opGM54qLoUE1rI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dhv5TAcu4S13Da+barMc23NXmwb9Csmw+gqRdDDUzy47vA0ZN2UjLr0+ww17V8YUdcvcdE7WanimRtbKr744GzTCm+O+Iws+5jniiTBb2XaW9QLGqiZsZOKEhly8232LiWzpgfPTCMSaQm3hLQEt9rBhLyilT2ymciZtPNHjeTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C+C6WWmh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C+C6WWmh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C79C4CEF1;
	Tue, 26 Aug 2025 11:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208464;
	bh=SqXTZnkwnFlDWSW1V25f72fh52nz2opGM54qLoUE1rI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C+C6WWmhJqFfIJN5Nczp/aicQPCldanQ0gF6mbF0fOrxgTBMnSrknFt96bE9S19mu
	 KnWeL9nzudrzD0zFpsIgcEBNLXDocQPPXTPdhu1RS28H3V8eluBrYyeBBNt31KnnmH
	 +njynsuUze4OON6vZ8pyFRmj/4f/lXhZ1rkhFwKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 122/322] drm/amdgpu: Initialize data to NULL in imu_v12_0_program_rlc_ram()
Date: Tue, 26 Aug 2025 13:08:57 +0200
Message-ID: <20250826110918.812217633@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit c90f2e1172c51fa25492471dc9910e2d7c1444b9 upstream.

After a recent change in clang to expose uninitialized warnings from
const variables and pointers [1], there is a warning in
imu_v12_0_program_rlc_ram() because data is passed uninitialized to
program_imu_rlc_ram():

  drivers/gpu/drm/amd/amdgpu/imu_v12_0.c:374:30: error: variable 'data' is uninitialized when used here [-Werror,-Wuninitialized]
    374 |                         program_imu_rlc_ram(adev, data, (const u32)size);
        |                                                   ^~~~

As this warning happens early in clang's frontend, it does not realize
that due to the assignment of r to -EINVAL, program_imu_rlc_ram() is
never actually called, and even if it were, data would not be
dereferenced because size is 0.

Just initialize data to NULL to silence the warning, as the commit that
added program_imu_rlc_ram() mentioned it would eventually be used over
the old method, at which point data can be properly initialized and
used.

Cc: stable@vger.kernel.org
Closes: https://github.com/ClangBuiltLinux/linux/issues/2107
Fixes: 56159fffaab5 ("drm/amdgpu: use new method to program rlc ram")
Link: https://github.com/llvm/llvm-project/commit/2464313eef01c5b1edf0eccf57a32cdee01472c7 [1]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/imu_v12_0.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/imu_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/imu_v12_0.c
@@ -361,7 +361,7 @@ static void program_imu_rlc_ram(struct a
 static void imu_v12_0_program_rlc_ram(struct amdgpu_device *adev)
 {
 	u32 reg_data, size = 0;
-	const u32 *data;
+	const u32 *data = NULL;
 	int r = -EINVAL;
 
 	WREG32_SOC15(GC, 0, regGFX_IMU_RLC_RAM_INDEX, 0x2);


