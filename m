Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B4D318146;
	Tue, 26 Aug 2025 11:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207354; cv=none; b=XuonFycZsBRHBC9GJil8FVq2xhs2ANaxXx+9VAu8KyFXq40g33We8PW9lE2exrF5+43846Ea/xTNf1uQApxyl5NsWXZ5KkjjZ2TP/Ki+k+QA/h6ft4BYAZCWegH7yJdl+aBmn7v/xYpcTXBnvQF68iL6gDqC8JLFQYW+S8XVBA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207354; c=relaxed/simple;
	bh=wE/GsqGrTsNH2STFZNGiwor1PXVfFWj302nPfpmg3sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aEJAo5DlhNvL6P/R5+777ePyhbZ9QfKDx9f23kz9euBYvWX07/cG5fENhjG0Bz+sb7P7iv0MvGkEnvNj8mvhtY5utuDGXqNc8kYHKx9O+cSH+MgWZjquGXO32kl27N5ZuR73ZK5+XqsDJVwzfMB18Idog0MjkWbORH5BqthM9SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f5laHqTK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f5laHqTK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFBE1C4CEF1;
	Tue, 26 Aug 2025 11:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207354;
	bh=wE/GsqGrTsNH2STFZNGiwor1PXVfFWj302nPfpmg3sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f5laHqTKdpdVtbaEV8EwmQuV7BCXtY+wTcLcRyW8JvKr5VWA0lqH7Ig09dMuRbAtN
	 85lP2IbLhe4mGQhdLRaAi95RZ6cOcvKJ58PN+66KjJVpm4YcaLVg9ml+T2iyMfjEeR
	 D2cCfb8cX5b5wS/y2ZeXX6fX5iwhl75Lcms1o/Xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jialin Wang <wjl.linux@gmail.com>,
	Penglei Jiang <superman.xpt@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.16 119/457] proc: proc_maps_open allow proc_mem_open to return NULL
Date: Tue, 26 Aug 2025 13:06:43 +0200
Message-ID: <20250826110940.317125610@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jialin Wang <wjl.linux@gmail.com>

commit c0e1b774f68bdbea1618e356e30672c7f1e32509 upstream.

The commit 65c66047259f ("proc: fix the issue of proc_mem_open returning
NULL") caused proc_maps_open() to return -ESRCH when proc_mem_open()
returns NULL.  This breaks legitimate /proc/<pid>/maps access for kernel
threads since kernel threads have NULL mm_struct.

The regression causes perf to fail and exit when profiling a kernel
thread:

  # perf record -v -g -p $(pgrep kswapd0)
  ...
  couldn't open /proc/65/task/65/maps

This patch partially reverts the commit to fix it.

Link: https://lkml.kernel.org/r/20250807165455.73656-1-wjl.linux@gmail.com
Fixes: 65c66047259f ("proc: fix the issue of proc_mem_open returning NULL")
Signed-off-by: Jialin Wang <wjl.linux@gmail.com>
Cc: Penglei Jiang <superman.xpt@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/task_mmu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -212,8 +212,8 @@ static int proc_maps_open(struct inode *
 
 	priv->inode = inode;
 	priv->mm = proc_mem_open(inode, PTRACE_MODE_READ);
-	if (IS_ERR_OR_NULL(priv->mm)) {
-		int err = priv->mm ? PTR_ERR(priv->mm) : -ESRCH;
+	if (IS_ERR(priv->mm)) {
+		int err = PTR_ERR(priv->mm);
 
 		seq_release_private(inode, file);
 		return err;


