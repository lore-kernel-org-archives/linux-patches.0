Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81CD1DE8BA;
	Tue,  8 Oct 2024 12:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389771; cv=none; b=RxlANvJ5FK9De0uGCHd39ZssUz3HmGlw8kfIWJrqobQSM6F6ZsMxUrlKlxqyWCJRu/P8eC8uCd3gGSpn2uUBSVXTXkvJ7lHgj5J8q/01LB7nfCtrRUl8bFkK6Bg9cUZ5HXvlGzDyGchg0dXOH8+DH/iHTtxI6MIwCe59k58iq+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389771; c=relaxed/simple;
	bh=gM6xZYeP5S0ne9iuTfCeaVeWXxJBAghm2TK+JDYIpIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ndgjwF4XEdbl0G/DVpLK7gO4k0Y0HiGYSuEUhsqQF4bLUJNAhDpg89TCJx0uXtkEoio5wp6+vijfnQy45u9Ufhy6sQIRR7luHxKO3SkHPKeVwDsMMEIIXBDAivrnE9Rz9IFkZaXji3U45NsCC4CDja4SkBWVezbpaeaVCjpW0rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IEP6esVA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IEP6esVA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35420C4CECC;
	Tue,  8 Oct 2024 12:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389771;
	bh=gM6xZYeP5S0ne9iuTfCeaVeWXxJBAghm2TK+JDYIpIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IEP6esVAUFyhAL8KId5ASc08gAe7iArK4+RQMbo9m6HpYm1l+uRh0hvw/jMecYUc5
	 Cz2Q695pnPt38hDzzHvNOsasR9uCJMjjQaeQWF9Vu6SfItJczJP3tWYZV021m0+qML
	 erZR7D0uHyysRzVBAe04ja3xHC0WteICzhPt0wEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 060/482] drm/panthor: Lock the VM resv before calling drm_gpuvm_bo_obtain_prealloc()
Date: Tue,  8 Oct 2024 14:02:03 +0200
Message-ID: <20241008115650.669857370@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit fa998a9eac8809da4f219aad49836fcad2a9bf5c ]

drm_gpuvm_bo_obtain_prealloc() will call drm_gpuvm_bo_put() on our
pre-allocated BO if the <BO,VM> association exists. Given we
only have one ref on preallocated_vm_bo, drm_gpuvm_bo_destroy() will
be called immediately, and we have to hold the VM resv lock when
calling this function.

Fixes: 647810ec2476 ("drm/panthor: Add the MMU/VM logical block")
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240913112722.492144-1-boris.brezillon@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_mmu.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/panthor/panthor_mmu.c b/drivers/gpu/drm/panthor/panthor_mmu.c
index cc6e13a977835..ce8e8a93d7076 100644
--- a/drivers/gpu/drm/panthor/panthor_mmu.c
+++ b/drivers/gpu/drm/panthor/panthor_mmu.c
@@ -1251,9 +1251,17 @@ static int panthor_vm_prepare_map_op_ctx(struct panthor_vm_op_ctx *op_ctx,
 		goto err_cleanup;
 	}
 
+	/* drm_gpuvm_bo_obtain_prealloc() will call drm_gpuvm_bo_put() on our
+	 * pre-allocated BO if the <BO,VM> association exists. Given we
+	 * only have one ref on preallocated_vm_bo, drm_gpuvm_bo_destroy() will
+	 * be called immediately, and we have to hold the VM resv lock when
+	 * calling this function.
+	 */
+	dma_resv_lock(panthor_vm_resv(vm), NULL);
 	mutex_lock(&bo->gpuva_list_lock);
 	op_ctx->map.vm_bo = drm_gpuvm_bo_obtain_prealloc(preallocated_vm_bo);
 	mutex_unlock(&bo->gpuva_list_lock);
+	dma_resv_unlock(panthor_vm_resv(vm));
 
 	/* If the a vm_bo for this <VM,BO> combination exists, it already
 	 * retains a pin ref, and we can release the one we took earlier.
-- 
2.43.0



