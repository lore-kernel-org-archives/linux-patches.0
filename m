Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD2B2108
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:36:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51F2FC433EF;
	Mon, 24 Apr 2023 13:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682343375;
	bh=brqD9kovKbqqEMZDB77NVyqbOcjN1x5OLnk6UGGxg8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E8R6OYLnlhs8XvREUC+qXA7KEmbt/wKq4+3ehPI6DFWNa24ZzRXYeofz9vYgIr5Ux
	 500mH5f793lmLSt5JDWPYyYYtwUpY9ickiwoafAcK8FY1MVf3vOUpLd3+KpEA7gZHX
	 HloIKZl7vOG1G9SfwpUAbFy6RdQlcuBRSXrYYGD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>,
	Zhang Tianci <zhangtianci.1997@bytedance.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Yang Bo <yb203166@antfin.com>
Subject: [PATCH 5.10 53/68] fuse: always revalidate rename target dentry
Date: Mon, 24 Apr 2023 15:18:24 +0200
Message-Id: <20230424131129.694028780@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131127.653885914@linuxfoundation.org>
References: <20230424131127.653885914@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>

commit ccc031e26afe60d2a5a3d93dabd9c978210825fb upstream.

The previous commit df8629af2934 ("fuse: always revalidate if exclusive
create") ensures that the dentries are revalidated on O_EXCL creates.  This
commit complements it by also performing revalidation for rename target
dentries.  Otherwise, a rename target file that only exists in kernel
dentry cache but not in the filesystem will result in EEXIST if
RENAME_NOREPLACE flag is used.

Signed-off-by: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Signed-off-by: Zhang Tianci <zhangtianci.1997@bytedance.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Yang Bo <yb203166@antfin.com>
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
-		 (flags & (LOOKUP_EXCL | LOOKUP_REVAL))) {
+		 (flags & (LOOKUP_EXCL | LOOKUP_REVAL | LOOKUP_RENAME_TARGET))) {
 		struct fuse_entry_out outarg;
 		FUSE_ARGS(args);
 		struct fuse_forget_link *forget;


