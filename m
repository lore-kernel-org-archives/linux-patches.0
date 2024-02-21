Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160097E0FB;
	Wed, 21 Feb 2024 14:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524453; cv=none; b=f+Spv9HLJHzzpyAViwdTWWf+1mFwkG4onZWh6ARDWMdHoGbScDdFLdCxIcc8sDO4UEGx/lvtJ0n/naMe1S4ruvPO1uTyUwjwmACKiG1N/3drFtCGxIPDtXSVdfisyisd5s9vxEEQuSh/7iGyNPUDsy9RHm7uFfY2g2agYoWdSRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524453; c=relaxed/simple;
	bh=1rPnaXsuqIknVG3YRW3zYe16Uder4BRSJP+SWCdi+lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=THnrkuS2yna1GN/ARTOcBo4uCwqgC0PmLZ7zecvdEqknAYa73zi+00EgsD8r/X6WcAj17RNwzPw1YogmDcFleecynQl6jdJ2Lwk20IoBPPZfzLkpMQfsBh0WCyTo37kgsns49spQTkTz+aLxks+i+eZKWydGXHwjNzFQxwdkTAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tvSPpl/C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tvSPpl/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A48C433C7;
	Wed, 21 Feb 2024 14:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524453;
	bh=1rPnaXsuqIknVG3YRW3zYe16Uder4BRSJP+SWCdi+lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tvSPpl/C2fG/0Y+Q6iTqdu0gXdDlbf3IR0zdstT8p4MchaAjvtCEnUEmnms3AEn7i
	 8tvfMk4S/uiTaHsBSrCulZ4ZE76MqXfqVlicS+1mdIFJZ/9qIQ6Euze6CHh99o48mi
	 FtihtyBQgpmhJHEpUHdMpVahAQzfAEfi40RUMchA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richter <tmricht@linux.ibm.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 220/379] perf: Fix the nr_addr_filters fix
Date: Wed, 21 Feb 2024 14:06:39 +0100
Message-ID: <20240221130001.409613577@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ab5b75f3b886..bd569cf23569 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -10864,12 +10864,10 @@ static umode_t pmu_dev_is_visible(struct kobject *kobj, struct attribute *a, int
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



