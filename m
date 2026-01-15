Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3083BFE36;
	Thu, 15 Jan 2026 17:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499223; cv=none; b=GxEkyG1OWcCAYvsZGJsJvCb0H/wmf4b8/bmBAcSi4cHBiQ141dEfUFUngC83UoVZ7OKv59a30M0cE9ZDmOy57RCjgzJRywcJvCVfYc86MKzT+WHlMmUzulqpQxfYGdIiTDgeqLf6E/MGZAG4MZM5D964MbA6m/WJjR8Nj+A30OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499223; c=relaxed/simple;
	bh=G8BibseTnFMY+dlqcSBEYMD5BDx7wMyzndxu5yh5w8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yzt8uM+KSdUPCjluOhCvZ0vOCjZbMeLkSJ569lfGmTmWHFjoKMo/HwqsgYItZKjdDL85919Rq/4pId1Ura3/lGjYZ7jaH1g9xyBL0jHey1mth+3E4y90//uhMJVLmXo9NKH27H5gxdp9UsgkjZdY8/1VhumIl+B6IOUUwkVOdmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tbLdLJGE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tbLdLJGE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A40C16AAE;
	Thu, 15 Jan 2026 17:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499223;
	bh=G8BibseTnFMY+dlqcSBEYMD5BDx7wMyzndxu5yh5w8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tbLdLJGEeDo9ibYAd8f0+d1WgBt+D8f8micjl9D8Usd9/YI7GfqdsNrqkvwSYKz/V
	 YhTLAlSDC5sLEtrO0BLJe7SSSArUJlk2p+HgUPMOge0uVz/Mv4ALuhkaQMGa3fFBrL
	 1jL9c72BJLBxX0qyMSBC0bpzUoVXKcIncgAUR2y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sun Ke <sunke32@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.10 151/451] NFS: Fix missing unlock in nfs_unlink()
Date: Thu, 15 Jan 2026 17:45:52 +0100
Message-ID: <20260115164236.376971427@linuxfoundation.org>
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

From: Sun Ke <sunke32@huawei.com>

commit 2067231a9e2cbbcae0a4aca6ac36ff2dd6a7b701 upstream.

Add the missing unlock before goto.

Fixes: 3c59366c207e ("NFS: don't unhash dentry during unlink/rename")
Signed-off-by: Sun Ke <sunke32@huawei.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/dir.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -2109,8 +2109,10 @@ int nfs_unlink(struct inode *dir, struct
 	 */
 	error = -ETXTBSY;
 	if (WARN_ON(dentry->d_flags & DCACHE_NFSFS_RENAMED) ||
-	    WARN_ON(dentry->d_fsdata == NFS_FSDATA_BLOCKED))
+	    WARN_ON(dentry->d_fsdata == NFS_FSDATA_BLOCKED)) {
+		spin_unlock(&dentry->d_lock);
 		goto out;
+	}
 	if (dentry->d_fsdata)
 		/* old devname */
 		kfree(dentry->d_fsdata);


