Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5893921DC;
	Thu, 17 Sep 2026 18:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668625; cv=none; b=R5gg29WiDp4MkcaqEndq/EMcU2vYE7UyRf4Ta/yKzvBnzmhcH/XpKwU5H1zYyDmcHGDC4vpLmHobACHxhYdZR/RryE3wUpT4xRrQ+9uQHNPpclv5RV52XWm/a1Jckk+xPUUpSbu+4M2Ocn98nlP7CUKtblp4/W8Lg9GmQj3AZ9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668625; c=relaxed/simple;
	bh=1ZH0my8Pt6dDk6qYO60+irjFj8ZorlhNoFXiXlIrVmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rc4U2KrNV5cz8o+PlO2GJhmOOQ7spvmuY3HYP0KoS5mDht7JYPIMQ7Rj/1IqURsJiw0EkqJx4/291RyVvqPe5NnYzV2VNgy6/u093PFmtWJcKDoAwiEYzibTiElqh0FluxLYhLiG6Rr62DKXaZMPoGYUT2Tp9tnEMTt5zjDm/oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gg0iJzC2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gg0iJzC2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C6A1F000FF;
	Thu, 17 Sep 2026 18:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668624;
	bh=jOB2P0fRReES9tDf/t60HlzLBSed+BgQvkttWLOHMts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gg0iJzC2jik8wAwT7Zc8b77pidWKNNo2Hxl0SORJNlDsQUBYDXDlQhgx/UIGISfr5
	 6bwN7vGqqd5nKkBv1ve8g8TsbJzh0YOne/fy5kB/x0X5/7NWX9fWFbK5YZ9Hh5vP/+
	 +oo+HF0bpBmin+xlpn6vLQc2durAb0oBrXVbtwl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Gan <jie.gan@oss.qualcomm.com>,
	James Clark <james.clark@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0487/1102] coresight: platform: defer connection counter increment until alloc succeeds
Date: Thu, 17 Sep 2026 16:07:10 +0100
Message-ID: <20260917151551.929001404@linuxfoundation.org>
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

From: Jie Gan <jie.gan@oss.qualcomm.com>

[ Upstream commit 1563ae33dc4f5ebac96b93af2ef72e72aaaa31ae ]

coresight_add_out_conn() increments nr_outconns before calling
devm_krealloc_array() and again before devm_kmalloc(). If either
allocation fails, the counter is already bumped while the corresponding
array entry is NULL or uninitialized garbage.

coresight_add_in_conn() has the same problem with nr_inconns and
devm_krealloc_array().

In both cases the probe returns -ENOMEM, which causes
coresight_get_platform_data() to call coresight_release_platform_data()
for cleanup. That function iterates up to nr_outconns (or nr_inconns)
entries and dereferences each pointer unconditionally, hitting the NULL
or garbage entry and panicking instead of failing gracefully.

Fix by moving the counter increments to after all allocations succeed,
so the struct is always consistent on any error path.

Fixes: 3d4ff657e454 ("coresight: Dynamically add connections")
Fixes: e3f4e68797a9 ("coresight: Store in-connections as well as out-connections")
Signed-off-by: Jie Gan <jie.gan@oss.qualcomm.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20260511-fix-ref-count-issue-v1-1-99d647810d3c@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-platform.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-platform.c b/drivers/hwtracing/coresight/coresight-platform.c
index 64e171eaad82c..ebb1cbb79f3c9 100644
--- a/drivers/hwtracing/coresight/coresight-platform.c
+++ b/drivers/hwtracing/coresight/coresight-platform.c
@@ -45,9 +45,8 @@ coresight_add_out_conn(struct device *dev,
 		}
 	}
 
-	pdata->nr_outconns++;
 	pdata->out_conns =
-		devm_krealloc_array(dev, pdata->out_conns, pdata->nr_outconns,
+		devm_krealloc_array(dev, pdata->out_conns, pdata->nr_outconns + 1,
 				    sizeof(*pdata->out_conns), GFP_KERNEL);
 	if (!pdata->out_conns)
 		return ERR_PTR(-ENOMEM);
@@ -63,7 +62,8 @@ coresight_add_out_conn(struct device *dev,
 	 * used right away.
 	 */
 	*conn = *new_conn;
-	pdata->out_conns[pdata->nr_outconns - 1] = conn;
+	pdata->out_conns[pdata->nr_outconns] = conn;
+	pdata->nr_outconns++;
 	return conn;
 }
 EXPORT_SYMBOL_GPL(coresight_add_out_conn);
@@ -86,13 +86,13 @@ int coresight_add_in_conn(struct coresight_connection *out_conn)
 			return 0;
 		}
 
-	pdata->nr_inconns++;
 	pdata->in_conns =
-		devm_krealloc_array(dev, pdata->in_conns, pdata->nr_inconns,
+		devm_krealloc_array(dev, pdata->in_conns, pdata->nr_inconns + 1,
 				    sizeof(*pdata->in_conns), GFP_KERNEL);
 	if (!pdata->in_conns)
 		return -ENOMEM;
-	pdata->in_conns[pdata->nr_inconns - 1] = out_conn;
+	pdata->in_conns[pdata->nr_inconns] = out_conn;
+	pdata->nr_inconns++;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(coresight_add_in_conn);
-- 
2.53.0



