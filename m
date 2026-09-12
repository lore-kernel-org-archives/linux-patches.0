Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12672DAFDE;
	Sat, 12 Sep 2026 14:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225026; cv=none; b=Yu9h2Cu+1MhF8Xymx13V31eNCE7Bt5d8XDLxpsQi2xpqSnjg3GTddgBMyTGgdBzbNpfC7crcY6w2IyEEvrHQ3OseKsY33L8qBgUWoL37F6Gl+Z+0DGmgELmsBPLTn/D2lBbosEtS984sK009NjNR2d3P8jjxvUhoz458QJzn55o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225026; c=relaxed/simple;
	bh=KQ/BmG2dJlp+Thhsp07mbnKRtUpldoKLiBH9Joudmb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o34bd+g+eFIQSmOGErh+yXk59VJB/QYYf1koG/axQ+tFLIUdkaYE6W2xcevZ7bMNA7m1cQ4wNHPqej2qatGvX+AQEAE26kjFgWAlutahN0bTqtkGavrwpy5n0JfZ/pND5sb0ohSlYOkTkelQVmQa2olAXh9fKdh+1Va4SRtF4to=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1AqHnPmE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1AqHnPmE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 983FD1F000FF;
	Sat, 12 Sep 2026 14:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225024;
	bh=7FMSi30s0Ru0jzpmol3/kw6m1YsK5iETsZVWoMmI5hM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1AqHnPmElrq6LVnlvvn0vkALjGntrjLZ6OronRAGl+ezQTb8vJytQSHAiEgpSvuT4
	 +BXwjaR3hVFX354jzCXDbmT7VldLQfvpn5XzsKlck/iwIkMvLyGboxbEtAE3zEOepy
	 r3KaL+5c/4kUvhyBDGrQnk/ONj+SOvEVj/LRb7wE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Gan <jie.gan@oss.qualcomm.com>,
	Leo Yan <leo.yan@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1114/1424] coresight: etm4x: fix leaked trace id
Date: Sat, 12 Sep 2026 08:59:06 +0200
Message-ID: <20260912065632.250861516@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 88c9cc483ea50..ace8027d7cb7d 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -848,8 +848,10 @@ static int etm4_enable_sysfs(struct coresight_device *csdev)
 	cscfg_config_sysfs_get_active_cfg(&cfg_hash, &preset);
 	if (cfg_hash) {
 		ret = cscfg_csdev_enable_active_config(csdev, cfg_hash, preset);
-		if (ret)
+		if (ret) {
+			etm4_release_trace_id(drvdata);
 			return ret;
+		}
 	}
 
 	spin_lock(&drvdata->spinlock);
-- 
2.53.0



