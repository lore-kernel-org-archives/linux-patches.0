Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021609;
	b=s9XSQizneY45e2nwrBkvOYIPmujKUqLgeinDxJl/kRDWB171zChWbf+eAbwx8pH0CB6i
	 JrgNY39TY2kN64pslbrxsAKAKRlr6R9G7zUz3RnTBXPP7D4qiWqdmXlnhajgThlTuA2xL
	 G//HEAKLKiLt3DeNvWztKCtCZ1kdd+bRWfccVhKfFtMQq08tAGCQqyfjRqh6cl8SheC2p
	 vPclG+uX+R42Dz85/jFyghHXMkaIkzDOD6WFArNePDbkqq5WumDyqY2ZMovky6bqO+nuW
	 7dWAqQb//Swq/TjUZXdNokJqAqQiiTibtjZAXFIUpIxB+zZA/dfojzrJV4AxwYnVMWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021609;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NERtTTv5NntT1NkD3gAahuIItX+5AV99kWuiN6Stv5M=;
	b=O6fQ31d+duMGk83WPHwo5Jy5HX5B3LpLkg2NpiTiE/LuhmIKgTU71Git9VHpeRgOzKzr
	 bSvNUwzBvPpqVuYzihFhfBNIdZtP+CzHAmyXXJOIHyLy3uZzt5oXCWgdM9s5yYzWn3OaS
	 /MRC9iQPxKblI6hY9ePH+mqYbAE+lFWYvqMrxvnIMwFfxSVVp9t8U0AOqs6lT/Y1WU27m
	 D1GzO9FcrQ84ETlLPlKEfP8QoXoHW5CwgZnfWpqjQou5wJThgLOvZ+N0AEDviHKGVWMl3
	 /fc4c+B0EXHFSuQo9Feq+bb8P1wL17+VrrQLygjIIgiI0RfV5BpxvtAvMwlpBUHekvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QheI099E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D4E60A2610;
	Wed, 18 Nov 2026 17:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QheI099E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F0971F000C9;
	Wed, 18 Nov 2026 17:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021608;
	bh=NERtTTv5NntT1NkD3gAahuIItX+5AV99kWuiN6Stv5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QheI099E1qF3SkLoCygosQjKdyk5+RE4bMFewgqDYUYjtwimMzYvKRWhu7wdXxfoY
	 16ddkkIXlhGBxPBNXQ33HK1WJnYt4+ru+F3VJsPrki0IEZeMNFCob9UOeq4E05Jtak
	 PYyNH9FbrButFCXlb9pUnczZ57ghyws3vfC1i8OE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2369/2651] cgroup/cpuset: check effective mems for a movable-only configuration
Date: Wed, 18 Nov 2026 16:00:09 +0100
Message-ID: <20261118150410.812196244@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gregory Price (Meta) <gourry@gourry.net>

[ Upstream commit 4c047bd0499602161959478b90e66f4c8e523c9b ]

check_insane_mems_config() warns and enables cpusets_insane_config_key
when a cpuset's tasks can allocate only from movable memory.

In cgroup v2 the request may name a memoryless node, which has no zones
and cpusets reports it as a movable-only nodemask.

For example, with node 2 a CPU-only node:

  # echo +cpuset > /sys/fs/cgroup/cgroup.subtree_control
  # mkdir /sys/fs/cgroup/test
  # echo 2 > /sys/fs/cgroup/test/cpuset.mems
  # cat /sys/fs/cgroup/test/cpuset.mems.effective
    0-1
  # dmesg
    Unsupported (movable nodes only) cpuset configuration detected (nmask=2)!

This is a bit confusing, especially consider mems.effective ends up with
a valid nodemask by-design (cpuset.mems is treated as-if it were empty).

Check each new effective mask in update_nodemasks_hier() instead, as the
hotplug path already does. The allocator's bail-out tests the task's
mems_allowed, which comes from the effective mask.

A request naming a movable-only not present in the parent's nodemask
no longer warns (since, again, the cpuset.mems gets overridden and
treated as empty). However, it will warn if the parent's mems include
the node later.

For Example, with node 3 a movable-only node:

  # echo 0 > /sys/fs/cgroup/test/cpuset.mems
  # echo 3 > /sys/fs/cgroup/test/child/cpuset.mems
  # cat /sys/fs/cgroup/test/child/cpuset.mems.effective
    0
  # dmesg
    { empty }
  # echo 0,3 > /sys/fs/cgroup/test/cpuset.mems
  # cat /sys/fs/cgroup/test/child/cpuset.mems.effective
    3
  # dmesg
    Unsupported (movable nodes only) cpuset configuration detected (nmask=3)!

Fixes: 8ca1b5a49885 ("mm/page_alloc: detect allocation forbidden by cpuset and bail out early")
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Waiman Long <longman@redhat.com>
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 5d1883d19319b..d39953799ad56 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2882,6 +2882,8 @@ static void update_nodemasks_hier(struct cpuset *cs, nodemask_t *new_mems)
 			continue;
 		rcu_read_unlock();
 
+		check_insane_mems_config(new_mems);
+
 		spin_lock_irq(&callback_lock);
 		cp->effective_mems = *new_mems;
 		spin_unlock_irq(&callback_lock);
@@ -2935,8 +2937,6 @@ static int update_nodemask(struct cpuset *cs, struct cpuset *trialcs,
 	if (retval < 0)
 		return retval;
 
-	check_insane_mems_config(&trialcs->mems_allowed);
-
 	spin_lock_irq(&callback_lock);
 	cs->mems_allowed = trialcs->mems_allowed;
 	spin_unlock_irq(&callback_lock);
-- 
2.53.0



