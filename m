Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0FA8267386;
	Tue, 26 Aug 2025 11:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207430; cv=none; b=NxTvuYXueSlW6tZW23rgjB4mBv8anQfeEUfQq4bpRZFeRy0KqU7zt/XHsM3RlouWCh8awhjm7lveW3bTQkKXZk6oVyuG9C8dpDIG1tKVrSi9JfLIK5B90baUe/EOE5w74wbS/Es9oJiVP5NVctXQgKvxQf0Xf9DymBfzidJihzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207430; c=relaxed/simple;
	bh=IZABP5PrhXWe7I5GHFqXHmNRtkE3w9qrFcL0j5g5MiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ne9ic5U1dFfMGBJFoxJuBZL49b32Ep0VzOlCvHewNOx3xxFzac3yMbseJpj/LC/aSAw2PExiHuMkCvEddRCfkx7WC1GtSiRF4nqTNFrhU/U9AndGIHQVb5JKorgK0gJGJqf3jQqA7yp6FTutJ/jiTcJyfTJxMoDdLUs+ExJVp/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eoh7kpwj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eoh7kpwj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9052C4CEF4;
	Tue, 26 Aug 2025 11:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207430;
	bh=IZABP5PrhXWe7I5GHFqXHmNRtkE3w9qrFcL0j5g5MiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eoh7kpwjLnQw39SJtor1Azm3MjtjxhpfIIW9lIJX6Srz1A4v2eHBifrnGZAC5Mua6
	 60BtX+YKMIu04rG+Tb4fcbxtUv5QTKnf/0RaeuVVb1+dMbuNHmP2DcjNUd8rUNMe6y
	 7DDuXDcUTyJVTZnbBdiTCxOCdZ4TwRqm4b1pUncM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.16 177/457] drm/amdgpu: Initialize data to NULL in imu_v12_0_program_rlc_ram()
Date: Tue, 26 Aug 2025 13:07:41 +0200
Message-ID: <20250826110941.749420254@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -367,7 +367,7 @@ static void program_imu_rlc_ram(struct a
 static void imu_v12_0_program_rlc_ram(struct amdgpu_device *adev)
 {
 	u32 reg_data, size = 0;
-	const u32 *data;
+	const u32 *data = NULL;
 	int r = -EINVAL;
 
 	WREG32_SOC15(GC, 0, regGFX_IMU_RLC_RAM_INDEX, 0x2);


