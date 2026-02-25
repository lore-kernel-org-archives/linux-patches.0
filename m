Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F721E2834;
	Wed, 25 Feb 2026 01:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983629; cv=none; b=GgvcmpB4/JS8/LTwiXTnqhkSIgj0eY4T7ei8K2oeF012o3HM1+PNCRi3j+Suy+O70+AohfWUPpBpSURG/l3fsHdXgZha+opE96iI699uL+EjSq09BJkUtARTQVfM18WRWWK7i1MHO6w9RUw3ZLxAkOFcYl9V/owyz5O9kU9ofbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983629; c=relaxed/simple;
	bh=cAij1+YVKbClfI1PB9TJR0KMJGkkd17Yqze00JI8E9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MT5CdfWpH0H8+mCEEzE8ACg6OjbAIAX2Aox5JC7P5HjlosM8QGMx+UqD8OpzQjv9AuAKiFCGWpM6H9EjGFipIATt8fZ+Jgiv3CVgysqke3CX3xEVgLguhU7Sh8ABKly722dUR9NCk+YMIxgTPceoxaGbhfZQr6qWR84sT8Qy+dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c9ZhjGSa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c9ZhjGSa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 122B2C116D0;
	Wed, 25 Feb 2026 01:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983629;
	bh=cAij1+YVKbClfI1PB9TJR0KMJGkkd17Yqze00JI8E9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c9ZhjGSaukL5QLtCHj+m28ZJofL6aRP/RRWe1BBde+4wMZSdubxVAIsM+Z1dxQYkQ
	 ypYc2AfB/JLJ+/umUl79Z+DTqWo4OB8YzIB/iWLJp3eIIR3VOvi4sIyanLI2V7nUgK
	 qfh9JHqXsEfnft0lOXs26WsV8y0kl9sC+kXB+Bvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 720/781] drm/amdgpu: Fix missing unwind in amdgpu_ib_schedule() error path
Date: Tue, 24 Feb 2026 17:23:49 -0800
Message-ID: <20260225012417.396485080@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit ba038065655c45728be346d0b174a6da08d8a5c5 ]

amdgpu_ib_schedule() returns early after calling amdgpu_ring_undo().
This skips the common free_fence cleanup path.  Other error paths were
already changed to use goto free_fence, but this one was missed.

Change the early return to goto free_fence so all error paths clean up
the same way.

Fixes the below:
drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c:232 amdgpu_ib_schedule()
warn: missing unwind goto?

drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c
    124 int amdgpu_ib_schedule(struct amdgpu_ring *ring, unsigned int num_ibs,
    125                        struct amdgpu_ib *ibs, struct amdgpu_job *job,
    126                        struct dma_fence **f)
    127 {

    ...

    224
    225         if (ring->funcs->insert_start)
    226                 ring->funcs->insert_start(ring);
    227
    228         if (job) {
    229                 r = amdgpu_vm_flush(ring, job, need_pipe_sync);
    230                 if (r) {
    231                         amdgpu_ring_undo(ring);
--> 232                         return r;

	The patch changed the other error paths to goto free_fence but
	this one was accidentally skipped.

    233                 }
    234         }
    235
    236         amdgpu_ring_ib_begin(ring);

    ...

    338
    339 free_fence:
    340         if (!job)
    341                 kfree(af);
    342         return r;
    343 }

Fixes: f903b85ed0f1 ("drm/amdgpu: fix possible fence leaks from job structure")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c
index 44f230d67da24..bfa64cd7a62d4 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c
@@ -229,7 +229,7 @@ int amdgpu_ib_schedule(struct amdgpu_ring *ring, unsigned int num_ibs,
 		r = amdgpu_vm_flush(ring, job, need_pipe_sync);
 		if (r) {
 			amdgpu_ring_undo(ring);
-			return r;
+			goto free_fence;
 		}
 	}
 
-- 
2.51.0



