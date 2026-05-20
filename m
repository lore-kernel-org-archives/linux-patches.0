Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D934332EBD;
	Wed, 20 May 2026 18:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301785; cv=none; b=EVvM/DKF/RyFJWp8YfgkGpr4z0Jqv63cHZgQtxPUXxYV81yRN9oecpu3NU9dGeIQMdsXS7gKBPAl+pVtoHLBFasm5XuCBxtsEtXgVPyL1fgYFN3Fgmm/oKZj2Uap8obxIsFSs+FrYjN/ZTLMu2/AmzQ/n9pV3na8tcGrYxTLr90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301785; c=relaxed/simple;
	bh=EWuUelS2SADji/rxJnEkagUCyL670xtVpvbhkLfiPEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h6w/0GY0/xJIYm9enRDYTdIyr0YEfqaIFR1/AH9QOZ+HhSeKCEjNB5zXorGmCZq2RwU66bYs/6iNOB5pdgWqEtL1k+MWNlK1jhbrUAUOfJHOWXp0o4Oq8ARJgq9Q1dqFAXdnlcHxBJHofWQLa+FDGGwvvVECgdA11XEb16Mb95o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lJGa9NqA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lJGa9NqA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E308B1F000E9;
	Wed, 20 May 2026 18:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301784;
	bh=oVP41h0QQUe2OF+74yiV8j3kvZDklL3A807rOvsbUjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lJGa9NqA8Iafx7i39Ntc2Ltf1t9ktSewzwPemTQ3tEZATxdnBbu7DsPHS+tU5jUmk
	 W/dwrvGpuSl0UqMQ/oANx5pDitDdRaQvZuirgXbMqbq60FfBBVxxYNr8/A8ltywoGo
	 Ya+euYZEum0fEBSJBnCs7nsuG4vnSmF2mPm3scO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyungjung Joo <jhj140711@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 002/508] fs/omfs: reject s_sys_blocksize smaller than OMFS_DIR_START
Date: Wed, 20 May 2026 18:17:05 +0200
Message-ID: <20260520162058.631212941@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

From: HyungJung Joo <jhj140711@gmail.com>

[ Upstream commit 0621c385fda1376e967f37ccd534c26c3e511d14 ]

omfs_fill_super() rejects oversized s_sys_blocksize values (> PAGE_SIZE),
but it does not reject values smaller than OMFS_DIR_START (0x1b8 = 440).

Later, omfs_make_empty() uses

    sbi->s_sys_blocksize - OMFS_DIR_START

as the length argument to memset().  Since s_sys_blocksize is u32,
a crafted filesystem image with s_sys_blocksize < OMFS_DIR_START causes
an unsigned underflow there, wrapping to a value near 2^32.  That drives
a ~4 GiB memset() from bh->b_data + OMFS_DIR_START and overwrites kernel
memory far beyond the backing block buffer.

Add the corresponding lower-bound check alongside the existing upper-bound
check in omfs_fill_super(), so that malformed images are rejected during
superblock validation before any filesystem data is processed.

Fixes: a3ab7155ea21 ("omfs: add directory routines")
Signed-off-by: Hyungjung Joo <jhj140711@gmail.com>
Link: https://patch.msgid.link/20260317054827.1822061-1-jhj140711@gmail.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/omfs/inode.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/omfs/inode.c b/fs/omfs/inode.c
index 2f8c1882f45c8..60ef691aeb702 100644
--- a/fs/omfs/inode.c
+++ b/fs/omfs/inode.c
@@ -514,6 +514,12 @@ static int omfs_fill_super(struct super_block *sb, void *data, int silent)
 		goto out_brelse_bh;
 	}
 
+	if (sbi->s_sys_blocksize < OMFS_DIR_START) {
+		printk(KERN_ERR "omfs: sysblock size (%d) is too small\n",
+			sbi->s_sys_blocksize);
+		goto out_brelse_bh;
+	}
+
 	if (sbi->s_blocksize < sbi->s_sys_blocksize ||
 	    sbi->s_blocksize > OMFS_MAX_BLOCK_SIZE) {
 		printk(KERN_ERR "omfs: block size (%d) is out of range\n",
-- 
2.53.0



