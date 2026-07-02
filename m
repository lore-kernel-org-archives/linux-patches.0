Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405B930C146;
	Thu,  2 Jul 2026 16:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011597; cv=none; b=Xp2v8Bk7dEcSafgi3lr12VOW1H9AbdBBBArbUBd/KKAYSBT0gP3OTW+n8Hx+SGpY8QPIme4L95mwxXCZC97cRnJwJ2tehzq5a3A5aT6VYqm8VosxYLJzioEOnm2MuL7X+NNgHNbRB1UrRN8j3JDiCIByxVpeQg35zEdVR77fm24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011597; c=relaxed/simple;
	bh=QHXm/NRkuf1XHRnlLuzJfiWOixtLvtt5urczIj9J3xU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AX8RTnUphPiNstS+ZmwwiwQ0o4bhaKWii4h2AWHV3Y3zPDyKqt+K/NMLQpIxK+2MI8bewfQM6FHNC2i/isv3hys59RLPDMhuOXa2MzLHJgu3TvyS6VrJVSJXJKkIiT0ONe7JHjjlwY1XxQikeFqcUg4wBdNrwUpj+bbivzBoWq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yk69B7Xu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yk69B7Xu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5FF01F00A3D;
	Thu,  2 Jul 2026 16:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011596;
	bh=2ZVOOouQciJmLzq7QNauuoEVmlMcroBbx3N7hmJ6fUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yk69B7XuGjnuTCcfMjkUovldKtAwiJgHnWrSV2UHbnZr19Bg7PhNhZqNDQno5XIL5
	 4WyIkL49Z2HOT9qhPFZkg44Ep09CiS5bs9p9VJ+bnmtjM3ENd5X7p6Q6e4U1AUiZ56
	 aefXaA8CE77C/wg8b43t7dwshq5kkuFJvsLzP02Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wenjie Qi <qiwenjie@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 7.1 061/120] f2fs: reject setattr size changes on large folio files
Date: Thu,  2 Jul 2026 18:20:57 +0200
Message-ID: <20260702155114.224430332@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.964534952@linuxfoundation.org>
References: <20260702155112.964534952@linuxfoundation.org>
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

From: Wenjie Qi <qwjhust@gmail.com>

commit 242d30bfc0a84b8b5de0a88821b53c9ad7fd31c4 upstream.

F2FS large folios are only enabled for immutable non-compressed files.
Writable open and writable mmap reject such mappings, but truncate(2)
through f2fs_setattr() misses the same guard.

If FS_IMMUTABLE_FL is cleared while the inode is still cached, the mapping
can keep large-folio support and ATTR_SIZE can change i_size. Reject size
changes in that state.

Cc: stable@kernel.org
Fixes: 05e65c14ea59 ("f2fs: support large folio for immutable non-compressed case")
Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/file.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 69aad1060c48..d240ca78a31f 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1098,6 +1098,8 @@ int f2fs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 		return -EPERM;
 
 	if ((attr->ia_valid & ATTR_SIZE)) {
+		if (mapping_large_folio_support(inode->i_mapping))
+			return -EOPNOTSUPP;
 		if (!f2fs_is_compress_backend_ready(inode) ||
 				IS_DEVICE_ALIASING(inode))
 			return -EOPNOTSUPP;
-- 
2.55.0



