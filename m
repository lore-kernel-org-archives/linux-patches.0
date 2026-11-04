Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827058;
	b=GNszS4BDIkoYYgJpEOZfUWXbgFzgh9SX74q0n+cqxwn0DMLZX1rgXSKnJXHsjMo5gAt2
	 YNuTYw6LzMJtqRi28+9zSF1pzfydGCroQtOOMHPcY3rUXCTIV6SWKHb58RnFWoUHH3QRp
	 DcrZCSLDIyhUh5lIvp16mJHpvK76CXWN9mDsZALAA2oIVSdS1RmylgVoKq+Vo8NkfFgk6
	 JXJGz/c4cTwnfBieyzGPPRHiOYRribLBk9X0qguYRQ8xjkfrdpR9T+pcqCQ6H4xg4hSC5
	 HNYTnxGNypxewo/wTnhPFniAJNqwMRALfQue/Dt4/lx2KGCSlJ3v25fr/PFHiDeYmeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827058;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XZubt2ihF1O1F9uFnnYD1u0uBbhXxyOHNthWk8P+cPg=;
	b=J7s6lP1HEva8R3Y5qszGzYGuKeq6lUbN8/042v4wVREoZf6HcjfCRxuLWgmXRg4P+niy
	 UTB1k4QmycsNON7IAuqc06m3guhXMPQ90hysTc/x9f3rvx95FlBYY153s3PBA22X6h5EM
	 wprqM02uqa8f00K6xiRMihRfVZODH/+w+ThnQFFAFjdmp5eK6j89kKZ2S2BV+orVgkbPp
	 kqzUpSNFSoB+W3c+h9Vj7+k3jKKyzdxDM+kQO4M2EnP8w6WAFuJJsH34eFCY8pHrO21gx
	 a1GU/Zr8MRD4J5GiJqv8E/bKWhLg8aplq0N2qEuz07z+X+8/xKq8f1LSKfV9kMNSZDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZHw5wEJ8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C64606A840;
	Wed,  4 Nov 2026 21:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZHw5wEJ8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A8FF1F000C1;
	Wed,  4 Nov 2026 21:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827057;
	bh=XZubt2ihF1O1F9uFnnYD1u0uBbhXxyOHNthWk8P+cPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZHw5wEJ8qO1f9Rc89IjBXVnfHRhgC644FPVf4DHSz/OuaaWNEt7VjjoHcFGqhT5RT
	 vwMTXDqtoSehUcJIzSz8s+9laV0JaDnsjBeH5eJC4GlbDkah/4wzcwMjlDq/PD6pFZ
	 v4U1m79HqgJXTUEJJcH3G1mMARb2nYW826qQZc8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Rob Clark <robin.clark@oss.qualcomm.com>
Subject: [PATCH 7.3 168/547] drm/msm: Fix vm_bo use-after-free in with_vm_locks()
Date: Wed,  4 Nov 2026 16:05:52 -0500
Message-ID: <20261104211042.924969718@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit 81878aa1a2f551f51a3d3aef2a9509503ec34d8b upstream.

The unwind loop drops the vm_bo reference taken while locking before
advancing to the next entry.  drm_gpuvm_bo_put() may drop the last
reference, removing and freeing the vm_bo, after which the plain list
iterator dereferences freed memory to advance.

Use the safe iterator, which saves the next entry before the body runs.

Fixes: fe4952b5f27cca5d ("drm/msm: Convert vm locking")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Patchwork: https://patchwork.freedesktop.org/patch/754331/
Message-ID: <20260916175548.2089821-1-vulab@iscas.ac.cn>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/msm_gem_shrinker.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/msm/msm_gem_shrinker.c
+++ b/drivers/gpu/drm/msm/msm_gem_shrinker.c
@@ -51,6 +51,7 @@ with_vm_locks(void (*fn)(struct drm_gem_
 	 * success paths
 	 */
 	struct drm_gpuvm_bo *vm_bo, *last_locked = NULL;
+	struct drm_gpuvm_bo *next;
 	bool locked = true;
 
 	drm_gem_for_each_gpuvm_bo (vm_bo, obj) {
@@ -82,7 +83,7 @@ with_vm_locks(void (*fn)(struct drm_gem_
 
 out_unlock:
 	if (last_locked) {
-		drm_gem_for_each_gpuvm_bo (vm_bo, obj) {
+		drm_gem_for_each_gpuvm_bo_safe(vm_bo, next, obj) {
 			struct dma_resv *resv = drm_gpuvm_resv(vm_bo->vm);
 
 			if (resv == obj->resv)


