Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C8517592;
	Tue, 30 Apr 2024 11:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476150; cv=none; b=uQNt42njUXmdQSz6FLYxuNAThCvLsOqdmvQnloyjoxKcpP7mXpbDNq7KwT9JsnprrekJB5DwkipJxcXnKXxucii9OKI/7CT6q8TOQleO3O/bKiRdm/Yvte7GalYh9yep7KYSjdbcrAyWNuKsLedYDSssJYnQfKHE3XynVhj+rn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476150; c=relaxed/simple;
	bh=bJfMKgdob1D03/d5a4LpbteY0lnIH0c4HLMWeK68nI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ijHz3RMlASYqwOrPi8waimt6xli3Jvn5h1vqqnHyzdRj1/w57cM3oTt6vrHBgRclhLdQD2AKryb/QDGesPo09Prn/zafoT3gb3l/2jvjfaHfabfQlGdLyK2LL7xm1soesWK9iM5M8S89LUvq1uKoX5fTbsx4Yw34q2GtoRve+vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HmAL0+Ff; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HmAL0+Ff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2FE0C2BBFC;
	Tue, 30 Apr 2024 11:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476150;
	bh=bJfMKgdob1D03/d5a4LpbteY0lnIH0c4HLMWeK68nI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HmAL0+Ff5fjnEws0mPD3/3GLlwMQ+T4Oi0pPsIKKlLhP5M+6865EM7H47NHiQ4+Bb
	 jsRTeyjsk+VcSBwujuNuVT2kutW/oRs3spKBZN6J6W0cYSmEgCNlHXNr+WeqaodclK
	 XXu94081UpUcpD+C07tpE/tS+9rzCn7uTO3exj/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2e22057de05b9f3b30d8@syzkaller.appspotmail.com,
	Jeongjun Park <aha310510@gmail.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.4 050/107] nilfs2: fix OOB in nilfs_set_de_type
Date: Tue, 30 Apr 2024 12:40:10 +0200
Message-ID: <20240430103046.135095628@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103044.655968143@linuxfoundation.org>
References: <20240430103044.655968143@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


