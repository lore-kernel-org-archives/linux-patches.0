Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8172C129;
	Mon,  1 Apr 2024 16:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988654; cv=none; b=UbeNQe9/VydMneUEU820bZQp3jmh2OH2EDkInuQn8g2OxYfFuZrQV/nTt9d9D/BLnHdZb0vwDAYP9+r34s6pF+/SwmCQvQ4n96nI0KelpV60W7lMq/RvFxxKB0AvLXtZ8VgcUv+HrvpE1A7wb+KQGWtniZ7Za+XxHxt9LgKXbs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988654; c=relaxed/simple;
	bh=8rRk3vsbYO1RffRK6coEA0kfZKzIGifE+4nJc5CCO9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DnsLlB35ytmTncHoBDRH2zYFXpU7Zvaaj2wUgq00LzR+DvlMaDL6sGPO5s0lOPBAw/udAtHL+rlZsPONq3WLs8mmdqZw2+44KtSIF4gpMa0m+DYSBCUdousjrzSOiTz7TROgUA/qiGp0QVb0AYK1taSojyQ0aDaao+v9J3bwjSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rZ8h2EXK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rZ8h2EXK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2538EC433F1;
	Mon,  1 Apr 2024 16:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988654;
	bh=8rRk3vsbYO1RffRK6coEA0kfZKzIGifE+4nJc5CCO9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rZ8h2EXKNqZdcQ2afaJ6mNkCSz83+UVyjTIrp4dGECUuexugpwkz4FvyzL+aQk0y+
	 jq0vISuEmypo0iaE//y9198iXW3wbxWv05OL9rvHVufdCQBFGBJsAmuvHw90cLwxUN
	 i1ZBiFUUjANeD99/Rh0T9xOyKIvWVAUlHyTOlgh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Mirsad Todorovac <mirsad.todorovac@alu.hr>
Subject: [PATCH 6.7 249/432] cgroup/cpuset: Fix a memory leak in update_exclusive_cpumask()
Date: Mon,  1 Apr 2024 17:43:56 +0200
Message-ID: <20240401152600.566378911@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

From: Waiman Long <longman@redhat.com>

commit 66f40b926dd249f74334a22162c09e7ec1ec5b07 upstream.

Fix a possible memory leak in update_exclusive_cpumask() by moving the
alloc_cpumasks() down after the validate_change() check which can fail
and still before the temporary cpumasks are needed.

Fixes: e2ffe502ba45 ("cgroup/cpuset: Add cpuset.cpus.exclusive for v2")
Reported-and-tested-by: Mirsad Todorovac <mirsad.todorovac@alu.hr>
Closes: https://lore.kernel.org/lkml/14915689-27a3-4cd8-80d2-9c30d0c768b6@alu.unizg.hr
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: stable@vger.kernel.org # v6.7+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cpuset.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2502,9 +2502,6 @@ static int update_exclusive_cpumask(stru
 	if (cpumask_equal(cs->exclusive_cpus, trialcs->exclusive_cpus))
 		return 0;
 
-	if (alloc_cpumasks(NULL, &tmp))
-		return -ENOMEM;
-
 	if (*buf)
 		compute_effective_exclusive_cpumask(trialcs, NULL);
 
@@ -2519,6 +2516,9 @@ static int update_exclusive_cpumask(stru
 	if (retval)
 		return retval;
 
+	if (alloc_cpumasks(NULL, &tmp))
+		return -ENOMEM;
+
 	if (old_prs) {
 		if (cpumask_empty(trialcs->effective_xcpus)) {
 			invalidate = true;


