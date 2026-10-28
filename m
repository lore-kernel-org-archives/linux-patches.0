Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211234;
	b=dVflDY4pkvKqNn8sSlHnhF8PRX4AHhZKkjJaHIHSXNrveNXlX28qsqu7+Bpt373ELqBp
	 08RdeTtGsRkysIwbDmnRhoHX+Db/cHe+9Tj0hcatTINkrXxDKjYCwpq1BYNxU9eFmPyP4
	 oAAhEkeoaxTjgnJxVieXpxgC1bx/HrSXjZJsSoA5T+vr5EXgkCPSj/p1c5cOaEQUVoS54
	 gPvgIk4uQqVTvIe0jVUB/yO/lvCK2RAzR6tWGb5/2H/tnwd8Bvsz7W9DMhJJdhsOwr+Cg
	 657rKXcIbTggpy4qCjvEqLQUK5B4Uga1bgP4hTfON+q048QpaMz+l0UmAOzslFJSg0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211234;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rdAJsSKVkSl6jahsWylk01NIy2LqWUsqdIfn+EDNqeA=;
	b=AEaKi/NpVubJltPUXZoUCz9mme/NoNQTUujpEsG8B5fzg2IVyZ+gUAujDUB1NDZlluTu
	 EQzzCNRpIJuHzRtmn8BbCS8ZSxWFJWJ0IVe9SPWw/xh3JdKXiXbhz/wdLq8oTPwVhVwq/
	 zNHmu12qfUk+nQS5QeZX6GDIEkuNnkrG3/1sMoq6la9PM1D/bEzHw4XntpdMpuixK/94f
	 KUlpHQ9r5ju43HB0MpIVhMXx8o3FVgKPwprWJcwolBibpxHDRJ8ddY5FahBFVpYKODTUU
	 WVeB1QFMo6s+3h+mi4E5bbemq401lltxay4Lkwqho75pVJGsXxX0vwFcFVM5WOXuldw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1MNcQXHg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7D6606B47F;
	Wed, 28 Oct 2026 18:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1MNcQXHg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B91401F01828;
	Wed, 28 Oct 2026 18:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211234;
	bh=rdAJsSKVkSl6jahsWylk01NIy2LqWUsqdIfn+EDNqeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1MNcQXHgRn+jGLIvmYclqVXpf9Nli0arkaw0vg++B4u6BaypYXkPw6iLWFn/t8S+X
	 NSIeY+myrvB5fqBjuxDHNUAkRtij0e9MkPfBVn5koW2CCcc9sVbGfjOzFppA0ZywwO
	 kZ3LiLSkWaxsNcq75cuzmmQkTMUA9HoceFC7TNyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willian Oliveira <williandossantosdeoliveira287@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 305/571] drm/amdgpu/gfx6: fix firmware leak on teardown
Date: Wed, 28 Oct 2026 17:57:32 +0100
Message-ID: <20261028170015.237459112@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Willian Oliveira <williandossantosdeoliveira287@gmail.com>

[ Upstream commit cc172e177795c5f87bc2d71768d077e1c10633e8 ]

The firmware requested in gfx_v6_0_init_microcode() is not released
when the GFX block is torn down, leaking the firmware resources.

Add gfx_v6_0_free_microcode() and call it from gfx_v6_0_sw_fini()
to release the PFP, ME, CE and RLC firmware.

Signed-off-by: Willian Oliveira <williandossantosdeoliveira287@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 386e81346f95ab0be5a82c5535de932e7a456924)
Cc: stable@vger.kernel.org
[ sashal: Replaced unavailable amdgpu_ucode_release() calls with inline release_firmware() and pointer clearing in gfx_v6_0_sw_fini(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
index 8f9a2e9c276ae..8d894a55c5d1c 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
@@ -3222,6 +3222,15 @@ static int gfx_v6_0_sw_fini(void *handle)
 
 	amdgpu_gfx_rlc_fini(adev);
 
+	release_firmware(adev->gfx.pfp_fw);
+	adev->gfx.pfp_fw = NULL;
+	release_firmware(adev->gfx.me_fw);
+	adev->gfx.me_fw = NULL;
+	release_firmware(adev->gfx.ce_fw);
+	adev->gfx.ce_fw = NULL;
+	release_firmware(adev->gfx.rlc_fw);
+	adev->gfx.rlc_fw = NULL;
+
 	return 0;
 }
 
-- 
2.53.0



