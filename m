Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202EDFBEA
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:07:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E783C433EF;
	Mon, 15 May 2023 17:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170454;
	bh=X+ehcE5JeX+adTKLqijCc/vzFBV7RRnOgPqyLoQUfq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a7Qq1GgEBddUH7Jz1n/7lhI8Flb6RG9DrS6/8X/2hI3KGyYctDzbG7yCpJaBeXlk3
	 jc90RHP4SpvRG9e12D7du7L8wyd6YZQJa2+r4b1TXm/lcHw54pJaQXoTEEbx9yuL0q
	 IXeNnjCrBTQm0WYK1JyjLJN3KTfq+bfsPt42SsCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 6.1 135/239] proc_sysctl: update docs for __register_sysctl_table()
Date: Mon, 15 May 2023 18:26:38 +0200
Message-Id: <20230515161725.742701771@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Luis Chamberlain <mcgrof@kernel.org>

commit 67ff32289acad9ed338cd9f2351b44939e55163e upstream.

Update the docs for __register_sysctl_table() to make it clear no child
entries can be passed. When the child is true these are non-leaf entries
on the ctl table and sysctl treats these as directories. The point to
__register_sysctl_table() is to deal only with directories not part of
the ctl table where thay may riside, to be simple and avoid recursion.

While at it, hint towards using long on extra1 and extra2 later.

Cc: stable@vger.kernel.org # v5.17
Cc: Christian Brauner <brauner@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/proc_sysctl.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -1281,7 +1281,7 @@ out:
  * __register_sysctl_table - register a leaf sysctl table
  * @set: Sysctl tree to register on
  * @path: The path to the directory the sysctl table is in.
- * @table: the top-level table structure
+ * @table: the top-level table structure without any child
  *
  * Register a sysctl table hierarchy. @table should be a filled in ctl_table
  * array. A completely 0 filled entry terminates the table.
@@ -1302,9 +1302,12 @@ out:
  * proc_handler - the text handler routine (described below)
  *
  * extra1, extra2 - extra pointers usable by the proc handler routines
+ * XXX: we should eventually modify these to use long min / max [0]
+ * [0] https://lkml.kernel.org/87zgpte9o4.fsf@email.froward.int.ebiederm.org
  *
  * Leaf nodes in the sysctl tree will be represented by a single file
- * under /proc; non-leaf nodes will be represented by directories.
+ * under /proc; non-leaf nodes (where child is not NULL) are not allowed,
+ * sysctl_check_table() verifies this.
  *
  * There must be a proc_handler routine for any terminal nodes.
  * Several default handlers are available to cover common cases -
@@ -1346,7 +1349,7 @@ struct ctl_table_header *__register_sysc
 
 	spin_lock(&sysctl_lock);
 	dir = &set->dir;
-	/* Reference moved down the diretory tree get_subdir */
+	/* Reference moved down the directory tree get_subdir */
 	dir->header.nreg++;
 	spin_unlock(&sysctl_lock);
 
@@ -1363,6 +1366,11 @@ struct ctl_table_header *__register_sysc
 		if (namelen == 0)
 			continue;
 
+		/*
+		 * namelen ensures if name is "foo/bar/yay" only foo is
+		 * registered first. We traverse as if using mkdir -p and
+		 * return a ctl_dir for the last directory entry.
+		 */
 		dir = get_subdir(dir, name, namelen);
 		if (IS_ERR(dir))
 			goto fail;


