Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8531B40803B;
	Tue, 21 Jul 2026 18:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660175; cv=none; b=EJkaRA9m4SMsVH3Qu7j7/RDqEHOs7LxXQM3db0rPR4Gm39tpEFtQO7tF3oaSwMMEfMthuYZ+OjTgG28yuOG24VVxEk6Epu7YX4wmR1DOJgB3Aug2OePF1R2Jop5LO/haTGU6Jgo0IZoHxufdfOYsyLFJGwrPaN3b9HXleQ8e49U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660175; c=relaxed/simple;
	bh=YMN+/xI6optYt5kv3hKwrpY1kuxByCWh+0bzgy0WixA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G7TMs4x3UNbRlpV52f4lVyM8PR1W+QxpoOHGyx2jYrFSbM1uV3PdYEbZJHc9Pceo2sqEGK06TOSv13/JhIKXm4i9qWYdHM09drfpqNSx+Dz+Qx+oxYM1IkCNfnhRdTDxCGY8rVYeDqwepYNt3x2EP2ltoPIlx8vKsU6uxSnPXWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KctNSuGL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KctNSuGL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC46F1F000E9;
	Tue, 21 Jul 2026 18:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660174;
	bh=rKAslWbsyAli1O0+s5XB+4rG7P013D+KKRowfEkZt7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KctNSuGL04kFDA8S0JYDTGa7//EONIStasqWkfmJS9sGtJ1sOXrktLlgjbUcpxPQ/
	 IKaQAMqUeXrlniFU5d+90fxTgUttTWYCtD6LXoIjtrNjlYOjiiq8vvT4EkpamUo7Kr
	 vlShL57xAgwmrmhqnI7PEB8i/rVLLnDrMxF6oIg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Gan <jie.gan@oss.qualcomm.com>,
	James Clark <james.clark@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0881/2077] coresight: platform: defer connection counter increment until alloc succeeds
Date: Tue, 21 Jul 2026 17:09:14 +0200
Message-ID: <20260721152613.579994904@linuxfoundation.org>
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
index e337b6e2bf327c..93c2d075cad66f 100644
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



