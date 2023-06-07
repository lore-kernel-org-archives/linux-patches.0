Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6107C3922F
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:55:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7831C433D2;
	Wed,  7 Jun 2023 20:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686171356;
	bh=qWxXZZCamekcYTGFIWg57QmyjnCXAtvfkHfIoEReLVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sS3hKB6OfpmTcLl6ZTt5ATsL/KPvxq4bNiBymoq99c3ushv4P6gnzXb5NtjNLd3fu
	 94s838WJUgjpMLZTNNZ5jP/J22ryuS5Ehx1BTbHSS6gHFwbUmsjb3hF5MpsTwK4U9g
	 jbG6Q08CRQdfyQhmxRa/hL7uqj/UdbJNiENuqL3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	syzbot+d4b971e744b1f5439336@syzkaller.appspotmail.com,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.4 87/99] ext4: set lockdep subclass for the ea_inode in ext4_xattr_inode_cache_find()
Date: Wed,  7 Jun 2023 22:17:19 +0200
Message-ID: <20230607200902.949798375@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200900.195572674@linuxfoundation.org>
References: <20230607200900.195572674@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Theodore Ts'o <tytso@mit.edu>

commit b928dfdcb27d8fa59917b794cfba53052a2f050f upstream.

If the ea_inode has been pushed out of the inode cache while there is
still a reference in the mb_cache, the lockdep subclass will not be
set on the inode, which can lead to some lockdep false positives.

Fixes: 33d201e0277b ("ext4: fix lockdep warning about recursive inode locking")
Cc: stable@kernel.org
Reported-by: syzbot+d4b971e744b1f5439336@syzkaller.appspotmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Link: https://lore.kernel.org/r/20230524034951.779531-3-tytso@mit.edu
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/xattr.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1500,6 +1500,7 @@ ext4_xattr_inode_cache_find(struct inode
 				     EXT4_IGET_EA_INODE);
 		if (IS_ERR(ea_inode))
 			goto next_entry;
+		ext4_xattr_inode_set_class(ea_inode);
 		if (i_size_read(ea_inode) == value_len &&
 		    !ext4_xattr_inode_read(ea_inode, ea_data, value_len) &&
 		    !ext4_xattr_inode_verify_hashes(ea_inode, NULL, ea_data,


