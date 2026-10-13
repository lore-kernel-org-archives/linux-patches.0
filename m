Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A7C4EB879;
	Tue, 13 Oct 2026 12:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894574; cv=none; b=htAuwMoV57v8HPn5SaPm6+LUO6n4bnoFHXDZ1KBeOa/IwDGFBD1xQMejOW+BH3PX001/xEdx7MGapeCt7zAmoRj5JfAwBwdqMX8N/G8TTblFGPeZiR03KUJS+NJ/XjBIxSwBTymWOoLg7BIPClu5PQ8vi5lG8qQNNOfdh9EgetY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894574; c=relaxed/simple;
	bh=fL55ufdNtw1kx0X9pxss4csHfMJt1dshUS1w1Y+YG4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CRjYKKbqfHNB4jpGOOLLwuw+neyPNKWr1e/z+P/NwnVvNdmQkn9Ztu0nxOY3Pq4uz7ctrN919vurEYjr0jYii0pvZeDj4IyR7/yWwgrY73/JD3YecPc/G671+7G96mXVOD19BLFPNYPzhBE483zKHVWJ8AJp1DoNbOm+iZmwCwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O8WuoAI8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O8WuoAI8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D101F0089A;
	Tue, 13 Oct 2026 12:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894573;
	bh=iluGd9A3xLTT5SgeJeVjr6Z7G2w302bh2abmtZeDjF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O8WuoAI8EGdgSPhRFD0xoJW8z4ddQBbZ/CbSoqNg4hXZPkQXq6E0O+rpMXKoBpcbs
	 F+nGGTtxLvfauss3k8juF+87j9cDUdenS1oMUUGn/4EDOiL+Mlreg65hol0tTHSTec
	 VGkBZHiqSU8go54GVgBn2r1KjXdcZRH/lskZ02Bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 579/621] cgroup/cpuset: Call is_in_v2_mode() after acquiring cpuset_mutex in cpuset_handle_hotplug()
Date: Tue, 13 Oct 2026 13:39:34 +0200
Message-ID: <20261013112934.546090415@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

[ Upstream commit b8eb5fd5bdb4c03758b056c70e5e1d962ca89757 ]

It is reported by sashiko that calling is_in_v2_mode() outside of
cpuset_mutex critical section in cpuset_handle_hotplug() can introduce
a TOCTOU race where cgroup hierarchy may have changed from v1 to v2 or
vice versa after is_in_v2_mode() is called leading to erroneously skip
the allocation of tmpmasks or incorrectly modify cpus_allowed masks,
resulting in cpuset state corruption. Fix that by calling is_in_v2_mode()
after acquiring the cpuset_mutex.

Fixes: b8d1b8ee93df ("cpuset: Allow v2 behavior in v1 cgroup")
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 37a807c7a73e5..15b6c9a6402ab 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -4113,15 +4113,16 @@ static void cpuset_handle_hotplug(void)
 	static cpumask_t new_cpus;
 	static nodemask_t new_mems;
 	bool cpus_updated, mems_updated;
-	bool on_dfl = is_in_v2_mode();
+	bool on_dfl;
 	struct tmpmasks tmp, *ptmp = NULL;
 
-	if (on_dfl && !alloc_tmpmasks(&tmp))
-		ptmp = &tmp;
-
 	lockdep_assert_cpus_held();
 	mutex_lock(&cpuset_mutex);
 
+	on_dfl = is_in_v2_mode();
+	if (on_dfl && !alloc_tmpmasks(&tmp))
+		ptmp = &tmp;
+
 	/* fetch the available cpus/mems and find out which changed how */
 	cpumask_copy(&new_cpus, cpu_active_mask);
 	new_mems = node_states[N_MEMORY];
-- 
2.53.0



