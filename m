Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7B21D0DF5;
	Wed,  2 Oct 2024 14:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878406; cv=none; b=d022BnX7DoGNF2oKPzb/rD1PGLRWG13L0HuPpIhBeMEOvVONKVf9HQo/PlmtJdcHuCYnjfLzi9z+4QZTenKpLQsD5D4G3IY68WD1DcFnrf6M4rw8UAf4nZ4JsVeGUA0Fe9fcqe0EmfYRDsVZfbFQbE0q0ajJZiqe6JrHkihgtdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878406; c=relaxed/simple;
	bh=1N6/yKA9qOqhR0otWM4clq70EWSFSV2OLfWp4ulVY/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pM4Ll+5VAEG7KmsEmWFrNU1J/o7dVznK499fKu0iKo67YZYIwu0DmY2SsTQSXjj3V+VoJPjVbvTEadQFFMsKfEfkkzqk8GD5Owsz4oBssTD4omHtLTdZ5E6SA+2rgbZd9FarMiIJUerNgb8SxCRn4NjT/aMZ39EauPeaiA2Tyrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g0H0/2Xy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g0H0/2Xy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 396A6C4CEC2;
	Wed,  2 Oct 2024 14:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878405;
	bh=1N6/yKA9qOqhR0otWM4clq70EWSFSV2OLfWp4ulVY/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g0H0/2Xy3M3iZV+mfHijWDrk/Zu1mmPMLWuTru9BNjDPUKFhvtB9mvP8MyHDId30C
	 f08Xk2PFp/t9MEHe0p3dM/zuJoCGYMX8wHzV/PedGMR7OwRfx8wHJhZx0WF+u7qDnD
	 sK50krgWDp1to1Trh/Qn+CuYQAPbZJ5IB9GhKm8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 401/634] f2fs: atomic: fix to truncate pagecache before on-disk metadata truncation
Date: Wed,  2 Oct 2024 14:58:21 +0200
Message-ID: <20241002125826.937525316@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit ebd3309aec6271c4616573b0cb83ea25e623070a ]

We should always truncate pagecache while truncating on-disk data.

Fixes: a46bebd502fe ("f2fs: synchronize atomic write aborts")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 8425fc33ea403..b2763cde3f582 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2185,6 +2185,10 @@ static int f2fs_ioc_start_atomic_write(struct file *filp, bool truncate)
 		F2FS_I(fi->cow_inode)->atomic_inode = inode;
 	} else {
 		/* Reuse the already created COW inode */
+		f2fs_bug_on(sbi, get_dirty_pages(fi->cow_inode));
+
+		invalidate_mapping_pages(fi->cow_inode->i_mapping, 0, -1);
+
 		ret = f2fs_do_truncate_blocks(fi->cow_inode, 0, true);
 		if (ret) {
 			f2fs_up_write(&fi->i_gc_rwsem[WRITE]);
-- 
2.43.0



