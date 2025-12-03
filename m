Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB8E3624CA;
	Wed,  3 Dec 2025 16:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779418; cv=none; b=rFz99Lhi3zZ5Xx7RgdOToRtuwm2BShKTfVhO66PpKcnYMFRH6vN8/Kf2r04ZioTvjLayW6BN2tUiRIQne/RDozWBpgIwYh+WzY7lw2feDpBGVSZ+HiOykgPHtRSRBoPZHQjlT9cTC3qwdrM/kfrq3MtSs/cQU8b3XAbaQwA+ydA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779418; c=relaxed/simple;
	bh=N8EzhqkKKcN/FskV/Gj80wJEayTQY3JUYKoFXRIVlSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FpjQurkjvLJf3GgURVDZuFKK4Tq41VdVgPEaxjK7wgmidBBszHki08SDSiNJnOiA3wUgMbk/3uJYDe620krPNYXSsyaEjl4IVi2FDB55GaKkAdHJHhdwVelcymWSjZaTcs7G04vbuW66sXVGkjC5MPUUt8Iha50L57uBqxlWFWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1STJ7btd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1STJ7btd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F8BFC4CEF5;
	Wed,  3 Dec 2025 16:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779418;
	bh=N8EzhqkKKcN/FskV/Gj80wJEayTQY3JUYKoFXRIVlSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1STJ7btdjsWAKKb1jJbhawejIfdNwxde15P9O/bPojjoovnad8kWJfcMA7XICXZVl
	 ly6qukMawAugD5Z9VaeYDJjwj79ooFRjXFOTMlqIGAijhNZFJYawtVZBSPTH/D0E8/
	 qSJ3+SDv9aeMETmFkown35e98mwuPPFvKOxNaKrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 208/568] ntfs3: pretend $Extend records as regular files
Date: Wed,  3 Dec 2025 16:23:30 +0100
Message-ID: <20251203152448.343363744@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 4e8011ffec79717e5fdac43a7e79faf811a384b7 ]

Since commit af153bb63a33 ("vfs: catch invalid modes in may_open()")
requires any inode be one of S_IFDIR/S_IFLNK/S_IFREG/S_IFCHR/S_IFBLK/
S_IFIFO/S_IFSOCK type, use S_IFREG for $Extend records.

Reported-by: syzbot <syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=895c23f6917da440ed0d
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 844113c3175c9..accff95baa847 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -456,6 +456,7 @@ static struct inode *ntfs_read_mft(struct inode *inode,
 		   fname->home.seq == cpu_to_le16(MFT_REC_EXTEND)) {
 		/* Records in $Extend are not a files or general directories. */
 		inode->i_op = &ntfs_file_inode_operations;
+		mode = S_IFREG;
 	} else {
 		err = -EINVAL;
 		goto out;
-- 
2.51.0



