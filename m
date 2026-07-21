Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC7546D0AB;
	Tue, 21 Jul 2026 17:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655410; cv=none; b=BCezkOIBjRRgXOb9dvJZQ3B7muTLvgfQCRTvZ7MlhCFszh2GBd5f8Pmz68UXyoTQieUZsoqEhQxSBfyJ5AGLn1QkmZlE99h3EM80sCFc5y5Yq6SkYYtSkdx0xc3Dv95agRO4P2JBoIdt1J/EpOvnd0XLTxqnEuFZIJG/k1znGBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655410; c=relaxed/simple;
	bh=fx9q95PMrgHYDQsrSHkQ1To4WqxWpROKkkYUIVCFPhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tfhujdn1rshVT4tHWzqFOBRbKOunOz4S+yrgMp2/YfKUDPCb8OwiXzLGVVXqoPefiowcxuY0mdG8R9R8BUZDM/5wFdNuJhs5y0dm33JyWSxF4+i2XfSzaknZgmHEzPKp7iTkKKhbpde8Yd7eLxs9Jfwvi/TWvkyWb2NUwR7+tcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NfFFI6iw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NfFFI6iw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F961F000E9;
	Tue, 21 Jul 2026 17:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655409;
	bh=xuLpZ5cVDqF7GG1tsOjDneWB+/rq56RJI9ZTFD0lBpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NfFFI6iwNpES0/hQbfpZpdtLu47DZOQlXhWmUlAZLwatulf6pyb0hUiZB1nqV5Mcz
	 cUAqZnH3CIaANQWFbVboczIydiSSc/vKIWLnIl8JAKYxAEx3U25Lsn7d3llX1vM+6P
	 zmeteww3448RSaM/OL+ebQR/EWQcVvEnTNCXEcYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 2071/2077] exfat: add balloc parameter to exfat_map_cluster() for iomap support
Date: Tue, 21 Jul 2026 17:29:04 +0200
Message-ID: <20260721152641.550838135@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 3474416bb9abafca2e79b7ff700a100b7e8bc766 ]

In preparation for supporting the iomap infrastructure, we need to know
whether a new cluster was allocated or not in exfat_map_cluster().

Add an optional 'bool *balloc' output parameter. When a new cluster is
allocated, *balloc is set to true. Pass NULL from exfat_get_block() to
preserve the existing behavior.

Acked-by: Christoph Hellwig <hch@lst.de>
Acked-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Stable-dep-of: 044472d5ee7d ("iomap: consolidate bio submission")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/inode.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/exfat/inode.c
+++ b/fs/exfat/inode.c
@@ -124,7 +124,8 @@ void exfat_sync_inode(struct inode *inod
  * *clu = (~0), if it's unable to allocate a new cluster
  */
 static int exfat_map_cluster(struct inode *inode, unsigned int clu_offset,
-		unsigned int *clu, unsigned int *count, int create)
+		unsigned int *clu, unsigned int *count, int create,
+		bool *balloc)
 {
 	int ret;
 	unsigned int last_clu;
@@ -229,6 +230,8 @@ static int exfat_map_cluster(struct inod
 		if (exfat_cluster_walk(sb, clu, num_to_be_allocated - 1, ei->flags))
 			return -EIO;
 		*count = 1;
+		if (balloc)
+			*balloc = true;
 	}
 
 	/* hint information */
@@ -262,7 +265,7 @@ static int exfat_get_block(struct inode
 	/* Is this block already allocated? */
 	count = exfat_bytes_to_cluster_round_up(sbi, bh_result->b_size);
 	err = exfat_map_cluster(inode, iblock >> sbi->sect_per_clus_bits,
-			&cluster, &count, create);
+			&cluster, &count, create, NULL);
 	if (err) {
 		if (err != -ENOSPC)
 			exfat_fs_error_ratelimit(sb,


