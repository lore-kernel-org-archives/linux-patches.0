Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1ACFBF3
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:59:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F903C433D2;
	Mon, 15 May 2023 16:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169973;
	bh=43TqDKCd4qjupXBs2ajov1rLIP/ldwSnPtNxZ7rIqSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r6A9SFlvSixKMRO3rj0wSyczcZ5a7ychtu7F6eGVKaHxyPXnFEQ5W9DHKVWx3e0OM
	 xnN9K6RnOMGH0oQ6ru22RlkGo5+c5dICh1mJyYfkn4h08kK0E71CtiGz3kn4rDUHKB
	 xI979prrU0ZZpOXMoYviqcQUDmd3K/NjsecVvlqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	syzbot+08106c4b7d60702dbc14@syzkaller.appspotmail.com,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.3 231/246] ext4: check iomap type only if ext4_iomap_begin() does not fail
Date: Mon, 15 May 2023 18:27:23 +0200
Message-Id: <20230515161729.547599576@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Baokun Li <libaokun1@huawei.com>

commit fa83c34e3e56b3c672af38059e066242655271b1 upstream.

When ext4_iomap_overwrite_begin() calls ext4_iomap_begin() map blocks may
fail for some reason (e.g. memory allocation failure, bare disk write), and
later because "iomap->type ! = IOMAP_MAPPED" triggers WARN_ON(). When ext4
iomap_begin() returns an error, it is normal that the type of iomap->type
may not match the expectation. Therefore, we only determine if iomap->type
is as expected when ext4_iomap_begin() is executed successfully.

Cc: stable@kernel.org
Reported-by: syzbot+08106c4b7d60702dbc14@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/00000000000015760b05f9b4eee9@google.com
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20230505132429.714648-1-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3576,7 +3576,7 @@ static int ext4_iomap_overwrite_begin(st
 	 */
 	flags &= ~IOMAP_WRITE;
 	ret = ext4_iomap_begin(inode, offset, length, flags, iomap, srcmap);
-	WARN_ON_ONCE(iomap->type != IOMAP_MAPPED);
+	WARN_ON_ONCE(!ret && iomap->type != IOMAP_MAPPED);
 	return ret;
 }
 


