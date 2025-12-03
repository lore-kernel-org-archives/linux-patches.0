Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB7834D4F6;
	Wed,  3 Dec 2025 16:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777767; cv=none; b=sP+qDqsF13uArKEEyEW7/WmN3oN1jv0+/a925sjrWBTG6/KUJB5Nkj0932wlBeoLGv9TKJP/uVUQwBxjWQZyOlgjPNPUkDVWqqul8l8OB6XKeSWfanV5kQHnatsNWJwmbQFMys2XIq13BoIfrOUC9JB49xNbjm5AyQYjn4/UpRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777767; c=relaxed/simple;
	bh=4XU8k8w7sXR8PkNUdNUh/KigMnWc5pekInK4IR9aKTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=piZCxIvAYUnMapJGTgC17guKcHD5NFH73Iqx6Du1kEIgS2n7FK7S+Jl2f4GPio+LxAVM4w13S11tK830PmZUwr76IlV+m5CeSf3XEp1bapZwjFhAp58FgMrUTItV7gNZqXvqPeN1nSKLXJtOF35ZoAJGLBC61xNURQnouYbX8r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JlLmAWCs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JlLmAWCs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1DC3C4CEF5;
	Wed,  3 Dec 2025 16:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777767;
	bh=4XU8k8w7sXR8PkNUdNUh/KigMnWc5pekInK4IR9aKTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JlLmAWCsdBL3CmuYgSuQdxtZnijqtNuixAK/7C2WBc4YvCMcswZ9I7w3yXt07jJut
	 Tt/gsBBVy1+3WHGlgRPS/osXd/OSkBSRXIkc1en+zbknNO3ROZpR5GWF097KG6HC9C
	 cMiBm8BSThTzm+JbbZhtucAEBgm7/otw4hKjUO5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 141/392] ntfs3: pretend $Extend records as regular files
Date: Wed,  3 Dec 2025 16:24:51 +0100
Message-ID: <20251203152419.276001394@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index edd7c89ba1a11..019a98e300dcf 100644
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



