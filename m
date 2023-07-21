Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B704A21D50
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:20:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26F79C43140;
	Fri, 21 Jul 2023 16:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956429;
	bh=PX000U1omiXGjurskrbDWLCkoEUtNBAG2bzqTT0cDuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TtGEIL3KtFTd4o59eqdbDvGAbIsy1ZTbZiulkOUjwpzjRY/cDIhulnHDmUNnRyiDd
	 BoqPPPy832V0K2O5MqoyEPApnwnrcOBa/3uXqOm5WLy8vk0NGOAFJy3yE9vUpX5bfA
	 tHmZffsA+w/4/MLtdAoPBCYmTk7dVJ9dq/KYWzP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Siddh Raman Pant <code@siddh.me>,
	syzbot+d2cd27dcf8e04b232eb2@syzkaller.appspotmail.com
Subject: [PATCH 6.4 162/292] jfs: jfs_dmap: Validate db_l2nbperpage while mounting
Date: Fri, 21 Jul 2023 18:04:31 +0200
Message-ID: <20230721160535.867249843@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Siddh Raman Pant <code@siddh.me>

commit 11509910c599cbd04585ec35a6d5e1a0053d84c1 upstream.

In jfs_dmap.c at line 381, BLKTODMAP is used to get a logical block
number inside dbFree(). db_l2nbperpage, which is the log2 number of
blocks per page, is passed as an argument to BLKTODMAP which uses it
for shifting.

Syzbot reported a shift out-of-bounds crash because db_l2nbperpage is
too big. This happens because the large value is set without any
validation in dbMount() at line 181.

Thus, make sure that db_l2nbperpage is correct while mounting.

Max number of blocks per page = Page size / Min block size
=> log2(Max num_block per page) = log2(Page size / Min block size)
				= log2(Page size) - log2(Min block size)

=> Max db_l2nbperpage = L2PSIZE - L2MINBLOCKSIZE

Reported-and-tested-by: syzbot+d2cd27dcf8e04b232eb2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?id=2a70a453331db32ed491f5cbb07e81bf2d225715
Cc: stable@vger.kernel.org
Suggested-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Siddh Raman Pant <code@siddh.me>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jfs/jfs_dmap.c   |    6 ++++++
 fs/jfs/jfs_filsys.h |    2 ++
 2 files changed, 8 insertions(+)

--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -178,7 +178,13 @@ int dbMount(struct inode *ipbmap)
 	dbmp_le = (struct dbmap_disk *) mp->data;
 	bmp->db_mapsize = le64_to_cpu(dbmp_le->dn_mapsize);
 	bmp->db_nfree = le64_to_cpu(dbmp_le->dn_nfree);
+
 	bmp->db_l2nbperpage = le32_to_cpu(dbmp_le->dn_l2nbperpage);
+	if (bmp->db_l2nbperpage > L2PSIZE - L2MINBLOCKSIZE) {
+		err = -EINVAL;
+		goto err_release_metapage;
+	}
+
 	bmp->db_numag = le32_to_cpu(dbmp_le->dn_numag);
 	if (!bmp->db_numag) {
 		err = -EINVAL;
--- a/fs/jfs/jfs_filsys.h
+++ b/fs/jfs/jfs_filsys.h
@@ -122,7 +122,9 @@
 #define NUM_INODE_PER_IAG	INOSPERIAG
 
 #define MINBLOCKSIZE		512
+#define L2MINBLOCKSIZE		9
 #define MAXBLOCKSIZE		4096
+#define L2MAXBLOCKSIZE		12
 #define	MAXFILESIZE		((s64)1 << 52)
 
 #define JFS_LINK_MAX		0xffffffff


