Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C147213D508;
	Fri,  6 Dec 2024 15:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497379; cv=none; b=ZvxKBC9NIkCmKD8rHoA1jtQR2qwqXdhjbdW1FUzON9wctPx4yUlxUueRNIn7axXdI1kM29u8fZbtvpcDbrJH5+lR1kBydZfiMv05G88jPz7NacwkpviIHuP/icGnz1/vHcyp1E08ctqfi6sG+D8Qn331yNB2NZrkeFNb+RvCaLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497379; c=relaxed/simple;
	bh=EKtj7PGMu8Mvn0H9ZBwfP5g3Pm7THM/nyUWOtSwwB9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IA+rtmhIeHqJCjcDOHivxWObLCamJvYGieo0jS1YnqfmWFxqyRhfOd4F55XA8Cu8GwQFpI51lEjS+KnywJMHd5whwd26GVNgQQIVwSxEzlVNLUbbxVMgswarC9RjkQdy3guT345KvYDfKs+CLepqIIKtnHkt+lKu9DUFiyU/WDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F5uO03ve; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F5uO03ve"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31BDDC4CED1;
	Fri,  6 Dec 2024 15:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497379;
	bh=EKtj7PGMu8Mvn0H9ZBwfP5g3Pm7THM/nyUWOtSwwB9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F5uO03velot6SGLjmCB/Cmv+pqK8siuWnXks09Jz9SSMXuLEw9mhv0PO0uMI7OpVt
	 G1FzXGi6TS5B/ndy0lX+RECErs5cHmp3HK1swCLf0WYhLDpDljkz+KTuVNckjYd1wO
	 LuUsssXMGlrS1kbMQGgLMQFVzzOV8ODnYWnq8Hvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 247/676] bpf: Force uprobe bpf program to always return 0
Date: Fri,  6 Dec 2024 15:31:06 +0100
Message-ID: <20241206143702.981037411@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit f505005bc7426f4309880da94cfbfc37efa225bd ]

As suggested by Andrii make uprobe multi bpf programs to always return 0,
so they can't force uprobe removal.

Keeping the int return type for uprobe_prog_run, because it will be used
in following session changes.

Fixes: 89ae89f53d20 ("bpf: Add multi uprobe link")
Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20241108134544.480660-3-jolsa@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/bpf_trace.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 9064f75de7e46..e8fb6ada323c1 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -3098,7 +3098,6 @@ static int uprobe_prog_run(struct bpf_uprobe *uprobe,
 	struct bpf_prog *prog = link->link.prog;
 	bool sleepable = prog->aux->sleepable;
 	struct bpf_run_ctx *old_run_ctx;
-	int err = 0;
 
 	if (link->task && current->mm != link->task->mm)
 		return 0;
@@ -3111,7 +3110,7 @@ static int uprobe_prog_run(struct bpf_uprobe *uprobe,
 	migrate_disable();
 
 	old_run_ctx = bpf_set_run_ctx(&run_ctx.run_ctx);
-	err = bpf_prog_run(link->link.prog, regs);
+	bpf_prog_run(link->link.prog, regs);
 	bpf_reset_run_ctx(old_run_ctx);
 
 	migrate_enable();
@@ -3120,7 +3119,7 @@ static int uprobe_prog_run(struct bpf_uprobe *uprobe,
 		rcu_read_unlock_trace();
 	else
 		rcu_read_unlock();
-	return err;
+	return 0;
 }
 
 static bool
-- 
2.43.0



