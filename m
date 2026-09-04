Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C40C33FE09;
	Fri,  4 Sep 2026 05:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498729; cv=none; b=G942fSsPrK0JXAdvC2W4UavJBr1GKe0ltw0mIYx3e58DOG+mxbgujgqt5XI/sfoJ1LfMGO1GWttEe0ru20g1jbALRDxfV6YyFUBAO7c/dQHARigpyVqi0WPm+VaBsIMN5HFiHWulwhVRR8ll7UsvhrbhtM/lcLR6/6xKjkeqCVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498729; c=relaxed/simple;
	bh=Lawf82kGSqvTyatE7PQmmh/5XuL+6v7RUIZTkKeKI58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JWJPvGmFkTre6tBb/Oj3mOSawAwVgIS01CRqZbtuKk9SJo/QXX206Dx07A7TQXuErdLeoglq/VsWzbe5slCS9yY1wUr090yqbZC0iUBTHo0Af9BdryczvoL9iDBqJXd4m9AvbNqK21IgkeR0gFYptCWZ6XDKFhhqIrp5nzZhCsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WQq97HaN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WQq97HaN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94A771F00A3E;
	Fri,  4 Sep 2026 05:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498728;
	bh=uP3jTjchQvrBiJJd+g6CbH6/8nnxK4PD4/XVF74C+V0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WQq97HaNNW0+mM7vTcbSl96laBt/yJUXPqueIhhE1trdbLQMv6UroYsc3U3b4nhLV
	 +KcizWgCrH989KEGW8lVb+ZXDjJ6ZrCzvQ+xdPg5uWGC044C2H2I+bD1XaXcsn7Man
	 TjnwLhL/xWHhWqn6QBAcT9x1FnViva6/gmMrkvbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 7.2 164/713] nfsd: cap decoded POSIX ACL count to bound sort cost
Date: Fri,  4 Sep 2026 06:52:12 +0200
Message-ID: <20260904045807.499242482@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <clm@meta.com>

commit 4bc1108e876153a2dd6d874052b99182c3603135 upstream.

nfsd4_decode_posixacl() reads a u32 entry count off the wire and passes
it straight to posix_acl_alloc() and sort_pacl_range(). The latter is
an O(n^2) bubble sort, so a client-chosen count drives unbounded CPU in
the server's compound processing path.

    nfsd4_decode_posixacl()
      xdr_stream_decode_u32(&count)       /* uncapped u32 */
      posix_acl_alloc(count, GFP_KERNEL)
      sort_pacl_range(*acl, 0, count - 1) /* O(n^2) bubble sort */

The encoder side in the same file already rejects ACLs whose a_count
exceeds NFS_ACL_MAX_ENTRIES, but the decoder introduced in commit
5fc51dfc2eb1 ("NFSD: Add support for XDR decoding POSIX draft ACLs")
omitted the symmetric check.

Fix by rejecting a wire count greater than NFS_ACL_MAX_ENTRIES with
nfserr_inval, before any allocation, so the sort is bounded by
NFS_ACL_MAX_ENTRIES^2 comparisons.

While we're in here, also fix the nfserr_resource return if
posix_acl_alloc() fails. That's not a legal error code for v4.1+. Change
it to return nfserr_jukebox as that's more appropriate for memory
allocation failures.

Fixes: 5fc51dfc2eb1 ("NFSD: Add support for XDR decoding POSIX draft ACLs")
Cc: stable@vger.kernel.org
Assisted-by: kres:claude-opus-4-7
Reported-by: Chris Mason <clm@meta.com>
Signed-off-by: Chris Mason <clm@meta.com>
Link: https://patch.msgid.link/20260530-nfsd-fixes-v2-8-f27e8eb4d974@kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4xdr.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index e17488a911f7..09068ca61b00 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -449,9 +449,18 @@ nfsd4_decode_posixacl(struct nfsd4_compoundargs *argp, struct posix_acl **acl)
 	if (xdr_stream_decode_u32(argp->xdr, &count) < 0)
 		return nfserr_bad_xdr;
 
+	/*
+	 * The NFSv4 POSIX ACL draft doesn't define a max number of ACE's, but
+	 * the NFSACL spec does. For NFSv4, cap the number of entries to the v3
+	 * limit, as we want to ensure that ACLs set via NFSv4 POSIX ACL
+	 * extensions are retrievable via NFSACL.
+	 */
+	if (count > NFS_ACL_MAX_ENTRIES)
+		return nfserr_inval;
+
 	*acl = posix_acl_alloc(count, GFP_KERNEL);
 	if (*acl == NULL)
-		return nfserr_resource;
+		return nfserr_jukebox;
 
 	(*acl)->a_count = count;
 	for (ace = (*acl)->a_entries; ace < (*acl)->a_entries + count; ace++) {
-- 
2.55.0



