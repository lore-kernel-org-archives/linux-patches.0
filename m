Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D449823DE;
	Wed,  7 Aug 2024 15:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043629; cv=none; b=Cr1tWWBQ2iV1sj965EydA84RpYM9MWpFq2k3AD5dKNrowB+eWfczTnei6eKpxvP+Im64AuvH3QV9nmX1mZxq7Ti2PfsnZMZcSsX4ydBDk3Vm0osdhGsVueJ/0ImxuWdF2oIbBB/UKtU5DNpo5kWqsNHhyNRPSsrRD1gthQMgHAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043629; c=relaxed/simple;
	bh=llLU+/L3iYJOF3rL3B6LRaVC4Emh8Bcxj3PhPgyIvmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hCADu3PiSHe2epSpbeHPWcWjqb7weKLUwXqel9ti8CndJ1qyZWAXqpE2FCDGeurTfXZ/fBDiuUL5zOcBP5HspjarqhOHwXuQ6ZrxR2a5q/O0aec9wjJe8XdYTZ6wp+bx/QdUgjrvPtZwYVdiZ/zAShYF3RzwuU1yuEjcrxBL+Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gr7fVpNa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gr7fVpNa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5BE2C32781;
	Wed,  7 Aug 2024 15:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043629;
	bh=llLU+/L3iYJOF3rL3B6LRaVC4Emh8Bcxj3PhPgyIvmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gr7fVpNa0Z/crvKIVjHCln1/+fowkHm87cwETb0e+3T2QsPwhtwltX8E1XDCUWeET
	 g5FKxsWp73q8Zs97s30xLYjGs7u1nQ/+m6nnLNyC6znyVzu6Lg4o0+DvMCqHlXKxlc
	 4NeEXsBzgNxoRzBwmnOOH4r4NjCTeS7XQSbrTVUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Skeggs <bskeggs@nvidia.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 41/86] drm/nouveau: prime: fix refcount underflow
Date: Wed,  7 Aug 2024 17:00:20 +0200
Message-ID: <20240807150040.596666593@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150039.247123516@linuxfoundation.org>
References: <20240807150039.247123516@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Danilo Krummrich <dakr@kernel.org>

[ Upstream commit a9bf3efc33f1fbf88787a277f7349459283c9b95 ]

Calling nouveau_bo_ref() on a nouveau_bo without initializing it (and
hence the backing ttm_bo) leads to a refcount underflow.

Instead of calling nouveau_bo_ref() in the unwind path of
drm_gem_object_init(), clean things up manually.

Fixes: ab9ccb96a6e6 ("drm/nouveau: use prime helpers")
Reviewed-by: Ben Skeggs <bskeggs@nvidia.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240718165959.3983-2-dakr@kernel.org
(cherry picked from commit 1b93f3e89d03cfc576636e195466a0d728ad8de5)
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_prime.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_prime.c b/drivers/gpu/drm/nouveau/nouveau_prime.c
index 9608121e49b7e..8340d55aaa987 100644
--- a/drivers/gpu/drm/nouveau/nouveau_prime.c
+++ b/drivers/gpu/drm/nouveau/nouveau_prime.c
@@ -63,7 +63,8 @@ struct drm_gem_object *nouveau_gem_prime_import_sg_table(struct drm_device *dev,
 	 * to the caller, instead of a normal nouveau_bo ttm reference. */
 	ret = drm_gem_object_init(dev, &nvbo->bo.base, size);
 	if (ret) {
-		nouveau_bo_ref(NULL, &nvbo);
+		drm_gem_object_release(&nvbo->bo.base);
+		kfree(nvbo);
 		obj = ERR_PTR(-ENOMEM);
 		goto unlock;
 	}
-- 
2.43.0



