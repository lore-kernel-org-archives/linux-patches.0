Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D66934405F;
	Wed,  3 Dec 2025 16:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779346; cv=none; b=PpPurMGCmJpmxQRlTGcCJJBCEoq6RvXLZHTkohkdHRP4278ZZWHpVbih8+zAXvYHc7KUmxuoStAqNFQ7Td/DbjafFrJXsy7HGIcUbz0/UitXD1fD/Pyop15dHEAIYK3jb6jWtbejfLO83BWKMbAzgakPzhespV9YiSJhGZ5YhPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779346; c=relaxed/simple;
	bh=XAtPWJ5zxCzbZrk2k/I5B0k4BgwnyR8/3ADE8AP7tnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q3UJmaA+gEIj3kjo6qk3gosz3VdjmxuwXOeoVZ4sBk7Z9crMCURbWJy1uOcW2a+tjxN1FnTZvZRDLhuRIDt6ECb6f52ViwbCqc+YSfsBym1dj8AeIkEmXr8OK31uya8O+JiIrJqE3PLM6QRn98nlw3D+5SRUZ8xl5lx/RVQf5lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Aq/YQMem; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Aq/YQMem"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61CB7C116C6;
	Wed,  3 Dec 2025 16:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779345;
	bh=XAtPWJ5zxCzbZrk2k/I5B0k4BgwnyR8/3ADE8AP7tnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Aq/YQMem1Kr3oF7s8KtRlBgYDlogd703C+E8//4caUtCiFtkPKbGe4I814KLXzGtA
	 BVDmW/2iZy6NiAcc8B7Dbbo8FJ4tGmb5I9q8P9xO9qjqfm7YfbUFUC0HZF5g6MEAFK
	 iDDqUyMonAOeaQLY3mUOiEzVc2CSpH3eG2rVC0eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 230/568] drm/amdgpu: reject gang submissions under SRIOV
Date: Wed,  3 Dec 2025 16:23:52 +0100
Message-ID: <20251203152449.145568009@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <christian.koenig@amd.com>

[ Upstream commit d7ddcf921e7d0d8ebe82e89635bc9dc26ba9540d ]

Gang submission means that the kernel driver guarantees that multiple
submissions are executed on the HW at the same time on different engines.

Background is that those submissions then depend on each other and each
can't finish stand alone.

SRIOV now uses world switch to preempt submissions on the engines to allow
sharing the HW resources between multiple VFs.

The problem is now that the SRIOV world switch can't know about such inter
dependencies and will cause a timeout if it waits for a partially running
gang submission.

To conclude SRIOV and gang submissions are fundamentally incompatible at
the moment. For now just disable them.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index e0cd6a08ffb27..9ff6a9255c1b1 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -279,7 +279,7 @@ static int amdgpu_cs_pass1(struct amdgpu_cs_parser *p,
 		}
 	}
 
-	if (!p->gang_size) {
+	if (!p->gang_size || (amdgpu_sriov_vf(p->adev) && p->gang_size > 1)) {
 		ret = -EINVAL;
 		goto free_all_kdata;
 	}
-- 
2.51.0



