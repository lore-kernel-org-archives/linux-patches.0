Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F06819D8BC;
	Sat, 12 Sep 2026 09:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206920; cv=none; b=VoJkaGvgflce60UQJO5QL3o2oLmGCl8xh0c0nUOqtjbVyHiPpyb/MJZGEt3rrd61Po9tYXsUf5Vsyxgd12o5QTlkwrjNKOpR8PgPSkkowGfF0z1QfMD7MT7yFj9EQypnnCDOrR9S7/ZeFRxOaNI7hLcJjgit/Cr3ucdwnFOZWFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206920; c=relaxed/simple;
	bh=GsJYdPZpKCcPypfDSufMj3S4KrNhopGMv2qv8oSdpuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LfLjAR/C6+1NGQkY7FTEk9L+u4DRgXctUFZ41ZH9TljWItMBRzQwRYLrMefPbN1cBwKF0kSFKcQ2QkvKtmpXBATJkxv2I5CZiR1v31+QIXIq/uZpUvK/4SGKaa+zVZwDUzP9cyZrezrheqACefiCmE1dVWyFCUumX+N7smjFZ0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TMZ16pVG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TMZ16pVG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C2E51F000FF;
	Sat, 12 Sep 2026 09:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206919;
	bh=pLb6cPV1yXoX5NFdsgTCo4nae/JdCYkErRysR8jUmYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TMZ16pVGRo/W2O5lDc3e2w/QpBnbTbbhJGHyNLxV0JeqojP2BrWcuOlwKMXZyKRHC
	 KqhmEbiKZb7HsxG0hxs5w++/ZAVf5uF49a6klrVoDzMq08ZRor82BucfV+vrAnVqF+
	 k/zq3svHfj9dgZTm3zTy/LSq4tl0NM/nz/D+o2ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang Luo <luoliang@kylinos.cn>,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0305/1518] selftests/sched_ext: Fix bpf_link leak on early return in prog_run
Date: Sat, 12 Sep 2026 08:41:14 +0200
Message-ID: <20260912065630.379399072@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liang Luo <luoliang@kylinos.cn>

[ Upstream commit e655c1f1bd14804f398df7da029c4a7e3f9ccd7f ]

In prog_run's run(), the bpf_link is attached early but only destroyed
on the success path. The three SCX_EQ assertions between attach and
destroy expand to a direct 'return SCX_TEST_FAIL', so if any of them
triggers, bpf_link__destroy() is never reached and the BPF scheduler
stays loaded. All subsequent tests then fail to attach because SCX is
not in the DISABLED state.

Convert those assertions to explicit checks that jump to a unified
'out' label which always runs the cleanup, matching the pattern used
in cyclic_kick_wait.c.

Fixes: a5db7817af78 ("sched_ext: Add selftests")
Signed-off-by: Liang Luo <luoliang@kylinos.cn>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/sched_ext/prog_run.c | 34 +++++++++++++++-----
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/sched_ext/prog_run.c b/tools/testing/selftests/sched_ext/prog_run.c
index 05974820ca69d..1129ec2aaddc7 100644
--- a/tools/testing/selftests/sched_ext/prog_run.c
+++ b/tools/testing/selftests/sched_ext/prog_run.c
@@ -28,7 +28,8 @@ static enum scx_test_status setup(void **ctx)
 static enum scx_test_status run(void *ctx)
 {
 	struct prog_run *skel = ctx;
-	struct bpf_link *link;
+	struct bpf_link *link = NULL;
+	enum scx_test_status status = SCX_TEST_PASS;
 	int prog_fd, err = 0;
 
 	prog_fd = bpf_program__fd(skel->progs.prog_run_syscall);
@@ -42,23 +43,40 @@ static enum scx_test_status run(void *ctx)
 	link = bpf_map__attach_struct_ops(skel->maps.prog_run_ops);
 	if (!link) {
 		SCX_ERR("Failed to attach scheduler");
-		close(prog_fd);
-		return SCX_TEST_FAIL;
+		status = SCX_TEST_FAIL;
+		goto out;
 	}
 
 	err = bpf_prog_test_run_opts(prog_fd, &topts);
-	SCX_EQ(err, 0);
+	if (err) {
+		SCX_ERR("BPF_PROG_RUN failed (%d)", err);
+		status = SCX_TEST_FAIL;
+		goto out;
+	}
 
 	/* Assumes uei.kind is written last */
 	while (skel->data->uei.kind == EXIT_KIND(SCX_EXIT_NONE))
 		sched_yield();
 
-	SCX_EQ(skel->data->uei.kind, EXIT_KIND(SCX_EXIT_UNREG_BPF));
-	SCX_EQ(skel->data->uei.exit_code, 0xdeadbeef);
+	if (skel->data->uei.kind != EXIT_KIND(SCX_EXIT_UNREG_BPF)) {
+		SCX_ERR("Unexpected exit kind: %llu",
+			(unsigned long long)skel->data->uei.kind);
+		status = SCX_TEST_FAIL;
+		goto out;
+	}
+	if (skel->data->uei.exit_code != 0xdeadbeef) {
+		SCX_ERR("Unexpected exit code: %lld",
+			(long long)skel->data->uei.exit_code);
+		status = SCX_TEST_FAIL;
+		goto out;
+	}
+
+out:
 	close(prog_fd);
-	bpf_link__destroy(link);
+	if (link)
+		bpf_link__destroy(link);
 
-	return SCX_TEST_PASS;
+	return status;
 }
 
 static void cleanup(void *ctx)
-- 
2.53.0



