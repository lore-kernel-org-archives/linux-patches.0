Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3615AF9C1;
	Sat,  3 Feb 2024 04:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933670; cv=none; b=CIfjRcleTtKMKgose0a8xLhZjCFdOf7EcwBUZYVHHbkjIaO3x5QpU0M1OdAFv1FsA7lFVbkjDtVhzitixekewHMMRcNJjkyHT31zv117bvvn23Vv7EC4bS4gsMa1iCmOAsErP8ghjwpbhDuZtgzCPn5gMALXHsbqK1hq1NhkM2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933670; c=relaxed/simple;
	bh=OB5jSncuoq5FobWTSn6XJk7OjsYT9HATv2sZ4iSzVI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nPITgXCCxZJpBHZh1gkutH7V12Gk1mBhHJkwqhcLo68H913t+FpcEB7U73Ua93zWX10AmR6QINLx20Hrf58+ua0lIaoOHIGSTMzEtNLJikqUH3qjfOB67llZptZecwV1xdul9Ov1IqW9bVzu86kbgud44nxV+WJdPv1k4z/Rkjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c5HLoU+e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c5HLoU+e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D60C433C7;
	Sat,  3 Feb 2024 04:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933670;
	bh=OB5jSncuoq5FobWTSn6XJk7OjsYT9HATv2sZ4iSzVI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c5HLoU+eLD3y+We6zDisHq4+fUETL9VTeTWtqr/lSblEOKM1fThovjgr4l6TQLO/Y
	 XNCJJ34wHyvgXJArTBFTzXpats0tZVgG4exoEvt0/ggWS1Xd5ps8VIcwq9N2620QVh
	 KGPO4ZrHHJtVDvAdBynpmFKkszfQae/UlRMV28qQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richter <tmricht@linux.ibm.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 259/322] perf: Fix the nr_addr_filters fix
Date: Fri,  2 Feb 2024 20:05:56 -0800
Message-ID: <20240203035407.518561886@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f22c540350a1..fe543e7898f5 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -11422,12 +11422,10 @@ static umode_t pmu_dev_is_visible(struct kobject *kobj, struct attribute *a, int
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



