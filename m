Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D40F848C
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:23:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C891DC433D2;
	Fri, 10 Mar 2023 14:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458200;
	bh=59+TRHuxBRWQzU+nD978+9ncOo9GSu4QEh44xEI+L/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0hLzZJy+TjjvS+C/kXCe+EhiJUlbEYW8wi4aNlbsj/MRhOiJdHCAdZgIqy+ovIG8Y
	 omlqBEYr6TpFLaa+KXmFcDqbYV9bPe0FiIlYM4leG+/cmP5R+gQIgPfzvCV0+IYPdl
	 OIJq9Wt9kqco5i5FurCQnlJXqiSw16J7x2xQm+AU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0be96567042453c0c820@syzkaller.appspotmail.com,
	Liu Shixin <liushixin2@huawei.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 198/252] fs/jfs: fix shift exponent db_agl2size negative
Date: Fri, 10 Mar 2023 14:39:28 +0100
Message-Id: <20230310133724.998797315@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Liu Shixin via Jfs-discussion <jfs-discussion@lists.sourceforge.net>

[ Upstream commit fad376fce0af58deebc5075b8539dc05bf639af3 ]

As a shift exponent, db_agl2size can not be less than 0. Add the missing
check to fix the shift-out-of-bounds bug reported by syzkaller:

 UBSAN: shift-out-of-bounds in fs/jfs/jfs_dmap.c:2227:15
 shift exponent -744642816 is negative

Reported-by: syzbot+0be96567042453c0c820@syzkaller.appspotmail.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_dmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index f06796cad9aa8..3ad0a33e0443b 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -206,7 +206,8 @@ int dbMount(struct inode *ipbmap)
 	bmp->db_agwidth = le32_to_cpu(dbmp_le->dn_agwidth);
 	bmp->db_agstart = le32_to_cpu(dbmp_le->dn_agstart);
 	bmp->db_agl2size = le32_to_cpu(dbmp_le->dn_agl2size);
-	if (bmp->db_agl2size > L2MAXL2SIZE - L2MAXAG) {
+	if (bmp->db_agl2size > L2MAXL2SIZE - L2MAXAG ||
+	    bmp->db_agl2size < 0) {
 		err = -EINVAL;
 		goto err_release_metapage;
 	}
-- 
2.39.2



