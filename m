Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D7F2F25F3;
	Wed, 30 Sep 2026 15:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783687; cv=none; b=FX1BiLNRbbTnB7AKLgnjH8PUAqZE4XLqQMFPVQtZCBaE8E2dWxzqfwuQ88QI57/MgNF3hbkaO5/zo07oDUlcoYbaSgYP56tm8CX6zD31s9MMhmpGDpMexlLGyBUrBrPozO+Vmj/hw4njIfFtiQNbhUsU4OI1RB8OXjRxbqCwGVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783687; c=relaxed/simple;
	bh=LyX/70oKMPlvKibVIvnHGLNP8TYazcXjO5rXOpscgNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZlHbGsqOw0M7sEl9fTZmhmnUAWpDTknGpSFU3bifhPKxJ+54NN5+hiOxACxkW3pXNGEm4m5D7T3ZqOGdBORFaWY4k96QR30MEJaVhqNTxRaN1FI0+5wW+p54G4RwvQaNbQQhhvIdwv5ktcqVvBBCYOmTwo44PekbuKr/Eig9B8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hP6jCY8Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hP6jCY8Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 553881F00893;
	Wed, 30 Sep 2026 15:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783684;
	bh=WpFFG0nuyZyzMLPD8/ZRmOZZTyUUtlZMZ/MNGqoIgyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hP6jCY8ZgMN5juA7JIqfaB3GbXNKWFd+vHoaOTPvL68B71Md3uckFFkAFW7dmVZ20
	 vFWtkUJHLuG0QikSzNxBYCk4HVfBysPJ36X+wUvXTp37tvPxQlyc7JTu711Gxw9BE1
	 5JdSdBUjd8lDa85ymKUIrkSIJEgJCKwjf5X9Wtq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ran Hongyun <ranhongyun1@huawei.com>,
	Phillip Lougher <phillip@squashfs.org.uk>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 485/595] squashfs: Add dictionary size range check to prevent shift-out-of-bounds
Date: Wed, 30 Sep 2026 17:26:18 +0200
Message-ID: <20260930152358.114859412@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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
index e80419aed862b..b787d49a11b86 100644
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



