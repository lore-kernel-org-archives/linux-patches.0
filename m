Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D2739FF3;
	Fri, 24 Nov 2023 18:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MJoGr9eQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C224C433C8;
	Fri, 24 Nov 2023 18:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849049;
	bh=yFSxXQnoxCpiMLe9fWZm3FyPStajFJE6IvSH3fRt8Fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MJoGr9eQYaFL+z7fzC0ywV46IG4TXu6Q8YMSsRJlS2kN8vI5gugoxlYXt9Ti4E9bT
	 yR+om3iJrbt3eTm9Rlbt8rNWJsNfGTGLKXjOKD9GTDn3ogucDLmPkAR6TxopmJjKSM
	 +VqYf/RV2USXtad224peVK8rWQ6Re7gRMED/N5xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Joel Fernandes (Google)" <joel@joelfernandes.org>,
	David Laight <David.Laight@aculab.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 007/530] srcu: Fix srcu_struct node grpmask overflow on 64-bit systems
Date: Fri, 24 Nov 2023 17:42:53 +0000
Message-ID: <20231124172028.326477105@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

From: Denis Arefev <arefev@swemel.ru>

[ Upstream commit d8d5b7bf6f2105883bbd91bbd4d5b67e4e3dff71 ]

The value of a bitwise expression 1 << (cpu - sdp->mynode->grplo)
is subject to overflow due to a failure to cast operands to a larger
data type before performing the bitwise operation.

The maximum result of this subtraction is defined by the RCU_FANOUT_LEAF
Kconfig option, which on 64-bit systems defaults to 16 (resulting in a
maximum shift of 15), but which can be set up as high as 64 (resulting
in a maximum shift of 63).  A value of 31 can result in sign extension,
resulting in 0xffffffff80000000 instead of the desired 0x80000000.
A value of 32 or greater triggers undefined behavior per the C standard.

This bug has not been known to cause issues because almost all kernels
take the default CONFIG_RCU_FANOUT_LEAF=16.  Furthermore, as long as a
given compiler gives a deterministic non-zero result for 1<<N for N>=32,
the code correctly invokes all SRCU callbacks, albeit wasting CPU time
along the way.

This commit therefore substitutes the correct 1UL for the buggy 1.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Denis Arefev <arefev@swemel.ru>
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: David Laight <David.Laight@aculab.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/srcutree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/rcu/srcutree.c b/kernel/rcu/srcutree.c
index c6481032d42be..7522517b63b6f 100644
--- a/kernel/rcu/srcutree.c
+++ b/kernel/rcu/srcutree.c
@@ -223,7 +223,7 @@ static bool init_srcu_struct_nodes(struct srcu_struct *ssp, gfp_t gfp_flags)
 				snp->grplo = cpu;
 			snp->grphi = cpu;
 		}
-		sdp->grpmask = 1 << (cpu - sdp->mynode->grplo);
+		sdp->grpmask = 1UL << (cpu - sdp->mynode->grplo);
 	}
 	smp_store_release(&ssp->srcu_sup->srcu_size_state, SRCU_SIZE_WAIT_BARRIER);
 	return true;
@@ -833,7 +833,7 @@ static void srcu_schedule_cbs_snp(struct srcu_struct *ssp, struct srcu_node *snp
 	int cpu;
 
 	for (cpu = snp->grplo; cpu <= snp->grphi; cpu++) {
-		if (!(mask & (1 << (cpu - snp->grplo))))
+		if (!(mask & (1UL << (cpu - snp->grplo))))
 			continue;
 		srcu_schedule_cbs_sdp(per_cpu_ptr(ssp->sda, cpu), delay);
 	}
-- 
2.42.0



