Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B744E3237;
	Thu, 17 Sep 2026 15:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658790; cv=none; b=P001Djzi7V9yc0HAh/qpRKpQyGm/+Lul6P3RnIkhhwVaZuH1ymltT4+Y9FvK+Fp1wyBT/Vzwy5WiSgD4TqOmxGxbEpVgEFwCNGAUDAa4uzg+Ys7KVX1TAl5XUKK+NkRZ3/59qXj9sVzzHyYoFNgHMVMU/3h//Cxn4XrksV5p9D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658790; c=relaxed/simple;
	bh=3jX19FaI5fWBl1IzxFVC7WFpcAoNSZkrvJ1+WcutVe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=haljy1+3wf4vKFkXujIgq2S3BcrNjf49yJPRBfp8zfEKINn110fzSKKF57gkMJpNGsXqCY3COX0d9qQh9uNcmlnn401QBWHruFyW3Iu4T6rlPYPF24r7LRJWjz1XHaVbmhkVCpiyYSf0i7y1XtsQOpCJRjF9Sbvk5HK4nRBLSGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e/Bq2BOs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e/Bq2BOs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AEAA1F00898;
	Thu, 17 Sep 2026 15:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658779;
	bh=orLAE7UWMKUbKyLcv0On9lgpg5hooENGeYXGnNkWgG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e/Bq2BOs5BKY8Z5ytUCND5lIiOdPDNgtqytNzZhbaw4ngt3JsJCfRAaIrAtUO4cj+
	 LxoKUW5rbugI4RERP1FBQoT4z97aohhgd2zIqeW3XYK1t9HlkhW5CZsX1LgHrYygQb
	 dhLfT7AGN/vOeuaUC4DzZ6SppAuXgH7mJPTCUc7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Ahmet Memis <ali@iusegentoo.com>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 035/733] ufs: do not treat unreadable directory blocks as empty
Date: Thu, 17 Sep 2026 16:05:43 +0100
Message-ID: <20260917151351.613441251@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ali Ahmet Memis <ali@iusegentoo.com>

[ Upstream commit 08edfb34ee9ca54383970c65ed3a6013e84f5e16 ]

ufs_empty_dir() scans every directory block to decide whether a
directory is empty before rmdir() removes it. When ufs_get_folio()
cannot read or validate a block it returns an error pointer, and the
loop currently skips that block with continue and keeps scanning the
remaining blocks.

If none of the readable blocks hold an entry, the function returns 1
and the caller unlinks the directory. A directory whose contents live
in a block that cannot be read, for example because of an I/O error or
corrupted directory metadata, is therefore seen as empty and removed,
losing the entries it still holds.

Follow the ext2 behaviour and treat an unreadable block as a reason to
consider the directory not empty, so rmdir() fails instead of
discarding data that could not be verified.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Ali Ahmet Memis <ali@iusegentoo.com>
Link: https://patch.msgid.link/20260801013942.279992-1-ali@iusegentoo.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ufs/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ufs/dir.c b/fs/ufs/dir.c
index e62fe56676710..ce43cf20b07c9 100644
--- a/fs/ufs/dir.c
+++ b/fs/ufs/dir.c
@@ -590,7 +590,7 @@ int ufs_empty_dir(struct inode * inode)
 
 		kaddr = ufs_get_folio(inode, i, &folio);
 		if (IS_ERR(kaddr))
-			continue;
+			return 0;
 
 		de = (struct ufs_dir_entry *)kaddr;
 		kaddr += ufs_last_byte(inode, i) - UFS_DIR_REC_LEN(1);
-- 
2.53.0



