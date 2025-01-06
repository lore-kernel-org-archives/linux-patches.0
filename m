Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E76C73451;
	Mon,  6 Jan 2025 15:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177781; cv=none; b=R+HKJZhysIsFFcWKF5f8+SjzJKHsoUV587twrdQgtWpZsHjUIgA5O2DdBs5uM6CTJ+ue05eXxredKw0Jwtr6ZD8iO8/WcGtwROgeSrmgNfeqn4cQyynmlaEVN+Zthis5h/MTaSCgOAR7+wDJOxfTCku1dRQ/p6fJgfjmFubQEjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177781; c=relaxed/simple;
	bh=+1ua5QiFmu5blk1J1ru/ASb+5xDje5wAR7ITGWenRz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UPKiM9Xnrhsclw7btzwI3isKOd/Ksx06Dd6rETmnFh1CFz/MHy3aqgnEjo+4JpAveIhKzJ8VqPWjnshmIBhPUxDQ4zyIu0gFoebeKl4K3fza8dtiCNE0hn77jUdRwK2e3S3Qdc2OUkTe2FCwyzwrn920ZtIbxS13AjkU37v6FWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0/UOf+VF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0/UOf+VF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 367DFC4CED2;
	Mon,  6 Jan 2025 15:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177780;
	bh=+1ua5QiFmu5blk1J1ru/ASb+5xDje5wAR7ITGWenRz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0/UOf+VF4iJ6zpZoFaZ1cfTJisT95PbFFY3rRMSNyp1zMEz5Yy82VuDwTl5WwflVp
	 JH5XUMYSI0WVI8d+daffpFjqIrgU9h+EY1IgsZM7u3E5Y7Pt12dPw+ThFbftyMCkll
	 7rZqNRlsM6p3zb8+4u1lEbD+lrLOYLk3L6tgAt60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	guanjing <guanjing@cmss.chinamobile.com>,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 013/156] sched_ext: fix application of sizeof to pointer
Date: Mon,  6 Jan 2025 16:14:59 +0100
Message-ID: <20250106151142.244400806@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: guanjing <guanjing@cmss.chinamobile.com>

[ Upstream commit f24d192985cbd6782850fdbb3839039da2f0ee76 ]

sizeof when applied to a pointer typed expression gives the size of
the pointer.

The proper fix in this particular case is to code sizeof(*cpuset)
instead of sizeof(cpuset).

This issue was detected with the help of Coccinelle.

Fixes: 22a920209ab6 ("sched_ext: Implement tickless support")
Signed-off-by: guanjing <guanjing@cmss.chinamobile.com>
Acked-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/sched_ext/scx_central.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/sched_ext/scx_central.c b/tools/sched_ext/scx_central.c
index 21deea320bd7..e938156ed0a0 100644
--- a/tools/sched_ext/scx_central.c
+++ b/tools/sched_ext/scx_central.c
@@ -97,7 +97,7 @@ int main(int argc, char **argv)
 	SCX_BUG_ON(!cpuset, "Failed to allocate cpuset");
 	CPU_ZERO(cpuset);
 	CPU_SET(skel->rodata->central_cpu, cpuset);
-	SCX_BUG_ON(sched_setaffinity(0, sizeof(cpuset), cpuset),
+	SCX_BUG_ON(sched_setaffinity(0, sizeof(*cpuset), cpuset),
 		   "Failed to affinitize to central CPU %d (max %d)",
 		   skel->rodata->central_cpu, skel->rodata->nr_cpu_ids - 1);
 	CPU_FREE(cpuset);
-- 
2.39.5



