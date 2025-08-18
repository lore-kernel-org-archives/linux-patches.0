Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77405335BAA;
	Mon, 18 Aug 2025 13:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523209; cv=none; b=bq12khwXH8NmkmTFSvSPcTyX51zll/gpoAy/jOC4hUdBLkgAEKovlchKQeT0jTbhyO52AqhAQtxfOMOtlt3HHsoyeDxoR3wca1vd+s5rIb6YKIgN6JFVbdWlWDdoz/aCpf/6OHQJtpvo64S0lAnp7nQ8GP9a2czhu2JY5cEwcO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523209; c=relaxed/simple;
	bh=ehqhilSCW861FksQQawIrBpbwS6bD1Z+a0EjkUwTY5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZScfZT3UsdzO+umfKTR6IhMLbjON5lmUVrb79Li7+4Hduv+3iTJHQFK6aUale6XLcpb/4r7RuknDuWGkkatRcCRAOsWNWT0KdtOnNYHZRKZ0ClUfrFNjCXxR0SLQC5i1xgl4+CDSOcw5euW7tON3Xdlts73c2aS86EwWociXmgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gqm9Z8f3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gqm9Z8f3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D49C4CEEB;
	Mon, 18 Aug 2025 13:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523209;
	bh=ehqhilSCW861FksQQawIrBpbwS6bD1Z+a0EjkUwTY5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gqm9Z8f3EdrFIu9vun3cmwnS8MKdjEbrBOISyx2fN65JqW0nTHXFSe/PzrGZZ7Iww
	 pYsuvRoa2pOjt5tqVtZR82qRjzWIBUnfBsn3tHztcsmBd9iHFdxN8MwBjF4KHs5Ats
	 6E+skbhRSNC65auJtxX0QLQ4+rSPddTPjtrtihq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+598057afa0f49e62bd23@syzkaller.appspotmail.com,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 103/515] fs/ntfs3: Add sanity check for file name
Date: Mon, 18 Aug 2025 14:41:29 +0200
Message-ID: <20250818124502.334357086@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



