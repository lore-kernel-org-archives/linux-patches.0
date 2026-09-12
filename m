Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D04237757A;
	Sat, 12 Sep 2026 09:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205359; cv=none; b=ddke50rDyx97vdh0M3AYOFXj6f1DlHZeEMpYm6YHlY3AFwhnNjxMdjHJLF53QeFt6SNzNkqNlXX+xGPyVqwV2Qo9cw1+MWBWoAHsKmwphNZov8qD3jQdV2LJ/MYcsA0hKpxeMEXyqLxWoSpK5hPx2KJIqJ2wUIHK3sj59aDH+Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205359; c=relaxed/simple;
	bh=lBvOMpAshlCdMoGwK1oARrmGvekwTJBTrD4CQ0zuCR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fKKBELDz7EH2233EuIzZeQNkql8OmrQTwl7nsgH/th1i1jQKFkoFe2Cdgqjw3uslJTuekxXA3E4dp00X+Hw324bOiNWiL9DGZp/xl/u4bGp7/3HZM6N050dYvEMk+YXNc713WQzCyHGixN9D7395+5TDz71iRUcu8N6mFesJmTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2UgGfE72; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2UgGfE72"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D8D1F000FF;
	Sat, 12 Sep 2026 09:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205357;
	bh=3qhj5zzEl2Bb4zYxTH5ekdJjj9DxZdSBvWPRiNE65I8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2UgGfE72d4IAcNo0tG3DcGVeXCAB1VV3BolI1Mt6klI1IwlN36v5z3jJLkJ5cBMGt
	 EA9oKlG/aXSvEWHtBnf6GsqTaQjNxDQWUn5YM4+OlJqB9J3vgWJjwMwpsvHHo6opxJ
	 zspTz2vtZIBoX9fco3F0ztelwJhRFPyFk0pbwQSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Arvind Yadav <arvind.yadav@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1784/1815] drm/xe: Reject page faults from non-fault-mode scratch VMs
Date: Sat, 12 Sep 2026 08:58:54 +0200
Message-ID: <20260912065730.912763037@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arvind Yadav <arvind.yadav@intel.com>

[ Upstream commit 5e977521d21717edb8e91d004434697d6e3f248c ]

Having scratch enabled does not make a VM capable of handling recoverable
page faults. Allowing scratch VMs through the ASID lookup also admits
dma-fence mode VMs.

If such a VM faults on an already valid VMA, the handler reports success
without fixing the fault, causing the GPU to retry indefinitely.

Only allow fault-mode VMs through the ASID lookup. Fault-mode VMs using
scratch remain supported, while faults from 3D VMs are rejected.

Fixes: ad9843aac91a ("drm/xe/madvise: Implement purgeable buffer object support")
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Suggested-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Arvind Yadav <arvind.yadav@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20260820065445.567228-1-arvind.yadav@intel.com
(cherry picked from commit bfb24a06405b652d37831f3fb66b71d33a6605de)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_pagefault.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_pagefault.c b/drivers/gpu/drm/xe/xe_pagefault.c
index dd3c068e1a399..dbf8f71d3328a 100644
--- a/drivers/gpu/drm/xe/xe_pagefault.c
+++ b/drivers/gpu/drm/xe/xe_pagefault.c
@@ -158,7 +158,7 @@ static struct xe_vm *xe_pagefault_asid_to_vm(struct xe_device *xe, u32 asid)
 
 	down_read(&xe->usm.lock);
 	vm = xa_load(&xe->usm.asid_to_vm, asid);
-	if (vm && (xe_vm_in_fault_mode(vm) || xe_vm_has_scratch(vm)))
+	if (vm && xe_vm_in_fault_mode(vm))
 		xe_vm_get(vm);
 	else
 		vm = ERR_PTR(-EINVAL);
-- 
2.53.0



