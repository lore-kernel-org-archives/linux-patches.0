Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3EA2C9C
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:14:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 798F7C433EF;
	Tue,  7 Feb 2023 13:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775694;
	bh=UpoLVT7g6V00nbnjrSzuK4ZlVZuL1+TKq7LFS53doko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2p2aAGJBmv9VhqRC78C9j1K2NcECh6Qgl6cmR47Is88RX6qEQlMPYzsUd+h5bW5el
	 0ce+C2tHjFgcmP9KPtrkFqlPdtG6KXlYbp4+DyW1TOJUx0slxIBcOObiYu79Ukkt7g
	 w+kA01ZpHK+mDj/QKv4qVeuVBSHDn5D2gLOSz+5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	syzbot+fa4648a5446460b7b963@syzkaller.appspotmail.com
Subject: [PATCH 5.15 113/120] fs/ntfs3: Validate attribute data and valid sizes
Date: Tue,  7 Feb 2023 13:58:04 +0100
Message-Id: <20230207125623.584827092@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Abdun Nihaal <abdun.nihaal@gmail.com>

commit 019d22eb0eb707fc099e6e8fad9b3933236a06d0 upstream.

The data_size and valid_size fields of non resident attributes should be
less than the its alloc_size field, but this is not checked in
ntfs_read_mft function.

Syzbot reports a allocation order warning due to a large unchecked value
of data_size getting assigned to inode->i_size which is then passed to
kcalloc.

Add sanity check for ensuring that the data_size and valid_size fields
are not larger than alloc_size field.

Link: https://syzkaller.appspot.com/bug?extid=fa4648a5446460b7b963
Reported-and-tested-by: syzbot+fa4648a5446460b7b963@syzkaller.appspotmail.com
Fixes: (82cae269cfa95) fs/ntfs3: Add initialization of super block
Signed-off-by: Abdun Nihaal <abdun.nihaal@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/inode.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -132,6 +132,13 @@ next_attr:
 	if (le16_to_cpu(attr->name_off) + attr->name_len > asize)
 		goto out;
 
+	if (attr->non_res) {
+		t64 = le64_to_cpu(attr->nres.alloc_size);
+		if (le64_to_cpu(attr->nres.data_size) > t64 ||
+		    le64_to_cpu(attr->nres.valid_size) > t64)
+			goto out;
+	}
+
 	switch (attr->type) {
 	case ATTR_STD:
 		if (attr->non_res ||


