Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD2A3CF42;
	Wed, 21 Feb 2024 14:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525448; cv=none; b=ry1sQ1hX8QjAqKlD/cyfDfPpZAXeNrxd+x8RhS3KDMRo3tf48ppMgCre+f1AMQwXdpv9X8d4R7pjSnKoPhdBqQNh14xcXOG5qggZO1le0hcEhSshdBDKg8MOQx4CK7KMhV+3iFXOFHpooMQ6vGMmwQDi/11Z/Z7sekjwDN37gOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525448; c=relaxed/simple;
	bh=WVC0KxXho6P5b2SY1S4VORYeGFuBKMDFrpfeBEvY+xM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IYceETKNcYhhseY9Pn80BgiSYoPpJU4ZvmvqPy7NTKO/b+DXEuu6keTgN27QRgXLblWsIMGv4LtCDWpD+EePLe/vyYSf8VXgwAVjWsJMcABvYK4NZJQ508LDtA/F2lK5p52euum0rrFAhmhGmAp/OjTmL1GUCE4u20+owWhiJLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d9+qvnyo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d9+qvnyo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD6AC433C7;
	Wed, 21 Feb 2024 14:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525448;
	bh=WVC0KxXho6P5b2SY1S4VORYeGFuBKMDFrpfeBEvY+xM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d9+qvnyov7lt4l0YowHB4nLbtFfpDVxNKZOrEQh4DWqEWcYhBz8vH+z6hKPhlerli
	 0qDiPWXJVjJoc8kQ9VP156x0KD5OFm5DV1rSQ9BS0E//Fw/JgfzVHsYOONosDBmly2
	 z/W75oXO469spWxJCof8ym2a7Pd4KcNv19ESwXiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richter <tmricht@linux.ibm.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 157/267] perf: Fix the nr_addr_filters fix
Date: Wed, 21 Feb 2024 14:08:18 +0100
Message-ID: <20240221125945.003883258@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 388a1fb7da6aaa1970c7e2a7d7fcd983a87a8484 ]

Thomas reported that commit 652ffc2104ec ("perf/core: Fix narrow
startup race when creating the perf nr_addr_filters sysfs file") made
the entire attribute group vanish, instead of only the nr_addr_filters
attribute.

Additionally a stray return.

Insufficient coffee was involved with both writing and merging the
patch.

Fixes: 652ffc2104ec ("perf/core: Fix narrow startup race when creating the perf nr_addr_filters sysfs file")
Reported-by: Thomas Richter <tmricht@linux.ibm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Thomas Richter <tmricht@linux.ibm.com>
Link: https://lkml.kernel.org/r/20231122100756.GP8262@noisy.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 3ec29a27d877..f18a5bbc66ef 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -10089,12 +10089,10 @@ static umode_t pmu_dev_is_visible(struct kobject *kobj, struct attribute *a, int
 	struct device *dev = kobj_to_dev(kobj);
 	struct pmu *pmu = dev_get_drvdata(dev);
 
-	if (!pmu->nr_addr_filters)
+	if (n == 2 && !pmu->nr_addr_filters)
 		return 0;
 
 	return a->mode;
-
-	return 0;
 }
 
 static struct attribute_group pmu_dev_attr_group = {
-- 
2.43.0



