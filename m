Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA71454854D;
	Wed, 30 Sep 2026 17:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790114; cv=none; b=OsMio71sgw0yl61ZBmEnfI6fjKiu1rxfxG65n/NLVT4quU2v4n84/9X+G6Kq9bKZ5WOocmYpNaPk112sFWro6dI7WGOLSRFE37UVUYAyFtMiuKnuzFUdFapzENSZa4KPPzNU2R/wi5rog2xsgTg+D+dWWh8YNl8a+db74s67N+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790114; c=relaxed/simple;
	bh=h4JuP0WkvTNtxsxpc/SVdBkK5eMxyQ+a6+mDK6OvDp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KKdsIyzqB5CzVi4gIPCqHUxoLN1ntqmqNp47CBvGRHQfJQwISC5Q42P9sf7Fl315v7votYPbBDcycAcUVFfj6Rvs2CNs/0EGSi8yzbDn039pU8TDX6wTnXaz4bMA12+qvAnlPfQzZMk50nHCt6lHxnx6ZBOhlyTk2hqWtOy8slw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XpvaWF9J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XpvaWF9J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 508AB1F000FF;
	Wed, 30 Sep 2026 17:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790112;
	bh=ssGs20TMIDKi6Ju8Zjb4nZZnbMody5CMpLe0lLg+3nY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XpvaWF9J7TQV0677BpF1LFO4DdMZWReI5ED9OUjXpmXq9aIdnZsCa/fPW46b7uu4u
	 3ez466UCThS0sI9+UAfI64pfjQP/H2UXujYa5V85Yf4b58fDVSFBXK2m4wmm9xaCaI
	 1+GCSLRiUi+a+rvSXwe1FVdvBusaXqlPZv3E701A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangzijie <wangzijie1@honor.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 688/877] f2fs: dont allow unaligned truncation to smaller/equal size on pinned file
Date: Wed, 30 Sep 2026 17:26:39 +0200
Message-ID: <20260930152429.524601953@linuxfoundation.org>
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

From: wangzijie <wangzijie1@honor.com>

[ Upstream commit d738f708564764ed591cb6ab50d55489f87c726a ]

To prevent scattered pin block generation, don't allow non-section aligned truncation
to smaller or equal size on pinned file. But for truncation to larger size, after
commit 3fdd89b452c2("f2fs: prevent writing without fallocate() for pinned files"),
we only support overwrite IO to pinned file, so we don't need to consider
attr->ia_size > i_size case.

Signed-off-by: wangzijie <wangzijie1@honor.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: d0a481fad5c7 ("f2fs: fix to avoid potential section-unaligned pinfile")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/file.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1097,6 +1097,17 @@ int f2fs_setattr(struct mnt_idmap *idmap
 			!IS_ALIGNED(attr->ia_size,
 			F2FS_BLK_TO_BYTES(fi->i_cluster_size)))
 			return -EINVAL;
+		/*
+		 * To prevent scattered pin block generation, we don't allow
+		 * smaller/equal size unaligned truncation for pinned file.
+		 * We only support overwrite IO to pinned file, so don't
+		 * care about larger size truncation.
+		 */
+		if (f2fs_is_pinned_file(inode) &&
+			attr->ia_size <= i_size_read(inode) &&
+			!IS_ALIGNED(attr->ia_size,
+			F2FS_BLK_TO_BYTES(CAP_BLKS_PER_SEC(sbi))))
+			return -EINVAL;
 	}
 
 	if (is_quota_modification(idmap, inode, attr)) {


