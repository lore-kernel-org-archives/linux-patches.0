Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388241170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:28:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F58C433C8;
	Mon, 11 Sep 2023 14:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442485;
	bh=5BfHHNYLtBggiQlydorJjJtc9JC/ipUMoktLgPa4sJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OQa6ymcB4oYD96LUsvob5B90JRU5/glV5WKG2xwS7XHQ8nODWR/GqmwfSAjtmgb1g
	 aO8RyxDmaX7JA/L2dkM7CnFiuayKOgs/lZVwo3ix27J+vxkieKfrOji/hCaIlcxC4M
	 OvRjb9J9/mpnHmgHEoksFANoy+EB44h62jB0ZzJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Snowberg <eric.snowberg@oracle.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 041/737] ovl: Always reevaluate the file signature for IMA
Date: Mon, 11 Sep 2023 15:38:20 +0200
Message-ID: <20230911134651.582204417@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Snowberg <eric.snowberg@oracle.com>

[ Upstream commit 18b44bc5a67275641fb26f2c54ba7eef80ac5950 ]

Commit db1d1e8b9867 ("IMA: use vfs_getattr_nosec to get the i_version")
partially closed an IMA integrity issue when directly modifying a file
on the lower filesystem.  If the overlay file is first opened by a user
and later the lower backing file is modified by root, but the extended
attribute is NOT updated, the signature validation succeeds with the old
original signature.

Update the super_block s_iflags to SB_I_IMA_UNVERIFIABLE_SIGNATURE to
force signature reevaluation on every file access until a fine grained
solution can be found.

Signed-off-by: Eric Snowberg <eric.snowberg@oracle.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index ae1058fbfb5b2..8c60da7b4afd8 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -2052,7 +2052,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		ovl_trusted_xattr_handlers;
 	sb->s_fs_info = ofs;
 	sb->s_flags |= SB_POSIXACL;
-	sb->s_iflags |= SB_I_SKIP_SYNC;
+	sb->s_iflags |= SB_I_SKIP_SYNC | SB_I_IMA_UNVERIFIABLE_SIGNATURE;
 
 	err = -ENOMEM;
 	root_dentry = ovl_get_root(sb, upperpath.dentry, oe);
-- 
2.40.1



