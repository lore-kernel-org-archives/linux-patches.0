Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD6D224F6;
	Tue,  8 Apr 2025 11:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110711; cv=none; b=Tf9uHx91vuON5Slrg42tlw8htr+P+Tu5gm6r3L+x543qJTnwFCp6eXIX2KepulLn/2MiBk5LhUXS7I5QLzzwA5LW6bBPMqZVI3Wj60g5Y6ZiwW2sB+5LqdAQnRPXJdUbaGSxi1947JouC9kap5Inwg9akT85bUAuP/h3ctnwUcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110711; c=relaxed/simple;
	bh=p9aT5Fl6NcetG6xW9DPDElVzJhTo8kDu2OHMtJNDSlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cwB0+7RZ06K1aVulN5IMNFRJTQm2hFQjIgmpdWckGQTmxAdhcBRnxP8wvZO4X6JRFUZHIzhzi+SVuWKQ/4syNfJFY/wwIk75RMD0L3GCmSRykNEpvCmQ1HBbfxbgXJpijAEhH+qw1b0G9b4SGNsrnoz+k2IOF1CXUbD2tgM5vr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tLTelEwC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tLTelEwC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D888DC4CEE5;
	Tue,  8 Apr 2025 11:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110711;
	bh=p9aT5Fl6NcetG6xW9DPDElVzJhTo8kDu2OHMtJNDSlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tLTelEwC0bcQd4HXcPboGi2LiDXpxTVbufbBG0ynnOIeuOa5OEVDRO9ifxv8YerhL
	 pAtA+KSRylSKDeAcATKiyEhYGc4eBLUWWWEjz6F0PB+9yMo++9MnMWW8L/U2dorSI2
	 PhqaqVD1o0GsX4cJ3TL41WLioaJRXKLXMTVMEeG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b01a36acd7007e273a83@syzkaller.appspotmail.com,
	Leo Stone <leocstone@gmail.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 128/731] f2fs: add check for deleted inode
Date: Tue,  8 Apr 2025 12:40:25 +0200
Message-ID: <20250408104917.258091562@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Stone <leocstone@gmail.com>

[ Upstream commit 81edb983b3f5d6900d3e337b9af7b1bec4bef0f2 ]

The syzbot reproducer mounts a f2fs image, then tries to unlink an
existing file. However, the unlinked file already has a link count of 0
when it is read for the first time in do_read_inode().

Add a check to sanity_check_inode() for i_nlink == 0.

[Chao Yu: rebase the code and fix orphan inode recovery issue]
Reported-by: syzbot+b01a36acd7007e273a83@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b01a36acd7007e273a83
Fixes: 39a53e0ce0df ("f2fs: add superblock and major in-memory structure")
Signed-off-by: Leo Stone <leocstone@gmail.com>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/namei.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index a278c7da81778..3d85d8116dae7 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -502,6 +502,14 @@ static struct dentry *f2fs_lookup(struct inode *dir, struct dentry *dentry,
 		goto out;
 	}
 
+	if (inode->i_nlink == 0) {
+		f2fs_warn(F2FS_I_SB(inode), "%s: inode (ino=%lx) has zero i_nlink",
+			  __func__, inode->i_ino);
+		err = -EFSCORRUPTED;
+		set_sbi_flag(F2FS_I_SB(inode), SBI_NEED_FSCK);
+		goto out_iput;
+	}
+
 	if (IS_ENCRYPTED(dir) &&
 	    (S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mode)) &&
 	    !fscrypt_has_permitted_context(dir, inode)) {
-- 
2.39.5



