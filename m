Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A92E189522;
	Tue, 30 Jul 2024 17:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359564; cv=none; b=mnTxVpSdQjqyW7bOqGawiTJoEI1N8eFe60olDPSnDCgpZ5WCMUwhuydVg+s1nDlT3evI/w/c9HIw+m/rb4euOUWnOJfmgdyKi/Y1iOjbJqkQbYRMiOzXFjh0SoD7VtQNpJS4aA2qW71bIh4p0m8pYIYy+Zr5iSfJzAz4adHUjK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359564; c=relaxed/simple;
	bh=wPQcR854A52znuobzisHWB8Yvagcacc9eSNdA97zADg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AcxzOz56/VuuVtOoTcCi0D7wycXCKpcx5LlvZsls6Vb4ALC42P9DdK6bCH1UAdRCd0YGtNj1G+hVobNmxK8xKtB2BggpAFKQr6K6MF4AGD5UwZt6xY+t8cwy2gvc7txvTmq3gm4zkeTuTF8VzRDBiGgeGGVAXA4BBt+e0+OEOm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Y+H7ijv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Y+H7ijv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C99E4C32782;
	Tue, 30 Jul 2024 17:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359564;
	bh=wPQcR854A52znuobzisHWB8Yvagcacc9eSNdA97zADg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Y+H7ijvWLzHBQFgrfrmecPToCiF3/wMDV0gLr9shtLQqCRmMzqPcvxOXayLca0hD
	 YV+LxjDdOL7Yzm3z0kupDRuRFBWRbCGPYX0+tK0xj8W8ohSOslOeb5SD1+jvijVBEQ
	 T/RrFTTkJAY1hgMUTXaLbYuzXqBLqcWltj8u1e3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 488/809] fs/ntfs3: Fix getting file type
Date: Tue, 30 Jul 2024 17:46:04 +0200
Message-ID: <20240730151744.013793745@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 24c5100aceedcd47af89aaa404d4c96cd2837523 ]

An additional condition causes the mft record to be read from disk
and get the file type dt_type.

Fixes: 22457c047ed97 ("fs/ntfs3: Modified fix directory element type detection")
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/dir.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/dir.c b/fs/ntfs3/dir.c
index 1937e8e612f87..858efe255f6f3 100644
--- a/fs/ntfs3/dir.c
+++ b/fs/ntfs3/dir.c
@@ -326,7 +326,8 @@ static inline int ntfs_filldir(struct ntfs_sb_info *sbi, struct ntfs_inode *ni,
 	 * It does additional locks/reads just to get the type of name.
 	 * Should we use additional mount option to enable branch below?
 	 */
-	if ((fname->dup.fa & FILE_ATTRIBUTE_REPARSE_POINT) &&
+	if (((fname->dup.fa & FILE_ATTRIBUTE_REPARSE_POINT) ||
+	     fname->dup.ea_size) &&
 	    ino != ni->mi.rno) {
 		struct inode *inode = ntfs_iget5(sbi->sb, &e->ref, NULL);
 		if (!IS_ERR_OR_NULL(inode)) {
-- 
2.43.0



