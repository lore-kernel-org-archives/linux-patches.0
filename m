Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688D6AD48
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:22:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC7BDC4339E;
	Wed,  4 Jan 2023 16:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672849334;
	bh=1kIbxSOtFvgKC/V/gaVa1VYt1O9i8rhUyH3A/MnqEyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oV/pmJL1oaNn3zX52ZTRJL4vunGfbCel8kW/LFo8YxPLL3J+acNsHKqGoXC8qizJc
	 rxjjKnFvGnh8RPfe73s/w/sGhq108Ko47fIslpWNHdGfyhShOm4yWkOfdmub1Y3yiF
	 LAc8oMLuyG2DGV9JiC+q6fWET195ug+eFjJVER3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Czerner <lczerner@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.1 172/207] ext4: journal_path mount options should follow links
Date: Wed,  4 Jan 2023 17:07:10 +0100
Message-Id: <20230104160517.326797187@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lukas Czerner <lczerner@redhat.com>

commit e3ea75ee651daf5e434afbfdb7dbf75e200ea1f6 upstream.

Before the commit 461c3af045d3 ("ext4: Change handle_mount_opt() to use
fs_parameter") ext4 mount option journal_path did follow links in the
provided path.

Bring this behavior back by allowing to pass pathwalk flags to
fs_lookup_param().

Fixes: 461c3af045d3 ("ext4: Change handle_mount_opt() to use fs_parameter")
Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Link: https://lore.kernel.org/r/20221004135803.32283-1-lczerner@redhat.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/filesystems/mount_api.rst |    1 +
 fs/ext4/super.c                         |    2 +-
 fs/fs_parser.c                          |    3 ++-
 include/linux/fs_parser.h               |    1 +
 4 files changed, 5 insertions(+), 2 deletions(-)

--- a/Documentation/filesystems/mount_api.rst
+++ b/Documentation/filesystems/mount_api.rst
@@ -814,6 +814,7 @@ process the parameters it is given.
        int fs_lookup_param(struct fs_context *fc,
 			   struct fs_parameter *value,
 			   bool want_bdev,
+			   unsigned int flags,
 			   struct path *_path);
 
      This takes a parameter that carries a string or filename type and attempts
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2247,7 +2247,7 @@ static int ext4_parse_param(struct fs_co
 			return -EINVAL;
 		}
 
-		error = fs_lookup_param(fc, param, 1, &path);
+		error = fs_lookup_param(fc, param, 1, LOOKUP_FOLLOW, &path);
 		if (error) {
 			ext4_msg(NULL, KERN_ERR, "error: could not find "
 				 "journal device path");
--- a/fs/fs_parser.c
+++ b/fs/fs_parser.c
@@ -138,15 +138,16 @@ EXPORT_SYMBOL(__fs_parse);
  * @fc: The filesystem context to log errors through.
  * @param: The parameter.
  * @want_bdev: T if want a blockdev
+ * @flags: Pathwalk flags passed to filename_lookup()
  * @_path: The result of the lookup
  */
 int fs_lookup_param(struct fs_context *fc,
 		    struct fs_parameter *param,
 		    bool want_bdev,
+		    unsigned int flags,
 		    struct path *_path)
 {
 	struct filename *f;
-	unsigned int flags = 0;
 	bool put_f;
 	int ret;
 
--- a/include/linux/fs_parser.h
+++ b/include/linux/fs_parser.h
@@ -76,6 +76,7 @@ static inline int fs_parse(struct fs_con
 extern int fs_lookup_param(struct fs_context *fc,
 			   struct fs_parameter *param,
 			   bool want_bdev,
+			   unsigned int flags,
 			   struct path *_path);
 
 extern int lookup_constant(const struct constant_table tbl[], const char *name, int not_found);


