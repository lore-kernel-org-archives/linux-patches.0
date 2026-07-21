Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D82A46DFF5;
	Tue, 21 Jul 2026 18:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660261; cv=none; b=UNS7ca6UJCHm+42cYCyuvC2xCAaqR51Tn3kpoDzhWmyMFHKcbopQ6IqZrzChkE+aYgXWYfABCwxYmd3640rqn566psYclJvMc4ca2HoujyDS/IIDYSGEzoJkvJBRsW7N69/JwdwchW0WoEDvJrn4hpZkM8f7EnIHsIj6SNiVj48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660261; c=relaxed/simple;
	bh=kzujns/nt873yxx4075rCSzmmXvvWgHvxDac/2o/01s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n6AWgMIBgt19bbqiapVwYU4qcQdZpup29gTYqMRRctGTGDmoGOk6GxBu/NjJxfjJZxQg/GBqgaeVOYNxJDZIihuQ9VursrYOFVfB3rKHx01+DHOiX6r86dMgVV+VhGlNN+FDASj2+pcYMK8N5T3011jpp1Mm2iTN3571+rso43w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jz9Q0e/d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jz9Q0e/d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB1361F000E9;
	Tue, 21 Jul 2026 18:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660258;
	bh=NtE0E7NniPhNTvRUEvFpLN4xLOXmpMTuZAbajxU+45w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jz9Q0e/d/hX+HgUlZPcxSnZqpAPBdnsUO4kWGCeF4npqhOgvC3lJ1KYGEEMLvMQo8
	 kN9WeOnnhimtCGbMQmJuYWqxev40FRURCyoENha5HLHcP1DRIHruFVpmQjZFVv/nx/
	 UV8z+TYDBvd5dVQ9pqE6xko+rZaqSTnskwea976M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	James Clark <james.clark@linaro.org>,
	Jie Gan <jie.gan@oss.qualcomm.com>,
	Leo Yan <leo.yan@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0875/2077] coresight: Handle helper enable failure properly
Date: Tue, 21 Jul 2026 17:09:08 +0200
Message-ID: <20260721152613.431900526@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit 864754d0a084141085f154db044401fb2dce6a34 ]

If a helper fails to be enabled, unwind any helpers that were already
enabled earlier in the loop. This avoids leaving partially enabled
helpers behind.

Fixes: 6148652807ba ("coresight: Enable and disable helper devices adjacent to the path")
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Tested-by: James Clark <james.clark@linaro.org>
Tested-by: Jie Gan <jie.gan@oss.qualcomm.com>
Signed-off-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20260515-arm_coresight_path_power_management_improvement-v14-2-f88c4a3ecfe9@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-core.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/hwtracing/coresight/coresight-core.c b/drivers/hwtracing/coresight/coresight-core.c
index 2105bb8139407b..256f6a32621b8e 100644
--- a/drivers/hwtracing/coresight/coresight-core.c
+++ b/drivers/hwtracing/coresight/coresight-core.c
@@ -499,10 +499,19 @@ static int coresight_enable_helpers(struct coresight_device *csdev,
 
 		ret = coresight_enable_helper(helper, mode, path);
 		if (ret)
-			return ret;
+			goto err;
 	}
 
 	return 0;
+
+err:
+	while (i--) {
+		helper = csdev->pdata->out_conns[i]->dest_dev;
+		if (helper && coresight_is_helper(helper))
+			coresight_disable_helper(helper, path);
+	}
+
+	return ret;
 }
 
 int coresight_enable_path(struct coresight_path *path, enum cs_mode mode)
-- 
2.53.0



