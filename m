Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888E33A8F2
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VyGGFlEt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 332E6C433C7;
	Wed, 15 Nov 2023 19:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077756;
	bh=aQ8HkF5w3sM3ld6bh7oNnXWG3EmPGoju/Qrt2zSziMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VyGGFlEtTa9R7dAdb/BM/tgsnvOPpmy/pfMfW8DD6cog+KpwLL7Fl7h4F0GCL/N8Z
	 tt0jvhWWtpTUGTmlNGXaf9FXoPXuGkHmF4BCfJUSU7MUkm1/PtRLom0J2c6MpebGRr
	 hvzYNkaRNOJ6xZWb9qVT8NvqkGO5pdg28jK06vAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zhijian <lizhijian@fujitsu.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 500/603] cxl/region: Fix cxl_region_rwsem lock held when returning to user space
Date: Wed, 15 Nov 2023 14:17:25 -0500
Message-ID: <20231115191646.834748707@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

From: Li Zhijian <lizhijian@fujitsu.com>

[ Upstream commit 3531b27f1f04a6bc9c95cf00d40efe618d57aa93 ]

Fix a missed "goto out" to unlock on error to cleanup this splat:

    WARNING: lock held when returning to user space!
    6.6.0-rc3-lizhijian+ #213 Not tainted
    ------------------------------------------------
    cxl/673 is leaving the kernel with locks still held!
    1 lock held by cxl/673:
     #0: ffffffffa013b9d0 (cxl_region_rwsem){++++}-{3:3}, at: commit_store+0x7d/0x3e0 [cxl_core]

In terms of user visible impact of this bug for backports:

cxl_region_invalidate_memregion() on x86 invokes wbinvd which is a
problematic instruction for virtualized environments. So, on virtualized
x86, cxl_region_invalidate_memregion() returns an error. This failure
case got missed because CXL memory-expander device passthrough is not a
production use case, and emulation of CXL devices is typically limited
to kernel development builds with CONFIG_CXL_REGION_INVALIDATION_TEST=y,
that makes cxl_region_invalidate_memregion() succeed.

In other words, the expected exposure of this bug is limited to CXL
subsystem development environments using QEMU that neglected
CONFIG_CXL_REGION_INVALIDATION_TEST=y.

Fixes: d1257d098a5a ("cxl/region: Move cache invalidation before region teardown, and before setup")
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Link: https://lore.kernel.org/r/20231025085450.2514906-1-lizhijian@fujitsu.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/region.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 644032cd680e4..d1f513800c10d 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -288,7 +288,7 @@ static ssize_t commit_store(struct device *dev, struct device_attribute *attr,
 	 */
 	rc = cxl_region_invalidate_memregion(cxlr);
 	if (rc)
-		return rc;
+		goto out;
 
 	if (commit) {
 		rc = cxl_region_decode_commit(cxlr);
-- 
2.42.0



