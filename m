Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C833FBEA
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:07:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 927E7C433EF;
	Mon, 15 May 2023 17:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170457;
	bh=XnMNx8MwxhSfis/j+qXCiZxa+vofvgVGhJnIpneWtOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T5oeMVhmYGQjz/I1A+cjDXXETkGnJtaPcx0c13f/frhSNoroGZkCzcuWY9HVfyLrb
	 rcn0Pn7ehYk/TecBkLXFCbGTnN6YBZiMphIfruStOg247vI7RFLD8N1k6462kKjIWy
	 ELp348O6n+vMcPJPmaDi0uMwEPUQzqMJCUC+NIdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 6.1 136/239] proc_sysctl: enhance documentation
Date: Mon, 15 May 2023 18:26:39 +0200
Message-Id: <20230515161725.773067405@linuxfoundation.org>
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

commit 1dc8689e4cc651e21566e10206a84c4006e81fb1 upstream.

Expand documentation to clarify:

  o that paths don't need to exist for the new API callers
  o clarify that we *require* callers to keep the memory of
    the table around during the lifetime of the sysctls
  o annotate routines we are trying to deprecate and later remove

Cc: stable@vger.kernel.org # v5.17
Cc: Christian Brauner <brauner@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/proc_sysctl.c |   25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -1281,7 +1281,10 @@ out:
  * __register_sysctl_table - register a leaf sysctl table
  * @set: Sysctl tree to register on
  * @path: The path to the directory the sysctl table is in.
- * @table: the top-level table structure without any child
+ * @table: the top-level table structure without any child. This table
+ * 	 should not be free'd after registration. So it should not be
+ * 	 used on stack. It can either be a global or dynamically allocated
+ * 	 by the caller and free'd later after sysctl unregistration.
  *
  * Register a sysctl table hierarchy. @table should be a filled in ctl_table
  * array. A completely 0 filled entry terminates the table.
@@ -1396,8 +1399,15 @@ fail:
 
 /**
  * register_sysctl - register a sysctl table
- * @path: The path to the directory the sysctl table is in.
- * @table: the table structure
+ * @path: The path to the directory the sysctl table is in. If the path
+ * 	doesn't exist we will create it for you.
+ * @table: the table structure. The calller must ensure the life of the @table
+ * 	will be kept during the lifetime use of the syctl. It must not be freed
+ * 	until unregister_sysctl_table() is called with the given returned table
+ * 	with this registration. If your code is non modular then you don't need
+ * 	to call unregister_sysctl_table() and can instead use something like
+ * 	register_sysctl_init() which does not care for the result of the syctl
+ * 	registration.
  *
  * Register a sysctl table. @table should be a filled in ctl_table
  * array. A completely 0 filled entry terminates the table.
@@ -1413,8 +1423,11 @@ EXPORT_SYMBOL(register_sysctl);
 
 /**
  * __register_sysctl_init() - register sysctl table to path
- * @path: path name for sysctl base
- * @table: This is the sysctl table that needs to be registered to the path
+ * @path: path name for sysctl base. If that path doesn't exist we will create
+ * 	it for you.
+ * @table: This is the sysctl table that needs to be registered to the path.
+ * 	The caller must ensure the life of the @table will be kept during the
+ * 	lifetime use of the sysctl.
  * @table_name: The name of sysctl table, only used for log printing when
  *              registration fails
  *
@@ -1559,6 +1572,7 @@ out:
  *
  * Register a sysctl table hierarchy. @table should be a filled in ctl_table
  * array. A completely 0 filled entry terminates the table.
+ * We are slowly deprecating this call so avoid its use.
  *
  * See __register_sysctl_table for more details.
  */
@@ -1630,6 +1644,7 @@ err_register_leaves:
  *
  * Register a sysctl table hierarchy. @table should be a filled in ctl_table
  * array. A completely 0 filled entry terminates the table.
+ * We are slowly deprecating this caller so avoid future uses of it.
  *
  * See __register_sysctl_paths for more details.
  */


