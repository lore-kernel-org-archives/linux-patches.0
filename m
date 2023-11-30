Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4DAA495C2;
	Thu, 30 Nov 2023 16:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vHYrVvcj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33700C433C8;
	Thu, 30 Nov 2023 16:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361445;
	bh=zrw24OEakGJPrVYJ6C58IcSlYLLE+G+SagM2UEEYyUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vHYrVvcjzJJ+zojwkjqcAw3Jtytn00anIM9VHGFdZq2sRZTajRhv8XRZLZIkPLiWv
	 a+o8vfCxxW0C3Ni5NFVpvT9Ai1P4wCnfjxjtU1JEjzYFlg7w5J2Y/Niewxf7AYIAOG
	 KzRgfKeJoEjzwVf9H8ABCXOCaQOG2Cwks3SSBluI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keisuke Nishimura <keisuke.nishimura@inria.fr>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Chen Yu <yu.c.chen@intel.com>,
	Shrikanth Hegde <sshegde@linux.vnet.ibm.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 006/112] sched/fair: Fix the decision for load balance
Date: Thu, 30 Nov 2023 16:20:53 +0000
Message-ID: <20231130162140.520284934@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
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

From: Keisuke Nishimura <keisuke.nishimura@inria.fr>

[ Upstream commit 6d7e4782bcf549221b4ccfffec2cf4d1a473f1a3 ]

should_we_balance is called for the decision to do load-balancing.
When sched ticks invoke this function, only one CPU should return
true. However, in the current code, two CPUs can return true. The
following situation, where b means busy and i means idle, is an
example, because CPU 0 and CPU 2 return true.

        [0, 1] [2, 3]
         b  b   i  b

This fix checks if there exists an idle CPU with busy sibling(s)
after looking for a CPU on an idle core. If some idle CPUs with busy
siblings are found, just the first one should do load-balancing.

Fixes: b1bfeab9b002 ("sched/fair: Consider the idle state of the whole core for load balance")
Signed-off-by: Keisuke Nishimura <keisuke.nishimura@inria.fr>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Chen Yu <yu.c.chen@intel.com>
Reviewed-by: Shrikanth Hegde <sshegde@linux.vnet.ibm.com>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://lkml.kernel.org/r/20231031133821.1570861-1-keisuke.nishimura@inria.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0351320148177..fa9fff0f9620d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -11121,12 +11121,16 @@ static int should_we_balance(struct lb_env *env)
 			continue;
 		}
 
-		/* Are we the first idle CPU? */
+		/*
+		 * Are we the first idle core in a non-SMT domain or higher,
+		 * or the first idle CPU in a SMT domain?
+		 */
 		return cpu == env->dst_cpu;
 	}
 
-	if (idle_smt == env->dst_cpu)
-		return true;
+	/* Are we the first idle CPU with busy siblings? */
+	if (idle_smt != -1)
+		return idle_smt == env->dst_cpu;
 
 	/* Are we the first CPU of this group ? */
 	return group_balance_cpu(sg) == env->dst_cpu;
-- 
2.42.0



