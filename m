Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179C0882B
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:06:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A521C433EF;
	Fri, 10 Mar 2023 15:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460811;
	bh=dpsCJHlwcgU8at/MHlGCfTyGGtD89VwRP84yZeE0ePw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=REovKqsyPaAoXNQhhy+4FTAGoNDeSPXHjKNMqIPrIA8u6HEx9yrUMUZ5CIFr4Nupx
	 sWHbz3Dm7ux0IXT3Orh6rF5WAN3LbnUJ6WfkY+JVp2Ppy/i5OAsISDfcO/aGdBwYV4
	 pR2GNX2c70wislDM31QvtYE64gscBXAySnK/bD8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 442/529] ubifs: Rectify space budget for ubifs_symlink() if symlink is encrypted
Date: Fri, 10 Mar 2023 14:39:45 +0100
Message-Id: <20230310133825.406997984@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit c2c36cc6ca23e614f9e4238d0ecf48549ee9002a ]

Fix bad space budget when symlink file is encrypted. Bad space budget
may let make_reservation() return with -ENOSPC, which could turn ubifs
to read-only mode in do_writepage() process.

Fetch a reproducer in [Link].

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216490
Fixes: ca7f85be8d6cf9 ("ubifs: Add support for encrypted symlinks")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ubifs/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index 9257ee893bdb8..7dceca1be9b5d 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -1117,7 +1117,6 @@ static int ubifs_symlink(struct inode *dir, struct dentry *dentry,
 	int err, sz_change, len = strlen(symname);
 	struct fscrypt_str disk_link;
 	struct ubifs_budget_req req = { .new_ino = 1, .new_dent = 1,
-					.new_ino_d = ALIGN(len, 8),
 					.dirtied_ino = 1 };
 	struct fscrypt_name nm;
 
@@ -1133,6 +1132,7 @@ static int ubifs_symlink(struct inode *dir, struct dentry *dentry,
 	 * Budget request settings: new inode, new direntry and changing parent
 	 * directory inode.
 	 */
+	req.new_ino_d = ALIGN(disk_link.len - 1, 8);
 	err = ubifs_budget_space(c, &req);
 	if (err)
 		return err;
-- 
2.39.2



