Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2893321C9;
	Mon, 29 Dec 2025 16:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025826; cv=none; b=Ey42WHUBXRxChNWmb6Q5GfJ7A9hyrttXOAGdwOA81iqPFiE/Me+cT6T7+HtIpyq8s6H0pFrpGQ7Z5qHlkl7i+xn97GNtigSnpeKSYVKXHvbyhEbXzwL7J+BActrzaeG4rUv3/gNIkjMU8Vagg7M3BvB7rupv9aCtkosqp36Exm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025826; c=relaxed/simple;
	bh=gB9Cd0bgR8E4VdFwZZd8unpJs51PrZyfQdEqYV0VAf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NR8flhacQpUxqxhWzwA3ZmFmQrUkucCBhkfUc7Zh9OmcDtwCmbr+rqxJc6hQvdIMiMCX6RvcRa/KbhfGm71k7mz4i5B7yvOYfyepiyW9/7528j3fwYDdnGW4Cqvn9b43av1QpDvzO09Y5Xe4efotjN6IP2FhVGCrAK9rsUpr4AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y4thpgYq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y4thpgYq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69FF7C4CEF7;
	Mon, 29 Dec 2025 16:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025825;
	bh=gB9Cd0bgR8E4VdFwZZd8unpJs51PrZyfQdEqYV0VAf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y4thpgYqBvndfAtafHVU9qDVKLzFQAHSxOCxqSreAW2rKjuJemMXMJafZyXj1ZqVq
	 bgl1O1ci2DOICGyUQviBi/7xW/b3yrvgpyLembI1dQv6qJ5iS7N2b1Aeest1rgjTWM
	 7HTHPmmbHnO4tZg0nnb43t/DNjr51h5f4WsckdEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.18 308/430] NFSD: use correct reservation type in nfsd4_scsi_fence_client
Date: Mon, 29 Dec 2025 17:11:50 +0100
Message-ID: <20251229160735.668385862@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Dai Ngo <dai.ngo@oracle.com>

commit 6f52063db9aabdaabea929b1e998af98c2e8d917 upstream.

The reservation type argument for the pr_preempt call should match the
one used in nfsd4_block_get_device_info_scsi.

Fixes: f99d4fbdae67 ("nfsd: add SCSI layout support")
Cc: stable@vger.kernel.org
Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/blocklayout.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/nfsd/blocklayout.c
+++ b/fs/nfsd/blocklayout.c
@@ -344,7 +344,8 @@ nfsd4_scsi_fence_client(struct nfs4_layo
 	struct block_device *bdev = file->nf_file->f_path.mnt->mnt_sb->s_bdev;
 
 	bdev->bd_disk->fops->pr_ops->pr_preempt(bdev, NFSD_MDS_PR_KEY,
-			nfsd4_scsi_pr_key(clp), 0, true);
+			nfsd4_scsi_pr_key(clp),
+			PR_EXCLUSIVE_ACCESS_REG_ONLY, true);
 }
 
 const struct nfsd4_layout_ops scsi_layout_ops = {


