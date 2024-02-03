Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6153C11720;
	Sat,  3 Feb 2024 04:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933945; cv=none; b=q7CqlwJSHVzwechZpamUY01Xwx5cf4JNoxrjLOiZv9wsyANY6pF3fg6w9e4g3W2qJGviQBgIJwZ9xstlft6JGtytCjxK2V4zC8Jyn3FDHed9TM7qdOq67dazk9SL+wzPlT3VWXaYoXYuuC/VxfaRmpwlFWYe9UN/Q9EjAOUM+WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933945; c=relaxed/simple;
	bh=Mu3Ee2Miy3ZWQjNzv46yOfxvTGKNpJPYH09yi6bsF/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tsJ8CWCBGf9HHtxfbg/SLbaXM2spqU864sSnivnLK1Lqp7e7W29VmYEiNOedyri/JNPhtuXjlIUXR9YDLxkG+MqdhfG97Y3LgBoHJCa+oJyNPHmVexJj4bhXWB/UAx+tGlPCcqRdKsavpLTc7aK0QhbOfjFhUFIMo2KNLDTI26s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JMEpR10v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JMEpR10v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A1E3C43390;
	Sat,  3 Feb 2024 04:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933945;
	bh=Mu3Ee2Miy3ZWQjNzv46yOfxvTGKNpJPYH09yi6bsF/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JMEpR10vSJ1MJWB0AFsEPhLSs0i2Cj1vCsmxqBfRUPWvZYoN13q/6+zhmlZWoRWD+
	 qPiG4ZvLk+eCEkW72P4SQy7AjeUVa39QzCvA2jiC6U1QtiTy8WwJkCUU+r3am72eDq
	 j3izhoWl8Hxfy52s0XTqIHcgd5O8TGDX99aRYeaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richter <tmricht@linux.ibm.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 287/353] perf: Fix the nr_addr_filters fix
Date: Fri,  2 Feb 2024 20:06:45 -0800
Message-ID: <20240203035412.866536521@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index fbecba5b00b1..7c0330579718 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -11434,12 +11434,10 @@ static umode_t pmu_dev_is_visible(struct kobject *kobj, struct attribute *a, int
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



