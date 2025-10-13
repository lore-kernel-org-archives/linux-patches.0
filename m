Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B874B3081B0;
	Mon, 13 Oct 2025 15:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368843; cv=none; b=YStO0Psb1rqpUDwoiRtjNDQ3EKdTeAaFoC582G4Zwgfp4DCsYDY1mIqx22AaM4Ukf4vHQ4hRtvWPL9ubIhDZmD0Lfm4ZE0eAyTis1hNpU1JkDPS4jLiuHPqdua7pcIEo62AWXOBfUfq4d0PXRwhUxEr2CQXHOUuUthrnO0qUbSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368843; c=relaxed/simple;
	bh=3ve1aNDhU3E7gM3f275jDnn4pKvq4xZ2xj68eTfIXzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W3cD6knPCw81ujQ/cNPdWpxbPzqzpx7cNZ1HUr11/Nxfr7kaYrWVxW7jMOF/IPXzC54mQCjMAGPrEnBbHx1+/O2DAv0E/4BMer47ILa90RsXrwcV0HKCMVJ8Uc8KoLY4HMpCwCO5yF9tTo/iZUo0YOb/fl1HsgHMBmMCoWZgfDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XxBbn7da; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XxBbn7da"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E3F5C4CEE7;
	Mon, 13 Oct 2025 15:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368843;
	bh=3ve1aNDhU3E7gM3f275jDnn4pKvq4xZ2xj68eTfIXzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XxBbn7davsx9C2q3r2urg4HbcX+8H4JJsHqn0eFut8t+6iE/vhGrqzfdob3jy6/l5
	 7AdB3aezW76sGBe54GNZpSLvfs81ob9e5d40NZXvt6IlLnsvrmeP0rVBPZmeoHUq9L
	 oMQk17mwTBgh5kFow4QkbD69aoMW+4cJRRlyiiKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 038/563] cpuset: fix failure to enable isolated partition when containing isolcpus
Date: Mon, 13 Oct 2025 16:38:19 +0200
Message-ID: <20251013144412.671134512@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

[ Upstream commit 216217ebee16afc4d79c3e86a736d87175c18e68 ]

The 'isolcpus' parameter specified at boot time can be assigned to an
isolated partition. While it is valid put the 'isolcpus' in an isolated
partition, attempting to change a member cpuset to an isolated partition
will fail if the cpuset contains any 'isolcpus'.

For example, the system boots with 'isolcpus=9', and the following
configuration works correctly:

  # cd /sys/fs/cgroup/
  # mkdir test
  # echo 1 > test/cpuset.cpus
  # echo isolated > test/cpuset.cpus.partition
  # cat test/cpuset.cpus.partition
  isolated
  # echo 9 > test/cpuset.cpus
  # cat test/cpuset.cpus.partition
  isolated
  # cat test/cpuset.cpus
  9

However, the following steps to convert a member cpuset to an isolated
partition will fail:

  # cd /sys/fs/cgroup/
  # mkdir test
  # echo 9 > test/cpuset.cpus
  # echo isolated > test/cpuset.cpus.partition
  # cat test/cpuset.cpus.partition
  isolated invalid (partition config conflicts with housekeeping setup)

The issue occurs because the new partition state (new_prs) is used for
validation against housekeeping constraints before it has been properly
updated. To resolve this, move the assignment of new_prs before the
housekeeping validation check when enabling a root partition.

Fixes: 4a74e418881f ("cgroup/cpuset: Check partition conflict with housekeeping setup")
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Reviewed-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 27adb04df675d..fef93032fe7e4 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1716,6 +1716,7 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 		xcpus = tmp->delmask;
 		if (compute_effective_exclusive_cpumask(cs, xcpus, NULL))
 			WARN_ON_ONCE(!cpumask_empty(cs->exclusive_cpus));
+		new_prs = (cmd == partcmd_enable) ? PRS_ROOT : PRS_ISOLATED;
 
 		/*
 		 * Enabling partition root is not allowed if its
@@ -1748,7 +1749,6 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 
 		deleting = true;
 		subparts_delta++;
-		new_prs = (cmd == partcmd_enable) ? PRS_ROOT : PRS_ISOLATED;
 	} else if (cmd == partcmd_disable) {
 		/*
 		 * May need to add cpus back to parent's effective_cpus
-- 
2.51.0



