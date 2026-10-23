Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774967;
	b=NVRSTmUctpU1AOmumAIfWpwslrGatJ3Hug9ujjdukxXErSyW3BtXHjYnoSRQmv61oUGL
	 KaDXMViJ/Y6MjQdix/HfGGsb1NScirUlC3dS2nd4RXDRl9pj2yZTgu7g+eXxg0k4hPHko
	 5Yvzvq/0CxTKm4AUJyzRdER/RWB1bb3H6UE9yBaDtuG9qGNivYOpaH64DHLCKTZE/zAxW
	 tPlokZTv0AwLUN+rXgNL0AOvMNRzdwi3iD/UrvL8/lQXoe1S3R/IUBOWfIZbRhr0po90k
	 pZirr6zatsv3Q8sAvQL5CV8LjG0Vmn5BEURCJIDzNsQvPKQ1yBxDlcEcSCM9ZGgBUmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774967;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=eBt8Oq3kVIInYDSYzjLxi0dOV/JbbtfFPb4xpV9l3dk=;
	b=EgLfdCucssXO1sFxFvAB4lpu0G3wmI6Sn8A4wq2A3qQWD3jGYZjybV4ozK8gxHAPmsJ1
	 wOjcYToS079zdaFX5pxWonisBBl9ABR3lpuQobe3FI6Yv8C/zXbMvO6Awszi/O6g4I4hF
	 FAzu9scCfwWPH51KAnJa8ZUDARNHgXCysEdHn4S/gVj0VqMVcbzxnBF7cID0OUugBQ1Oa
	 FCyZCTNXS/Ob7Kem08/zdx3qABQ/JfAPJXVr1Tf/Am8NxLhQlPV5ccLGYL14KTbFUweyQ
	 f79TRogMBclfW1MpeOeyZAGdO5ucVmPdzkdaGv6hZtyJKW8wQkFYrf4O0Tdyqte8a1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Al/unYio";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D95606A31A;
	Fri, 23 Oct 2026 17:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Al/unYio
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19DF51F01825;
	Fri, 23 Oct 2026 17:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774966;
	bh=eBt8Oq3kVIInYDSYzjLxi0dOV/JbbtfFPb4xpV9l3dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Al/unYiouN6QaGVXRm9xPYIq2ijX3xZlhrmVbQjBoDJQnzzBfXG2K8MEfosga+Cu8
	 SX4KNECj7WHBE/qtXsRrc+VVmcRSz5LdsYChb55rUbnoVIka5+YX+SEFLVAhY05q4s
	 203cO++w1dL0Qi9zSKB0up3w6EO7g47t8DyJE/bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prike Liang <Prike.Liang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 210/242] drm/amdgpu: correct reservation fence slots for userq per-vm BOs eviction
Date: Fri, 23 Oct 2026 18:40:52 +0200
Message-ID: <20261023163718.764488659@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prike Liang <Prike.Liang@amd.com>

[ Upstream commit 50b24a20be8c0d35f89f7d5c39533f69d84fe48e ]

It fixes both the move overflow and the eviction fence add for
evicting these per-vm BOs.

Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 32d0771ef4ca ("drm/amdgpu/userq: actually validate userq BOs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
@@ -948,7 +948,8 @@ amdgpu_userq_bo_validate(struct amdgpu_d
 		spin_unlock(&vm->individual_lock);
 
 		bo = bo_va->base.bo;
-		ret = drm_exec_prepare_obj(exec, &bo->tbo.base, 2);
+		ret = drm_exec_prepare_obj(exec, &bo->tbo.base,
+					   TTM_NUM_MOVE_FENCES + 1);
 		if (unlikely(ret))
 			return ret;
 


