Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB3F46EC78;
	Tue, 21 Jul 2026 18:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659639; cv=none; b=LdOY7J4g0Czp4VNxp0cF/1yxbRJRHeeOm0P+8Vhw5QzwffFVYbi+3Ha5NhYOwHbsOoI5XYrwfa0+CJDze7mDFIGtnyfwigIqtDEf9GAXGDxYzBsivjriGhdz4y5H9k5ITMszrFeIIiwqLUhPJzJwFKEOlN8en+uwRuQuSuSEtSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659639; c=relaxed/simple;
	bh=G8ibjzTkoTVjJjzMws/XoDQp3RnSTtsUo4RCLQgkFAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tkA9oDZVKYmKcPNELGBmTWrZUsZFqVzyGLzANvYwH0o+0PULhye6lgxswiyWJGZAbpYKWPRW2HepulnUJgKbSyyukZuVV6NxBH+OWc9qNg8MrY8shB0jwxpX6bf8hSEz0wJ4FdeHpcmQiqBpgFzO2ejslCuWGewQIgQ2a0rsSaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fwqg4aGY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fwqg4aGY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6659A1F000E9;
	Tue, 21 Jul 2026 18:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659637;
	bh=w9Vsqc5OmkqGaQ+heSMCE87+lQnMTnsqdC2/hhUMC5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fwqg4aGYbpYND4t//ynEGIM5atec6JJ0QIgY8/WbmsUcnPwyq1qI2Zh23J8jeYZOm
	 fD7E0eQKkZvlovqX6XOmVbcItdfH8tsAefztrJrKAKYcBbLBAM4wDB64L8oRWCAX6P
	 FDDiG8vmJQwHZ6BM02aoao8b4fjWYpNPLVXqfq9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zenghui Yu <yuzenghui@huawei.com>,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 1596/1611] samples/damon/mtier: fail early if address range parameters are invalid
Date: Tue, 21 Jul 2026 17:28:32 +0200
Message-ID: <20260721152551.376148651@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zenghui Yu <yuzenghui@huawei.com>

commit 7746d72c64054976887928d64d2caf25c5a6dcc0 upstream.

The comment on top of `struct damon_region` clearly says that

    For any use case, @ar should be non-zero positive size.

which is now verified in damon_verify_new_region() if the kernel is built
with DAMON_DEBUG_SANITY.

The WARN_ONCE() can be triggered if the mtier sample module is enabled
before node{0,1}_{start,end}_addr have been properly initialized, which is
obviously not good.

 ------------[ cut here ]------------
 start 0 >= end 0
 WARNING: mm/damon/core.c:217 at damon_new_region+0xf4/0x118, CPU#59: bash/341468
 Call trace:
  damon_new_region+0xf4/0x118 (P)
  damon_set_regions+0xfc/0x3c0
  damon_sample_mtier_build_ctx+0xe8/0x3a8
  damon_sample_mtier_start+0x1c/0x90
  damon_sample_mtier_enable_store+0x98/0xb0
  param_attr_store+0xb4/0x128
  module_attr_store+0x2c/0x50
  sysfs_kf_write+0x58/0x90
  kernfs_fop_write_iter+0x16c/0x238
  vfs_write+0x2c0/0x370
  ksys_write+0x74/0x118
  __arm64_sys_write+0x24/0x38
  invoke_syscall+0xa8/0x118
  el0_svc_common.constprop.0+0x48/0xf0
  do_el0_svc+0x24/0x38
  el0_svc+0x54/0x370
  el0t_64_sync_handler+0xa0/0xe8
  el0t_64_sync+0x1ac/0x1b0
 ---[ end trace 0000000000000000 ]---

Note that the same issue can happen if detect_node_addresses is true, and
node 0 or 1 is memoryless.  Fix it together by checking the validity of
parameters right before damon_new_region() and fail early if they're
invalid.

Link: https://lore.kernel.org/20260629144432.133962-1-sj@kernel.org
Fixes: 82a08bde3cf7 ("samples/damon: implement a DAMON module for memory tiering")
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: SJ Park <sj@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.16.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 samples/damon/mtier.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/samples/damon/mtier.c
+++ b/samples/damon/mtier.c
@@ -120,6 +120,8 @@ static struct damon_ctx *damon_sample_mt
 		addr.end = promote ? node1_end_addr : node0_end_addr;
 	}
 
+	if (addr.start >= addr.end)
+		goto free_out;
 	region = damon_new_region(addr.start, addr.end);
 	if (!region)
 		goto free_out;


