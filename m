Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CBAA267731;
	Tue,  8 Apr 2025 12:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115498; cv=none; b=d1pmFu9qU9gsnFSG8LyGGp1nu+4UUg2CnQzQe6EyqWZG4JveKlCpJChOT50h7UKzCtyuOY1tc14+oTwRv6XQLbAMmExBx6dSjKxiwm2Q7xZAndNDXyWjs25MtXqjFU1VsfV4ynVIn1C2xoC7M+adPCsi2SyvmVlk4jWK7xChs/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115498; c=relaxed/simple;
	bh=rzr8UrcuTziS+2hMLfSjXnH/PX0IK4U7w8vkQ+h9/jI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b7taSzyfAbiS0O446d3cGkMWVWq5d88LABBP+/ZdeTDhyob3Gt7vUg8G8D9OLgkrvAQkJMNY1Tia+6nK5GeKsY+dcz0s86ckO2vuMDSg2fZ4g5Z4Bpyrh50xK1hiotZnuwKi+HbnWWdtTc7fekOBn8mgEYO7yKKKTFDb6wr0T+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CRMu16UN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CRMu16UN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26BD5C4CEEA;
	Tue,  8 Apr 2025 12:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115498;
	bh=rzr8UrcuTziS+2hMLfSjXnH/PX0IK4U7w8vkQ+h9/jI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CRMu16UN2JpjpmuRYdaXlf7e/kBktXgqvBk2sea+Tc7X8ZQjw0zSzbZM/84NVz1gZ
	 3WBrzxXQ96vN11oA2t8RRmqYUPYFuIsXNvUKOKZEbbW8B0uvKTSFzhYuuzDJZ4uHJr
	 CBVQLobtIqqcL+rM/7mRmbGbFv4ORxjQqJ9BvLZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trondmy@hammerspace.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.13 496/499] NFSD: Never return NFS4ERR_FILE_OPEN when removing a directory
Date: Tue,  8 Apr 2025 12:51:48 +0200
Message-ID: <20250408104903.730390009@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit 370345b4bd184a49ac68d6591801e5e3605b355a upstream.

RFC 8881 Section 18.25.4 paragraph 5 tells us that the server
should return NFS4ERR_FILE_OPEN only if the target object is an
opened file. This suggests that returning this status when removing
a directory will confuse NFS clients.

This is a version-specific issue; nfsd_proc_remove/rmdir() and
nfsd3_proc_remove/rmdir() already return nfserr_access as
appropriate.

Unfortunately there is no quick way for nfsd4_remove() to determine
whether the target object is a file or not, so the check is done in
in nfsd_unlink() for now.

Reported-by: Trond Myklebust <trondmy@hammerspace.com>
Fixes: 466e16f0920f ("nfsd: check for EBUSY from vfs_rmdir/vfs_unink.")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/vfs.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1931,9 +1931,17 @@ out:
 	return err;
 }
 
-/*
- * Unlink a file or directory
- * N.B. After this call fhp needs an fh_put
+/**
+ * nfsd_unlink - remove a directory entry
+ * @rqstp: RPC transaction context
+ * @fhp: the file handle of the parent directory to be modified
+ * @type: enforced file type of the object to be removed
+ * @fname: the name of directory entry to be removed
+ * @flen: length of @fname in octets
+ *
+ * After this call fhp needs an fh_put.
+ *
+ * Returns a generic NFS status code in network byte-order.
  */
 __be32
 nfsd_unlink(struct svc_rqst *rqstp, struct svc_fh *fhp, int type,
@@ -2007,10 +2015,14 @@ out_drop_write:
 	fh_drop_write(fhp);
 out_nfserr:
 	if (host_err == -EBUSY) {
-		/* name is mounted-on. There is no perfect
-		 * error status.
+		/*
+		 * See RFC 8881 Section 18.25.4 para 4: NFSv4 REMOVE
+		 * wants a status unique to the object type.
 		 */
-		err = nfserr_file_open;
+		if (type != S_IFDIR)
+			err = nfserr_file_open;
+		else
+			err = nfserr_acces;
 	}
 out:
 	return err != nfs_ok ? err : nfserrno(host_err);


