Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04B6225A2CF;
	Fri, 31 Oct 2025 14:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919574; cv=none; b=Nf7Pg1aGg/pn0nWzwq4ZJFsSp9chtQpBoV6ts+hEzNP3XcLjMMLRe8OS67E5NsDd+fSHXr1/N40bU4u8qY7V0POKeIlE1L4sQYdKTGfUf9FCJPXYa4R6kVaFSBoESHhPeInwkE6j5KRd0z/9VNqxRGUFZG/RGdy0BZe8ia0thQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919574; c=relaxed/simple;
	bh=mHAM/94tQxAzMvI5x54IhoChMMq1x6bMdLL9et1kk70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GAiCB/wAEcr96no4A3V9wKkSGaJIGaCkXk9Wd38/Ip33StmE+k5RKmU7P63jykS1VpXFrN67lGZha76a0tjrIb0Y85Tg8vF3WhiJsSjrlMabGQjsA+HmKncMSd3QPoSN7XLVcrS5NqNsWXi196wALoASb5uWErLG33GFj3kU1/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ul3H+7ZQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ul3H+7ZQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DCAEC4CEE7;
	Fri, 31 Oct 2025 14:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919573;
	bh=mHAM/94tQxAzMvI5x54IhoChMMq1x6bMdLL9et1kk70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ul3H+7ZQ5ERYZYuihfeM0hsK9KGXOZnm5KmeTW6CanG53R5PDAlP19H34P7sFfJ0F
	 vhySeSTi4yfG0pVBBHpbS40k95WUX6xQT5rIRsu34WJ0R3/JmSJGc5qr3PeMZ6qeIL
	 aC67K/AcmUPSN6bPKaECnNOc0jDRB38kswChBz8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 23/35] cpuset: Use new excpus for nocpu error check when enabling root partition
Date: Fri, 31 Oct 2025 15:01:31 +0100
Message-ID: <20251031140044.124653801@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140043.564670400@linuxfoundation.org>
References: <20251031140043.564670400@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index fef93032fe7e4..fd890b34a8403 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1728,11 +1728,7 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 		if (prstate_housekeeping_conflict(new_prs, xcpus))
 			return PERR_HKEEPING;
 
-		/*
-		 * A parent can be left with no CPU as long as there is no
-		 * task directly associated with the parent partition.
-		 */
-		if (nocpu)
+		if (tasks_nocpu_error(parent, cs, xcpus))
 			return PERR_NOCPUS;
 
 		/*
-- 
2.51.0



