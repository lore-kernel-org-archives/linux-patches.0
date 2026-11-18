Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021780;
	b=24nh0Lc/LEpoNNGOwiD69WUF1yJ67F7LDC12vRZDWzjbYYh0fQFOtlbxJawHdFD+2x3M
	 6r0/Ypb0I0Uszuvb+284C2A3oAyG9RK0SyLcw7wOYQsXtQquEpoXidPWSHS/z54sbcNAN
	 GZyJINjdu9DkkyeB3TNF64qmZxS1SzbcVu0+z/ycTICvJu8tOmyYrzYqdweqNX5juySyR
	 4sD4/r5O2laTKUMUNrZ84VEjA8bdM1wJpJ+1DLXXG5dznqw9/5t9rYxQbZpgvq2WJWH7s
	 m+ladXSDL7QZlJQSl+RyCfzVX+ZSkU8WgB+e1z+DiWrpfDLrJ/BJxiEnadSM2pcjjHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021780;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OWqRHKkI4BaJ5fLFrWW/DKq2Va3ar7qxdczZT9lp7as=;
	b=NnKJcG8Xpaqtcv5pTiAQoiaEwcTUt5Qpy9vg6/sAqNMjj+8VRQNBW1LOAVCjIjeaKQZ5
	 Y9xeAy13c64OfVKHaieuPz0f8mG/Y1IjQ7uBEa4YgZ8hllDaOBYk1abCAv7bXr6vkDwuz
	 kwkf2j1Od5U7TfXPul9mLXtak+67GZ582GQuh6jj7FS4XkP6XpmKi9uKsg4XFDPgucm1O
	 GSrmKF03CXbnfKHn5LLahL2z3iGlKB6rBrMxMH1ifUuKhkOsWf02yCDP7KZNVDoZbHVkE
	 5T4fnYxvdoW639sb66zrJPZD3FhAfdaSI0D343ufVRy52/hIVMMy4ZLTxdJy49kutvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="WfG3/Eb6";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28AB3606A320;
	Wed, 18 Nov 2026 17:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WfG3/Eb6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 309491F000C4;
	Wed, 18 Nov 2026 17:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021779;
	bh=OWqRHKkI4BaJ5fLFrWW/DKq2Va3ar7qxdczZT9lp7as=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WfG3/Eb65NO7PX9K7zvSfIl1+sPOnvYSsrRNjeFDrR/3EIP11VaqkAWju+Aryg8dC
	 26YUuqr1AvpgPV7/EmnGTijgtHAPMeEjMtEMseStUs6DqzTN8k5MnVK6dttJbD4cAq
	 syCGldpD0HrY3sQh90nbDRyJnWc+zJu/oedH/ywc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2428/2651] cgroup/cpuset: Make sure compute_partition_effective_cpumask() is only called for valid partition
Date: Wed, 18 Nov 2026 16:01:08 +0100
Message-ID: <20261118150412.632288186@linuxfoundation.org>
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

From: Waiman Long <longman@redhat.com>

[ Upstream commit 356a3aa7404e420e6f19c5ed42db7b8bd0c7ee9f ]

With visual inspection to make sure that
compute_partition_effective_cpumask() is only called for valid partition
root, it was found that the function can be called for an invalidated
partition near the end of cpuset_hotplug_update_tasks(). When partcmd is
set, update_parent_effective_cpumask() is called to either invalidate a
valid partition or with partcmd_update to check if an invalid partition
can be switched back to valid. In both cases, cpuset_force_rebuild()
should be invoked. However, compute_partition_effective_cpumask()
should only be called when an invalid partition is switched back to
valid. When a partition is invalidated, compute_effective_cpumask()
should be called instead.

Also add a WARN_ON_ONCE() in compute_partition_effective_cpumask() to
ensure that a valid partition root is passed in.

Fixes: 72c6303acfa1 ("cgroup/cpuset: Take isolated CPUs out of workqueue unbound cpumask")
Signed-off-by: Waiman Long <longman@redhat.com>
Acked-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 3abfd6c2387d8..96c018c77838f 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2204,6 +2204,8 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
 	struct cpuset *child;
 	bool populated = partition_is_populated(cs, NULL);
 
+	WARN_ON_ONCE(!is_partition_valid(cs));
+
 	/*
 	 * Check child partition roots to see if they should be
 	 * invalidated when
@@ -4149,9 +4151,12 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 
 	if (partcmd >= 0) {
 		update_parent_effective_cpumask(cs, partcmd, NULL, tmp);
-		if ((partcmd == partcmd_invalidate) || is_partition_valid(cs)) {
+		if (is_partition_valid(cs)) {
 			compute_partition_effective_cpumask(cs, &new_cpus);
 			cpuset_force_rebuild();
+		} else if (partcmd == partcmd_invalidate) {
+			compute_effective_cpumask(&new_cpus, cs, parent);
+			cpuset_force_rebuild();
 		}
 	}
 
-- 
2.53.0



