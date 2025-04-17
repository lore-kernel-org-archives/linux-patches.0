Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 144E31DB148;
	Thu, 17 Apr 2025 18:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913815; cv=none; b=ftG0iOJBXi0O2Wn0C7E5+rPWjBeUdy4pZOv01sJiRf/uNyNwX6D2VgEs55L41K0VkCBHaquROdd93IkpE65rnrxsLWr0GzH3APzuHeWWUDbGdKFXcKdNlMmQkilqZqpvF7PWPgbYufguFH5yJ995RhLmqAUB085ZUo0S8G3QHxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913815; c=relaxed/simple;
	bh=3LAkob1DvaTTbV8Is9XRCyoyb5I7Epdi035+nzb/ASs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UUcFfDU7sjA3BZZVePOHNBsXw4BtFz6E/43I5xyzGi/8505mEOo8Uu3l/6Dz+4nirucTbwDC3ofSM5ZF0nlzlVNv+WmxPxMuMX+Jq1ZdE6SfCD44JD2NSYMnWg0ZtoOqKpBL/DKaVdNC8fxGGKlimuvMV9OGNItqyZI+ICDfKKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kMRAsXL5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kMRAsXL5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99749C4CEE4;
	Thu, 17 Apr 2025 18:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913815;
	bh=3LAkob1DvaTTbV8Is9XRCyoyb5I7Epdi035+nzb/ASs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kMRAsXL5ti04hrUDvdICe5pgr7a1Mhmftg/W6bIhDfCPLOzltIAre446l4ZBXJ8tP
	 xar22nD4a5OJvCm/szttfxHS7cMEZFzJLvPaCu6VUURRMyS0QiE+tgE3Bjp1xKwGvv
	 12FcIbj21d6IHirXl0AT9eL55w1e+CqfONmcBXXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 002/414] cgroup/cpuset: Fix incorrect isolated_cpus update in update_parent_effective_cpumask()
Date: Thu, 17 Apr 2025 19:46:00 +0200
Message-ID: <20250417175111.495767196@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

[ Upstream commit 668e041662e92ab3ebcb9eb606d3ec01884546ab ]

Before commit f0af1bfc27b5 ("cgroup/cpuset: Relax constraints to
partition & cpus changes"), a cpuset partition cannot be enabled if not
all the requested CPUs can be granted from the parent cpuset. After
that commit, a cpuset partition can be created even if the requested
exclusive CPUs contain CPUs not allowed its parent.  The delmask
containing exclusive CPUs to be removed from its parent wasn't
adjusted accordingly.

That is not a problem until the introduction of a new isolated_cpus
mask in commit 11e5f407b64a ("cgroup/cpuset: Keep track of CPUs in
isolated partitions") as the CPUs in the delmask may be added directly
into isolated_cpus.

As a result, isolated_cpus may incorrectly contain CPUs that are not
isolated leading to incorrect data reporting. Fix this by adjusting
the delmask to reflect the actual exclusive CPUs for the creation of
the partition.

Fixes: 11e5f407b64a ("cgroup/cpuset: Keep track of CPUs in isolated partitions")
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 0f910c828973a..02f3e9d076894 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1680,9 +1680,9 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 		if (nocpu)
 			return PERR_NOCPUS;
 
-		cpumask_copy(tmp->delmask, xcpus);
-		deleting = true;
-		subparts_delta++;
+		deleting = cpumask_and(tmp->delmask, xcpus, parent->effective_xcpus);
+		if (deleting)
+			subparts_delta++;
 		new_prs = (cmd == partcmd_enable) ? PRS_ROOT : PRS_ISOLATED;
 	} else if (cmd == partcmd_disable) {
 		/*
-- 
2.39.5



