Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB4541212
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vk7K9JCQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D2DC433C9;
	Wed, 15 Nov 2023 19:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076769;
	bh=zm2IymB5UicGTddR+DlRQ7+NOTPhpNDwPkAu6tDGQ3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vk7K9JCQO88QEWKh9uy3CzLjoj+iZc6JYmUFIdDUwENDmX0YmCRgQSvww5sLncMSV
	 dUkArMIvExrNhA4Xf3d966BQr/boKXGdHKIXMim9nQxYRYGJBpqFrVfZ7FYTmJaHAc
	 jOj0iiPyLEq8oo/KZykXJSqOzahMehiz8froFr/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 021/603] cgroup/cpuset: Fix load balance state in update_partition_sd_lb()
Date: Wed, 15 Nov 2023 14:09:26 -0500
Message-ID: <20231115191614.639316907@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

[ Upstream commit 6fcdb0183bf024a70abccb0439321c25891c708d ]

Commit a86ce68078b2 ("cgroup/cpuset: Extract out CS_CPU_EXCLUSIVE
& CS_SCHED_LOAD_BALANCE handling") adds a new helper function
update_partition_sd_lb() to update the load balance state of the
cpuset. However the new load balance is determined by just looking at
whether the cpuset is a valid isolated partition root or not.  That is
not enough if the cpuset is not a valid partition root but its parent
is in the isolated state (load balance off). Update the function to
set the new state to be the same as its parent in this case like what
has been done in commit c8c926200c55 ("cgroup/cpuset: Inherit parent's
load balance state in v2").

Fixes: a86ce68078b2 ("cgroup/cpuset: Extract out CS_CPU_EXCLUSIVE & CS_SCHED_LOAD_BALANCE handling")
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 58ec88efa4f82..4749e0c86c62c 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1304,13 +1304,23 @@ static int update_partition_exclusive(struct cpuset *cs, int new_prs)
  *
  * Changing load balance flag will automatically call
  * rebuild_sched_domains_locked().
+ * This function is for cgroup v2 only.
  */
 static void update_partition_sd_lb(struct cpuset *cs, int old_prs)
 {
 	int new_prs = cs->partition_root_state;
-	bool new_lb = (new_prs != PRS_ISOLATED);
 	bool rebuild_domains = (new_prs > 0) || (old_prs > 0);
+	bool new_lb;
 
+	/*
+	 * If cs is not a valid partition root, the load balance state
+	 * will follow its parent.
+	 */
+	if (new_prs > 0) {
+		new_lb = (new_prs != PRS_ISOLATED);
+	} else {
+		new_lb = is_sched_load_balance(parent_cs(cs));
+	}
 	if (new_lb != !!is_sched_load_balance(cs)) {
 		rebuild_domains = true;
 		if (new_lb)
-- 
2.42.0



