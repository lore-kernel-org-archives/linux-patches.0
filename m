Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E771478E49;
	Sat, 12 Sep 2026 13:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219254; cv=none; b=c9hJ7KLCA9dmIP0/AVWrjRpadElFMlvkx3nQfDWz9zsnA38llZkrEdU3frbVD4zBuN7aQKLsquM8oNHH8rNWPSOouODggsOuZW+hbw3cyVxhs1Q4R1vdCaC8dyH2tMwzSJMpW2aUURKAJSwRXDH2p6t04pnDJAq0WV/h57eFjSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219254; c=relaxed/simple;
	bh=UILfdanlo8KTV+XdKpCp4pkA08yg1iS318vI9JgKWeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NfNjghHkYz25QD3ta8CJ284TIOwDk4cEtGqxYsUhUoNU2ajSTRWv2nezpC8A2pd3GvNfsVKAs8zXOouLYwDqPWGP04TqTD39xFWb6LHIEHZne97Y5BnS5GAmX+i28kVRKlE56trkMLWd/J3sfDsjQpoMCZ6Y/tcQJg9VL9P1UFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mLXYOrbt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mLXYOrbt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 347A31F000FF;
	Sat, 12 Sep 2026 13:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219253;
	bh=sB6/mkzNlEeJndb3Zuxkoti42/e7Zfqm11sr2Kc55Tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mLXYOrbtgG8fzRsyRwBp8rx4KEmdcd87AfBa629EEqkkuEJ2zLbOAgBqmilpuUKmA
	 v3pRwJEVtAtyOgCTna5gm5+nF8VEH1nX4cyo9zFBWX4TB5RnYYBiU/GwrJBAUKd06a
	 ZxEfGs19OfvsHzoNC1sBEpVoRSLjjdDO85YICHt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1313/1376] samples/ftrace: Fix kthread_stop() on ERR_PTR in ftrace-direct-multi-modify
Date: Sat, 12 Sep 2026 09:02:19 +0200
Message-ID: <20260912065636.797560782@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 6727b7618f49401acf373fa3ec5712e2ec52e5cf ]

ftrace_direct_multi_init() assigns kthread_run()'s return value to
simple_tsk without an IS_ERR() check. When kthread_run() fails it
returns ERR_PTR(-ENOMEM), but init still returns 0, so the module loads
with simple_tsk holding an error pointer. On unload,
ftrace_direct_multi_exit() then passes that ERR_PTR to kthread_stop(),
leading to a null-pointer-dereference.

Check the return value of kthread_run() with IS_ERR(); on failure,
unregister the ftrace direct call and propagate the error code.

Link: https://patch.msgid.link/20260826015050.10772-1-vulab@iscas.ac.cn
Fixes: e1067a07cfbc ("ftrace/samples: Add module to test multi direct modify interface")
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/ftrace/ftrace-direct-multi-modify.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/samples/ftrace/ftrace-direct-multi-modify.c b/samples/ftrace/ftrace-direct-multi-modify.c
index cc7f42999c001..34b396c9cbb7b 100644
--- a/samples/ftrace/ftrace-direct-multi-modify.c
+++ b/samples/ftrace/ftrace-direct-multi-modify.c
@@ -265,9 +265,15 @@ static int __init ftrace_direct_multi_init(void)
 
 	ret = register_ftrace_direct(&direct, my_tramp);
 
-	if (!ret)
-		simple_tsk = kthread_run(simple_thread, NULL, "event-sample-fn");
-	return ret;
+	if (ret)
+		return ret;
+	simple_tsk = kthread_run(simple_thread, NULL, "event-sample-fn");
+	if (IS_ERR(simple_tsk)) {
+		unregister_ftrace_direct(&direct, my_tramp, true);
+		return PTR_ERR(simple_tsk);
+	}
+
+	return 0;
 }
 
 static void __exit ftrace_direct_multi_exit(void)
-- 
2.53.0



