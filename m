Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E09EAD0;
	Fri, 15 Nov 2024 06:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653343; cv=none; b=M9wE8d1DWLMkjqJ9swwDaZmTiJ7aCqdUy4fNEamk8zLs0qSYkZx3QemJMYlBwBqyy3RsqUSVSKnhETXoKllR9JH8GoeyxWz87pYhD6NxA8zAu+IHNyazA850WuMS5lrNTMO8dsqTSbvJAS+4lVg+eUlvOL7NKYsiuW4wrDPLzfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653343; c=relaxed/simple;
	bh=Qjb5lbN5dAOcMqvO3ApEkvxJ15U4wNcEsofQvZq7kUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FsiMCssSoYvxdKU8bZPn20V163ErJI490QGNPky6STBWKWsCA2IVJfIhE/MN0O7ntuYKKgYgC89Tm+/GFTMjxaAGlOJS+OuGObFNWxe3/AFBCU6jvW5tZAS2ICLRlEjYxSJ3elCKK7Geitm8P0OYi5ce2SKDS757L84dFDafeQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XRR37g/B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XRR37g/B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 963EAC4CECF;
	Fri, 15 Nov 2024 06:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653343;
	bh=Qjb5lbN5dAOcMqvO3ApEkvxJ15U4wNcEsofQvZq7kUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XRR37g/B5WUYTgUveOefk/IQlY2UuIvMQ8eleNrZ3agI5ovjyUk0r5HPyvxJ+Qbh/
	 oidVdFIb99JBqIkpJmkZstYp+moQO+TZt5BoclEtZ150WLZdWbDSWBx86WbcI37s+/
	 CJoO11TiGQ0yYVlKZoXIGLI4DMeJcxjrr+rxrZdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Yao <jia.yao@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Zongyao Bai <zongyao.bai@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 57/63] drm/xe: Enlarge the invalidation timeout from 150 to 500
Date: Fri, 15 Nov 2024 07:38:20 +0100
Message-ID: <20241115063727.965591739@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.892410236@linuxfoundation.org>
References: <20241115063725.892410236@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuicheng Lin <shuicheng.lin@intel.com>

[ Upstream commit c8fb95e7a54315460b45090f0968167a332e1657 ]

There are error messages like below that are occurring during stress
testing: "[   31.004009] xe 0000:03:00.0: [drm] ERROR GT0: Global
invalidation timeout". Previously it was hitting this 3 out of 1000
executions of warm reboot.  After raising it to 500, 1000 warm reboot
executions passed and it didn't fail.

Due to the way xe_mmio_wait32() is implemented, the timeout is able to
expire early when the register matches the expected value due to the
wait increments starting small. So, the larger timeout value should have
no effect during normal use cases.

v2 (Jonathan):
  - rework the commit message
v3 (Lucas):
  - add conclusive message for the fail rate and test case
v4:
  - add suggested-by

Suggested-by: Jia Yao <jia.yao@intel.com>
Signed-off-by: Shuicheng Lin <shuicheng.lin@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Jonathan Cavitt <jonathan.cavitt@intel.com>
Tested-by: Zongyao Bai <zongyao.bai@intel.com>
Reviewed-by: Nirmoy Das <nirmoy.das@intel.com>
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241015161207.1373401-1-shuicheng.lin@intel.com
(cherry picked from commit 2eb460ab9f4bc5b575f52568d17936da0af681d8)
[ Fix conflict with gt->mmio ]
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_device.c b/drivers/gpu/drm/xe/xe_device.c
index fb394189d9e23..13213f39e52f9 100644
--- a/drivers/gpu/drm/xe/xe_device.c
+++ b/drivers/gpu/drm/xe/xe_device.c
@@ -870,7 +870,7 @@ void xe_device_l2_flush(struct xe_device *xe)
 	spin_lock(&gt->global_invl_lock);
 	xe_mmio_write32(gt, XE2_GLOBAL_INVAL, 0x1);
 
-	if (xe_mmio_wait32(gt, XE2_GLOBAL_INVAL, 0x1, 0x0, 150, NULL, true))
+	if (xe_mmio_wait32(gt, XE2_GLOBAL_INVAL, 0x1, 0x0, 500, NULL, true))
 		xe_gt_err_once(gt, "Global invalidation timeout\n");
 	spin_unlock(&gt->global_invl_lock);
 
-- 
2.43.0



