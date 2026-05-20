Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128473C6A5C;
	Wed, 20 May 2026 17:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297245; cv=none; b=BUanjPQ0zRFtw63d+AVYlcbMt6THr7HOiwkczcaE0bj86u6x2Ty+VtK4AOgRz0nHLUfyDzn47IUuiIOETZgh8XbjjUcJkkAUjpOp9QM5nfbZpvU6uJ/kllei3FS9pQOCX/fPypvRHJujzOSDX8peTo7a5zIFq/C7czqFhdQ+a7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297245; c=relaxed/simple;
	bh=OO5r/dUF++oaWjEym0HjQNWJoAXHKAhu5MaVpSQ38aI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HCYJeDKbdkMpAGnpqbuxCeUHA07KFLCE2GGCC1zSxO9/QGZXQ1kj7sDUm9/3F3AzooVWwS1Iy1INEfsV3geFtFtFbvz+6wLMxBnMj1GmcWIfDUiYQOF1imhz0cBjignrMybbUY0MU5cNipmYhzw6iK6R1aZad8vwsaMRCVXYbjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yQxopLj+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yQxopLj+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 782BB1F000E9;
	Wed, 20 May 2026 17:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297244;
	bh=YWtGSxs4nlLtoR8iMM1mPvlholdixoDe5g/5kBH8qH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yQxopLj+03DRdRlvZBgmpYtoe9266Xi1ALdvrWEEzujDfs+T6icMpGpbUC+VyX6J5
	 evcX2ABU2nqWwzWyJnPoegtcZMqOgH1RFUYWySCSoSrrGUvKG1/u4SMnttwiU8JbcL
	 nvencTwDI8MKci4u6UM7Ey5ouGg4sUX1msPS8bbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Scott Mayhew <smayhew@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 7.0 1106/1146] nfsd: fix file change detection in CB_GETATTR
Date: Wed, 20 May 2026 18:22:36 +0200
Message-ID: <20260520162213.275112920@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6368,7 +6368,6 @@ nfs4_open_delegation(struct svc_rqst *rq
 		}
 		open->op_delegate_type = deleg_ts ? OPEN_DELEGATE_WRITE_ATTRS_DELEG :
 						    OPEN_DELEGATE_WRITE;
-		dp->dl_cb_fattr.ncf_cur_fsize = stat.size;
 		dp->dl_cb_fattr.ncf_initial_cinfo = nfsd4_change_attribute(&stat);
 		dp->dl_atime = stat.atime;
 		dp->dl_ctime = stat.ctime;
@@ -9417,11 +9416,15 @@ nfsd4_deleg_getattr_conflict(struct svc_
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
 


