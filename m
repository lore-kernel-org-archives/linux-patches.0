Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A70451DAFC;
	Thu, 17 Sep 2026 17:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665084; cv=none; b=rsz0lk79mfa1+4FAfp7qk6vChTThK8s77vIgiCPHdCVzmuCka++wRQYqK5CwLz4ahHRyPXKUEot0pVv2GiRdAG89UDuyRZOtu4K1oPmwMoVwYo/GeNvBskaHMXtOO0UhLjfeuBTyvGKoHAi2kaRwBJuWzdlotyr9BopZi7SoZMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665084; c=relaxed/simple;
	bh=zLwHU4enDD4RMTZpBw/P4tb/gtOe2PuPbm7JNmrAiIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oakOzMNsyCjVV9AacdOflAKraezxZnNGdqZsSO896lyfvgtXzJoQ+myYoaqgDNRj6rP/y9e3WEciCFZHpzlwMBMbHRVkmrqG308Vpqu7l57BRv2yu+GwPKJsRWHgkF2Ks628iO4IL9IpxLKXIcqKHAlqsO2YmL/qQIosncMYo7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V2S+YP3N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V2S+YP3N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85A831F000FF;
	Thu, 17 Sep 2026 17:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665083;
	bh=WXX/+6MArksZgq7nH89a6XLs3QnLP3HIMrWaMbGm7Ak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V2S+YP3Ny6JUFFdwKcMqHWC7g7rHok2f/DjbdjaB5BNIgPhrb3/HvOscI741PYqzJ
	 +H3uNUbN5ShdU4uXYWtdlGeomF8Bb3UoYqzj9EblAaXM4wBbioLcd1A7sRgd7fU03S
	 UjE5KcvMVm84EjHWHJe8nS3K4i84meGP9K5QPFq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Gan <jie.gan@oss.qualcomm.com>,
	James Clark <james.clark@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0586/1250] coresight: platform: defer connection counter increment until alloc succeeds
Date: Thu, 17 Sep 2026 16:06:21 +0100
Message-ID: <20260917151607.769967341@linuxfoundation.org>
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
index 0db64c5f49959..6e57fc5018f47 100644
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



