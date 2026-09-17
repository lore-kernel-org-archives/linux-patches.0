Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E313518133;
	Thu, 17 Sep 2026 17:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666959; cv=none; b=ZeavzunBeRQGbMqMunsTKn9QxYIimw2JFlV6lB7mICsSZBV5WHi2b3f3vj4Mb0dBA5VVo+RH3T5laUXbTP8juKOos1V9uIesx+9/aX4qtoXRXpkMrcVyL4HWJSewvx8fh46sCZAVzD8ZnNis+seiahfFR5ZmjD2IYZUi9xo7bRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666959; c=relaxed/simple;
	bh=CHelxkoKuffFH+gRzlu5C3nSJHhTXgo+hi9ePqTQVRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OegXQbZN+1YVTfJf9YIst8n1MbMG0XviP4JuXYDaGKPaIYSowRVALBM+Leua/FzqDYpIJZpe5bgXsPrv2E8/UTRg3MlBbNHKX04Io2dIMkcWOvNxV/AxWeoyCMw2uWqJqf39/cf8NyCFhIN4s56tNcBplS2p6bqPYTEEiz06vok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0L1CGn6D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0L1CGn6D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B6F71F000FF;
	Thu, 17 Sep 2026 17:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666958;
	bh=w67LeaFtbtScplf8525u5kFf2WbGI31LG+RMr183yw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0L1CGn6DLySpeDnlls63FhijipwMgFtLjLEMy3uAxtqJLeHJxF3x/N3qAHpqyH1MD
	 yp4kpjH0dw2a0HSCoCAOtJCG6p5NwSgV4C8+T/hVeSiPgsDVHJ2VFIIN10y2oqpjy1
	 fMYHMtGu751awhrMsdHmh9au4gmBYkGbLbZi+i1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wenjie Qi <qiwenjie@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1180/1250] f2fs: reject setattr size changes on large folio files
Date: Thu, 17 Sep 2026 16:16:15 +0100
Message-ID: <20260917151624.266219420@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wenjie Qi <qwjhust@gmail.com>

[ Upstream commit 242d30bfc0a84b8b5de0a88821b53c9ad7fd31c4 ]

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
Stable-dep-of: 2b8704b6a8b2 ("f2fs: fix to reset all pinned status during fggc")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/file.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1136,6 +1136,8 @@ int f2fs_setattr(struct mnt_idmap *idmap
 		return -EPERM;
 
 	if ((attr->ia_valid & ATTR_SIZE)) {
+		if (mapping_large_folio_support(inode->i_mapping))
+			return -EOPNOTSUPP;
 		if (!f2fs_is_compress_backend_ready(inode) ||
 				IS_DEVICE_ALIASING(inode))
 			return -EOPNOTSUPP;


