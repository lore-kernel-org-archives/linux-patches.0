Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5152572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:47:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3158CC433EF;
	Tue, 18 Apr 2023 12:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681822048;
	bh=zr5LTGDtV+oczzGvn6qOkrO6MGsv74CWL+RACJzmASk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PHcFqOCFXMTPOc36axcjqyqXc7RiYHNVlbwu7WpR2l3W/aQdLBrlawIOa08K5Lkz0
	 5hWqFi23jHsMunkLVzORbr7MZWMSzVRj5ch2XL1whyD/uS2ZfjPxaO8qUCzzXYq4NS
	 iEOwhLkqzDiFoLcinmy9Auimr70GJ/uHnMPrVSfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.1 112/134] cgroup/cpuset: Fix partition roots cpuset.cpus update bug
Date: Tue, 18 Apr 2023 14:22:48 +0200
Message-Id: <20230418120317.089478368@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Waiman Long <longman@redhat.com>

commit 292fd843de26c551856e66faf134512c52dd78b4 upstream.

It was found that commit 7a2127e66a00 ("cpuset: Call
set_cpus_allowed_ptr() with appropriate mask for task") introduced a bug
that corrupted "cpuset.cpus" of a partition root when it was updated.

It is because the tmp->new_cpus field of the passed tmp parameter
of update_parent_subparts_cpumask() should not be used at all as
it contains important cpumask data that should not be overwritten.
Fix it by using tmp->addmask instead.

Also update update_cpumask() to make sure that trialcs->cpu_allowed
will not be corrupted until it is no longer needed.

Fixes: 7a2127e66a00 ("cpuset: Call set_cpus_allowed_ptr() with appropriate mask for task")
Signed-off-by: Waiman Long <longman@redhat.com>
Cc: stable@vger.kernel.org # v6.2+
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cpuset.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1509,7 +1509,7 @@ static int update_parent_subparts_cpumas
 	spin_unlock_irq(&callback_lock);
 
 	if (adding || deleting)
-		update_tasks_cpumask(parent, tmp->new_cpus);
+		update_tasks_cpumask(parent, tmp->addmask);
 
 	/*
 	 * Set or clear CS_SCHED_LOAD_BALANCE when partcmd_update, if necessary.
@@ -1766,10 +1766,13 @@ static int update_cpumask(struct cpuset
 	/*
 	 * Use the cpumasks in trialcs for tmpmasks when they are pointers
 	 * to allocated cpumasks.
+	 *
+	 * Note that update_parent_subparts_cpumask() uses only addmask &
+	 * delmask, but not new_cpus.
 	 */
 	tmp.addmask  = trialcs->subparts_cpus;
 	tmp.delmask  = trialcs->effective_cpus;
-	tmp.new_cpus = trialcs->cpus_allowed;
+	tmp.new_cpus = NULL;
 #endif
 
 	retval = validate_change(cs, trialcs);
@@ -1834,6 +1837,11 @@ static int update_cpumask(struct cpuset
 	}
 	spin_unlock_irq(&callback_lock);
 
+#ifdef CONFIG_CPUMASK_OFFSTACK
+	/* Now trialcs->cpus_allowed is available */
+	tmp.new_cpus = trialcs->cpus_allowed;
+#endif
+
 	/* effective_cpus will be updated here */
 	update_cpumasks_hier(cs, &tmp, false);
 


