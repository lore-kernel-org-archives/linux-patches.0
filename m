Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FCDA4EB844;
	Thu, 17 Sep 2026 15:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659406; cv=none; b=DjspWIjkVyG4MRH/FlPUe+iYqeWLADfNYWk8XckbMAEfqE4gSJIDpOS10afB2FOLuii6FGgA/hTIKqfc3wi8sRfx/3KSFbZY4Y40CNqVv/BfimpwG8Bzv213+FPvRcv744gdtfRHyzn0XyD1rA69PP4Bv4Letvr8qWkD9K0YHSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659406; c=relaxed/simple;
	bh=Ob96O00eH9BjgVhKemdAMs0UnQXe27SCohNiDoGflPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PMbRsfRTJq+mUZW3/8Y1+5Hv8sk+IyMgQ0LLrBkDc1WYioIa9FEGAWBrHRAS2mrw131cGQ3hheaGCh2iDXlU99fVSi2PuudDmHHCWVys1ZVuLKjuJPTyVrbCig0mMN7dYuTTESrWmrKhYdb6qZ6qXgbrq5p/OrQk+Riwk9FgwwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OdlGG/a3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OdlGG/a3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B31C51F000FF;
	Thu, 17 Sep 2026 15:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659401;
	bh=bN8OitTj7ZM0Q9BCFkBr8wnuBt6YYQrwCElLwLaOE84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OdlGG/a3CXDglFYqp+6cOW0QHHg7wzgwmrucSidgz0SUDrqnLbnEqn0AbkCCGDFvK
	 3FVNLeBwTw/EMp7y+STi2cj81ewDmtDeNmvcdvAVvpO0Ii45yfh/5qCegC6QP7ujgM
	 zkgQ9+jl9PACJgVwdE1CKCCeYprKKxbMDidNZPQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 242/733] ASoC: Intel: avs: Fix unbalanced module reference count
Date: Thu, 17 Sep 2026 16:09:10 +0100
Message-ID: <20260917151357.296292991@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit d4fa6f94b91137e329ea3f5b360e140b227bb696 ]

strace_open() invokes try_module_get() which on success takes
the module reference.  If any follow up operation causes
strace_open() to fail, the refcount shall be put down.

Fixes: 0a5fb3cc28fd ("ASoC: Intel: avs: Keep module refcount up when gathering traces")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20260902081814.1590883-9-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/debugfs.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/sound/soc/intel/avs/debugfs.c b/sound/soc/intel/avs/debugfs.c
index 701c247227bf9..fc321f61fc929 100644
--- a/sound/soc/intel/avs/debugfs.c
+++ b/sound/soc/intel/avs/debugfs.c
@@ -8,6 +8,7 @@
 
 #include <linux/debugfs.h>
 #include <linux/kfifo.h>
+#include <linux/module.h>
 #include <linux/wait.h>
 #include <linux/sched/signal.h>
 #include <linux/string_helpers.h>
@@ -235,15 +236,20 @@ static int strace_open(struct inode *inode, struct file *file)
 	if (!try_module_get(adev->dev->driver->owner))
 		return -ENODEV;
 
-	if (kfifo_initialized(&adev->trace_fifo))
-		return -EBUSY;
+	if (kfifo_initialized(&adev->trace_fifo)) {
+		ret = -EBUSY;
+		goto err;
+	}
 
 	ret = kfifo_alloc(&adev->trace_fifo, PAGE_SIZE, GFP_KERNEL);
 	if (ret < 0)
-		return ret;
+		goto err;
 
 	file->private_data = adev;
 	return 0;
+err:
+	module_put(adev->dev->driver->owner);
+	return ret;
 }
 
 static int strace_release(struct inode *inode, struct file *file)
-- 
2.53.0



