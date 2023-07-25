Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042ED14263
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:47:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D6B7C433C8;
	Tue, 25 Jul 2023 11:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690285642;
	bh=/6qy0W4HWDIn7gndrX9MwiTGc78ncsM+UWjHWgGq3vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t+3yiIfhnlvPaLdiWPrR0UU1NXxZjuLvUBhTkKf6RB8D2Wb6WUwBqItVOqYm/6oUH
	 u5bg2oRsyRdwNh/nIxD+BxlumQn7gyDetQq9mvSVnZV8KfxjSlRQlla1PB2TDwgmcd
	 I/qhBrQJTv/1e88Hw95uKk9Qy+XLUEX2M1epq2Ng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rongbo <xurongbo@baidu.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.4 278/313] fuse: revalidate: dont invalidate if interrupted
Date: Tue, 25 Jul 2023 12:47:11 +0200
Message-ID: <20230725104533.106715449@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Miklos Szeredi <mszeredi@redhat.com>

commit a9d1c4c6df0e568207907c04aed9e7beb1294c42 upstream.

If the LOOKUP request triggered from fuse_dentry_revalidate() is
interrupted, then the dentry will be invalidated, possibly resulting in
submounts being unmounted.

Reported-by: Xu Rongbo <xurongbo@baidu.com>
Closes: https://lore.kernel.org/all/CAJfpegswN_CJJ6C3RZiaK6rpFmNyWmXfaEpnQUJ42KCwNF5tWw@mail.gmail.com/
Fixes: 9e6268db496a ("[PATCH] FUSE - read-write operations")
Cc: <stable@vger.kernel.org>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -246,7 +246,7 @@ static int fuse_dentry_revalidate(struct
 			spin_unlock(&fi->lock);
 		}
 		kfree(forget);
-		if (ret == -ENOMEM)
+		if (ret == -ENOMEM || ret == -EINTR)
 			goto out;
 		if (ret || fuse_invalid_attr(&outarg.attr) ||
 		    (outarg.attr.mode ^ inode->i_mode) & S_IFMT)


