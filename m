Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184CC6EB72;
	Mon,  8 Apr 2024 13:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584419; cv=none; b=SqEbhRbF/8f7o3hng844mkGkckMM3f95Q1/OnTRCH8/6BPZ4d6pRsg5xB8rmbJXmnqwwXIPSJb+E8wQ7iC5DZYBWuGWsqm5S99pYAIVXgyfzWjy49UEivspZCLJ03X3hRoaQgakTwl0vT0KLlbvhOvF5K0qAR8Zc5quLbFMzqBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584419; c=relaxed/simple;
	bh=+Yo7IZBN+X3STyszytDXXF/aTbJawbxJ1u30A29Ip/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rQJzdBgEh0bgeyvDY5Jml59PrDvHozlV2IEF0WQh5NpgjCOhhtxypJhS8I/LjID0IeJDC5nK3MPzU0KvvmtOGLyz6TNY+WlJlNfgRQ3mRCETL1+DMRiKA7lD1FG+5UYVKyYA7tlduaGnpj0mAwXv0O+MGo5BVVYYSoehpsC1dPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s7MJyl/U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s7MJyl/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D4C7C433F1;
	Mon,  8 Apr 2024 13:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584418;
	bh=+Yo7IZBN+X3STyszytDXXF/aTbJawbxJ1u30A29Ip/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s7MJyl/UyNKU3r6o8BszNyA8DTiFq6Yiuslxk1xh1zn5Z7xLapRc+T99ihRRE/we+
	 kKb2PJMRbLDS7ifX9V1QHQp8yLAYsqHCNfTIfUukmUi6fzHDVFWEEL78gMBAG+eYZe
	 PvkOdYisjbnivwwp/JI8EllzT7kCJjx4CCsux7Fc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Mammedov <imammedo@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 5.15 432/690] NFSD: Make nfsd4_rename() wait before returning NFS4ERR_DELAY
Date: Mon,  8 Apr 2024 14:54:58 +0200
Message-ID: <20240408125415.255540385@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 68c522afd0b1936b48a03a4c8b81261e7597c62d ]

nfsd_rename() can kick off a CB_RECALL (via
vfs_rename() -> leases_conflict()) if a delegation is present.
Before returning NFS4ERR_DELAY, give the client holding that
delegation a chance to return it and then retry the nfsd_rename()
again, once.

This version of the patch handles renaming an existing file,
but does not deal with renaming onto an existing file. That
case will still always trigger an NFS4ERR_DELAY.

Link: https://bugzilla.linux-nfs.org/show_bug.cgi?id=354
Tested-by: Igor Mammedov <imammedo@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/vfs.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index e8329051dde01..4c5cc142562b2 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1698,7 +1698,15 @@ nfsd_rename(struct svc_rqst *rqstp, struct svc_fh *ffhp, char *fname, int flen,
 			.new_dir	= tdir,
 			.new_dentry	= ndentry,
 		};
-		host_err = vfs_rename(&rd);
+		int retries;
+
+		for (retries = 1;;) {
+			host_err = vfs_rename(&rd);
+			if (host_err != -EAGAIN || !retries--)
+				break;
+			if (!nfsd_wait_for_delegreturn(rqstp, d_inode(odentry)))
+				break;
+		}
 		if (!host_err) {
 			host_err = commit_metadata(tfhp);
 			if (!host_err)
-- 
2.43.0



