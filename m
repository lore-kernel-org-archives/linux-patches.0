Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530DF13A25F;
	Tue,  9 Jul 2024 11:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523918; cv=none; b=IbiLkJKguCpuKBGBjYCDyC763IQ1LDOhF9wjtUpevB/2Rjq6wbgVguOzpb80cJCjXZ7Val20Yy7w5lmYeDSBMy6MW6U4wQ4fbMvIOqmvhWPTB9zpJylFWuo3mAlIFNOoDBkvZ8rFp2UMzvyQMSg0wre5acheuZa9rlAYpyNnWbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523918; c=relaxed/simple;
	bh=adq/m4tZFOOTiMTw7DkiVlVEGj6PknCHBoZ3W6itZ1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ym3ToIrNIMbwYvjB1waxWIA4g+gSIcg2/4//um6SCxKgGV0qqLJdPqgZwjZ462PcAF/6rYaEdeOeZ2I/GA1vxHjMvrFmAsmQQGMrg9gKbaWIlwjJ8lS0QC+EGj+r7Uu+IEQLjl8rZEHyYY6suyD07PqITBJ5Pq4vx9yczt9A4Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xL9uo0UI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xL9uo0UI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEFBBC3277B;
	Tue,  9 Jul 2024 11:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523918;
	bh=adq/m4tZFOOTiMTw7DkiVlVEGj6PknCHBoZ3W6itZ1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xL9uo0UIWV96Z/VKkJShOqrfTXY6pWGa9b/ZZUh5Lr+F8THOVvMiF/p7i5HO8OhN3
	 lozNT6P+YmqBLuM8VdAieOfhC1tkiNQId0QVOuHYsyM7q4+UJ4ati5zozGC08WOubl
	 L/g0dPpKP/W/bNbIOZnL137mKRWf1dbGESK0+Who=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Francois Dugast <francois.dugast@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 012/197] drm/xe: Add outer runtime_pm protection to xe_live_ktest@xe_dma_buf
Date: Tue,  9 Jul 2024 13:07:46 +0200
Message-ID: <20240709110709.387849632@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rodrigo Vivi <rodrigo.vivi@intel.com>

[ Upstream commit f9116f658a6217b101e3b4e89f845775b6fb05d9 ]

Any kunit doing any memory access should get their own runtime_pm
outer references since they don't use the standard driver API
entries. In special this dma_buf from the same driver.

Found by pre-merge CI on adding WARN calls for unprotected
inner callers:

<6> [318.639739]     # xe_dma_buf_kunit: running xe_test_dmabuf_import_same_driver
<4> [318.639957] ------------[ cut here ]------------
<4> [318.639967] xe 0000:4d:00.0: Missing outer runtime PM protection
<4> [318.640049] WARNING: CPU: 117 PID: 3832 at drivers/gpu/drm/xe/xe_pm.c:533 xe_pm_runtime_get_noresume+0x48/0x60 [xe]

Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Francois Dugast <francois.dugast@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240417203952.25503-10-rodrigo.vivi@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/tests/xe_dma_buf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/xe/tests/xe_dma_buf.c b/drivers/gpu/drm/xe/tests/xe_dma_buf.c
index 9f6d571d7fa9c..a3d2dd42adf96 100644
--- a/drivers/gpu/drm/xe/tests/xe_dma_buf.c
+++ b/drivers/gpu/drm/xe/tests/xe_dma_buf.c
@@ -12,6 +12,7 @@
 #include "tests/xe_pci_test.h"
 
 #include "xe_pci.h"
+#include "xe_pm.h"
 
 static bool p2p_enabled(struct dma_buf_test_params *params)
 {
@@ -259,6 +260,7 @@ static int dma_buf_run_device(struct xe_device *xe)
 	const struct dma_buf_test_params *params;
 	struct kunit *test = xe_cur_kunit();
 
+	xe_pm_runtime_get(xe);
 	for (params = test_params; params->mem_mask; ++params) {
 		struct dma_buf_test_params p = *params;
 
@@ -266,6 +268,7 @@ static int dma_buf_run_device(struct xe_device *xe)
 		test->priv = &p;
 		xe_test_dmabuf_import_same_driver(xe);
 	}
+	xe_pm_runtime_put(xe);
 
 	/* A non-zero return would halt iteration over driver devices */
 	return 0;
-- 
2.43.0



