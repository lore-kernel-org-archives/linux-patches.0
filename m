Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773D64477F9;
	Sat, 12 Sep 2026 08:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202401; cv=none; b=S3xbZUDP2koNvkfsWPYbNXz4lQpZYqGaedGaDOZlOs1LHB/XXKfnQ2oRwSrEZg7nsy8aHvjZhMEysu38Bph501DPXtgRwDlZpDcfd1PdqL3GaKJGBZi8yAmEe8JiNsSvY5mf4SwuY0b9CBBUS48uJZoeVaBaUZtEgH4Ar8TMzxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202401; c=relaxed/simple;
	bh=PKxpM+ujSDJZR6fx0qGxYn9exeaBBlk/skXU7w92ri0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QFYQmRPTa/efrUF+xBRQeb3VYKd1nqEK9VL12yuQvLt2sdlvWSI7IVqPaBKowth94ZvjGX3srbBet5cmm6idr/4oQ3e9lZSPl3pUcjFHY620ID1zmgF8vT0D8yihJ7bocFUMGZ9eBDfi7qF36CMeFENq0JS6b/kUJAwh7v3XsyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z+7WQWAs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z+7WQWAs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EACD1F000FF;
	Sat, 12 Sep 2026 08:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202400;
	bh=bx342SWQLVlvhHX19L1vXMj3Z/3arG8SGwx9irM8T1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z+7WQWAsW7ybC+g5z/DnImjeejo/LdTa6WFZkEgBus2kQyz5HVia6U9X2DVG0VdSS
	 JWWMU0Rt1mxZxXUGoFQ7E0CWBXmlw64gUHpGnmPMEWtzrhqf50HQi6jemMA7UCA54W
	 MsctEIT3sLdu8Qp1lZxMdV6sJxyU2cpTq/266ZRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Gan <jie.gan@oss.qualcomm.com>,
	Leo Yan <leo.yan@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1196/1815] coresight: etm4x: fix leaked trace id
Date: Sat, 12 Sep 2026 08:49:06 +0200
Message-ID: <20260912065717.090145037@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yeoreum Yun <yeoreum.yun@arm.com>

[ Upstream commit 467e5862ccb0eed907002f4c6d3badfe34360940 ]

If etm4_enable_sysfs() fails in cscfg_csdev_enable_active_config(),
the trace ID may be leaked because it is not released.

To address this, call etm4_release_trace_id() when etm4_enable_sysfs()
fails in cscfg_csdev_enable_active_config().

Fixes: 7ebd0ec6cf94 ("coresight: configfs: Allow configfs to activate configuration")
Reviewed-by: Jie Gan <jie.gan@oss.qualcomm.com>
Reviewed-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20260725113645.57519-4-yeoreum.yun@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm4x-core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index 1884960cfe6f7..8363c55b3952a 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -920,8 +920,10 @@ static int etm4_enable_sysfs(struct coresight_device *csdev, struct coresight_pa
 	cscfg_config_sysfs_get_active_cfg(&cfg_hash, &preset);
 	if (cfg_hash) {
 		ret = cscfg_csdev_enable_active_config(csdev, cfg_hash, preset);
-		if (ret)
+		if (ret) {
+			etm4_release_trace_id(drvdata);
 			return ret;
+		}
 	}
 
 	raw_spin_lock(&drvdata->spinlock);
-- 
2.53.0



