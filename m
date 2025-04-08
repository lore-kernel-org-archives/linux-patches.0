Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621722690C0;
	Tue,  8 Apr 2025 11:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111842; cv=none; b=uYlfKaXo2mq5pFsuDmPW1PGS8tqlRZYytjtqo2K4MsYFglRkaG8NGg8sJTaAN2VdHuVNjw50qRfZm0RtYa4s0ZXH3yTTbw0McMhkw9/KED2djbm4n9MHBKcIjV2Eu9z1SBz/4O5z7HixvsO59no3P6DC4/a3xy2S1dpCQuRGk5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111842; c=relaxed/simple;
	bh=6nMAZlCS1kNXGpWUqtvEj4ZFKHoav+m6Gw5zg5SOI/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G7IKEdpJ7aOH1oRDsxMY+3j0Ab+VPtdpN+piIZfiTrPGARKzZneAPpaqrPCWsPQD+ll1nHAME1dUW3NBmTjn/sd4PpRW8mYuptMCznvKX/84HDYAxijJi7rxi84UfcGz21YgP1CNvxn6BXtaKgQYHPjFN/LMRc5HHM1KsWROzEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r3sLi1H4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r3sLi1H4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6CF2C4CEEA;
	Tue,  8 Apr 2025 11:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111842;
	bh=6nMAZlCS1kNXGpWUqtvEj4ZFKHoav+m6Gw5zg5SOI/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r3sLi1H4QpNNf0ZSVFE2XbJBRBMlW15FMBxhNYBs+8mvdJ55K1MOl2qKDMvcOLnlN
	 tu84FMN0DIiVm7jWoFjV48LsKTYZl4JsLADcfLI2Mkn+hB0aARjZjVvMHO0eGMxs4z
	 LIRNu3WWHBw3S9DU7n1MQtsiBvzRYKuTCXElobjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 579/731] spufs: fix a leak in spufs_create_context()
Date: Tue,  8 Apr 2025 12:47:56 +0200
Message-ID: <20250408104927.741678742@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 0f5cce3fc55b08ee4da3372baccf4bcd36a98396 ]

Leak fixes back in 2008 missed one case - if we are trying to set affinity
and spufs_mkdir() fails, we need to drop the reference to neighbor.

Fixes: 58119068cb27 "[POWERPC] spufs: Fix memory leak on SPU affinity"
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/cell/spufs/inode.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platforms/cell/spufs/inode.c
index c566e7997f2c1..9f9e4b8716278 100644
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -460,8 +460,11 @@ spufs_create_context(struct inode *inode, struct dentry *dentry,
 	}
 
 	ret = spufs_mkdir(inode, dentry, flags, mode & 0777);
-	if (ret)
+	if (ret) {
+		if (neighbor)
+			put_spu_context(neighbor);
 		goto out_aff_unlock;
+	}
 
 	if (affinity) {
 		spufs_set_affinity(flags, SPUFS_I(d_inode(dentry))->i_ctx,
-- 
2.39.5



