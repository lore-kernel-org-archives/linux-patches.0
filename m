Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406E928314A;
	Tue, 26 Aug 2025 13:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214229; cv=none; b=Tn9toiDV1C0eeW0ixtWDyEOYLnHw8q7lsZHRQli6luc28KtMKp/mauRPk4gqBLQAZrySoP4VAj7Hm8e8fD9k1lZ1UnfWDoLTKW/So2XONMH0Vl11b9aQv98KuO7h2TAPZIiGgz3poLaYHy/VRFj/26/LHOtICg2hfEfYpQuJBKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214229; c=relaxed/simple;
	bh=xV57gHm7GEvDKeP3iWYn0JgTtjzKT693Mny0c7UgXA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jz5dDdPXj3SXFpyvG0Cfm1rz7QOo/gqMgjhyqgJAwZ+RWN/nV/oF0efV29ElUZibW/aKT0Waq1AL2Ox7vDOQqVSNZRPzTFarPHSkYT5CpKHhUvK2fhzOHlm/M3ZtbzIXPIHOtFNpy5zbDzPNjn3ULfKOytp0Z2tTIdWTGC81yXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pcLUzTQW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pcLUzTQW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1D6AC4CEF1;
	Tue, 26 Aug 2025 13:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214229;
	bh=xV57gHm7GEvDKeP3iWYn0JgTtjzKT693Mny0c7UgXA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pcLUzTQWsGu8mEMfAA9yuspHe7gk0un/bCSYYnLyqFmzVdTEaUlfUsJKIH5eFDkUO
	 WTBBpO2q92+ruCFT47gLR9Xm4QD2cmqDcbq4/9TOlYRyy9Hjqj5zXOS4bIw0eS9jff
	 W7L0H6tXT8k3G3W8LhEwWCQPaVlWkZX/2tYrGj4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+598057afa0f49e62bd23@syzkaller.appspotmail.com,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 060/482] fs/ntfs3: Add sanity check for file name
Date: Tue, 26 Aug 2025 13:05:13 +0200
Message-ID: <20250826110932.305084468@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



