Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03068827;
	Mon, 23 Dec 2024 16:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970553; cv=none; b=SCCC2+DROwHj2b8vArVUsNw1tkghbnZYtyPhWYNytEmgNN4ZjprH+PIBvD7WuHo68vgOmfHSEWqRFgx0ceW0EGZvEOnIqPAo4egbYEDzFg7xDPfoZMMiSzfNO9bill1LLVvbQAqpUZXrcjdzdTpVBvFGljwAueICJCxWj9gWftU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970553; c=relaxed/simple;
	bh=F9DjLvZuw4yeqNtQAgcb1BLTUbjIwYtqWWbB85xJWRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r0lGN302VrNByjhBmXPbAWfI8KLyfvuQ7pAzkGlpHJae1XxiEr79eb8s4tuGJ8PH5cQknl9a5wzOuVykqtLrejKt3ZoS3EeUWb27wY1Q7bLm/cNPKbH+R49DXBF+4AZ70Q9mm315qAool6md4GoDEq7TV9h6+Nek+0OMTN2NujI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dTs/HkSD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dTs/HkSD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E83C4CED3;
	Mon, 23 Dec 2024 16:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970552;
	bh=F9DjLvZuw4yeqNtQAgcb1BLTUbjIwYtqWWbB85xJWRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dTs/HkSDJn09vvynGiCLCF4AMTk3WuKFVvc4YzsRfDzcTojgwxCMZluhQ9/xLUZMu
	 OFeavgPpOPMJ4hNfOQjipsK2UEJ2Hkj7tsPtwJt12w9DPxwr8XG3UPJnex7S04DPvx
	 DC8vdATVlegjnVp1HrcOTaJkGsmQ1FLDInRiWIqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	=?UTF-8?q?Michel=20D=C3=A4nzer?= <mdaenzer@redhat.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 116/116] drm/amdgpu: Handle NULL bo->tbo.resource (again) in amdgpu_vm_bo_update
Date: Mon, 23 Dec 2024 16:59:46 +0100
Message-ID: <20241223155404.062703866@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michel Dänzer <mdaenzer@redhat.com>

commit 85230ee36d88e7a09fb062d43203035659dd10a5 upstream.

Third time's the charm, I hope?

Fixes: d3116756a710 ("drm/ttm: rename bo->mem and make it a pointer")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3837
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Michel Dänzer <mdaenzer@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 695c2c745e5dff201b75da8a1d237ce403600d04)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -1161,10 +1161,9 @@ int amdgpu_vm_bo_update(struct amdgpu_de
 	 * next command submission.
 	 */
 	if (bo && bo->tbo.base.resv == vm->root.bo->tbo.base.resv) {
-		uint32_t mem_type = bo->tbo.resource->mem_type;
-
-		if (!(bo->preferred_domains &
-		      amdgpu_mem_type_to_domain(mem_type)))
+		if (bo->tbo.resource &&
+		    !(bo->preferred_domains &
+		      amdgpu_mem_type_to_domain(bo->tbo.resource->mem_type)))
 			amdgpu_vm_bo_evicted(&bo_va->base);
 		else
 			amdgpu_vm_bo_idle(&bo_va->base);


