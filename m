Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04693FC5B0;
	Wed, 20 May 2026 17:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299902; cv=none; b=ng+q4w7w0RtGKuFf2zcRmgs7vSXRsVy4EuiAmrCQJUJTj5IuMET6AyqZ9W4Zlv9JwvqcDOsRHNioDd9A4YdC49hBHgWWuf/snXOh3RaVRBdtJ+vSI+iLq7/uI58Nsjxedjsvu+XMOscQz461tXJU+w4Lxb9X+OFXJx10U37aqR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299902; c=relaxed/simple;
	bh=IFtHrhnCvC79CLalt2KI0EsD745hdapG8/ZNTMFUy8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FPMHYoea+5fEFWGB3GOlKzJQB9lPHaW/7h6PNIogL1Gmz7y9HdpO3GLkwT7zAcY6w+TeLsB0Za+JYfU8ktFM4UC2lPnwzY0l5372kVSYv78NS7Dw8o2BnDM7CczeT/GQ4wks7HuUncFZdBluUDpWazYcU9ZK+cVv4olqz+Z+sFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hjROmw87; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hjROmw87"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FE481F00893;
	Wed, 20 May 2026 17:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299899;
	bh=7hH5K8HniR7i4OotLo2HQ8vPsSDKSvshnYVupYQf+ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hjROmw8784CYQcCjSfgVwOaBbapOBcaFltCRcrHfzBNyeNkz+yA7Pddo1qa9wVmDs
	 BYtdhknYxsiRK7VLIcf7KxhrTfj12ZY8sZabl27tctAzp9NwG2+UiAuCjqW1IOGvGR
	 nEzVE6cHahSCcZFBpjt79/n72A46jN+ouTduD29E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Scott Mayhew <smayhew@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.18 927/957] nfsd: fix file change detection in CB_GETATTR
Date: Wed, 20 May 2026 18:23:30 +0200
Message-ID: <20260520162154.689865718@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Scott Mayhew <smayhew@redhat.com>

commit 304d81a2fbf2b454def4debcb38ea173911b72cd upstream.

RFC 8881, section 10.4.3 doesn't say anything about caching the file
size in the delegation record, nor does it say anything about comparing
a cached file size with the size reported by the client in the
CB_GETATTR reply for the purpose of determining if the client holds
modified data for the file.

What section 10.4.3 of RFC 8881 does say is that the server should
compare the *current* file size with the size reported by the client
holding the delegation in the CB_GETATTR reply, and if they differ to
treat it as a modification regardless of the change attribute retrieved
via the CB_GETATTR.

Doing otherwise would cause the server to believe the client holding the
delegation has a modified version of the file, even if the client
flushed the modifications to the server prior to the CB_GETATTR.  This
would have the added side effect of subsequent CB_GETATTRs causing
updates to the mtime, ctime, and change attribute even if the client
holding the delegation makes no further updates to the file.

Modify nfsd4_deleg_getattr_conflict() to obtain the current file size
via i_size_read().  Retain the ncf_cur_fsize field, since it's a
convenient way to return the file size back to nfsd4_encode_fattr4(),
but don't use it for the purpose of detecting file changes.  Remove the
unnecessary initialization of ncf_cur_fsize in nfs4_open_delegation().

Also, if we recall the delegation (because the client didn't respond to
the CB_GETATTR), then skip the logic that checks the nfs4_cb_fattr
fields.

Fixes: c5967721e106 ("NFSD: handle GETATTR conflict with write delegation")
Cc: stable@vger.kernel.org
Signed-off-by: Scott Mayhew <smayhew@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6350,7 +6350,6 @@ nfs4_open_delegation(struct svc_rqst *rq
 		}
 		open->op_delegate_type = deleg_ts ? OPEN_DELEGATE_WRITE_ATTRS_DELEG :
 						    OPEN_DELEGATE_WRITE;
-		dp->dl_cb_fattr.ncf_cur_fsize = stat.size;
 		dp->dl_cb_fattr.ncf_initial_cinfo = nfsd4_change_attribute(&stat);
 		dp->dl_atime = stat.atime;
 		dp->dl_ctime = stat.ctime;
@@ -9396,11 +9395,15 @@ nfsd4_deleg_getattr_conflict(struct svc_
 		if (status != nfserr_jukebox ||
 		    !nfsd_wait_for_delegreturn(rqstp, inode))
 			goto out_status;
+		status = nfs_ok;
+		goto out_status;
+	}
+	if (!ncf->ncf_file_modified) {
+		if (ncf->ncf_initial_cinfo != ncf->ncf_cb_change)
+			ncf->ncf_file_modified = true;
+		else if (i_size_read(inode) != ncf->ncf_cb_fsize)
+			ncf->ncf_file_modified = true;
 	}
-	if (!ncf->ncf_file_modified &&
-	    (ncf->ncf_initial_cinfo != ncf->ncf_cb_change ||
-	     ncf->ncf_cur_fsize != ncf->ncf_cb_fsize))
-		ncf->ncf_file_modified = true;
 	if (ncf->ncf_file_modified) {
 		int err;
 


