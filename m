Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A483306F;
	Fri, 24 Nov 2023 19:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HIsRmNZR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AB42C433C8;
	Fri, 24 Nov 2023 19:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853668;
	bh=S8tNrChh671yrxGLn18UOZDgE0bdtYZvI7pi1fOrUMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HIsRmNZR6g+7R9bu8WSFNvcJLXRxy83J2KN5K3wACIw9oPHNU4BckfNnOG0xjUVt4
	 rlRMkylpwh6h97BayGZcAABcquPfG8ch1K8cj8TLZuuDNO9bWvBnu2u3AsXmlomA3u
	 1UATutsMSwUHU1258jb0zZe0e5B/9++jyQyjA5Sg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"J. Bruce Fields" <bfields@redhat.com>,
	Max Kellermann <max.kellermann@ionos.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 281/297] ext4: apply umask if ACL support is disabled
Date: Fri, 24 Nov 2023 17:55:23 +0000
Message-ID: <20231124172009.957953724@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Kellermann <max.kellermann@ionos.com>

commit 484fd6c1de13b336806a967908a927cc0356e312 upstream.

The function ext4_init_acl() calls posix_acl_create() which is
responsible for applying the umask.  But without
CONFIG_EXT4_FS_POSIX_ACL, ext4_init_acl() is an empty inline function,
and nobody applies the umask.

This fixes a bug which causes the umask to be ignored with O_TMPFILE
on ext4:

 https://github.com/MusicPlayerDaemon/MPD/issues/558
 https://bugs.gentoo.org/show_bug.cgi?id=686142#c3
 https://bugzilla.kernel.org/show_bug.cgi?id=203625

Reviewed-by: "J. Bruce Fields" <bfields@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Link: https://lore.kernel.org/r/20230919081824.1096619-1-max.kellermann@ionos.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/acl.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/ext4/acl.h
+++ b/fs/ext4/acl.h
@@ -68,6 +68,11 @@ extern int ext4_init_acl(handle_t *, str
 static inline int
 ext4_init_acl(handle_t *handle, struct inode *inode, struct inode *dir)
 {
+	/* usually, the umask is applied by posix_acl_create(), but if
+	   ext4 ACL support is disabled at compile time, we need to do
+	   it here, because posix_acl_create() will never be called */
+	inode->i_mode &= ~current_umask();
+
 	return 0;
 }
 #endif  /* CONFIG_EXT4_FS_POSIX_ACL */


