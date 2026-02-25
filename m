Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6999D258ED5;
	Wed, 25 Feb 2026 01:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983645; cv=none; b=SCcdqDzHOAeYnClJj2IyiERO7lxX7psURXm+7bvOwqqOVLGqKZlSt68Ss0xl7WakZRX22pNUXy8zOkbxwNQ6YQCuoIVHRtscLFZGxtmoK1vC2avnBsjkbTLlX5bDmbSN6+r6sdny+r0a34Mgoz8LKXgq/2Is2k9AOmqfAk2Y24M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983645; c=relaxed/simple;
	bh=EkZkrL8BhQ+hyvc2AOC0P1XbY2AY4W109S0aaUg6bdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r3KYYgVUZLvy7motHN7W+e4d3kO/BlrntWXlkF9RorXhMGCEIhpgynLJqweGouZzgKPMtnIHzDxE4VXOjSN+d2SXrH6iBTMQ81VU8NvJcuOruTKvEvflXJvpKpJhtswJN2iX+BokDN4erpHo+nNyqhj2IZ8jSW4a1GdR17thQ7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=smYu62tZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="smYu62tZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A15C116D0;
	Wed, 25 Feb 2026 01:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983645;
	bh=EkZkrL8BhQ+hyvc2AOC0P1XbY2AY4W109S0aaUg6bdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=smYu62tZ0X5QA4Kn/guGrnzGpuC7cI7CWA3p9526InbyJ6W+GBPz6vdUrdANtwd1n
	 uAks9Ok/kcCE24s1TFFkM4BX6UdnJpHlLdbZSs/8qvGbTuXHEX/WOB9t8vCURPUXbw
	 WpGFvVtEVbVKeXAWOlx9oPU8segx68xomOgGwXnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raag Jadav <raag.jadav@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 733/781] drm/xe/bo: Redirect faults to dummy page for wedged device
Date: Tue, 24 Feb 2026 17:24:02 -0800
Message-ID: <20260225012417.708847778@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raag Jadav <raag.jadav@intel.com>

[ Upstream commit 4e83a8d58e1c721a89b3ffe15f549007080272e2 ]

As per uapi documentation[1], the prerequisite for wedged device is to
redirected page faults to a dummy page. Follow it.

[1] Documentation/gpu/drm-uapi.rst

v2: Add uapi reference and fixes tag (Matthew Brost)

Fixes: 7bc00751f877 ("drm/xe: Use device wedged event")
Signed-off-by: Raag Jadav <raag.jadav@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20260212055622.2054991-1-raag.jadav@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
(cherry picked from commit c020fff70d757612933711dd3cc3751d7d782d3c)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_bo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_bo.c b/drivers/gpu/drm/xe/xe_bo.c
index 71acd45aa33b0..579e98dec7492 100644
--- a/drivers/gpu/drm/xe/xe_bo.c
+++ b/drivers/gpu/drm/xe/xe_bo.c
@@ -1942,7 +1942,7 @@ static vm_fault_t xe_bo_cpu_fault(struct vm_fault *vmf)
 	int err = 0;
 	int idx;
 
-	if (!drm_dev_enter(&xe->drm, &idx))
+	if (xe_device_wedged(xe) || !drm_dev_enter(&xe->drm, &idx))
 		return ttm_bo_vm_dummy_page(vmf, vmf->vma->vm_page_prot);
 
 	ret = xe_bo_cpu_fault_fastpath(vmf, xe, bo, needs_rpm);
-- 
2.51.0



