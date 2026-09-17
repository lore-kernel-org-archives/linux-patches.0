Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3FE19F40B;
	Thu, 17 Sep 2026 17:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665624; cv=none; b=LKfqypF674QkSP7pW02Rk8qoOvGGJS/2ClrypYGQV0/FrplFNKsOFVpF/6cTKD4lwJEt8+0Pezlcs8nZ8cFoAywTRDWrXWnsfUraT+WlCWR4jIzKcsL6MDFTapF74qlcm+kT2EEKBOHy8KbY0YeQuymI5CN0J7eJB7bnYSXBmtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665624; c=relaxed/simple;
	bh=XkW5MTNeC8vGd4jlTYzHr++m247YXArTfFnqNNq/eao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CdehpV8WtpfbC56uz1uY+qBPuyD0Gv3b+7KUwhShthSLqC98+zp0zAAP+OQl+mat4Rb0zLVcJZ0V6FmMoiNMWrhHm2YAjFmG8/yQzq3lCzpvnnoQf8o5c6tJKU6l9u3wiRdTsyaCswijD7JXxR/qGzcFS98FiqfgPa5XBNnCxzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hPBdJ8iE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hPBdJ8iE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A29091F000FF;
	Thu, 17 Sep 2026 17:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665623;
	bh=hytYP9SURmJyDtqYAWAYr/18GvZXEJ0s8EEUC/9PH4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hPBdJ8iEN5yFods/o9gSqNQgpLj8BLbGOYmWYbU+X+WktzOIa7qBkJHP+A8fPH4Wl
	 NBlKmeTioNQGcQ5m1DSSt6rKvzfPxDRIYLfb0iOnGQy1W2aF8/iN+54qkQhCnOi3Ey
	 0575D6DcgqEtQ/ZhmnI/LLAOc0tZaDnXxHbDvgFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0765/1250] ASoC: Intel: avs: Fix unbalanced module reference count
Date: Thu, 17 Sep 2026 16:09:20 +0100
Message-ID: <20260917151612.610427226@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 3534de46f9e45..d793071a22d48 100644
--- a/sound/soc/intel/avs/debugfs.c
+++ b/sound/soc/intel/avs/debugfs.c
@@ -8,6 +8,7 @@
 
 #include <linux/debugfs.h>
 #include <linux/kfifo.h>
+#include <linux/module.h>
 #include <linux/wait.h>
 #include <linux/sched/signal.h>
 #include <linux/string_helpers.h>
@@ -238,15 +239,20 @@ static int strace_open(struct inode *inode, struct file *file)
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



