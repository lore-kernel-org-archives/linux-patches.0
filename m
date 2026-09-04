Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF924415B85;
	Fri,  4 Sep 2026 05:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498684; cv=none; b=nrvVf63dovez1W9ZcmMCETzwTfjhzFWoIhUS6upWy0SU2ReK3uefCnMHX/bH8b02MsmF6ccnsjPLLJnv8Zr7s7T4ki7r2W1ghqOrWwD2dtmADRNoEwAT1+L60jLJ/kvkmB3fGLmkiBay37V81d312PYf3FEV47BO+HZYdc/1zKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498684; c=relaxed/simple;
	bh=7WBvy/lNtq9hvZLAPjtdaS/sqAJiH4zy4rbY4QYiGd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=antu0O9juTDUo4kfe9h3nOJS7yq549fjy03AqAweOcKKFrAmYQVrQpXqFOlrKRA9vhw3V6KPZ0ac7tNkuOxuHkdE3pHn3hGAHuCIr5HKsvh8hUTq7Bqs0ZipwvENX8ePkgIIrZgKc4IJv/yNQX9SM2lbrNVwm70eHbqgfSwST2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WWb1Ptxt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WWb1Ptxt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD1A61F00A3D;
	Fri,  4 Sep 2026 05:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498683;
	bh=VyJbH0smbffrbM2wxveu5ho61g85p54qGKo7ROQNb3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WWb1PtxtzVV7LKRbkiUpysCkPPHRjcjHRFfchXH0dV7o5I7V8fuWGgQzGse3XgN4l
	 FZoPiPCas/Bta/ppYUWuoN2WtN8bM0RIpKdt3hGJ5Ro+kUQSzsAqhcNgY3XkVfthCb
	 6vIvNImJX24R1KRWT0iRWA4bsGSHj/t3i4+IWEVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 7.2 150/713] nfsd: Reset write verifier when async COPY writeback fails
Date: Fri,  4 Sep 2026 06:51:58 +0200
Message-ID: <20260904045807.189870616@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

commit f5cb2276954cb80987a93ef9f9dfbfdbfc0f10b9 upstream.

Async COPY captures nn->writeverf at request time and reports it to
the client via CB_OFFLOAD after the worker kthread completes. When
the post-copy vfs_fsync_range() or filemap_check_wb_err() in
_nfsd_copy_file_range() reports an error, the worker correctly
leaves NFSD4_COPY_F_COMMITTED clear so that CB_OFFLOAD encodes
wr_stable_how as NFS_UNSTABLE, but the server's write verifier is
not rotated.

A client that receives NFS_UNSTABLE in CB_OFFLOAD follows up with
COMMIT to make the copied data durable. With the verifier
unchanged, COMMIT returns the same value the client just received
via CB_OFFLOAD, and the client concludes the copy is durable --
silently dropping the data whose writeback in fact failed. This
violates the UNSTABLE+COMMIT durability contract (RFC 7862 section
15.1, RFC 8881 section 18.32) and matches the bug just fixed in
nfsd_vfs_write() and nfsd_commit().

Rotate nn->writeverf at the writeback-failure site. The async COPY
worker has no svc_rqst, so commit_reset_write_verifier() is not
available here; calling nfsd_reset_write_verifier() directly
mirrors the trace-less reset already used by
nfsd_file_check_write_error() for the same purpose. Filter out
-EAGAIN and -ESTALE, matching commit_reset_write_verifier(), since
neither indicates a durable-storage failure.

Fixes: eac0b17a77fb ("NFSD add vfs_fsync after async copy is done")
Cc: stable@vger.kernel.org
Assisted-by: kres:claude-opus-4-7
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260522203723.446841-1-cel@kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4proc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1972,6 +1972,8 @@ static ssize_t _nfsd_copy_file_range(str
 			status = filemap_check_wb_err(dst->f_mapping, since);
 		if (!status)
 			set_bit(NFSD4_COPY_F_COMMITTED, &copy->cp_flags);
+		else if (status != -EAGAIN && status != -ESTALE)
+			nfsd_reset_write_verifier(copy->cp_nn);
 	}
 	return bytes_copied;
 }


