Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3AA13A0E98;
	Thu, 15 Jan 2026 17:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498073; cv=none; b=eqk83e4jxUKMn+lal6cZi8CiPkZPkzp4P5D4wOjJBeof1NZALAtigcVixGYbfu0BR2QP28JnhanoZMYgxs3uNXS4fIEdeDCL4s7Y4eIranaPj+nOupWICvpdnvd3mr/gNShg4xUYMNWsaJ2NQn1dUVg/l89YncVwcR8IsHPljmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498073; c=relaxed/simple;
	bh=1hKc6Hw6WP7QrHIO8XHJRz8p3IJbIiXp3EyEP6LLnbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NpfETcmq5u0ZWuKYgA/HCkj/qC+x28ce7Jo3x+OkGgDwAn8eBD2E0clbRAef3QZEW703W8zpezgJELIRSFm8QPfugQ5FHvf3QgTfdyhuNMs9SEy4b3nrO3m/a9BHBIGDtx/8B15Hs9uRJ1cBMZJrGUxyE0XMPM+j/EzB5N+v1mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YB8pD7PC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YB8pD7PC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C7DDC116D0;
	Thu, 15 Jan 2026 17:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498072;
	bh=1hKc6Hw6WP7QrHIO8XHJRz8p3IJbIiXp3EyEP6LLnbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YB8pD7PC7EL3BvS4daF1aZniXY7GXVh6iY+lU6IhNFzc9D7ynLbMMubA62hq5GFlj
	 lBQioXqOnqB0BIUj6EXON3QUrlDDNSbLBpDYfU90iBpAcwovfydcUdb/5OXDRfCjzx
	 baljoKgMDfkoCr7xR70TWB8hK13s5ZZjkr5ZnbHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 303/554] NFSD: use correct reservation type in nfsd4_scsi_fence_client
Date: Thu, 15 Jan 2026 17:46:09 +0100
Message-ID: <20260115164257.199473892@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -410,7 +410,8 @@ nfsd4_scsi_fence_client(struct nfs4_layo
 	struct block_device *bdev = ls->ls_file->nf_file->f_path.mnt->mnt_sb->s_bdev;
 
 	bdev->bd_disk->fops->pr_ops->pr_preempt(bdev, NFSD_MDS_PR_KEY,
-			nfsd4_scsi_pr_key(clp), 0, true);
+			nfsd4_scsi_pr_key(clp),
+			PR_EXCLUSIVE_ACCESS_REG_ONLY, true);
 }
 
 const struct nfsd4_layout_ops scsi_layout_ops = {


