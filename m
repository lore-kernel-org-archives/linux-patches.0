Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1D51F76A4;
	Tue,  3 Dec 2024 15:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238719; cv=none; b=XhZ77LlTRG+pPELidYBg+W/U3T71/FF7ZNlxlJIAhhPw0cYmP/D2yMiXC5oJzbi8EBzYhegvbN+IM29f6lJyd2oxLUzvtSpMczuz0Bk6QYHLIsc4S835NoaGsDPx0f+z+60mETWfVVIix59EJoan5S3z2G1rnwRBmGMpPPCcKWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238719; c=relaxed/simple;
	bh=sMd9p5uSZ6C2UQJWp+flJUWF1h6Gmqubny42CjkSW2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WCne71FP7uKP/POZpmTaYqoMOlRSQXakGaBpfv575qsrlEwPL011gHxfmtEgRrQX8vk4XgI+ZJ4FABkVWHdmRl/oRh5eZfDANZEK73H6BPhKVawSUPB11VEb7l42cgWx+r3rzTh2BEiOV51mmAKD1eC/g96Scfnb+MjUARCxFeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UCfuNdT8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UCfuNdT8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD10C4CECF;
	Tue,  3 Dec 2024 15:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238719;
	bh=sMd9p5uSZ6C2UQJWp+flJUWF1h6Gmqubny42CjkSW2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UCfuNdT8iA8I5P070ku8tACIXzVtUm9r9A+/0W1VUOqHatC7PB+l2/k1duGMnOvZP
	 GKiH2l2c+4ROdvCL+q/g5RfcY94kkj1YXj7u4Vfzg3iOMLYv1MDaA5AzRJ/SClONSK
	 TA40ebRe8DlqrMhzT8FTlD4aWXU4lFqL9eRFcoBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 343/817] bpf: Force uprobe bpf program to always return 0
Date: Tue,  3 Dec 2024 15:38:35 +0100
Message-ID: <20241203144009.212607507@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 6dbbb3683ab2e..9cb1c952c3ec4 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -3294,7 +3294,6 @@ static int uprobe_prog_run(struct bpf_uprobe *uprobe,
 	struct bpf_prog *prog = link->link.prog;
 	bool sleepable = prog->sleepable;
 	struct bpf_run_ctx *old_run_ctx;
-	int err = 0;
 
 	if (link->task && current->mm != link->task->mm)
 		return 0;
@@ -3307,7 +3306,7 @@ static int uprobe_prog_run(struct bpf_uprobe *uprobe,
 	migrate_disable();
 
 	old_run_ctx = bpf_set_run_ctx(&run_ctx.run_ctx);
-	err = bpf_prog_run(link->link.prog, regs);
+	bpf_prog_run(link->link.prog, regs);
 	bpf_reset_run_ctx(old_run_ctx);
 
 	migrate_enable();
@@ -3316,7 +3315,7 @@ static int uprobe_prog_run(struct bpf_uprobe *uprobe,
 		rcu_read_unlock_trace();
 	else
 		rcu_read_unlock();
-	return err;
+	return 0;
 }
 
 static bool
-- 
2.43.0



