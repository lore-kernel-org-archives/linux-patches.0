Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C2030146A;
	Tue, 26 Aug 2025 13:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216122; cv=none; b=RXzj27jMmm6agzYgiPPtfMwnyAcQgS7ztwCE3GHd5SOPFYL1Be6onKajVThbLjcJJoNf6I/j5VkZnQxJNCtvPKyJD60INrGKVPIaIDld2pzF+FFymZGYKA9VB3jVkGUSKA0BO9a+reTtK6STwAchE5kejVoR7hlE/hCiJT6RJac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216122; c=relaxed/simple;
	bh=ZnE8Q8T/M4a/wir1K4UcK0nh6adHAbYdvPnyCdYblCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BwRrYQVgrdPKt3YsshRw7wTvw0rKEXWHj+sKLmDtwauZHJknnFsC7GEIs7cgnhD1nNcAfUADmPL2sf5i7SvKgl6h5oauVlRZoUyQx6JMDS2kbBY3+WkzWlzYfhrXR08HL9RHBuxaZWr5JQ65V8I4PpncCSTnRAR1N7ry0aSp7ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C2vWF6ES; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C2vWF6ES"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FB74C4CEF1;
	Tue, 26 Aug 2025 13:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216121;
	bh=ZnE8Q8T/M4a/wir1K4UcK0nh6adHAbYdvPnyCdYblCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C2vWF6ESjIqKg/Umeure30Lw6efBf3QegwDRpts/mNbZx7DFLDn2+1HwGHlskT5Ny
	 62oaF0g4D3/UkHkkUuQN87jSDcB4va9HpfkcQAmRrpPRt35zNn/nyJWKhdbhPmkC9I
	 FjJh5ToV7KPGinFBwOojNVuuvIo4ilmAoot9CxDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+598057afa0f49e62bd23@syzkaller.appspotmail.com,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 291/644] fs/ntfs3: Add sanity check for file name
Date: Tue, 26 Aug 2025 13:06:22 +0200
Message-ID: <20250826110953.593437345@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a4ab0164d150..c49e64ebbd0a 100644
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



