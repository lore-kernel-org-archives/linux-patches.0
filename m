Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6B934CFDE;
	Wed, 30 Sep 2026 19:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794883; cv=none; b=UyMg55DZ7ifkspLcDlM0v9L2vvoAkMJx6S4gQlmaTwHmNxoj4lSmfBml4UCgyyVz28PHUmBiaces8NQxCAwoUkBK/Um9ygtp6ENY9ia0c9M7cWKNPCG7QjBhO6qJbbhYbJeZNYkspiFuATuVhiXmG3nlNEM1JheixT7BqOyujIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794883; c=relaxed/simple;
	bh=lGW3UbL12eElusQewO8Nq0nrAUxMfLHQA3MyGCk9qxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EjnkqzX3WeIU/ou7ZEwicsBf7RKTFtzoXBNJjSYTlTlVL9UNigeVuwnM6d2rh+OXAjpMkyOE05RKnKs/rtNCIiyD0dC2EnQlj49P48nwwRvqYlY0R8YnH+jJQQM8yIlyOGQnQjUm3vFEoJSVmToStYYx3YoJ74+t7oyOxBJpA4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SIZ7d7TT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SIZ7d7TT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D67EC1F0089D;
	Wed, 30 Sep 2026 19:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794864;
	bh=sOfuuIMI4Pys914rdv9NSDuUKwMZKedRTd6po4O2lkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SIZ7d7TTQIshdu7mgq60ENGAdTxhcAm/mvYfgAD6wQsx/9w03UcDZqRD1NxpahY+p
	 Ro84PyJ21tBvJx5uEkLOZ8m0wYpzo60+vhB1cWJi7/XTcW1Q+uiNN7Ls5KlK7ghCDP
	 MKenY+gL1Lw/yWmCLnQqG483LRp/fC4Tpyj8Meys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Gan <jie.gan@oss.qualcomm.com>,
	James Clark <james.clark@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0359/1193] coresight: platform: defer connection counter increment until alloc succeeds
Date: Wed, 30 Sep 2026 17:17:23 +0200
Message-ID: <20260930152442.150907262@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index 57a009552cc5c..5873ff5a61de5 100644
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



