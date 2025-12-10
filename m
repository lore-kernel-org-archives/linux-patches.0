Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A910C303C81;
	Wed, 10 Dec 2025 07:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352155; cv=none; b=hBVAlv50eXm9UeH6MNWIFPd0ihONhXQYHrS4vPkNW56wzTEUhT3ZzrTDifrhNI510bEKsXYnJPQ/GpCpR/pZd/7BYx2XP4HZQ9VjnQnp/dUM34packL0345iH3WAvaCsHFRCNzWCFI4bsCv7+anM/DVT8V7Bs2PG0ulfrS1dTLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352155; c=relaxed/simple;
	bh=G6YZ6IL3bv/JeJz/su0d0QG/WFM9zT4AWeOE1tQoLxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=beVoieqlLWcIm5W+3/x2N2DvkYvT+2BNt+ila6PJVDJNYMg33xEiaZLuXzgAYPViSffdvYgBIEEd3SHBc172xt5/zJTp3dfcW1/dZp2KrDBzbE0df9TDodhOvmqTwARTD0bFoE1Q6SKF/hGN0KY5Nq9QNQkjmP4mbwhIkANZqbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GiiKuOq0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GiiKuOq0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17D78C116B1;
	Wed, 10 Dec 2025 07:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765352155;
	bh=G6YZ6IL3bv/JeJz/su0d0QG/WFM9zT4AWeOE1tQoLxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GiiKuOq0z84q3Pn8UlMP4CaLAYph0kFCSfF5OKr8c52zSzCQ9sUcoWgZJ5DGLaKFT
	 +MbwfiVf/UH07LYoUSEncnAYXQuDr1+YqW9l47ULJdmpTocNMF6pJYwDNm+VjpGdEa
	 GF7g/KffKC/s3wMtdFv+QJEKOZPCWbWNFAF065tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f3185be57d7e8dda32b8@syzkaller.appspotmail.com,
	stable@kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.18 03/29] ext4: refresh inline data size before write operations
Date: Wed, 10 Dec 2025 16:30:13 +0900
Message-ID: <20251210072944.463475676@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072944.363788552@linuxfoundation.org>
References: <20251210072944.363788552@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Deepanshu Kartikey <kartikey406@gmail.com>

commit 892e1cf17555735e9d021ab036c36bc7b58b0e3b upstream.

The cached ei->i_inline_size can become stale between the initial size
check and when ext4_update_inline_data()/ext4_create_inline_data() use
it. Although ext4_get_max_inline_size() reads the correct value at the
time of the check, concurrent xattr operations can modify i_inline_size
before ext4_write_lock_xattr() is acquired.

This causes ext4_update_inline_data() and ext4_create_inline_data() to
work with stale capacity values, leading to a BUG_ON() crash in
ext4_write_inline_data():

  kernel BUG at fs/ext4/inline.c:1331!
  BUG_ON(pos + len > EXT4_I(inode)->i_inline_size);

The race window:
1. ext4_get_max_inline_size() reads i_inline_size = 60 (correct)
2. Size check passes for 50-byte write
3. [Another thread adds xattr, i_inline_size changes to 40]
4. ext4_write_lock_xattr() acquires lock
5. ext4_update_inline_data() uses stale i_inline_size = 60
6. Attempts to write 50 bytes but only 40 bytes actually available
7. BUG_ON() triggers

Fix this by recalculating i_inline_size via ext4_find_inline_data_nolock()
immediately after acquiring xattr_sem. This ensures ext4_update_inline_data()
and ext4_create_inline_data() work with current values that are protected
from concurrent modifications.

This is similar to commit a54c4613dac1 ("ext4: fix race writing to an
inline_data file while its xattrs are changing") which fixed i_inline_off
staleness. This patch addresses the related i_inline_size staleness issue.

Reported-by: syzbot+f3185be57d7e8dda32b8@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=f3185be57d7e8dda32b8
Cc: stable@kernel.org
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Message-ID: <20251020060936.474314-1-kartikey406@gmail.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inline.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -418,7 +418,12 @@ static int ext4_prepare_inline_data(hand
 		return -ENOSPC;
 
 	ext4_write_lock_xattr(inode, &no_expand);
-
+	/*
+	 * ei->i_inline_size may have changed since the initial check
+	 * if other xattrs were added. Recalculate to ensure
+	 * ext4_update_inline_data() validates against current capacity.
+	 */
+	(void) ext4_find_inline_data_nolock(inode);
 	if (ei->i_inline_off)
 		ret = ext4_update_inline_data(handle, inode, len);
 	else


