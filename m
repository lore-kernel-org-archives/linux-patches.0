Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20AFE1ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:31:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99582C433C8;
	Tue, 25 Jul 2023 11:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284685;
	bh=NRU1EXr9f48AtTRuirfXVPJ/c+b3C9/SGdOWJpS9NbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E0AXLsI34bRecTEBhQKEh2QOHk2lBkSobA6DuviNhkYKYwh/h35vFrA4VlkgH6YyT
	 jdB3F6cy+LJiWLPpFmIBwUZaFODM2i3WU6hyO/wCcOV941Na4MlmpNpjNk0wGhKpIi
	 q2Zui5WhoGlym6NL2gDb89Ntu4l5i9KUJo+4xlS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rongbo <xurongbo@baidu.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.10 445/509] fuse: revalidate: dont invalidate if interrupted
Date: Tue, 25 Jul 2023 12:46:24 +0200
Message-ID: <20230725104614.130786919@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
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
@@ -249,7 +249,7 @@ static int fuse_dentry_revalidate(struct
 			spin_unlock(&fi->lock);
 		}
 		kfree(forget);
-		if (ret == -ENOMEM)
+		if (ret == -ENOMEM || ret == -EINTR)
 			goto out;
 		if (ret || fuse_invalid_attr(&outarg.attr) ||
 		    fuse_stale_inode(inode, outarg.generation, &outarg.attr))


