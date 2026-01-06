Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5C4376BD3;
	Tue,  6 Jan 2026 17:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722395; cv=none; b=O+wzrSOnlNuFn59L+c4T0rqjlLp1RG7Nl5MVxn81BujMj6YLBKjCUUymRGVYILv2nExSj7nwr3yppEZId0Mv2qpg4ragESy/mdYSNLC9Y7UawW5PkGfGx7uCVLLgzmvMNza5PGp3odw8AygPAqBAHtDOXytGw906x/j+Rxoa3jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722395; c=relaxed/simple;
	bh=724lZXmaHDp0+o68yJu+33hnDFFg7smiD1rxxX0rCyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l+NH+oi4ZLv+mgwONFLUX/8vSx+dtYXCNW9uv6pPOtjdhOYTQnjtghrBEM6Yg8YZhJrnG8utziNUvF38L4hHgUeNTSSa4GO6LSC1XNsZO3eXnns1p3jwv5IfuJOQMVBnqoupvyR8e1GqUer7fgaPivBUSOOcnYJouXcy5hRH1gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Au1BlfSI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Au1BlfSI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB03C19423;
	Tue,  6 Jan 2026 17:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722395;
	bh=724lZXmaHDp0+o68yJu+33hnDFFg7smiD1rxxX0rCyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Au1BlfSI3nGPYukQ46Uf92dFXpo+H4aSchSYyy633Baz/nwdjyBzLqwOv5fweh3CP
	 Q3rrLtApTAafKgEml2NXM5jx+zDPStAuNsDtcyMwC5QkhWyXqsm4FBvY8YvN0dHHRv
	 /yv2tjscmP9aYdszkR1Vzi2s31CkxXGkBCkdk0gY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.18 251/312] nfsd: fix nfsd_file reference leak in nfsd4_add_rdaccess_to_wrdeleg()
Date: Tue,  6 Jan 2026 18:05:25 +0100
Message-ID: <20260106170556.929269283@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

commit 8072e34e1387d03102b788677d491e2bcceef6f5 upstream.

nfsd4_add_rdaccess_to_wrdeleg() unconditionally overwrites
fp->fi_fds[O_RDONLY] with a newly acquired nfsd_file. However, if
the client already has a SHARE_ACCESS_READ open from a previous OPEN
operation, this action overwrites the existing pointer without
releasing its reference, orphaning the previous reference.

Additionally, the function originally stored the same nfsd_file
pointer in both fp->fi_fds[O_RDONLY] and fp->fi_rdeleg_file with
only a single reference. When put_deleg_file() runs, it clears
fi_rdeleg_file and calls nfs4_file_put_access() to release the file.

However, nfs4_file_put_access() only releases fi_fds[O_RDONLY] when
the fi_access[O_RDONLY] counter drops to zero. If another READ open
exists on the file, the counter remains elevated and the nfsd_file
reference from the delegation is never released. This potentially
causes open conflicts on that file.

Then, on server shutdown, these leaks cause __nfsd_file_cache_purge()
to encounter files with an elevated reference count that cannot be
cleaned up, ultimately triggering a BUG() in kmem_cache_destroy()
because there are still nfsd_file objects allocated in that cache.

Fixes: e7a8ebc305f2 ("NFSD: Offer write delegation for OPEN with OPEN4_SHARE_ACCESS_WRITE")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1218,8 +1218,10 @@ static void put_deleg_file(struct nfs4_f
 
 	if (nf)
 		nfsd_file_put(nf);
-	if (rnf)
+	if (rnf) {
+		nfsd_file_put(rnf);
 		nfs4_file_put_access(fp, NFS4_SHARE_ACCESS_READ);
+	}
 }
 
 static void nfsd4_finalize_deleg_timestamps(struct nfs4_delegation *dp, struct file *f)
@@ -6253,10 +6255,14 @@ nfsd4_add_rdaccess_to_wrdeleg(struct svc
 		fp = stp->st_stid.sc_file;
 		spin_lock(&fp->fi_lock);
 		__nfs4_file_get_access(fp, NFS4_SHARE_ACCESS_READ);
-		fp = stp->st_stid.sc_file;
-		fp->fi_fds[O_RDONLY] = nf;
-		fp->fi_rdeleg_file = nf;
+		if (!fp->fi_fds[O_RDONLY]) {
+			fp->fi_fds[O_RDONLY] = nf;
+			nf = NULL;
+		}
+		fp->fi_rdeleg_file = nfsd_file_get(fp->fi_fds[O_RDONLY]);
 		spin_unlock(&fp->fi_lock);
+		if (nf)
+			nfsd_file_put(nf);
 	}
 	return true;
 }


