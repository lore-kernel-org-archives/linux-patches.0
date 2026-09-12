Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC74278161;
	Sat, 12 Sep 2026 15:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226761; cv=none; b=jXTBP5s8yQLwGoY0/oMHi1wE9/qZp4Se47XafRw51jOtZf8Cbw4M7JadvfFukzbssTwGYV7TLinwZYRA5AU1mD9zBOmN6kdP71o46t2lialCyaP6w9kFg96cu9s+SV/5URbDYuDtlA4DS0TxWzsfbyXgAhpEjDnomhWd48oDzCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226761; c=relaxed/simple;
	bh=VDDOxD4O28ORWJAIpI3BZj0u+opchx1Fu3eYkX2EwtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OxzNeBaaG3876jUkmB8qRSMnaoL6DBvnshGyjQdY3ue9+yPdckehunoISStPlXZ1v2zBdgilkKICV84MY75XpoPhZivpiR/jiqFP7WjIdMm9fea7zZyAJJxWOLaRKSunhpDfwMKCcpECWpfUZhLkBd3R9FN8/GEOUH8fkDrChW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jbl//fW6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jbl//fW6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8C691F000FF;
	Sat, 12 Sep 2026 15:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226759;
	bh=B5mp7FX1jawsXxNr4rJPUOIHhtxnsvNwYmSfHnlEe8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jbl//fW6ZT2xQMPYVLTf4IIq3B1EV0krS0oVg3VfGjqzgbzmLdInHhFBi+i3XPg4D
	 Vc8rYoL86Sr0zyWQALadb9bxMNl4KwISMcjwykbROEVMUuu39U/TSQn7j7m57y8RUZ
	 zAaTryTMsvMBSxnsNweMzSCzBS7lNu4gZwv+yBlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 6.1 0042/1191] NFSv4.1: fix layout segment leak on the pnfs_layout_process() forget path
Date: Sat, 12 Sep 2026 08:46:10 +0200
Message-ID: <20260912065549.083416403@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junrui Luo <moonafterrain@outlook.com>

commit ee5a386cfe60f3f8286de16a9db8e1a08f0bc124 upstream.

When the server returns a new layout stateid while a valid one is still
held, pnfs_layout_process() calls pnfs_mark_matching_lsegs_return() on
the on-stack free_me list and jumps to out_forget. Segments whose
reference count drops to zero are unlinked from lo->plh_segs and moved
to free_me by mark_lseg_invalid(); for an idle cached segment the layout
header holds the only reference, so this happens on the first decrement.

out_forget never drains free_me -- only the success path calls
pnfs_free_lseg_list().

Commit 814b84971388 ("pNFS/NFSv4: Fix a layout segment leak in
pnfs_layout_process()") added the drain; commit 08bd8dbe8882
("pNFS/NFSv4: Try to return invalid layout in pnfs_layout_process()")
removed it while switching the destination to lo->plh_return_segs, which
is drained elsewhere. Commit fb700ef02676 ("NFSv4.1: Simplify layout
return in pnfs_layout_process()") switched the destination back to
free_me without restoring the drain.

Restore the pnfs_free_lseg_list() call.

Fixes: fb700ef02676 ("NFSv4.1: Simplify layout return in pnfs_layout_process()")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/pnfs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -2482,6 +2482,7 @@ out_forget:
 	spin_unlock(&ino->i_lock);
 	lseg->pls_layout = lo;
 	NFS_SERVER(ino)->pnfs_curr_ld->free_lseg(lseg);
+	pnfs_free_lseg_list(&free_me);
 	return ERR_PTR(-EAGAIN);
 }
 


