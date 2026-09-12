Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FEDB315D49;
	Sat, 12 Sep 2026 12:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217584; cv=none; b=khxJa6jNvtPeCBISfKVodBvF6avICcvPDq8exlwV6oI0WIA93seREqVaXBfIc9lmaT+xVLY5cvL5x+DOhJMQZoZXg8d0bokI7PRIJZ1Y0K9bPh/1D6AEYfff3vJL97Odn4+bMowyp71SaY9ZiFnl3liNZ7V+CaU6nI0VEaeEq48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217584; c=relaxed/simple;
	bh=MKwa17w9Z90hxjtLNjQoV7WPjJbHdroVhW3NQ4C9hVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lsrni5VpG/iZQd1snSQAP/VME2ZheJ7Y1wjlvUTnac06VaXHZacArBuarFfybGuEusnGrKE/SLSF6qaEIu7uvadFQI5J/egPk4ByXV398XpqXWkMLRpeWwmpz4xHmnV+NqqhPKUQ7XpQaPoOylOOP473R5hPKWmtFmORqgOJp4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OEFKXNrS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OEFKXNrS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0CE1F000FF;
	Sat, 12 Sep 2026 12:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217583;
	bh=CJ8AytVf5mlMX0TlopS3Y5WclKoBzTBWjDckov6obIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OEFKXNrSWhz3vMlEfMIhAmXLvcDLVxgO3VNJSaIMAzFwg1IMQd+VITZXvuRBLVSOl
	 PC58Op96RYaQNka3iwejYsuGnJoRNArZpTeDlAS+1VnT8LQr4nmdpuzBHzB2nSuFdD
	 vdtMmIsBdx7EqwvQ+1gM3YFeWkGvLymotzse4Eek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Gan <jie.gan@oss.qualcomm.com>,
	Leo Yan <leo.yan@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0961/1376] coresight: etm4x: fix leaked trace id
Date: Sat, 12 Sep 2026 08:56:27 +0200
Message-ID: <20260912065628.978276585@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index 0157dc5b08928..312abd57ddce9 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -854,8 +854,10 @@ static int etm4_enable_sysfs(struct coresight_device *csdev)
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



