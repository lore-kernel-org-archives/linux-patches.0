Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C35F569B
	for <patches@lists.linux.dev>; Thu, 15 Dec 2022 18:11:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDD1FC433EF;
	Thu, 15 Dec 2022 18:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1671127907;
	bh=nngRGiIU4K8reXKMuh8Wp0mTEN5EQZNiYsM0B9rOix8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tEnsctL23W2qy+MziA4/FS1qLUw4HAADI2ZKTzmmrOPwZYmLl2Vuky7zUqbfegcty
	 cF62CRcaXSh+/mM6RXEupCW2Pjlmwoss9cjM8cqCSTr4pRd7xsiFU+cx3bTeBWe/qA
	 IQQS/38mqod7mKkn3KP7ZZJqXnT7viwOeOBKAWDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ken Schalk <kschalk@nvidia.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Wu Bo <bo.wu@vivo.com>
Subject: [PATCH 5.10 05/15] fuse: always revalidate if exclusive create
Date: Thu, 15 Dec 2022 19:10:32 +0100
Message-Id: <20221215172907.241626130@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221215172906.638553794@linuxfoundation.org>
References: <20221215172906.638553794@linuxfoundation.org>
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

commit df8629af293493757beccac2d3168fe5a315636e upstream.

Failure to do so may result in EEXIST even if the file only exists in the
cache and not in the filesystem.

The atomic nature of O_EXCL mandates that the cached state should be
ignored and existence verified anew.

Reported-by: Ken Schalk <kschalk@nvidia.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Wu Bo <bo.wu@vivo.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -205,7 +205,7 @@ static int fuse_dentry_revalidate(struct
 	if (inode && fuse_is_bad(inode))
 		goto invalid;
 	else if (time_before64(fuse_dentry_time(entry), get_jiffies_64()) ||
-		 (flags & LOOKUP_REVAL)) {
+		 (flags & (LOOKUP_EXCL | LOOKUP_REVAL))) {
 		struct fuse_entry_out outarg;
 		FUSE_ARGS(args);
 		struct fuse_forget_link *forget;


