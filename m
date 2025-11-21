Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A6034CFA6;
	Fri, 21 Nov 2025 13:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732085; cv=none; b=QqCKzf4TieYA2fARomnuK7bdhv4u/oW92vgD6YfDR3nGR00BvsC92o/rQokak68H10fI2GcNCmX0WPzD5Szs49E6TEr+Odxc3JPxVA+NbaJW6itJ1ZZWgEbmGNPCvnUvFMwdO5lxMuM/lI7ltCKf96dp0086vcRLPo+ifRKrWZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732085; c=relaxed/simple;
	bh=OT3nXtPWLo3XgU1AGSbHwgDL1iGdNQutNBJ5+RL63Bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P8ljO+XbOKpC8e5gGa5w00if75sLNKn2t+rlt3Lc7zvzCpl7odAZXwzCAEEClvWDwoLlVi3FiyF4CYxx/NDUMB+HXqPshTLUy41BVTADHCNhopBVq5oPNvJMW7Nk/2CZP0m72xYCtbYHuPrhD1CXUCFijw0ppupIIycdUtgtpf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qar+cTLP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qar+cTLP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1395FC4CEF1;
	Fri, 21 Nov 2025 13:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732085;
	bh=OT3nXtPWLo3XgU1AGSbHwgDL1iGdNQutNBJ5+RL63Bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qar+cTLP4xCk72+JthqaH+LTyDfR8nY2JCpk6NcCtsmy5bNoJ0QlhAvTnTYsUzjsn
	 dJZ6h0f7wdyI1Uzq8SHlRSNRY7bTmPmSv6bZRr3+tm/S36Qb8eFwN3P+U6zV0R7xri
	 Qq9HEaqxZvHBDWE8jdmANd7sLjLmFzR0SPvPv6lI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jialin Wang <wjl.linux@gmail.com>,
	Penglei Jiang <superman.xpt@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 184/185] proc: proc_maps_open allow proc_mem_open to return NULL
Date: Fri, 21 Nov 2025 14:13:31 +0100
Message-ID: <20251121130150.531817962@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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


