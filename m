Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF6544F57F;
	Wed, 30 Sep 2026 17:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789018; cv=none; b=bN0YYOb3fmbBFbq6BLDvK6l0wRKbH0qYkQMW8FEDArdBVAj3RAqKRL8eDtmXMYYF+EMK8t97bwHIwP83Fd2DKkzyF4Bt/cFmlYwtqaCbcY7qEVQTeL9PXHlmSkADDzGt6rTTrpk8CSINlPXl5OT5EmG/EajFosFYEt21CBpHMP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789018; c=relaxed/simple;
	bh=ALQRURoS+n7LsU/YqeV3gRW1h95pqhEJcRlKVA1yAZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DM+Ej+mTHi6mZABNGrv9piPkYGH6bopi3WEgoJWkn0futoQjH4YxVdn3jQZsnx6sr+1xKsWO/AyWNYXpTpMcZ9eu01kMeSC5bZjWUzsBgwCMgFRKJ18ZaujNcrn9+RslHNRhliI+cr33ONJKLOgftU20pTKiP2VPd6c2ALVp5jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qJw2Rt0b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qJw2Rt0b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 301061F000FF;
	Wed, 30 Sep 2026 17:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789016;
	bh=iUn9U15zxTzjZcUqFMcoiYfmD1VO56OWAJqwle+MDwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qJw2Rt0b3ZZhzcaPvLC/vWJBXm0h/LZXMeMAhdOsMinF6pRNSFm/xnRcKIv5oO0fj
	 17tSzBUCA7IFfNDjgccHqhj+FncMZDlgArD1xBjIwZix/0ue8HjfY1gRuAxUWHHTJJ
	 Xr/FuRVoqPUtzDe4bo03IK/WiYNENv9EYu0ikUDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ran Hongyun <ranhongyun1@huawei.com>,
	Phillip Lougher <phillip@squashfs.org.uk>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 329/877] squashfs: Add dictionary size range check to prevent shift-out-of-bounds
Date: Wed, 30 Sep 2026 17:20:40 +0200
Message-ID: <20260930152421.782069465@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6c49481a2f8c4..7d54cd524d6d9 100644
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



