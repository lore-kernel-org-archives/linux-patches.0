Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB6F134BA44;
	Fri, 31 Oct 2025 14:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919555; cv=none; b=bboAMbTGpAS4NL9VJJwwqSOf4ePsENH+omD0rMIP7R1ZrSRLxlJd5EqLqvKVpAPa0P81cQqf8SCHaim16NYinJtmLwSUlqSZwInsMndNbjlSmwBcHyu8yRXzVUg1IiWRPp5fQzaGMA+ehBbyVgYqDg+aNBcbAbiPrq0ov8nlXY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919555; c=relaxed/simple;
	bh=rInUEDEDqkdJqWwlkJ+4QTgbFdoJuCZiccwWs66JPN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k+mzuqdx4+lueLjIrj80zImn4sMqAl792m/3cJGDkoB3F9NgM9+QdLLrNjr76uHScwPTYaDpPqZOXbadnOUWSHq/WF0MoHZAJlG5WQbrYRqLkoX2Ccq8vXsWSi8VeobJzV0nkkwbLf1bi7feO1fHI7U5b1V9Fh52FU6xr0uuEsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d7vDQfC9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d7vDQfC9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F5AC4CEE7;
	Fri, 31 Oct 2025 14:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919555;
	bh=rInUEDEDqkdJqWwlkJ+4QTgbFdoJuCZiccwWs66JPN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d7vDQfC9BM3LB2c76Zpe1GNd5ZQh3tSSS1yFoxdvf2ipPb3OxcA+v6ZWYeg3B7SBQ
	 8nYSoaO0O8p/xJ2IYOmo2bkf9FU1ecfU5InCWVFEpz+f0yJa6n/4/fF0Nkl9wuw3BE
	 G9z+q7Sz6Xe3oU2QverDR8CZv8aCsGFYRYcc6otE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 18/35] sched_ext: Keep bypass on between enable failure and scx_disable_workfn()
Date: Fri, 31 Oct 2025 15:01:26 +0100
Message-ID: <20251031140043.999720048@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140043.564670400@linuxfoundation.org>
References: <20251031140043.564670400@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 4a1d9d73aabc8f97f48c4f84f936de3b265ffd6f ]

scx_enable() turns on the bypass mode while enable is in progress. If
enabling fails, it turns off the bypass mode and then triggers scx_error().
scx_error() will trigger scx_disable_workfn() which will turn on the bypass
mode again and unload the failed scheduler.

This moves the system out of bypass mode between the enable error path and
the disable path, which is unnecessary and can be brittle - e.g. the thread
running scx_enable() may already be on the failed scheduler and can be
switched out before it triggers scx_error() leading to a stall. The watchdog
would eventually kick in, so the situation isn't critical but is still
suboptimal.

There is nothing to be gained by turning off the bypass mode between
scx_enable() failure and scx_disable_workfn(). Keep bypass on.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index f89894476e51f..14724dae0b795 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -4763,7 +4763,7 @@ static int scx_enable(struct sched_ext_ops *ops, struct bpf_link *link)
 err_disable_unlock_all:
 	scx_cgroup_unlock();
 	percpu_up_write(&scx_fork_rwsem);
-	scx_bypass(false);
+	/* we'll soon enter disable path, keep bypass on */
 err_disable:
 	mutex_unlock(&scx_enable_mutex);
 	/*
-- 
2.51.0



