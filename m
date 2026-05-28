Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE23533F5BE;
	Thu, 28 May 2026 20:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999105; cv=none; b=OJcH4cwcP7C2pRHAGbc5b571DLjGXXU1X7gx2BtJllaaG+NeRokurTbIyKc3TqJCU93ggHXGiLTtVjtf6h73uieGJWXLVxzFXbeE+QBLKG5C6w12fLg2lQ36c6PhkMFhwSpP5FnISx5KU8YVJmgACkNApwJ45hPYQjq5ICbBQkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999105; c=relaxed/simple;
	bh=FfVgbMDtvzfFDI5mCelm2FtRSx9iKEGWl6LDQJTkitA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nk6ESM8Z8S8Zsr1YJuuj1hmR396TwLcc7Ll6mMioE1BrOzJ3hECbGfnF/C4AKb3vZzEjKWNM4LWOoCc9EvaUvi/8jQIm6fWSS3GNaOfvMFP44pWG1J6G7E36i33Xnuv4PkBrIJN5ZBTiUZR3xJuJFzEC2F5ArW2SnIvpSE7je1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c+NXY5wO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c+NXY5wO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00B771F000E9;
	Thu, 28 May 2026 20:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999104;
	bh=vxMPRXPBt8TBUQOX+za7g59PME0iKSuaf2zHSHRTVSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c+NXY5wOBADtcFank44MWGeQ0fTFTBzBa7ORt2jUbJeczcgR/CvKY2aru50v7L5kV
	 Yxju+i2kSsmTORE7NMchbr27h0TSWLExOXpkLnVHYXodMK5O2eQ2NwZU+BC12y/xO2
	 a7YT32IdNXFcR3+4lyOS4UxOWKjIuB0E7b0/pvZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Utkal Singh <singhutkal015@gmail.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Chao Yu <chao@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 410/461] erofs: harden h_shared_count in erofs_init_inode_xattrs()
Date: Thu, 28 May 2026 21:48:59 +0200
Message-ID: <20260528194659.355427119@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Utkal Singh <singhutkal015@gmail.com>

[ Upstream commit 6a01f5478d208544c8ba5ddbd674ea660f1b7047 ]

`u8 h_shared_count` indicates the shared xattr count of an inode. It is
read from the on-disk xattr ibody header, which should be corrupted if
the size of the shared xattr array exceeds the space available in
`xattr_isize`.

It does not cause harmful consequence (e.g. crashes), since the image is
already considered corrupted, it indeed results in the silent processing
of garbage metadata.

Let's harden it to report -EFSCORRUPTED earlier.

Signed-off-by: Utkal Singh <singhutkal015@gmail.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Stable-dep-of: 79b09c54c656 ("erofs: fix metabuf leak in inode xattr initialization")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/xattr.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/erofs/xattr.c b/fs/erofs/xattr.c
index c411df5d9dfc7..41e311019a251 100644
--- a/fs/erofs/xattr.c
+++ b/fs/erofs/xattr.c
@@ -85,6 +85,14 @@ static int erofs_init_inode_xattrs(struct inode *inode)
 	}
 	vi->xattr_name_filter = le32_to_cpu(ih->h_name_filter);
 	vi->xattr_shared_count = ih->h_shared_count;
+	if ((u32)vi->xattr_shared_count * sizeof(__le32) >
+	    vi->xattr_isize - sizeof(struct erofs_xattr_ibody_header)) {
+		erofs_err(sb, "invalid h_shared_count %u @ nid %llu",
+			  vi->xattr_shared_count, vi->nid);
+		erofs_put_metabuf(&buf);
+		ret = -EFSCORRUPTED;
+		goto out_unlock;
+	}
 	vi->xattr_shared_xattrs = kmalloc_objs(uint, vi->xattr_shared_count);
 	if (!vi->xattr_shared_xattrs) {
 		erofs_put_metabuf(&buf);
-- 
2.53.0



