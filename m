Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591222;
	b=SK6gn31SHzSWxfNLzzTHaUMCDkKUSuYPS3gNtgzB1FeQq9/Olh6chazWkxrQ3kDvi6dl
	 1PNos+G38EM0wahGZ6DntM0dx3r1ZmNwphh0b5oVU/zScCl1kXBCKVtkDaIBR36K2bZKq
	 cgM6QPaC6IMVtqxDpt8tST+MEkTAuNwBLqS4ys/7jM6+nqsejn4XZj2PtyqNTppniWXuq
	 qcbOaYPn6YtUhoAMrD60birOVCeHe4GJ5AYeUSgkiwbMcII2qxZRV5GQHViQXTa2G2JGA
	 uXqTJ5uGpgrOP8Ez8k7PL9NmHe+y+GYIj5wXk4aR2KNdsbY0d4ErXM/wiS4B+8jQRAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591222;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=c5WeX2Sk8/oA7OKS5MPY4/Z2Tg5GGOQyLROS1kv56+k=;
	b=yvQqNr9EJ2prTTfkP58KkVoo6awXIcVe2zv1/eRHxECvljyNVLzpZ4oYujH+65AMASSs
	 OhlR617a+faRfSrgTLDbHffZk4s5LfFiZiReTkt+2NnSXG/wmFmGDlZWrpb0FMb39JJQd
	 pIFltk75xDX8EFRqThizGUHPwD7g8h1n2H/zdBShBO5Es59N8le+fZMNiZAEJy/STUJtk
	 cPwvMUFzZnGHmymJZBrxEFkQdYR9Xceqj4A7T/G6QjgIQ+E16fForjuYi1XltZyMQSXOm
	 xBKxTSA3CvgbLRcLIkKDiCe9aEbfm4k1KVtwfbyla+soRd3eXHI8JauW/XM5ED35/TA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gjzpDAlp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295EC6075E1A;
	Fri, 13 Nov 2026 17:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gjzpDAlp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9A551F000CC;
	Fri, 13 Nov 2026 17:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591222;
	bh=c5WeX2Sk8/oA7OKS5MPY4/Z2Tg5GGOQyLROS1kv56+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gjzpDAlptXk7k5c3pAOtq2w25kpCuh+0dhTkNvuRxhctIf+tSnaP9521I6ZabfYu0
	 qQNdBlRAbmL7JtmPalDXHYuoDXbWTxM99dt0YicZMoiGiTslS6aD75LkT/llf+8nQx
	 MrUkHp69+CniAK5Ilh/rXbmtGohUGn1Y4P6Bm7Tc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 354/670] drm/amdgpu: dont drop the gang dependency fence twice
Date: Fri, 13 Nov 2026 10:48:38 -0500
Message-ID: <20261113153823.818173966@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7b4bd20aee6f1..502872bfde49c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -1325,10 +1325,8 @@ static int amdgpu_cs_submit(struct amdgpu_cs_parser *p,
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



