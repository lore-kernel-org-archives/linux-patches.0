Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BADCE4FC324;
	Tue, 13 Oct 2026 11:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892664; cv=none; b=sqeeGQxqo8pObXBC66WP6bS13+5UkGHUMK+rme1cOBZglUcoWrAGubLBJLmPuH44iUtYv9JiRf981RtyNkr9ZJSXTt/BtH6NryH+zBPwrkricn6YD+cuxQnJU2nOulIoWFfT2HsdIzMvAt7BP2PObsJ2T0NZ5Kn9HCp5X+VDvsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892664; c=relaxed/simple;
	bh=4zSfn3ctHtkoRotNFMzh84ATl6ObdZYtwmWpEWeB/YA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VFpUxYGKsuXZ1APD7t30nJ0DBj8eb9WEXJjbNnnn1W9GV+YFt4DlgshM6Hx0nYs/+TKIRnTj/vK29UKCB0EWIWouZqhuyQCdgEy7ZwU0NLVzeeBIixSRgjcloIvIxQUV+AXxivmc7mAx7K1W7i1F8fqSOC1o70Oia9tNV7lH4mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0+3WAaC/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0+3WAaC/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC74A1F00893;
	Tue, 13 Oct 2026 11:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892663;
	bh=LAYvMnMyhErN1MQqZE0qtKvfmEbkrLgyT4l3oxMI2bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0+3WAaC/N8vB0wPkweefkMvmvFb2GTq6OwO5Gd4Zm+MP+FFNPynW8vvTJu2ShrHLf
	 yMnLnYY6RmUxjAGH7XQKEoFwycxmIJcgJ/euUyUPmsNPZUF77rEBcvnykCbJCITw7T
	 naRsHNvd/3a9+Lff68A9jQF4Vyus5mMb6kA6tXwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 247/281] cgroup/cpuset: Call is_in_v2_mode() after acquiring cpuset_mutex in cpuset_handle_hotplug()
Date: Tue, 13 Oct 2026 13:39:23 +0200
Message-ID: <20261013112901.141001048@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 16c554df4a50e..501f12de533f4 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3925,15 +3925,16 @@ static void cpuset_handle_hotplug(void)
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



