Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B393183CA6;
	Mon, 12 Aug 2024 16:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479751; cv=none; b=fIwvDGwbHAD9TC3JDrcjhFsH6mNTLtQ/PqsGJwqYi3di4b1YiPzcWwt1Uj4QtAVunrvKmJE2pdopgemKPVZvJPX8DIbMUqEgZoi1KyrSr/Nf6U2M8C0ggRRMJfZQvJFZNUcizqnUDilhosA+qwdlatwzGU0Fn+RGB8mG+zCPYuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479751; c=relaxed/simple;
	bh=oqr1o1Rk+kkLIjss6GWEzeCQStU1rJEK4hScVEtdBdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DhHLUlI0JZwJf1yO/0qEIT+mxPiRWlaRMMFiHKg3mJI5zQkN7j8QgIJ5naGYi5F34aYSvKha0U88JikLccOovzSiUSO0CvpwjLbn4sthYqvp9L8G6z0fLHy24wUrCj8WAwhe4T5B198Y8js/TqMX2AB/HBkxe6em8JVwluEJCbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2FIrf+Gp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2FIrf+Gp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E25CC32782;
	Mon, 12 Aug 2024 16:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479751;
	bh=oqr1o1Rk+kkLIjss6GWEzeCQStU1rJEK4hScVEtdBdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2FIrf+GpsqZM1JJ2/StQ54OilIi8VZHlXdqfqBKVp4NXZGwnDs24LWjjpc/aipzsk
	 xrwSFulTtNoDM5y/r0x34HpOHuk/JwAjZCHNGYvJYwnbyNCNnhRq/VOEy7LYK2bAz5
	 gRdgTaDaRTf1PKAjRLeO2VwEJcjXyhfffRpzJkCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danilo Krummrich <dakr@redhat.com>,
	Dave Airlie <airlied@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.6 180/189] nouveau: set placement to original placement on uvmm validate.
Date: Mon, 12 Aug 2024 18:03:56 +0200
Message-ID: <20240812160139.074719796@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 9c685f61722d30a22d55bb8a48f7a48bb2e19bcc upstream.

When a buffer is evicted for memory pressure or TTM evict all,
the placement is set to the eviction domain, this means the
buffer never gets revalidated on the next exec to the correct domain.

I think this should be fine to use the initial domain from the
object creation, as least with VM_BIND this won't change after
init so this should be the correct answer.

Fixes: b88baab82871 ("drm/nouveau: implement new VM_BIND uAPI")
Cc: Danilo Krummrich <dakr@redhat.com>
Cc: <stable@vger.kernel.org> # v6.6
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240515025542.2156774-1-airlied@gmail.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_uvmm.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/nouveau/nouveau_uvmm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_uvmm.c
@@ -1320,6 +1320,7 @@ nouveau_uvmm_bind_job_submit(struct nouv
 
 		drm_gpuva_for_each_op(va_op, op->ops) {
 			struct drm_gem_object *obj = op_gem_obj(va_op);
+			struct nouveau_bo *nvbo;
 
 			if (unlikely(!obj))
 				continue;
@@ -1330,8 +1331,9 @@ nouveau_uvmm_bind_job_submit(struct nouv
 			if (unlikely(va_op->op == DRM_GPUVA_OP_UNMAP))
 				continue;
 
-			ret = nouveau_bo_validate(nouveau_gem_object(obj),
-						  true, false);
+			nvbo = nouveau_gem_object(obj);
+			nouveau_bo_placement_set(nvbo, nvbo->valid_domains, 0);
+			ret = nouveau_bo_validate(nvbo, true, false);
 			if (ret) {
 				op = list_last_op(&bind_job->ops);
 				goto unwind;


