Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534C41E48A;
	Mon, 18 Aug 2025 13:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524955; cv=none; b=hFsi9Hw1/dzyN9tpXZV2gjOcIHTV3MsMgx0VluQI+vQdyTBK8nr54q1AZwEETTuB5LphiifCER+OQ+EyqngK9ClXkcXVWF6NQ3dEFPwWcJCmhfqVc6LNX7eYqiUAUtjhXHiHRQqn5QPXUl4X00fjjWvDG0MPIjgI/XRklRCHhZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524955; c=relaxed/simple;
	bh=eBbA60LyVR+9jN6SjS/mvmViyaVHbKNdTrGp4/cMB7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JzbUx9K5zU8P7uBNPJAKLsQsAwcn93Wr26UgIJNEZCzx1vx2Qi/iG/nJT4iK/Mzv5kDK51gCEE+KfcWGZGU3L9L15LtK//2CC3bJ6jmGZJJSbFsYM24BJH3FI5/wTIWHJEHmy3W6YLaFTPvsz56DQ69Bc7Cc/N1iep6TBXWHaNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M4PqJ8PW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M4PqJ8PW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE7CDC4CEEB;
	Mon, 18 Aug 2025 13:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524955;
	bh=eBbA60LyVR+9jN6SjS/mvmViyaVHbKNdTrGp4/cMB7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M4PqJ8PWopgIDrUTfycBsJC/M3ybY6dX2v0Em150sGHK5XcZkoWzLHo+V19kXVSrH
	 zGXFNyLracTAL1GIixVX3h5gwsQLI5KHEaRiHS+ZVyyeMaLfY03SjX4xtlVrP4CPZO
	 bhy9plzqVCU0nk0RUhsG6pVWGrMdiwq/leXiOEwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+598057afa0f49e62bd23@syzkaller.appspotmail.com,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 115/570] fs/ntfs3: Add sanity check for file name
Date: Mon, 18 Aug 2025 14:41:42 +0200
Message-ID: <20250818124510.242825295@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Xu <lizhi.xu@windriver.com>

[ Upstream commit e841ecb139339602bc1853f5f09daa5d1ea920a2 ]

The length of the file name should be smaller than the directory entry size.

Reported-by: syzbot+598057afa0f49e62bd23@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=598057afa0f49e62bd23
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/dir.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ntfs3/dir.c b/fs/ntfs3/dir.c
index b6da80c69ca6..600e66035c1b 100644
--- a/fs/ntfs3/dir.c
+++ b/fs/ntfs3/dir.c
@@ -304,6 +304,9 @@ static inline bool ntfs_dir_emit(struct ntfs_sb_info *sbi,
 	if (sbi->options->nohidden && (fname->dup.fa & FILE_ATTRIBUTE_HIDDEN))
 		return true;
 
+	if (fname->name_len + sizeof(struct NTFS_DE) > le16_to_cpu(e->size))
+		return true;
+
 	name_len = ntfs_utf16_to_nls(sbi, fname->name, fname->name_len, name,
 				     PATH_MAX);
 	if (name_len <= 0) {
-- 
2.39.5



