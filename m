Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 261BF179A3;
	Tue, 17 Mar 2026 16:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766177; cv=none; b=Gpe0I7akbYl+yJ4mPC+01q2+eDCsgjfykzOhWRCtm0UrMd3h6zqYNNd8xKUZkm1BsBkTylxatpq1QAvJhcv1AEMBIkuzQLn+j8WAE40pED2DfkYFJuQXJnBK4ydswMEpmqttB6nSO69zqu2z5+nOzmcKFNI+svGvfPGGarA5NwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766177; c=relaxed/simple;
	bh=rI1Lx3ezxJSWaBit2QPc0TebgZnuzCiXNLj2ctIPGBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UftckR1My/xYC/jfa5CD2UbritSltkbJ5l1CAYqCw4G49+ng3pqEqeqA5FFJ0JHqH20gfS3bJXpsExXCgA/A7hJSghORWOPqbFopY17XzVQCebh/olu8d6YNhcrbjnqR787mjVMmLdcnS9+qdFgYkxMZFEpSN6RWfFq+xnQE7wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vYHnd55N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vYHnd55N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46966C4CEF7;
	Tue, 17 Mar 2026 16:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766176;
	bh=rI1Lx3ezxJSWaBit2QPc0TebgZnuzCiXNLj2ctIPGBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vYHnd55NXUtpM/u+iuvm9Bkd6yh5odPZ0x4GGlwqWyxt1UtKdYCZe9vJp0W0SxGc8
	 PJO9uf39XORwBHsdUknkjfCg03EP73bXcaCmuE4TTKTs+dr3+ISdHh0so8zy9XYsAC
	 ZLLQ8+gsDLMqHM0kOP1GbZ4q17tIgw/j0Z0NDQ4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matttbe@kernel.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 186/378] sched/mmcid: Handle vfork()/CLONE_VM correctly
Date: Tue, 17 Mar 2026 17:32:23 +0100
Message-ID: <20260317163013.849583054@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@kernel.org>

[ Upstream commit 28b5a1395036d6c7a6c8034d85ad3d7d365f192c ]

Matthieu and Jiri reported stalls where a task endlessly loops in
mm_get_cid() when scheduling in.

It turned out that the logic which handles vfork()'ed tasks is broken. It
is invoked when the number of tasks associated to a process is smaller than
the number of MMCID users. It then walks the task list to find the
vfork()'ed task, but accounts all the already processed tasks as well.

If that double processing brings the number of to be handled tasks to 0,
the walk stops and the vfork()'ed task's CID is not fixed up. As a
consequence a subsequent schedule in fails to acquire a (transitional) CID
and the machine stalls.

Cure this by removing the accounting condition and make the fixup always
walk the full task list if it could not find the exact number of users in
the process' thread list.

Fixes: fbd0e71dc370 ("sched/mmcid: Provide CID ownership mode fixup functions")
Closes: https://lore.kernel.org/b24ffcb3-09d5-4e48-9070-0b69bc654281@kernel.org
Reported-by: Matthieu Baerts <matttbe@kernel.org>
Reported-by: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260310202526.048657665@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ca6e6e4b17eaf..24d607c78f119 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -10618,10 +10618,7 @@ static void mm_cid_do_fixup_tasks_to_cpus(struct mm_struct *mm)
 	for_each_process_thread(p, t) {
 		if (t == current || t->mm != mm)
 			continue;
-		if (mm_cid_fixup_task_to_cpu(t, mm)) {
-			if (--users == 0)
-				return;
-		}
+		mm_cid_fixup_task_to_cpu(t, mm);
 	}
 }
 
-- 
2.51.0



