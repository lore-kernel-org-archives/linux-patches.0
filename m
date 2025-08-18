Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96FA9320397;
	Mon, 18 Aug 2025 12:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521665; cv=none; b=pJTnWaQrRCgSIwMOW6Kz+gmjKMTimtIo4TulqC33Yhiy5gn/UNHFRptrdXwWvH+Q7HmdsScnMa+BshySuE06I+gsUkCAEky59VYj+4FnBYT+s3QzYgHq1e+TiyQW9NLUCVbqb18pHD7RK+DMkAAmrHyH4k2T8CXcpgqZ4wlVQ4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521665; c=relaxed/simple;
	bh=ULN4++o3IdN7usMPjS0YfL1iC7+FZrg2J3UEEObDCzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e62JOkQEH9FhEx6BaPZsc52cq8LMUHKvdhIOIXABzhNVNosz2ITg8Gcj+JQrGCOgWWAmXFQ18ltF8jsyWyA+5As5sxxG3MI1uSTMvLJxWt5Zp3SOdY5PMbLphJ7abQA4hEwNC/I+XF53qSQdFruQFtC90jsyL5RILV7lBR6Eqrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D4HaGObk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D4HaGObk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9C07C113D0;
	Mon, 18 Aug 2025 12:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521665;
	bh=ULN4++o3IdN7usMPjS0YfL1iC7+FZrg2J3UEEObDCzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D4HaGObkLtfDxFaHA690yYnx+3k7OtaXJ9rjaEfWQ/i0kKNYQwVilBrIWcO0kLh8e
	 1ph4fx2CFhF6HSD9CEXyPw4XQTrxIKxPznT/OSVJ88rbqSBsKc+HEnEA+87DIQ0+vz
	 qK6VGX0HCeCImJXkTdc3rBvQSaN12wj3umRwJL+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+598057afa0f49e62bd23@syzkaller.appspotmail.com,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 087/444] fs/ntfs3: Add sanity check for file name
Date: Mon, 18 Aug 2025 14:41:53 +0200
Message-ID: <20250818124452.210156350@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



