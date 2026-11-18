Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037834;
	b=m2JbBjulrrlFIorBE/QK2J8X8uhlsGgw0KDegtgA40opochsjm73D0KiEJIDXdgbxuqM
	 onz97DIL4sUd+YwcGrJprrmWR2GRxMwFmVY66P3kXEDUDJ63Tv3capnkqTB19TRxo/P65
	 2zUocwjrg1/7X7roZA8/X+v8Q3t21z65DMpE3AcmkMr3puXEcnp8c+GOAHrO+oYrXnEoS
	 Oc8uu3oMT3Z75oKWv5vy2zHawJzSezuh888fWD52YOIlfwSHNpclSkArQG1vAkcnZ60Gr
	 8Wuv83FxET4rYxoMmM+DaRh7A6zdBB0dNcE3bbDpmXSokynPUjX7TRrlfV0dDnf+NbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037834;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=EObHrAurtsBLb51OuzzAGylnVUsJti8nW+NOr/jPQkY=;
	b=D5lpd85uhrXF7UOBF99TZjaGFf8H8sy8+c3EtiNgBBIVgTee4jAu/6ni2RKeeJozKmGM
	 jZaxH49kXxGZ1mySOE7V6GSCXyCQTxSfmsCCPquKW1tuZs4idCq1a0MB67YEPiASk0xVM
	 WyblXSs6JxLDrt4BSr8FDXqbEeX6buTeDCeRqz+OgFhIn+R27AN3n32taA36MU5NYr072
	 iWAEkTfjPae8GVG/C1tQal6TcIJgcQ9ll+p7bM21eaTuOGnYrbihaBJLBSwKgeFXrgWoy
	 +vJm2kHBRcr5grJUoHrU4vhWYJQiCJ1/wKLhJ7OQgRtfBrNKq8sB9wKO1T0NgfZ+uCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dsFPbJg9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD3560A2603;
	Wed, 18 Nov 2026 21:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dsFPbJg9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16DF81F000CC;
	Wed, 18 Nov 2026 21:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037834;
	bh=EObHrAurtsBLb51OuzzAGylnVUsJti8nW+NOr/jPQkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dsFPbJg91ONfvJ/MytHusQdxC1+pUaPwLzhYBlSYeZhr4ws9qiZlEXjMUDc79rTvz
	 1EaDNDXIPWNnRlw46Q3gCR5JYf/e+SYR4MoqyBbw2ZrTx6N3GY6pfLWOPgolOJEmyK
	 lKz5jj4QvueHxBg10xwm1J4MrspS3atknhumwdLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1534/3318] drm/amdgpu: dont drop the gang dependency fence twice
Date: Wed, 18 Nov 2026 15:35:56 +0100
Message-ID: <20261118150406.994407312@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <Jesse.Zhang@amd.com>

[ Upstream commit 6d1f901a83603a7d314e4a756b416b11d8dc7e35 ]

drm_sched_job_add_dependency() drops the fence reference when it fails,
but amdgpu_cs_submit() drops it again, so the scheduled fence of a gang
member loses a reference it still needs.

A GFX+COMPUTE gang waiting for another context, with the
xarray node allocation for the leader's dependency failed through
failslab:

  WARNING: drivers/dma-buf/dma-fence.c:589 at dma_fence_release+0x34d/0x730, CPU#1: amd_uapi_regres/2993
   drm_sched_job_cleanup+0x2c2/0x340 [gpu_sched]
   amdgpu_job_free+0xcb/0x3e0 [amdgpu]
   amdgpu_cs_parser_fini+0x435/0x710 [amdgpu]
   amdgpu_cs_ioctl+0xcd2/0x7a60 [amdgpu]
  Oops: general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] SMP KASAN NOPTI
  KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
  RIP: 0010:dma_fence_signal_timestamp_locked+0x1b8/0x610

Fixes: ed21f6c3fe42 ("drm/amdgpu: fix another missing fence reference in the CS code")
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 5aa070a83c8378810b906cc8bfc650ce69822a7c)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index efbd297f4cc43..12000996f7a45 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -1316,10 +1316,8 @@ static int amdgpu_cs_submit(struct amdgpu_cs_parser *p,
 		fence = &p->jobs[i]->base.s_fence->scheduled;
 		dma_fence_get(fence);
 		r = drm_sched_job_add_dependency(&leader->base, fence);
-		if (r) {
-			dma_fence_put(fence);
+		if (r)
 			return r;
-		}
 	}
 
 	if (p->gang_size > 1) {
-- 
2.53.0



