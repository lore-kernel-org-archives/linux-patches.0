Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795D523EA8B;
	Tue, 13 Oct 2026 12:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791896031; cv=none; b=dFA88TWHgQE4edGQdVqDtwcicLd+fhsQjlSndBq06tMxvGd+krn9nUbpQHwyVGVVoc00Fpp5+/Fc8zavz0QQg6oT/W7g10g3KpCMmUa9IAohr5EVkaCUWU360L43T66flaRmZ4Tf8pb+d2Rk/FU/cgph7P0ee1wIepnoHEF/5ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791896031; c=relaxed/simple;
	bh=G25y6LxcqhZmysR6r1nf/voM0WbXxkVxqxQugIUJbXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=biPzENhHYuochs9RHNLL0LJjb93Uh0p2KTEdDfnCcwHZs7ttrBYl4OZn2jEEzy/klIWsI6OiBAhx1VekIZR3XK6B4QQjJ1DeNBQtr8bZCjvy7dQnfltVAR5GRBM9zFKw3Gn8n9eDIE8iaQV2QmVz1YuHqZJ0sIP4KPEABxjaY80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TU0uCtYY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TU0uCtYY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD26E1F000FF;
	Tue, 13 Oct 2026 12:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791896030;
	bh=pkDyVdcXbAyY+LaajppJ7U3if3JV0wnR0dWRlPJY9v4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TU0uCtYYo7a7iPH/tFp/HS3HSt7kaZ+PwoWHIrE3LJfUFfzLX3tbLTnDFAQX9w7Dp
	 YqGB+yfAbCXpfIX2Y6ey+KKRj67S7zFOYd2vhgB1O31ncxAb2Q2ltzvKvvpKYPLQBm
	 +/HSGRM42xhJeVFXXeHhDYQVnq2ffnUN+2u2/Fhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 475/497] cgroup/cpuset: Call is_in_v2_mode() after acquiring cpuset_mutex in cpuset_handle_hotplug()
Date: Tue, 13 Oct 2026 13:40:42 +0200
Message-ID: <20261013112919.152664273@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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
index eb725c516ce39..5991a9a354aad 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3915,15 +3915,16 @@ static void cpuset_handle_hotplug(void)
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



