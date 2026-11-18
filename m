Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037829;
	b=RXM+fAHnnpTzTC0S9EIneVD+SLr7cVnTKQ7mMq3kVLsPhyzm/xQlepGxQ4oZUq5Q2RLB
	 YPzOjEo3iTdBwpwXQ6TOuyAqdoX2KoamrEKhclkrAhZG9Y39ej0G00K9LLMemCbpv1+1G
	 paqIukmwfyU6lgHTetZJ1s+6WabNGR6znxYmk16CZqYZp6ScAwUA3sYUtxhecS9c20spb
	 lsbys3h2i/K4S0l/CyrW/xUCgZQXo6G5sYk9/T0aJaLssw4CVWMpjby5davbsFGKyhumF
	 /X1q+ca6G9e1kArhhfjD2umpZwOY2SCa4Lnuox1xo59z9kREWL61VTlLoCKFtXmRJfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037829;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W2ziai1dZ8wkk5yRUtRhxImqbgUNiDQcXXI0yYdyG58=;
	b=wz+2C5qQAabK53a2R2EXNZL0GQ7F/xzyDdJyD7qelH9dYVkvIC7OeOakROOaSdtqTMKc
	 FkecJaG92FqOlqsHwFfJu7tY1UECuR+fOopwGmbDxrHOY6SIvSrj6G3KooR1wKT8E0keG
	 pk0tqxksbAw0pvy4xFyhjBK6CysfS6LfiBNgtgOWjVfFdn7gGqn9H9mrCYmI9BKoBuAwu
	 CBC6AupRfYiFKYQysaWXsjPo986KP8LKQyarMSDanRi6tPU2tLzluUwD3BocOoAkSaMzc
	 Nu2rudBu3ZgeMUhhwSwy58IKLzIMShOCJpLWPSxnAD5gWGjTUOggYKPCmQxeoW8ggMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QkVd5w88;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 273BB606A32A;
	Wed, 18 Nov 2026 21:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QkVd5w88
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BAD41F000C7;
	Wed, 18 Nov 2026 21:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037828;
	bh=W2ziai1dZ8wkk5yRUtRhxImqbgUNiDQcXXI0yYdyG58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QkVd5w88M3z/xpBHXk0IUMwoPNfwPwtrnXrG5C+NRx2R+iDfrN19MtcNqVidnKeJc
	 t96g+4TjpDJfE+pRBc428spOgwhVQGmVexXe2h2vtMGI5PLv562t/YpP6ZkjgrIzBy
	 f8Zby2PVxQlHUdAITiu4QMJgGotMcExH7JAT917w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Erhan Bilgili <erhan.bilgili@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1532/3318] drm/amdgpu: Fix duplicate dependency fence releases
Date: Wed, 18 Nov 2026 15:35:54 +0100
Message-ID: <20261118150406.934253928@linuxfoundation.org>
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

From: Erhan Bilgili <erhan.bilgili@gmail.com>

[ Upstream commit ea47f84199241dd083d40a241beea665415d4f6c ]

drm_sched_job_add_dependency() consumes its fence reference on success
and failure. Do not release the fence again if
drm_sched_job_add_dependency() fails.

Fixes: 41cc108b2451 ("drm/amdgpu: fix missing dma_fence_put in error path")
Fixes: c1c4a8b21721 ("drm/amdgpu: grab extra fence reference for drm_sched_job_add_dependency")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Erhan Bilgili <erhan.bilgili@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit e04f3dfb2071451633e6440a3911a9bb65df9144)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c    | 4 +---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c | 1 -
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c
index 1b013a44ca99a..03ba96c7a71d9 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c
@@ -392,10 +392,8 @@ int amdgpu_sync_push_to_job(struct amdgpu_sync *sync, struct amdgpu_job *job)
 
 		dma_fence_get(f);
 		r = drm_sched_job_add_dependency(&job->base, f);
-		if (r) {
-			dma_fence_put(f);
+		if (r)
 			return r;
-		}
 	}
 	return 0;
 }
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c
index be7d91574ec56..c8e510b27654c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c
@@ -246,7 +246,6 @@ static int amdgpu_vm_sdma_update(struct amdgpu_vm_update_params *p,
 		dma_fence_get(fence);
 		r = drm_sched_job_add_dependency(&p->job->base, fence);
 		if (r) {
-			dma_fence_put(fence);
 			dma_resv_iter_end(&cursor);
 			return r;
 		}
-- 
2.53.0



