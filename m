Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E4452572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:47:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A032C433D2;
	Tue, 18 Apr 2023 12:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681822046;
	bh=V7e/AyIHuQEgs1bKHSAVIrxY3J4tgCgRrxFN+SQ7H80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vZ2NlN9Uk6VGRF2JF6aGqxQ+zX7FaUIWclF7wZ4iMMaAaVq+iG05lonLvhXA1LS+Z
	 ruV7FpMRbxepbnrpf7kFcyHwH9cHhv7ghxmjzqxZISxIbyognwe5E1Q0byPEBJm1cj
	 mpe9J++/llNaHozaEt2P0qhddSUR/joXgM1k07DY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Don <joshdon@google.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.1 111/134] cgroup: fix display of forceidle time at root
Date: Tue, 18 Apr 2023 14:22:47 +0200
Message-Id: <20230418120317.059603841@linuxfoundation.org>
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

From: Josh Don <joshdon@google.com>

commit fcdb1eda5302599045bb366e679cccb4216f3873 upstream.

We need to reset forceidle_sum to 0 when reading from root, since the
bstat we accumulate into is stack allocated.

To make this more robust, just replace the existing cputime reset with a
memset of the overall bstat.

Signed-off-by: Josh Don <joshdon@google.com>
Fixes: 1fcf54deb767 ("sched/core: add forced idle accounting for cgroups")
Cc: stable@vger.kernel.org # v6.0+
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/rstat.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index 831f1f472bb8..0a2b4967e333 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -457,9 +457,7 @@ static void root_cgroup_cputime(struct cgroup_base_stat *bstat)
 	struct task_cputime *cputime = &bstat->cputime;
 	int i;
 
-	cputime->stime = 0;
-	cputime->utime = 0;
-	cputime->sum_exec_runtime = 0;
+	memset(bstat, 0, sizeof(*bstat));
 	for_each_possible_cpu(i) {
 		struct kernel_cpustat kcpustat;
 		u64 *cpustat = kcpustat.cpustat;
-- 
2.40.0



