Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F48935BDD4;
	Fri,  9 Jan 2026 12:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962408; cv=none; b=IHuNYGrgK16nOPZihseMTtcEh7uGx14k9IDWnPRE1Swdsqf6Q4lwqeokf+xCckuf4ZMUjvpXIqe3uAGE1sRcdUbj1rzPYQTkmlkeZfB1VS2xUnWXA14tCAQtUl6j7xym5h5a+pvZ61+X0uvtznRScBAc812twkdzsEMuRPS0P4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962408; c=relaxed/simple;
	bh=JtR3ZuKpDvzJ7zR7gu75hCMsV1F5JzGFQP/my5a9ZsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mlO9aKmYBsWKenwLpa7IXg7oMS7NZWQZ9DU7P6/rujvf3zyhgm7mwEh7JgYBFXg/vLQrvSfvJMAR38jLpl84svd5O7cA58IL1k9gxF8NlvzTNJK2f20PMotSxyuIMO4MJOcQIH5lP7sO4+9mFDNTw+LNI/nKYLnCWG23nw8dTQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j6q/lTSH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j6q/lTSH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4665C4CEF1;
	Fri,  9 Jan 2026 12:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962408;
	bh=JtR3ZuKpDvzJ7zR7gu75hCMsV1F5JzGFQP/my5a9ZsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j6q/lTSHXCzorWE3+ws2KXrO3msaXwb/ZKx5B/Uxc6fiDfNCzdhJDBGc+Kvy5/Bax
	 grMfDRQc0aR0uk+Z4+mricWItlk9ayQRf5v8oLNiRKtw9vrNoYuBjNQd/pIxzSyPeD
	 DLX4v4IKzFB4C1lQ9738Vau/bDS2SjlwIFFUtzJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 347/634] NFSD: use correct reservation type in nfsd4_scsi_fence_client
Date: Fri,  9 Jan 2026 12:40:25 +0100
Message-ID: <20260109112130.581683335@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


