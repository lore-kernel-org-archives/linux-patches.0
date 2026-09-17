Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13694E36C2;
	Thu, 17 Sep 2026 18:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670398; cv=none; b=B2gddIgaXblYdqzGQSB0vtVT7r5TutbKPH00BU8jB4NwZ86uquiPp300/3DJAHACBRBrqLEJGsLfllWAQ+PANLiuQoWosRwv+Qw3fgvyzMfp0Q/PgamKTfOJY4OEPKrydg2dklGJ+xJYgyHkY8hGAgz/JKoQrhSvhZm1TdE1QiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670398; c=relaxed/simple;
	bh=LWymDk8WVgj9JWATrQZBG0eD7BpNEwE+o3QeuWd8JFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r3XrAEra6h95T5Hq6X15Wlfj1dXBx9x3bCis3FPcp1klhCEtclgofaM4Xj1fKig2ClYw7V72MKNrMDkJ9rBZ1Zmq7J1NV2RSMOnoyYtQwc821yGTqRYSm+ArKrkZxBLejxg1yErbZ/2Ho4f2U168tZGLBZ+NlyTmWD7pPMYHIZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gdRdXt+x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gdRdXt+x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD811F000FF;
	Thu, 17 Sep 2026 18:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670396;
	bh=e/vRogdFobQi73Okh4ZCvzYnl4JuAGCOKmTwQTDJPro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gdRdXt+xS8kYiD2JopVPUKOFLs7e4+2lvyMwuL/Hpf1g/qiLXQpleafx6ZMlpsb9u
	 6+UrDX+dCy4Pyjh5BuH2w4ME9AS7VMCoiuOIKNF82ELZFk+rkXLcVyVQauos6X14Cv
	 UTXmnFuZswlc+SvssUgQXp/xEFp1DZdnkIidMEZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0651/1102] ASoC: Intel: avs: Fix unbalanced module reference count
Date: Thu, 17 Sep 2026 16:09:54 +0100
Message-ID: <20260917151556.506822995@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c9978fb9c74e2..bea5e36ead3ea 100644
--- a/sound/soc/intel/avs/debugfs.c
+++ b/sound/soc/intel/avs/debugfs.c
@@ -8,6 +8,7 @@
 
 #include <linux/debugfs.h>
 #include <linux/kfifo.h>
+#include <linux/module.h>
 #include <linux/wait.h>
 #include <linux/sched/signal.h>
 #include <sound/soc.h>
@@ -236,15 +237,20 @@ static int strace_open(struct inode *inode, struct file *file)
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



