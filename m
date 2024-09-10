Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C685A46444;
	Tue, 10 Sep 2024 09:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962025; cv=none; b=i/pv3zMH6+Kj2oTRU1Z9gdwsvwUT+BI+Ewcm5Vnoos1kazwh5XAVVINUYvIM5M7IrploT4lG1LKtrKWaRbsLIc6lrCLjR9mv6vM5slQxxxIK0QmpqVVosMXtvyqI0Y5b4OP79QTIM+2UcNdl+JqSpyKpBrAHJhhcWzmzPDPxhNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962025; c=relaxed/simple;
	bh=/agO7h7JIGtoQVjveGiSfcNoSduXeZdGpJPl4RF1UMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X0vIMIMMyaKvy3QXAn/s5kTDEW5gjUGurXmxw0aZuiXHdz9z5GrN43h0kQwPbn2LRt15T24B4VHNVf9kq0PTFkcUEl3KAje+guAu9l6iveduunjU0EYlytaefMN01362rPmHKNuOeEUABJ7eGR4bPuxlNaH2cjMyrsVGZ+IyKyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=01rhNdwr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="01rhNdwr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E217C4CEC6;
	Tue, 10 Sep 2024 09:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962025;
	bh=/agO7h7JIGtoQVjveGiSfcNoSduXeZdGpJPl4RF1UMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=01rhNdwrjCBjh7PLW1krlcrycVKSMx2cXtYoHl++WHY/e0lsoqFWw6P1UmK9xpIkR
	 mijFImCahPzOCN7gNYj/GwjTl2ulFZPSaJi6u5Q3ZJuFxEeaufdbHkOFI4BNroBJuR
	 NUZXB1d1LGSuk3BIQBqbUplj2jlfBVoJ6OG5eiAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phillip Lougher <phillip@squashfs.org.uk>,
	Lizhi Xu <lizhi.xu@windriver.com>,
	syzbot+24ac24ff58dc5b0d26b9@syzkaller.appspotmail.com,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 269/375] Squashfs: sanity check symbolic link size
Date: Tue, 10 Sep 2024 11:31:06 +0200
Message-ID: <20240910092631.598987701@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

From: Phillip Lougher <phillip@squashfs.org.uk>

[ Upstream commit 810ee43d9cd245d138a2733d87a24858a23f577d ]

Syzkiller reports a "KMSAN: uninit-value in pick_link" bug.

This is caused by an uninitialised page, which is ultimately caused
by a corrupted symbolic link size read from disk.

The reason why the corrupted symlink size causes an uninitialised
page is due to the following sequence of events:

1. squashfs_read_inode() is called to read the symbolic
   link from disk.  This assigns the corrupted value
   3875536935 to inode->i_size.

2. Later squashfs_symlink_read_folio() is called, which assigns
   this corrupted value to the length variable, which being a
   signed int, overflows producing a negative number.

3. The following loop that fills in the page contents checks that
   the copied bytes is less than length, which being negative means
   the loop is skipped, producing an uninitialised page.

This patch adds a sanity check which checks that the symbolic
link size is not larger than expected.

--

Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Link: https://lore.kernel.org/r/20240811232821.13903-1-phillip@squashfs.org.uk
Reported-by: Lizhi Xu <lizhi.xu@windriver.com>
Reported-by: syzbot+24ac24ff58dc5b0d26b9@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/000000000000a90e8c061e86a76b@google.com/
V2: fix spelling mistake.
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/squashfs/inode.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/squashfs/inode.c b/fs/squashfs/inode.c
index 16bd693d0b3a..d5918eba27e3 100644
--- a/fs/squashfs/inode.c
+++ b/fs/squashfs/inode.c
@@ -279,8 +279,13 @@ int squashfs_read_inode(struct inode *inode, long long ino)
 		if (err < 0)
 			goto failed_read;
 
-		set_nlink(inode, le32_to_cpu(sqsh_ino->nlink));
 		inode->i_size = le32_to_cpu(sqsh_ino->symlink_size);
+		if (inode->i_size > PAGE_SIZE) {
+			ERROR("Corrupted symlink\n");
+			return -EINVAL;
+		}
+
+		set_nlink(inode, le32_to_cpu(sqsh_ino->nlink));
 		inode->i_op = &squashfs_symlink_inode_ops;
 		inode_nohighmem(inode);
 		inode->i_data.a_ops = &squashfs_symlink_aops;
-- 
2.43.0



