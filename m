Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062703;
	b=blWrcQW+YWNFCFQEJ6xXVVZwzsgu+bZgG/c37xMn5dgCKSF2OnWmZhSXrHBHK4ZMt48s
	 sV/kYHml78cFvpaBftdGLsMGlNXreaClvAw7R3lsp07CR5boeUPe5To53ydFO3sUwV0kS
	 HcweBnIdD/3/xhMGOVsTdpqMF9GIFQNWwXt1JrU6nGTxumbcZMQ3BXT4LmNCDwa5rHifo
	 wIjgCvZmIJ1P7C2+G8H5Ylw2npHNsYcKpG6m4O1ZGbAtsfI9NsspDDDv4clDnTIgRsamE
	 y1gb9EYTqe0hXyK/+iIly7wMnvOP+fLf0i/OoBRQy+g2Zfeday0t7e90Nv7wPNS4bxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062703;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=KWzoY05kij5YqUNbkP3U/HSLuHtxZq8TpaC3ItznjTA=;
	b=tWOl9N9tIEPeVk8JYYxAXTb7LosesNlSNFPhWtOyDG3Y2J/MEROp1+/gwZ7Dkw9pF6dE
	 svioM8Eq7nB2WSY0QZr8am6d/WeWbWHcmGK/TBgOrPeQAScUv9f+QVfKV90VefrQ5quid
	 5naeVIidWCU/wTBkQI6P299P+3udVOEzI8JzRq8AkFwN0Q2dgLSgGfqirI2wFRH3/Uymy
	 T+Q+a/IcdEcGVtz3P9Atv6lkbyiaAzj1XYtKif62xeQnVCrtN3ZY5tvemDy24M4KRwdpt
	 blH7698Vk9974cnK9PAlODZ0R07tAq2NTRJc3+Upf4JL7NL3JXlYSaIzSysLzrs6uKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PPkvBkPP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF7A606A330;
	Sat,  7 Nov 2026 14:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PPkvBkPP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C5D31F008A1;
	Sat,  7 Nov 2026 14:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062703;
	bh=KWzoY05kij5YqUNbkP3U/HSLuHtxZq8TpaC3ItznjTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PPkvBkPPbSo7MERQVfLaKuA7o13lGtY0c1C/EG8ONRVN7vu0SlIRklfH4ubWLklWi
	 GoOAfelpA9zoJS8mxbNq8u1IAGaoDypb7UYM8oDpTp2iY2yprAlqySqXD6ozLel3E+
	 fbegpLLO2g/08LEQGXY+GiUo4EKELR2FMR3QoLTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YuBiao Wang <YuBiao.Wang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 027/869] drm/amdgpu: recompute the dw estimate after allocating a new VM update job
Date: Sat,  7 Nov 2026 08:45:09 -0500
Message-ID: <20261107134853.021756572@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: YuBiao Wang <YuBiao.Wang@amd.com>

[ Upstream commit a74c7832b11827907de560169c7d4ac94505fd87 ]

amdgpu_vm_sdma_update() keeps the number of free dwords of the current
job in a local variable. When the job runs out of room it is committed
and a new one is allocated, but that local variable is not refreshed and
still describes the job which was just submitted.

The stale value is then used to decide how many PTEs fit into the new
job. If it happens to be copy_pte_num_dw + 7, or one more than that, the
result is zero. copy_pte() encodes the transfer size as count * 8 - 1,
so a count of zero asks the engine for a 1GB copy starting inside the IB
pool. That runs off the end of the pool, faults on the first unmapped
GART page above it and hangs the ring.

Re-initialize the estimate from the newly allocated job, which is empty
and therefore has its full budget available.

Cc: stable@vger.kernel.org
Signed-off-by: YuBiao Wang <YuBiao.Wang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c
index 36805dcfa1598..902d0a538e419 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c
@@ -254,6 +254,11 @@ static int amdgpu_vm_sdma_update(struct amdgpu_vm_update_params *p,
 						     AMDGPU_KERNEL_JOB_ID_VM_UPDATE);
 			if (r)
 				return r;
+
+			/* The estimate above describes the job which was just
+			 * submitted, take the budget of the newly allocated one.
+			 */
+			ndw = p->num_dw_left;
 		}
 
 		if (!p->pages_addr) {
-- 
2.53.0



