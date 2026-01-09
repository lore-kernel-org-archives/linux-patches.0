Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4200E359FB0;
	Fri,  9 Jan 2026 12:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960562; cv=none; b=D2SSt1R0bynPcG6d0p62m3p8KCtTamfcdpcm4Q0gh7Mo/6pYJyK96hVhm+MQ50WUM5DohJV/O/E5HwrCPgubNGhecnFSw6o6rpNwxKrS4yX1tlKJ3G9IygnQOiBEVu+/8+b27kWVxV0Ypu4Nz5uIJjQjLZJ1/n+RbBvPQAaK1Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960562; c=relaxed/simple;
	bh=REK7oh1iMZBEWCQbTOtNhRRm19m89KSB2fM5BKyROhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SYTFwb+orf8Ud5fdMU/iCF3RYUobTRz+3aq0Op4O9r+Jqa6pS1RhMqF2NrskwT8VdEiqKX68ZCzuhG8gGYUTDHwHxK36yKKXCwFHPKO/OfaTNniOglsUlKhjwNiKbD0GMtIee13DVZnXQFW/P9T9HGSCy5vOJ0SLJud7zMDKx0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0QvaOTWC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0QvaOTWC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7CACC4CEF1;
	Fri,  9 Jan 2026 12:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960562;
	bh=REK7oh1iMZBEWCQbTOtNhRRm19m89KSB2fM5BKyROhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0QvaOTWCd8UcvfOtlbfRnc1qnITGXdKQdp4i6HWnWowmO0qygJHCI8aeCsIdjGB+3
	 5f+0kw1QIUCjU+SOLoYv3WVFSyIt0uC6r9tVsMlZMBtV+/7WxjpfP9/5snj5NCAbiK
	 a1/FCEMAKgB5MDRlPDH3bAT8J/At3HvHf46hvqcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.6 447/737] NFSD: use correct reservation type in nfsd4_scsi_fence_client
Date: Fri,  9 Jan 2026 12:39:46 +0100
Message-ID: <20260109112150.811887877@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -334,7 +334,8 @@ nfsd4_scsi_fence_client(struct nfs4_layo
 	struct block_device *bdev = ls->ls_file->nf_file->f_path.mnt->mnt_sb->s_bdev;
 
 	bdev->bd_disk->fops->pr_ops->pr_preempt(bdev, NFSD_MDS_PR_KEY,
-			nfsd4_scsi_pr_key(clp), 0, true);
+			nfsd4_scsi_pr_key(clp),
+			PR_EXCLUSIVE_ACCESS_REG_ONLY, true);
 }
 
 const struct nfsd4_layout_ops scsi_layout_ops = {


