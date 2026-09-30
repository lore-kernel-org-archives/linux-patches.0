Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11ECF502D5A;
	Wed, 30 Sep 2026 18:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792298; cv=none; b=JiUO7ewTl5lj5Bdn/PDcBsqDcy9ell9ec6c3frn/jy7ExWCw2xuQ1bEOHLh75lY/tGMmgQR6zX5QmfrbHf9fo7sR17srWD3L8WoYFJwZV8yhbdgrisingM7f6XEA0kUsrP8sUwfnT46Ov30bmn2zMJ/wywUOH34DBDCgv7JXrlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792298; c=relaxed/simple;
	bh=967Qq7G9FqMVMgaByrOnnCiEEncr6937Vs1HZYtJXMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f77PypRha51HQqrRisCWxFAhMc6OhhsdxFvP0B4dtN1P0fkCOG1xyVkxCRx/8A1J5UO0tLBTTjFxB/PbhhgUQeilHOO57fj0VL2EE5vJuJqHqBCt/+yb30BACLdEe58xXDaU2pvNhVZRnpNqT80tVRXo9zw/Hi8Jd6DyQO4Q1SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BuBoBs53; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BuBoBs53"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DA911F000FF;
	Wed, 30 Sep 2026 18:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792296;
	bh=MgM1deUCV4Vk0cohdRDyI97IbjItLdvMLh/UtyAU270=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BuBoBs53G4yPRBN/cBHiXr65lTGHdI5K2llOV9hBSxz45a4224Tk6Qy5xD5MUaKrC
	 aXQ6X6c5SS4FM4vjEs8wF4EgXWo/yGarH0IZUqP5gd9zM6UA+40q+4hkp6xgtNx+Am
	 A3spG+Iv9TxN+Z/qDkhXRol/qGjjHR+1KTr2JubI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ran Hongyun <ranhongyun1@huawei.com>,
	Phillip Lougher <phillip@squashfs.org.uk>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 603/752] squashfs: Add dictionary size range check to prevent shift-out-of-bounds
Date: Wed, 30 Sep 2026 17:27:53 +0200
Message-ID: <20260930152411.332510982@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

From: Ran Hongyun <ranhongyun1@huawei.com>

[ Upstream commit 1f7745fb3580152ca902ef181b605f33cabfb1d0 ]

When an abnormal SquashFS image (COMP_OPTS flag is 1 but dictionary size
is 0) is mounted, and performs shift operations using dictionarysize, the
shift exponent is -1, causing a shift-out-of-bounds.

Detail as below:
squashfs_comp_opts(msblk, buffer, length)
  squashfs_xz_comp_opts()
    if (comp_opts)
      n = ffs(opts->dict_size) - 1;<----opts->dict_size=0, n=-1
      if (opts->dict_size != (1 << n) && opts->dict_size !=
	  	(1 << n) + (1 << (n + 1))) <----shift-out-of-bounds

Fix it by adding a dictionary size range check before the shift operation.

Fixes: ff750311d30a ("Squashfs: add compression options support to xz decompressor")
Signed-off-by: Ran Hongyun <ranhongyun1@huawei.com>
Link: https://patch.msgid.link/20260713115525.2661734-1-ranhongyun1@huawei.com
Reviewed-by: Phillip Lougher <phillip@squashfs.org.uk>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/squashfs/xz_wrapper.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/squashfs/xz_wrapper.c b/fs/squashfs/xz_wrapper.c
index 68f6d09bb3a2b..76bb3ee595503 100644
--- a/fs/squashfs/xz_wrapper.c
+++ b/fs/squashfs/xz_wrapper.c
@@ -57,10 +57,10 @@ static void *squashfs_xz_comp_opts(struct squashfs_sb_info *msblk,
 
 		opts->dict_size = le32_to_cpu(comp_opts->dictionary_size);
 
-		/* the dictionary size should be 2^n or 2^n+2^(n+1) */
+		/* the dictionary size should be positive and 2^n or 2^n+2^(n+1) */
 		n = ffs(opts->dict_size) - 1;
-		if (opts->dict_size != (1 << n) && opts->dict_size != (1 << n) +
-						(1 << (n + 1))) {
+		if (opts->dict_size <= 0 || (opts->dict_size != (1 << n) &&
+			opts->dict_size != (1 << n) + (1 << (n + 1)))) {
 			err = -EIO;
 			goto out;
 		}
-- 
2.53.0



