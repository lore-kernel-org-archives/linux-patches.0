Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9251864B
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:45:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88BEEC433C7;
	Wed, 20 Sep 2023 11:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210316;
	bh=4GXyfwZxrXI1KFY3yPDzH/+z6eZRBYNfwS/yUOylHX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aLpWWSYJdkqUn5IuA9p9ZV3gTrZ4QnYHhwJUZt4kkcysxJUcZIe3EcLB93HHWVpv9
	 3XCfT4QG7kYGjMtw3ynGWO9kPcHIzC7escWk93P9AHZs+tLnrmZN4lbZBeSMD++ZqX
	 Z7fHTEHxStUuikd8MwrINgOc5b/kkUXzZltJGUis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 009/211] scftorture: Forgive memory-allocation failure if KASAN
Date: Wed, 20 Sep 2023 13:27:33 +0200
Message-ID: <20230920112846.127275452@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
References: <20230920112845.859868994@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit 013608cd0812bdb21fc26d39ed8fdd2fc76e8b9b ]

Kernels built with CONFIG_KASAN=y quarantine newly freed memory in order
to better detect use-after-free errors.  However, this can exhaust memory
more quickly in allocator-heavy tests, which can result in spurious
scftorture failure.  This commit therefore forgives memory-allocation
failure in kernels built with CONFIG_KASAN=y, but continues counting
the errors for use in detailed test-result analyses.

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/scftorture.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/scftorture.c b/kernel/scftorture.c
index 5d113aa59e773..83c33ba0ca7e0 100644
--- a/kernel/scftorture.c
+++ b/kernel/scftorture.c
@@ -171,7 +171,8 @@ static void scf_torture_stats_print(void)
 		scfs.n_all_wait += scf_stats_p[i].n_all_wait;
 	}
 	if (atomic_read(&n_errs) || atomic_read(&n_mb_in_errs) ||
-	    atomic_read(&n_mb_out_errs) || atomic_read(&n_alloc_errs))
+	    atomic_read(&n_mb_out_errs) ||
+	    (!IS_ENABLED(CONFIG_KASAN) && atomic_read(&n_alloc_errs)))
 		bangstr = "!!! ";
 	pr_alert("%s %sscf_invoked_count %s: %lld resched: %lld single: %lld/%lld single_ofl: %lld/%lld single_rpc: %lld single_rpc_ofl: %lld many: %lld/%lld all: %lld/%lld ",
 		 SCFTORT_FLAG, bangstr, isdone ? "VER" : "ver", invoked_count, scfs.n_resched,
@@ -323,7 +324,8 @@ static void scftorture_invoke_one(struct scf_statistics *scfp, struct torture_ra
 		preempt_disable();
 	if (scfsp->scfs_prim == SCF_PRIM_SINGLE || scfsp->scfs_wait) {
 		scfcp = kmalloc(sizeof(*scfcp), GFP_ATOMIC);
-		if (WARN_ON_ONCE(!scfcp)) {
+		if (!scfcp) {
+			WARN_ON_ONCE(!IS_ENABLED(CONFIG_KASAN));
 			atomic_inc(&n_alloc_errs);
 		} else {
 			scfcp->scfc_cpu = -1;
-- 
2.40.1



