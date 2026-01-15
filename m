Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CCF62C237E;
	Thu, 15 Jan 2026 17:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496425; cv=none; b=pawzYhiROFmt9vac6bNYQOL1gQKLuHmxd/EcNrvk9P1pAX05beqQb6LmYLljzEPoevoQsQFuo4E1o3OFL691zC4BH2spU7JdPGl6OWl3l6/HcxRLMFVJlQuhKquy5nnYFtID345OaJBNpqSnlH85FECr+snmkOFm4ZNIX9dfJ/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496425; c=relaxed/simple;
	bh=QiFwwFK56VhQQeDFulXzS7hiwwlLXtTwbNT9vNMJLoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dIY0qRCe3MrJY1mbsflZKoJoXpRvBXszS3Mb1B4SYZTmOBCHoFHmx84pcukz9rh/DBib9PS0sWO/5FgLZcnWO95lMWQipCy1vB0pmdUq1VxHqDcN1vLBUaOIG9MZeEfq4cyQF95Q/m0jIZB6m8GBh2HcbSw3xmMilaVkmtikB+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CKOrk3hX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CKOrk3hX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEEBDC16AAE;
	Thu, 15 Jan 2026 17:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496425;
	bh=QiFwwFK56VhQQeDFulXzS7hiwwlLXtTwbNT9vNMJLoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CKOrk3hXmueqqDsGNGxYNkXEIesBVahlIWLEdZzb8t0Hj0gLWupk/92s1NYCLhMwE
	 P2KYhyaYu+k80s/IbawB2jsa6ZH3GDl/kkbye5HVA4CzyDK5uy6TrwO+xywyI6eI8S
	 6bDikmqGBkIsxhH52DfyinN4hUgqvQ9yM/zngQq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Scott Mayhew <smayhew@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 001/119] NFSD: Fix permission check for read access to executable-only files
Date: Thu, 15 Jan 2026 17:46:56 +0100
Message-ID: <20260115164152.007488721@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

From: Scott Mayhew <smayhew@redhat.com>

commit e901c7fce59e72d9f3c92733c379849c4034ac50 upstream.

Commit abc02e5602f7 ("NFSD: Support write delegations in LAYOUTGET")
added NFSD_MAY_OWNER_OVERRIDE to the access flags passed from
nfsd4_layoutget() to fh_verify().  This causes LAYOUTGET to fail for
executable-only files, and causes xfstests generic/126 to fail on
pNFS SCSI.

To allow read access to executable-only files, what we really want is:
1. The "permissions" portion of the access flags (the lower 6 bits)
   must be exactly NFSD_MAY_READ
2. The "hints" portion of the access flags (the upper 26 bits) can
   contain any combination of NFSD_MAY_OWNER_OVERRIDE and
   NFSD_MAY_READ_IF_EXEC

Fixes: abc02e5602f7 ("NFSD: Support write delegations in LAYOUTGET")
Cc: stable@vger.kernel.org # v6.6+
Signed-off-by: Scott Mayhew <smayhew@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: NeilBrown <neil@brown.name>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/vfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -2568,8 +2568,8 @@ nfsd_permission(struct svc_cred *cred, s
 
 	/* Allow read access to binaries even when mode 111 */
 	if (err == -EACCES && S_ISREG(inode->i_mode) &&
-	     (acc == (NFSD_MAY_READ | NFSD_MAY_OWNER_OVERRIDE) ||
-	      acc == (NFSD_MAY_READ | NFSD_MAY_READ_IF_EXEC)))
+	     (((acc & NFSD_MAY_MASK) == NFSD_MAY_READ) &&
+	      (acc & (NFSD_MAY_OWNER_OVERRIDE | NFSD_MAY_READ_IF_EXEC))))
 		err = inode_permission(&nop_mnt_idmap, inode, MAY_EXEC);
 
 	return err? nfserrno(err) : 0;


