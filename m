Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8366C823DD;
	Mon, 23 Mar 2026 16:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282988; cv=none; b=u7zKwDXE4MPHtMYO2NLWrdi9WVdxTtz5wTnnMkIn/5sZER1ECG4eUpmoP//abIziWgiVeWWTz5YiiLlA9LlmM5dsaXH1vXYPLan8NGIU9lmwiRInx+3Rzy1BXPKT4sNQEtY71RrJqiAPBHM4avOkE0DP7cLh+cSOw66C3QEiFCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282988; c=relaxed/simple;
	bh=yMJb64TTOBPAZcldBzgCR1jdrpcJ51AoOfKMGRmVaVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WXJczO9yoeWae6VUlX9GIk1T+8QWzy78t4SyPqQqhAzcH75ulUewOgsONbudb93qmwxXbYo34uSJoV7d5cq4CY0CItRVjV1jPohb9AwWncISpSVGAL9vQWzysVN4TXJ6q1/qxU9QFUAn5/mzuLAcdzWMxlaiblxk6w5G4GUZiQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0VMba8Ox; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0VMba8Ox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A24C4CEF7;
	Mon, 23 Mar 2026 16:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282988;
	bh=yMJb64TTOBPAZcldBzgCR1jdrpcJ51AoOfKMGRmVaVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0VMba8OxNxgsaOo48SyHrAcloklCPsuiok1bnGiQd2FUg97CYX11IVL145KnQejF1
	 Hr7tsrdxbP0HkpmySYMpVfY58RIMfg1EW45bcchgazUgIJf5P1Oqf2zzRfkIJnk1NC
	 kXzf855MOkBT5L1gOZtRk26Vweu5z13Cc/E9zMSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Misbah Anjum N <misanjum@linux.ibm.com>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 359/481] NFSD: Hold net reference for the lifetime of /proc/fs/nfs/exports fd
Date: Mon, 23 Mar 2026 14:45:41 +0100
Message-ID: <20260323134533.854892366@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit e7fcf179b82d3a3730fd8615da01b087cc654d0b ]

The /proc/fs/nfs/exports proc entry is created at module init
and persists for the module's lifetime. exports_proc_open()
captures the caller's current network namespace and stores
its svc_export_cache in seq->private, but takes no reference
on the namespace. If the namespace is subsequently torn down
(e.g. container destruction after the opener does setns() to a
different namespace), nfsd_net_exit() calls nfsd_export_shutdown()
which frees the cache. Subsequent reads on the still-open fd
dereference the freed cache_detail, walking a freed hash table.

Hold a reference on the struct net for the lifetime of the open
file descriptor. This prevents nfsd_net_exit() from running --
and thus prevents nfsd_export_shutdown() from freeing the cache
-- while any exports fd is open. cache_detail already stores
its net pointer (cd->net, set by cache_create_net()), so
exports_release() can retrieve it without additional per-file
storage.

Reported-by: Misbah Anjum N <misanjum@linux.ibm.com>
Closes: https://lore.kernel.org/linux-nfs/dcd371d3a95815a84ba7de52cef447b8@linux.ibm.com/
Fixes: 96d851c4d28d ("nfsd: use proper net while reading "exports" file")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: NeilBrown <neil@brown.name>
Tested-by: Olga Kornievskaia <okorniev@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsctl.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -152,9 +152,19 @@ static int exports_net_open(struct net *
 
 	seq = file->private_data;
 	seq->private = nn->svc_export_cache;
+	get_net(net);
 	return 0;
 }
 
+static int exports_release(struct inode *inode, struct file *file)
+{
+	struct seq_file *seq = file->private_data;
+	struct cache_detail *cd = seq->private;
+
+	put_net(cd->net);
+	return seq_release(inode, file);
+}
+
 static int exports_nfsd_open(struct inode *inode, struct file *file)
 {
 	return exports_net_open(inode->i_sb->s_fs_info, file);
@@ -164,7 +174,7 @@ static const struct file_operations expo
 	.open		= exports_nfsd_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release,
+	.release	= exports_release,
 };
 
 static int export_features_show(struct seq_file *m, void *v)
@@ -1421,7 +1431,7 @@ static const struct proc_ops exports_pro
 	.proc_open	= exports_proc_open,
 	.proc_read	= seq_read,
 	.proc_lseek	= seq_lseek,
-	.proc_release	= seq_release,
+	.proc_release	= exports_release,
 };
 
 static int create_proc_exports_entry(void)


