Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662F33EA9A;
	Wed,  7 Aug 2024 15:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723042912; cv=none; b=Swe3Mrx4V5SWdUgS7aXcDCF8q0157W7Bs4IBMs83vbaC5SL7wh3T4usiezo/Dg1gt7+KIg06wImbTrkTivsdhKeiKBmxpnuJ3ue0FgtoKo3WnpTWQm4YGkeBUp5j7EPFHZUYECx/Ij8RDI8SUq1qFpc1FdOcBcsy9DFbAI0KUDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723042912; c=relaxed/simple;
	bh=yz66p5R+fdpPph2b7QjHxLxOTQRzYe4mCSvu4JQXN9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UpYDVq9o4rQL8aAuop3ZIbAOEkCTLeIn6ce9hH4A5wktkeUdx7fDhzi9pK8SZJSx9H3N6JjGBCh3C+4wGdNdODfTuTlC3XHGYKg80wSBSumnq8Y4SHJwkW1R3FggPYPOiCUg9qdidaBi3d3OvOY6i2MvgLVJWc3gSGFy9bq5/5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iz62jEM3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iz62jEM3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD86C32781;
	Wed,  7 Aug 2024 15:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723042912;
	bh=yz66p5R+fdpPph2b7QjHxLxOTQRzYe4mCSvu4JQXN9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iz62jEM32pqRy4WHV90cu9i5ao4X/mGRnJbwowKEWq7H+GsuFlGJSBG2AEzy+raRm
	 xUOWCSIdL0CYklqLUFPeuHQuizxM6UN1k1gXoqsB2ZZQJVRipt0JP5gUwMxHRlIfmy
	 l6uXk87WjRTl7uYjLxUVO4BMBv8gktRAMJk+U7Fc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Skeggs <bskeggs@nvidia.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 021/123] drm/nouveau: prime: fix refcount underflow
Date: Wed,  7 Aug 2024 16:59:00 +0200
Message-ID: <20240807150021.505473679@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index b58ab595faf82..cd95446d68511 100644
--- a/drivers/gpu/drm/nouveau/nouveau_prime.c
+++ b/drivers/gpu/drm/nouveau/nouveau_prime.c
@@ -64,7 +64,8 @@ struct drm_gem_object *nouveau_gem_prime_import_sg_table(struct drm_device *dev,
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



