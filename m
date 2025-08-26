Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58C0195811;
	Tue, 26 Aug 2025 12:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212722; cv=none; b=li7Dn+6yurNhwZG1crkWl6Usg69NmeZCvDsZRz0O5cO91/lcZujUjyhGaau7tkAgvb+GXZF3LglE4QqND+N5JJq8JlSuXdzr1IKcdKypNOSeAv2wzCzyqC4Vo5uKAa0QRFb85rmqFI+yt0UbPKlAnin/hPSD42rAQeZ7uvKMiQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212722; c=relaxed/simple;
	bh=kc5cybpjKSbR1pDESOqVsx/PaNUQ4GF90+wq8q1/mwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WvRYxWzef6gRiqq/kJqnotFbhtbCAvXwcD8wgvt0ipRCKkwPXp6SZ9W9JF1aSU0ddYmHjlIJmLVLCsEkST9gu2qS/yEnDVNxIX4yjd4qJFyxom8cR5Wu7pMj5cNyPvJ6bnVj5GL+4tS2yDRrnONAyKhMBnSYJPfz5HQbw+XTXOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kjkoJz2A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kjkoJz2A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68FDFC4CEF1;
	Tue, 26 Aug 2025 12:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212722;
	bh=kc5cybpjKSbR1pDESOqVsx/PaNUQ4GF90+wq8q1/mwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kjkoJz2ACyxS/fNpLqDuBA5nCIC43r45atbuAmny+jZL8aCASebQXFBRtnbxjTKvg
	 cKFWEuYP0RvUL15uYI8cKYvVf8dZZATu9+fYwNtNpIzy9UxeHGuC/5JT3/wRe+YNwi
	 7FLekwKoCmHTSMEof6UeIQ7yXf9sW/ScnSDm99P4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+598057afa0f49e62bd23@syzkaller.appspotmail.com,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 077/587] fs/ntfs3: Add sanity check for file name
Date: Tue, 26 Aug 2025 13:03:46 +0200
Message-ID: <20250826110954.891969843@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e1b856ecce61..6b93c909bdc9 100644
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



