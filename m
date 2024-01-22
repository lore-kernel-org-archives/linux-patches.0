Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6B46026B;
	Tue, 23 Jan 2024 00:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970815; cv=none; b=udhvtYO4eVfQNtNRGMOauBxw43LQ/JboJV+48WSpvcrTDxhKpO4/dzgPdTEjRFC/PrQvO3+pjMAuXl3RIj0dyiNnwpAT+NsSchaYPWF+04XGzVL+Ry8fDKzlmY66k1hHIuMVu8oMP7bGaw28l05hDK9jm/sZVhEvGB7K2BWfgBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970815; c=relaxed/simple;
	bh=3yWYnpDIkP0sB+SfrpNR8wzkmTdOFcQqYi4jIbIzbWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=InGA5j/A3R+5Q+bzeIbXD9Fh97lB7oI1IOUhGLFDMkr5sof7yw1UoPhDVLW9hqWqmGakONQ5QDCQvwyLyU11TLVpuFbWba6HPaW8kV1TQt+5MeNHhGZapNkHrTD09nYxe7fEAysYWfd8b+JIjuporybKc2l/Kf8Ny8R7TFDK4iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wj7cITB5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wj7cITB5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDFC0C433F1;
	Tue, 23 Jan 2024 00:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970815;
	bh=3yWYnpDIkP0sB+SfrpNR8wzkmTdOFcQqYi4jIbIzbWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wj7cITB5GGAtiu/g2bPTej//N/0BtphTugHblsdnp/ejGQr1Da5yxPf11NNJxzIrU
	 5QEFPET0eVlPVzlbnq9ldIec2HXhbemKTGLuI+RXBHSsEDly/lLIXGt6AkBMXLdA2m
	 /78W+UxyVKTHaIO6qeXqU7RTef/8rgL/ueKCyXy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao@huaweicloud.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 093/417] rcu-tasks: Provide rcu_trace_implies_rcu_gp()
Date: Mon, 22 Jan 2024 15:54:21 -0800
Message-ID: <20240122235754.917598986@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit e6c86c513f440bec5f1046539c7e3c6c653842da ]

As an accident of implementation, an RCU Tasks Trace grace period also
acts as an RCU grace period.  However, this could change at any time.
This commit therefore creates an rcu_trace_implies_rcu_gp() that currently
returns true to codify this accident.  Code relying on this accident
must call this function to verify that this accident is still happening.

Reported-by: Hou Tao <houtao@huaweicloud.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Link: https://lore.kernel.org/r/20221014113946.965131-2-houtao@huaweicloud.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: 876673364161 ("bpf: Defer the free of inner map when necessary")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rcupdate.h | 12 ++++++++++++
 kernel/rcu/tasks.h       |  2 ++
 2 files changed, 14 insertions(+)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index e9e61cd27ef6..46bd9a331fd5 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -242,6 +242,18 @@ static inline void exit_tasks_rcu_stop(void) { }
 static inline void exit_tasks_rcu_finish(void) { }
 #endif /* #else #ifdef CONFIG_TASKS_RCU_GENERIC */
 
+/**
+ * rcu_trace_implies_rcu_gp - does an RCU Tasks Trace grace period imply an RCU grace period?
+ *
+ * As an accident of implementation, an RCU Tasks Trace grace period also
+ * acts as an RCU grace period.  However, this could change at any time.
+ * Code relying on this accident must call this function to verify that
+ * this accident is still happening.
+ *
+ * You have been warned!
+ */
+static inline bool rcu_trace_implies_rcu_gp(void) { return true; }
+
 /**
  * cond_resched_tasks_rcu_qs - Report potential quiescent states to RCU
  *
diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
index c1f18c63b9b1..b5d5b6cf093a 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -1570,6 +1570,8 @@ static void rcu_tasks_trace_postscan(struct list_head *hop)
 {
 	// Wait for late-stage exiting tasks to finish exiting.
 	// These might have passed the call to exit_tasks_rcu_finish().
+
+	// If you remove the following line, update rcu_trace_implies_rcu_gp()!!!
 	synchronize_rcu();
 	// Any tasks that exit after this point will set
 	// TRC_NEED_QS_CHECKED in ->trc_reader_special.b.need_qs.
-- 
2.43.0



