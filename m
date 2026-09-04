Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB95730C366;
	Fri,  4 Sep 2026 06:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502060; cv=none; b=Ju6y1muQopqE7RfEBXqvrwbEcregImB75rqG78B6GC4FoO3uLJlPIPFHMzFlcr+waWZ7wQUgW6CA7h3BsljF2PBieM+/o1yzPlViIBeedJQGpJCDohKDbow2DrkUCvKUy3ecTGWzOwD4/53/KSdSdeHPvDppmH96e1O+jV1nZjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502060; c=relaxed/simple;
	bh=oWmUAVSeOABs6LG0lf3Ot++J/hraS1NH1L4rs7PDjOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FtqChTQ+EIEwmRpWz4HbQwN4bqmydfT3yfyB7sBFqxmz4SEbxdkuKNntutjoQByVfHDOHFLkD2SK/6WXi9ksVwEKq5F9Slz4NAUFvQiRI6WmY5ZvwyTNa4OPaJu8SdZ6CsSYTzfKuknTsgpHN1/QEanUOdWVKwrjLhrYNAgMARg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2sr2iDYc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2sr2iDYc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3142C1F00A3D;
	Fri,  4 Sep 2026 06:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502059;
	bh=Vovh0dojQ2akXkQsUX3HN7df55kKTEzR9Tb1EE7n71M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2sr2iDYcIVhGPLYdYB6lE6TfHLPUKVxaH48hYwCbMM8F+VtCeAsVS4ZrsbBXxX+AV
	 S0zw6EItqK/2pRCtq3kqHRKulpCW2wMlfkaLEgkVMEk1TeaPcf/8crHxPmseZ8TOMc
	 KcbY5XaLEqLoWi6pjMmXhxWQWnV5rzPh05e+CNN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 6.12 074/403] NFSv4.1: fix layout segment leak on the pnfs_layout_process() forget path
Date: Fri,  4 Sep 2026 06:57:57 +0200
Message-ID: <20260904045736.516234806@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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
@@ -2631,6 +2631,7 @@ out_forget:
 	spin_unlock(&ino->i_lock);
 	lseg->pls_layout = lo;
 	NFS_SERVER(ino)->pnfs_curr_ld->free_lseg(lseg);
+	pnfs_free_lseg_list(&free_me);
 	return ERR_PTR(-EAGAIN);
 }
 


