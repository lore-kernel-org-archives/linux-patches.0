Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5752572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:47:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F59C433D2;
	Tue, 18 Apr 2023 12:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681822051;
	bh=fF/dcsiIzn8wZeI2ZrY1tS/II0KNFvwcxXRNDNTsB/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YQD1MHddFnZlPQzydBcs0pvF1BnjVa2a9F5tZ8AedVL9xbqTwDJ3hz3G8ZK88q023
	 YAYryi/GfoyRmbIHUlzorTuQNG9uxT2+xZUw/Cuu3GqVnxnRAHkOuOIUEvz8c9F0/v
	 8B3s5NlWUUStHvEapCWJ6DBgQtwYGkQ/HMrwa0vI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.1 113/134] cgroup/cpuset: Wake up cpuset_attach_wq tasks in cpuset_cancel_attach()
Date: Tue, 18 Apr 2023 14:22:49 +0200
Message-Id: <20230418120317.123168016@linuxfoundation.org>
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

commit ba9182a89626d5f83c2ee4594f55cb9c1e60f0e2 upstream.

After a successful cpuset_can_attach() call which increments the
attach_in_progress flag, either cpuset_cancel_attach() or cpuset_attach()
will be called later. In cpuset_attach(), tasks in cpuset_attach_wq,
if present, will be woken up at the end. That is not the case in
cpuset_cancel_attach(). So missed wakeup is possible if the attach
operation is somehow cancelled. Fix that by doing the wakeup in
cpuset_cancel_attach() as well.

Fixes: e44193d39e8d ("cpuset: let hotplug propagation work wait for task attaching")
Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
Cc: stable@vger.kernel.org # v3.11+
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cpuset.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2498,11 +2498,15 @@ out_unlock:
 static void cpuset_cancel_attach(struct cgroup_taskset *tset)
 {
 	struct cgroup_subsys_state *css;
+	struct cpuset *cs;
 
 	cgroup_taskset_first(tset, &css);
+	cs = css_cs(css);
 
 	percpu_down_write(&cpuset_rwsem);
-	css_cs(css)->attach_in_progress--;
+	cs->attach_in_progress--;
+	if (!cs->attach_in_progress)
+		wake_up(&cpuset_attach_wq);
 	percpu_up_write(&cpuset_rwsem);
 }
 


