Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6E02E649
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GtvB8ku3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24807C433C8;
	Mon,  9 Oct 2023 13:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858886;
	bh=7kr1apUnOgof/nfGWbasV0ilaEMeFeYctRygXQ+ufAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GtvB8ku34lrKOHqqPuQUOiFLpIe5gKfbIjF9PDZ1iQ3JmiZPNNUpNRwKc2cw/0yTP
	 39C9Zh2FhLGc1pytSi9Efb4BFZblq4RewS7tpPFu7+2Rhg6tZ9BqH9mB/ISQndKLNd
	 w1XbnZp296jHUjIQ4oclRVB6w/lrHZM/l9PNq+tc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	syzbot+16e3f2c77e7c5a0113f9@syzkaller.appspotmail.com,
	Chengming Zhou <zhouchengming@bytedance.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Tejun Heo <tj@kernel.org>,
	Zhouyi Zhou <zhouzhouyi@gmail.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 132/226] cgroup: Fix suspicious rcu_dereference_check() usage warning
Date: Mon,  9 Oct 2023 15:01:33 +0200
Message-ID: <20231009130130.210024505@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengming Zhou <zhouchengming@bytedance.com>

commit f2aa197e4794bf4c2c0c9570684f86e6fa103e8b upstream.

task_css_set_check() will use rcu_dereference_check() to check for
rcu_read_lock_held() on the read-side, which is not true after commit
dc6e0818bc9a ("sched/cpuacct: Optimize away RCU read lock"). This
commit drop explicit rcu_read_lock(), change to RCU-sched read-side
critical section. So fix the RCU warning by adding check for
rcu_read_lock_sched_held().

Fixes: dc6e0818bc9a ("sched/cpuacct: Optimize away RCU read lock")
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Reported-by: syzbot+16e3f2c77e7c5a0113f9@syzkaller.appspotmail.com
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Tejun Heo <tj@kernel.org>
Tested-by: Zhouyi Zhou <zhouzhouyi@gmail.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20220305034103.57123-1-zhouchengming@bytedance.com
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/cgroup.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 7653f54189502..c9c430712d471 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -451,6 +451,7 @@ extern struct mutex cgroup_mutex;
 extern spinlock_t css_set_lock;
 #define task_css_set_check(task, __c)					\
 	rcu_dereference_check((task)->cgroups,				\
+		rcu_read_lock_sched_held() ||				\
 		lockdep_is_held(&cgroup_mutex) ||			\
 		lockdep_is_held(&css_set_lock) ||			\
 		((task)->flags & PF_EXITING) || (__c))
-- 
2.40.1



