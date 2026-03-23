Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F3A1DA0E1;
	Mon, 23 Mar 2026 16:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282985; cv=none; b=p6B/QVxHzALG2yTgJ5OhMp3wiZ0bDadpkO84A4n4G1nvICfJ7jeieyHWEHW+/7JnjFInhX4i1XBBSk+DSgU6/pc8x1T9PNj3zejjruIFgHVbyjo1Nu6U7I95hNAj1Y1qocgs1vR/lYA0HZHqP1lMwGTzgWkZfJVG/o7zZr+B2NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282985; c=relaxed/simple;
	bh=60/v5VW7C6Mup+ww/ec0qjcJPXN6SKG7X4bC7KbZYsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SSXpHJWrFQ+jNhe47RdzNlddGjC4kb8XO2g2UdzPbWAnIdGtD7UxyCIJjhxKTBGz1mYww/yy1JSPdfMOd6d1ebwmRIK6rHpoGei3z2KLz0QDmdKN6d3vWUwdTisw5SZm2DGMaayCfx/XLUKtCoO+CzLp/8uQnhoVSXtcIh94wh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uKt+vyv7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uKt+vyv7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A75BC4CEF7;
	Mon, 23 Mar 2026 16:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282985;
	bh=60/v5VW7C6Mup+ww/ec0qjcJPXN6SKG7X4bC7KbZYsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uKt+vyv7wBQk98AHhv3p9zELVcEN3P1k1sGWnSWoT0ySkteQuk+Yv1TqSawi/ehfX
	 M+fyOTBzLCiwtDPc/F7m5BS/sfWeVeh/PAuH993EMego9rhHnzyBYOfE7qRumpnRNu
	 NazrinIR0FePt72x5XFg+BsWz6vkz3o8tv5pi19M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Rix <trix@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 358/481] nfsd: define exports_proc_ops with CONFIG_PROC_FS
Date: Mon, 23 Mar 2026 14:45:40 +0100
Message-ID: <20260323134533.830692779@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Rix <trix@redhat.com>

[ Upstream commit 340086da9a87820b40601141a0e9e87c954ac006 ]

gcc with W=1 and ! CONFIG_PROC_FS
fs/nfsd/nfsctl.c:161:30: error: ‘exports_proc_ops’
  defined but not used [-Werror=unused-const-variable=]
  161 | static const struct proc_ops exports_proc_ops = {
      |                              ^~~~~~~~~~~~~~~~

The only use of exports_proc_ops is when CONFIG_PROC_FS
is defined, so its definition should be likewise conditional.

Signed-off-by: Tom Rix <trix@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: e7fcf179b82d ("NFSD: Hold net reference for the lifetime of /proc/fs/nfs/exports fd")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsctl.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -155,18 +155,6 @@ static int exports_net_open(struct net *
 	return 0;
 }
 
-static int exports_proc_open(struct inode *inode, struct file *file)
-{
-	return exports_net_open(current->nsproxy->net_ns, file);
-}
-
-static const struct proc_ops exports_proc_ops = {
-	.proc_open	= exports_proc_open,
-	.proc_read	= seq_read,
-	.proc_lseek	= seq_lseek,
-	.proc_release	= seq_release,
-};
-
 static int exports_nfsd_open(struct inode *inode, struct file *file)
 {
 	return exports_net_open(inode->i_sb->s_fs_info, file);
@@ -1423,6 +1411,19 @@ static struct file_system_type nfsd_fs_t
 MODULE_ALIAS_FS("nfsd");
 
 #ifdef CONFIG_PROC_FS
+
+static int exports_proc_open(struct inode *inode, struct file *file)
+{
+	return exports_net_open(current->nsproxy->net_ns, file);
+}
+
+static const struct proc_ops exports_proc_ops = {
+	.proc_open	= exports_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= seq_release,
+};
+
 static int create_proc_exports_entry(void)
 {
 	struct proc_dir_entry *entry;


