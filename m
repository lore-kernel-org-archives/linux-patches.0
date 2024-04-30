Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35B612B176;
	Tue, 30 Apr 2024 11:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474908; cv=none; b=B2vl3lXyLk5w4szIySd6r1YMfxcC1xNIoLz6KVxkmRQTqYk+UZcEjufXFxfDhkU/PKUzPWX8MZE+TpF1Fb9F5hjixEedvbNCP0EuL6vS6u++V1t3trguASD5N+x7scgMn+gypLyhcFjGaohKEYHxXVoHtsQ4kSumyZzJSk2lNdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474908; c=relaxed/simple;
	bh=YzvIiYo84HsCgIHo29UfsYyziKf52i/I4Be0XbD00kM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QaE1dcQfJ+fvwsZ4ks7XaJqp51sURD+/Z2oS1CGpbqy/tkG0JqxHM5KumqV0ph0ILeHaF3t1l6SC4IV5rTeBXZjMAIB33InKioBLPkPpvwLdZCCcC/R/Ros+G8Wtb8ls1juMeVIJiiuz7Uzval/7+9rFhJFg05QlS1CvBMwOEDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OtBDW+1i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OtBDW+1i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61ECDC2BBFC;
	Tue, 30 Apr 2024 11:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474907;
	bh=YzvIiYo84HsCgIHo29UfsYyziKf52i/I4Be0XbD00kM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OtBDW+1ifzD25qT63mqESGA6w7J/IoueZ35QXUeU37I39KTm3jYC0TNKnYkVyAg8a
	 ejZBPkGl9K2KmO4tOJZAIb+5SVqrIOvkQG/80EGauQ2lzTmlCfzIP0VhjmC2f0hKqj
	 TN+v5gnfRLPbx5k0KFQ28ifw2PQn3veHVI5waV/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2e22057de05b9f3b30d8@syzkaller.appspotmail.com,
	Jeongjun Park <aha310510@gmail.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 071/138] nilfs2: fix OOB in nilfs_set_de_type
Date: Tue, 30 Apr 2024 12:39:16 +0200
Message-ID: <20240430103051.519230970@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeongjun Park <aha310510@gmail.com>

commit c4a7dc9523b59b3e73fd522c73e95e072f876b16 upstream.

The size of the nilfs_type_by_mode array in the fs/nilfs2/dir.c file is
defined as "S_IFMT >> S_SHIFT", but the nilfs_set_de_type() function,
which uses this array, specifies the index to read from the array in the
same way as "(mode & S_IFMT) >> S_SHIFT".

static void nilfs_set_de_type(struct nilfs_dir_entry *de, struct inode
 *inode)
{
	umode_t mode = inode->i_mode;

	de->file_type = nilfs_type_by_mode[(mode & S_IFMT)>>S_SHIFT]; // oob
}

However, when the index is determined this way, an out-of-bounds (OOB)
error occurs by referring to an index that is 1 larger than the array size
when the condition "mode & S_IFMT == S_IFMT" is satisfied.  Therefore, a
patch to resize the nilfs_type_by_mode array should be applied to prevent
OOB errors.

Link: https://lkml.kernel.org/r/20240415182048.7144-1-konishi.ryusuke@gmail.com
Reported-by: syzbot+2e22057de05b9f3b30d8@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=2e22057de05b9f3b30d8
Fixes: 2ba466d74ed7 ("nilfs2: directory entry operations")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -243,7 +243,7 @@ nilfs_filetype_table[NILFS_FT_MAX] = {
 
 #define S_SHIFT 12
 static unsigned char
-nilfs_type_by_mode[S_IFMT >> S_SHIFT] = {
+nilfs_type_by_mode[(S_IFMT >> S_SHIFT) + 1] = {
 	[S_IFREG >> S_SHIFT]	= NILFS_FT_REG_FILE,
 	[S_IFDIR >> S_SHIFT]	= NILFS_FT_DIR,
 	[S_IFCHR >> S_SHIFT]	= NILFS_FT_CHRDEV,


