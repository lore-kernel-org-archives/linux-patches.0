Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526B813A897;
	Thu, 23 May 2024 13:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470778; cv=none; b=pXCd68BImxjGdWWEEQ7uf87+qmpy5eoXH+qQ0KzIR3Jwc7BmdLkPgeKBoJp1XxoXa32fEHTNCnSwN1pCqR0vMQ8bDEntkzfL82QrhOMoZ3zpEvBVPSt09GmW1Ox3QQ+TDVul1QsfIQG0qS5ikf4/ViD77F40kq5WR0q3OdBNRtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470778; c=relaxed/simple;
	bh=N2X4gLyO5oopsbNW0rsekWgW05fJBPqVM1oyuq0GpTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S6l9phmQ4f19i8diV5BAGCeEhQMqVduyImCkyc8x/BA0GdommEVqcd+aO8UfsFKijpSDFkSU+Im5JhpDNOUJYIxQhcrXzorS3p/RVhKpkxRHlrvFE8gOS811JVn7KSe+BfeuuwB5IDY88kd+pe+XW8p0QR2h/cUWHeZ6OIgCUR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XMlUiLWt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XMlUiLWt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBEFFC3277B;
	Thu, 23 May 2024 13:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470778;
	bh=N2X4gLyO5oopsbNW0rsekWgW05fJBPqVM1oyuq0GpTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XMlUiLWtPc7bOF2oozd+xcjHSkoNi0rGDqkfLvLGxJMxnCRrL047PlADgcO0btf0A
	 4FDqfy3E6TpOXDBwSWAk694JKCflFIm29nc+j8q5XtOHSYpCL5umnyj9oYpudoVeX7
	 gp7r6OhSiaGP0uNWtmtFOPkvoayRqYhYqZvEdlco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Paulo Alcantara <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 054/102] smb: client: return reparse type in /proc/mounts
Date: Thu, 23 May 2024 15:13:19 +0200
Message-ID: <20240523130344.502869322@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit 1e5f4240714bb238d2d17c7e14e5fb45c9140665 ]

Add support for returning reparse mount option in /proc/mounts.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202402262152.YZOwDlCM-lkp@intel.com/
Signed-off-by: Paulo Alcantara <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsfs.c   |  2 ++
 fs/smb/client/cifsglob.h | 12 ++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 6d9d2174ee691..30bf754c9fc93 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -674,6 +674,8 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 		seq_printf(s, ",backupgid=%u",
 			   from_kgid_munged(&init_user_ns,
 					    cifs_sb->ctx->backupgid));
+	seq_show_option(s, "reparse",
+			cifs_reparse_type_str(cifs_sb->ctx->reparse_type));
 
 	seq_printf(s, ",rsize=%u", cifs_sb->ctx->rsize);
 	seq_printf(s, ",wsize=%u", cifs_sb->ctx->wsize);
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index ddb64af50a45d..053556ca6f011 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -159,6 +159,18 @@ enum cifs_reparse_type {
 	CIFS_REPARSE_TYPE_DEFAULT = CIFS_REPARSE_TYPE_NFS,
 };
 
+static inline const char *cifs_reparse_type_str(enum cifs_reparse_type type)
+{
+	switch (type) {
+	case CIFS_REPARSE_TYPE_NFS:
+		return "nfs";
+	case CIFS_REPARSE_TYPE_WSL:
+		return "wsl";
+	default:
+		return "unknown";
+	}
+}
+
 struct session_key {
 	unsigned int len;
 	char *response;
-- 
2.43.0



