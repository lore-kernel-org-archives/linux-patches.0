Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8443D3D7D6C;
	Thu, 15 Jan 2026 17:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499912; cv=none; b=RFchG740CvzbxKnxXXI0Wb+XCu2ZMt7Z38xDWsTILgVLES6+fIa1/SmzJietXtstQ62a6s3+CIdEgmmQe/1/TOEatqR2KP32H5YWB+Dz7WrM0st+t7Xx2+Y8iIvUMo3oRjvXcWiT3r7gRv7O4cVvPouEyabKDFqZBKZDIMpLQlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499912; c=relaxed/simple;
	bh=eQl3TbBVJIYse2nrm/w5Fa5o7I2Ab3aZPSCQs6biKug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uIu+ujCN1J29lbMCanFEScfyERehpZnPFWqZJknP2wIhjY7sPIVL5WhWiOwGjjsr1ys/aoLWIe4L1tHSeM53+6kc3mvPNpsvlof/0q42PI5jQ6YSW1Z0lJ2d26+f2GX1XEwEmvhpDXU+OJriUy5nBa/f729MIW5OthfVSf1egj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zkVe5z2y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zkVe5z2y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C7EAC16AAE;
	Thu, 15 Jan 2026 17:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499912;
	bh=eQl3TbBVJIYse2nrm/w5Fa5o7I2Ab3aZPSCQs6biKug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zkVe5z2yk7ae1g/5/jgZPGZHxuRF8gehxEQ82q8xL1g3b7DeqKXagHLA9av5fd34O
	 oTELz0eyl+JisroStk04pYjJcgx85RAY+oj6rTJAUYN3577DARgeK5Y6J0Wo2PDhL4
	 msSbWaGmMD3VNdVXQIOEKnHgR9PPa99O3rwkTPgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurelien Couderc <aurelien.couderc2002@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 393/451] NFSD: NFSv4 file creation neglects setting ACL
Date: Thu, 15 Jan 2026 17:49:54 +0100
Message-ID: <20260115164245.151340252@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 913f7cf77bf14c13cfea70e89bcb6d0b22239562 ]

An NFSv4 client that sets an ACL with a named principal during file
creation retrieves the ACL afterwards, and finds that it is only a
default ACL (based on the mode bits) and not the ACL that was
requested during file creation. This violates RFC 8881 section
6.4.1.3: "the ACL attribute is set as given".

The issue occurs in nfsd_create_setattr(). On 6.1.y, the check to
determine whether nfsd_setattr() should be called is simply
"iap->ia_valid", which only accounts for iattr changes. When only
an ACL is present (and no iattr fields are set), nfsd_setattr() is
skipped and the POSIX ACL is never applied to the inode.

Subsequently, when the client retrieves the ACL, the server finds
no POSIX ACL on the inode and returns one generated from the file's
mode bits rather than returning the originally-specified ACL.

Reported-by: Aurelien Couderc <aurelien.couderc2002@gmail.com>
Fixes: c0cbe70742f4 ("NFSD: add posix ACLs to struct nfsd_attrs")
Cc: stable@vger.kernel.org
[ cel: Adjust nfsd_create_setattr() instead of nfsd_attrs_valid() ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/vfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1335,7 +1335,7 @@ nfsd_create_setattr(struct svc_rqst *rqs
 	 * Callers expect new file metadata to be committed even
 	 * if the attributes have not changed.
 	 */
-	if (iap->ia_valid)
+	if (iap->ia_valid || attrs->na_pacl || attrs->na_dpacl)
 		status = nfsd_setattr(rqstp, resfhp, attrs, 0, (time64_t)0);
 	else
 		status = nfserrno(commit_metadata(resfhp));


