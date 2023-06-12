Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D731911C88
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:39:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D65DC433D2;
	Mon, 12 Jun 2023 10:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566387;
	bh=zKysH0PqgO4ppCUgof0pBqkfcBmwRsnAPviQqMNILN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iflXxiOsBOfqEKnAgsOp3fJkFiXxx31hNvbEXjci0+AURKIlQEeuaVeNxDcJ/pInr
	 8DOb+tayPJuufn3vBBpWBBhF/RxBqG5m8G/cL/9vPW1TqV1WIkA3zD2zRI5V+3VR2K
	 quC9b7AdqhLfXAYrirHeF85zKfExTSkLnp/0CEzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuba Piecuch <jpiecuch@google.com>,
	KP Singh <kpsingh@kernel.org>,
	Song Liu <song@kernel.org>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 013/132] bpf: Fix UAF in task local storage
Date: Mon, 12 Jun 2023 12:25:47 +0200
Message-ID: <20230612101710.884537100@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101710.279705932@linuxfoundation.org>
References: <20230612101710.279705932@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: KP Singh <kpsingh@kernel.org>

[ Upstream commit b0fd1852bcc21accca6260ef245356d5c141ff66 ]

When task local storage was generalized for tracing programs, the
bpf_task_local_storage callback was moved from a BPF LSM hook
callback for security_task_free LSM hook to it's own callback. But a
failure case in bad_fork_cleanup_security was missed which, when
triggered, led to a dangling task owner pointer and a subsequent
use-after-free. Move the bpf_task_storage_free to the very end of
free_task to handle all failure cases.

This issue was noticed when a BPF LSM program was attached to the
task_alloc hook on a kernel with KASAN enabled. The program used
bpf_task_storage_get to copy the task local storage from the current
task to the new task being created.

Fixes: a10787e6d58c ("bpf: Enable task local storage for tracing programs")
Reported-by: Kuba Piecuch <jpiecuch@google.com>
Signed-off-by: KP Singh <kpsingh@kernel.org>
Acked-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20230602002612.1117381-1-kpsingh@kernel.org
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/fork.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index ec913b13c5edb..6bb91fbbf73cc 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -559,6 +559,7 @@ void free_task(struct task_struct *tsk)
 	arch_release_task_struct(tsk);
 	if (tsk->flags & PF_KTHREAD)
 		free_kthread_struct(tsk);
+	bpf_task_storage_free(tsk);
 	free_task_struct(tsk);
 }
 EXPORT_SYMBOL(free_task);
@@ -843,7 +844,6 @@ void __put_task_struct(struct task_struct *tsk)
 	cgroup_free(tsk);
 	task_numa_free(tsk, true);
 	security_task_free(tsk);
-	bpf_task_storage_free(tsk);
 	exit_creds(tsk);
 	delayacct_tsk_free(tsk);
 	put_signal_struct(tsk->signal);
-- 
2.39.2



