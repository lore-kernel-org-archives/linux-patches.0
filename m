Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C4018EFCB;
	Tue, 10 Sep 2024 09:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961490; cv=none; b=D+RYQRO6/nAqIO2vMoJv9vyDEgumpiWeei13WnZNvJkJ7rQn0XfSZwYi995amLxBwNB94qU33rSDBBBppj0pNl/c3ckAtzjZNhlMdunCIudpiDX0aKd1Hau5AyB4PH3k22U63u3adbTKIWFmv/2OO+4div6MZagJNutaJUDk08o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961490; c=relaxed/simple;
	bh=2jCPx6Z1f3FLoRw4BuAw5MjdxW2e9uPFuWxHmFWNFGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sukoT5pFn9ETaw1CJCbh99Zo0WuBXzUHDpHaK1u5APWZXQMFCxfaD9g+qsPN5udQmu7YymwuCSAi5jCs6EWGpv93+gjGT4lZ8VzKx7RM8xfNC2Z+Z6eOVlp3x1Wp5OGJLtld5Y3ZaPgO/ebVmqjKMHV4SXHLpmJ6VV6RG3IyYAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AItld4vu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AItld4vu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C55C4CEC3;
	Tue, 10 Sep 2024 09:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961490;
	bh=2jCPx6Z1f3FLoRw4BuAw5MjdxW2e9uPFuWxHmFWNFGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AItld4vuV//qlMW76EMpfU4LRX/CN9Ycd7tG0FSMKqMA/QhvagNzfjPND4/iZpKzc
	 wNKONI2WyW9FcIwUEmMeLrnBrlKvjEqFXMhXue4vFYlTOrBBgg3KVy4/S0rr4D6UI0
	 Uz1uh/S9cC8aDFrLMqORsAe7yHpl64L0WGwaRj4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Binns <frank.binns@imgtec.com>,
	Matt Coster <matt.coster@imgtec.com>
Subject: [PATCH 6.10 088/375] drm/imagination: Free pvr_vm_gpuva after unlink
Date: Tue, 10 Sep 2024 11:28:05 +0200
Message-ID: <20240910092625.194696986@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

From: Matt Coster <matt.coster@imgtec.com>

commit 3f6b2f60b4631cd0c368da6a1587ab55a696164d upstream.

This caused a measurable memory leak. Although the individual
allocations are small, the leaks occurs in a high-usage codepath
(remapping or unmapping device memory) so they add up quickly.

Fixes: ff5f643de0bf ("drm/imagination: Add GEM and VM related code")
Cc: stable@vger.kernel.org
Reviewed-by: Frank Binns <frank.binns@imgtec.com>
Link: https://patchwork.freedesktop.org/patch/msgid/35867394-d8ce-4698-a8fd-919a018f1583@imgtec.com
Signed-off-by: Matt Coster <matt.coster@imgtec.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/imagination/pvr_vm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/imagination/pvr_vm.c b/drivers/gpu/drm/imagination/pvr_vm.c
index e59517ba039e..97c0f772ed65 100644
--- a/drivers/gpu/drm/imagination/pvr_vm.c
+++ b/drivers/gpu/drm/imagination/pvr_vm.c
@@ -114,6 +114,8 @@ struct pvr_vm_gpuva {
 	struct drm_gpuva base;
 };
 
+#define to_pvr_vm_gpuva(va) container_of_const(va, struct pvr_vm_gpuva, base)
+
 enum pvr_vm_bind_type {
 	PVR_VM_BIND_TYPE_MAP,
 	PVR_VM_BIND_TYPE_UNMAP,
@@ -386,6 +388,7 @@ pvr_vm_gpuva_unmap(struct drm_gpuva_op *op, void *op_ctx)
 
 	drm_gpuva_unmap(&op->unmap);
 	drm_gpuva_unlink(op->unmap.va);
+	kfree(to_pvr_vm_gpuva(op->unmap.va));
 
 	return 0;
 }
@@ -433,6 +436,7 @@ pvr_vm_gpuva_remap(struct drm_gpuva_op *op, void *op_ctx)
 	}
 
 	drm_gpuva_unlink(op->remap.unmap->va);
+	kfree(to_pvr_vm_gpuva(op->remap.unmap->va));
 
 	return 0;
 }
-- 
2.46.0



