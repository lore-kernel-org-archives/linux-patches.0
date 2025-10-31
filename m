Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC6725DAEA;
	Fri, 31 Oct 2025 14:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919468; cv=none; b=VZFzDd6Rb8oIVS2kgX+WjF22QFe0EoR51jM8q5F3SFzzej+BBpLpB6eYYa4faQ0OKJRUAUQU9jca1ovoUC24neY9BLqNDsqYlGf4RXrvp4R1jmeX13wz0RDXmkM+DA3EatcVuZw6NLLF0f5jEhN9a30F97G4AkM+Eg+s7lITXgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919468; c=relaxed/simple;
	bh=GODqVgLhNSKYcSLUpOUpl/v8rHUq7Cwx2aMtofoOC64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oXZQj5aJkNNH4Vji+7+tXF3TL5caQhiUM3CU86Uhx9DOrUE4pMkfegpsCCJqL7w7Ra/6HM2W0QwQKh61zfyASF967PaDzZWVTFt27XRUlc1y8MjjlkRnC89AbBYSv5XJwpL1xZFg7BJB9YCfiaHOFYqVBRU0k5+AiuEkDqag2jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vuF2Bk1Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vuF2Bk1Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E21EEC4CEE7;
	Fri, 31 Oct 2025 14:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919468;
	bh=GODqVgLhNSKYcSLUpOUpl/v8rHUq7Cwx2aMtofoOC64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vuF2Bk1YTHE4wqb0ZS06IY8+iaybIS0hlvqNUYPxXrsdBxKClyUidruvpamjP9Fvi
	 f8sxiMPSq8iwty4byHDFCN+JQir5t0YkG0+yw1V2mY5IUzPrxwMfbji5n127iYqO58
	 0wMkWyxw3XAZhoTE9dgc9L4wU3CNv40b9Gg5HRpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 11/40] cpuset: Use new excpus for nocpu error check when enabling root partition
Date: Fri, 31 Oct 2025 15:01:04 +0100
Message-ID: <20251031140044.218130016@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140043.939381518@linuxfoundation.org>
References: <20251031140043.939381518@linuxfoundation.org>
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

From: Chen Ridong <chenridong@huawei.com>

[ Upstream commit 59d5de3655698679ad8fd2cc82228de4679c4263 ]

A previous patch fixed a bug where new_prs should be assigned before
checking housekeeping conflicts. This patch addresses another potential
issue: the nocpu error check currently uses the xcpus which is not updated.
Although no issue has been observed so far, the check should be performed
using the new effective exclusive cpus.

The comment has been removed because the function returns an error if
nocpu checking fails, which is unrelated to the parent.

Signed-off-by: Chen Ridong <chenridong@huawei.com>
Reviewed-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 25f9565f798d4..13eb986172499 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1679,11 +1679,7 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 		if (prstate_housekeeping_conflict(new_prs, xcpus))
 			return PERR_HKEEPING;
 
-		/*
-		 * A parent can be left with no CPU as long as there is no
-		 * task directly associated with the parent partition.
-		 */
-		if (nocpu)
+		if (tasks_nocpu_error(parent, cs, xcpus))
 			return PERR_NOCPUS;
 
 		deleting = cpumask_and(tmp->delmask, xcpus, parent->effective_xcpus);
-- 
2.51.0



