Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5BA269885;
	Tue,  8 Apr 2025 11:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113473; cv=none; b=YrSeSbQ4x6C1jB3uRHmzSZveGzhVlW1j5qXvKqBb31UMggpNLSbbSu5/fhBV0R6gp4GUqMx+I7VsZRwyTileLluN2W/r1J4RpVoTHG0MPcjDl1VQ5dc7gIvPBD5J1arU+knxiB0n+HbykqabirdcsxYnoAhEccJez+IX7wHb4w0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113473; c=relaxed/simple;
	bh=fnKfMzZWQk4jRxKHk/6e5RgwhSOmLIvh1nNG1schVsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZ2lX1ojRxj3PAJ1fs2GYjdfz+SiwiCtJkg4zbJlXW+3fLHlfk3AJalnIj78iStbxMfw6Wq63U4Uq13UusK18tKtqD7eVhf51vp2sdc3Y4u8qsv4YT2go4uLuXz/wu0ATfn8zyQdd/wOYUx445IZ+f+/+pKee2IQi3wL0VwwYlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hXciJjZq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hXciJjZq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB647C4CEEA;
	Tue,  8 Apr 2025 11:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113473;
	bh=fnKfMzZWQk4jRxKHk/6e5RgwhSOmLIvh1nNG1schVsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hXciJjZq4njt5Oqe06FV0CYaQbUyuYD1Cox3t4lLvtV19UBGgaSzi81ClV05IbM6L
	 7Qc5jCL1FtKGpeG1ri8DKobjwmK+mZ2fzLVpU7mFI4Y8hkBY9GACxV1eJl8z3ea7HU
	 YPkJN/OEQhbFRX8Sc7LTURamP49vddYNIxUGZt7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 172/268] perf/core: Fix perf_pmu_register() vs. perf_init_event()
Date: Tue,  8 Apr 2025 12:49:43 +0200
Message-ID: <20250408104833.182601192@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 003659fec9f6d8c04738cb74b5384398ae8a7e88 ]

There is a fairly obvious race between perf_init_event() doing
idr_find() and perf_pmu_register() doing idr_alloc() with an
incompletely initialized PMU pointer.

Avoid by doing idr_alloc() on a NULL pointer to register the id, and
swizzling the real struct pmu pointer at the end using idr_replace().

Also making sure to not set struct pmu members after publishing
the struct pmu, duh.

[ introduce idr_cmpxchg() in order to better handle the idr_replace()
  error case -- if it were to return an unexpected pointer, it will
  already have replaced the value and there is no going back. ]

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20241104135517.858805880@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 4dd8936b5aa09..a524329149a71 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -11556,6 +11556,21 @@ static int pmu_dev_alloc(struct pmu *pmu)
 static struct lock_class_key cpuctx_mutex;
 static struct lock_class_key cpuctx_lock;
 
+static bool idr_cmpxchg(struct idr *idr, unsigned long id, void *old, void *new)
+{
+	void *tmp, *val = idr_find(idr, id);
+
+	if (val != old)
+		return false;
+
+	tmp = idr_replace(idr, new, id);
+	if (IS_ERR(tmp))
+		return false;
+
+	WARN_ON_ONCE(tmp != val);
+	return true;
+}
+
 int perf_pmu_register(struct pmu *pmu, const char *name, int type)
 {
 	int cpu, ret, max = PERF_TYPE_MAX;
@@ -11577,7 +11592,7 @@ int perf_pmu_register(struct pmu *pmu, const char *name, int type)
 	if (type >= 0)
 		max = type;
 
-	ret = idr_alloc(&pmu_idr, pmu, max, 0, GFP_KERNEL);
+	ret = idr_alloc(&pmu_idr, NULL, max, 0, GFP_KERNEL);
 	if (ret < 0)
 		goto free_pdc;
 
@@ -11585,6 +11600,7 @@ int perf_pmu_register(struct pmu *pmu, const char *name, int type)
 
 	type = ret;
 	pmu->type = type;
+	atomic_set(&pmu->exclusive_cnt, 0);
 
 	if (pmu_bus_running && !pmu->dev) {
 		ret = pmu_dev_alloc(pmu);
@@ -11633,14 +11649,22 @@ int perf_pmu_register(struct pmu *pmu, const char *name, int type)
 	if (!pmu->event_idx)
 		pmu->event_idx = perf_event_idx_default;
 
+	/*
+	 * Now that the PMU is complete, make it visible to perf_try_init_event().
+	 */
+	if (!idr_cmpxchg(&pmu_idr, pmu->type, NULL, pmu))
+		goto free_context;
 	list_add_rcu(&pmu->entry, &pmus);
-	atomic_set(&pmu->exclusive_cnt, 0);
+
 	ret = 0;
 unlock:
 	mutex_unlock(&pmus_lock);
 
 	return ret;
 
+free_context:
+	free_percpu(pmu->cpu_pmu_context);
+
 free_dev:
 	if (pmu->dev && pmu->dev != PMU_NULL_DEV) {
 		device_del(pmu->dev);
-- 
2.39.5



