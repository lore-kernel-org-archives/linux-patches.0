Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4342DF9F;
	Tue, 20 Feb 2024 21:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464198; cv=none; b=e5q8gLkJXFSLbY3naQjVWx8SQ8GiZJoABIsxtXT9apdLS7gsbaapZ1fox6AIryPXJux588SlAsdiCNaaslHeOOfFdtIWwr7hZ143RIjRCdBdeELmNRAR4MHt3X/dpnvl/CPiKF9KikdxWODNn5nLM4F1bJ9RHLGt4cwySNV9yQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464198; c=relaxed/simple;
	bh=46+/G18wK+IixG9MfhBIHeWbc0onOqbrvWl7BH2gUYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YDagbEnwuSiDepYwit8Sq8mM4YZjqmQRdlJ076uKQ3BaZoOELu2swzuYHo5foWhP7kWnVnA7vDEMC0gzJzayHKxnYsJM06LmXZQNTCI2AidrlMGDIgmkcOnGigtNEbV1i27mG6zW0YDhSnUDuznich3oVO4WxJCLCHQfvqB6sLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fFkVvcRp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fFkVvcRp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B988C433C7;
	Tue, 20 Feb 2024 21:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464197;
	bh=46+/G18wK+IixG9MfhBIHeWbc0onOqbrvWl7BH2gUYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fFkVvcRpWiZSbEG4CMWeQtdNHTYoFxB+NfJ4Dap1jOrxhVoD4bCq8pefE+RLmOSYx
	 1N4p4LK+FRLjDUORJRzmpwXdU6nve9lm9JklpcRJ69zFeUX5uSw0fc0BcFmEy7T8Uk
	 FLtyLoTv/vzOLdCA7f/kj22UTYj9UEatpV/DQCJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 282/331] eventfs: Do not invalidate dentry in create_file/dir_dentry()
Date: Tue, 20 Feb 2024 21:56:38 +0100
Message-ID: <20240220205646.811429687@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

commit 71cade82f2b553a74d046c015c986f2df165696f upstream.

With the call to simple_recursive_removal() on the entire eventfs sub
system when the directory is removed, it performs the d_invalidate on all
the dentries when it is removed. There's no need to do clean ups when a
dentry is being created while the directory is being deleted.

As dentries are cleaned up by the simpler_recursive_removal(), trying to
do d_invalidate() in these functions will cause the dentry to be
invalidated twice, and crash the kernel.

Link: https://lore.kernel.org/all/20231116123016.140576-1-naresh.kamboju@linaro.org/
Link: https://lkml.kernel.org/r/20231120235154.422970988@goodmis.org

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Fixes: 407c6726ca71 ("eventfs: Use simple_recursive_removal() to clean up dentries")
Reported-by: Mark Rutland <mark.rutland@arm.com>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |   19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -326,7 +326,6 @@ create_file_dentry(struct eventfs_inode
 	struct eventfs_attr *attr = NULL;
 	struct dentry **e_dentry = &ei->d_children[idx];
 	struct dentry *dentry;
-	bool invalidate = false;
 
 	mutex_lock(&eventfs_mutex);
 	if (ei->is_freed) {
@@ -389,17 +388,14 @@ create_file_dentry(struct eventfs_inode
 		 * Otherwise it means two dentries exist with the same name.
 		 */
 		WARN_ON_ONCE(!ei->is_freed);
-		invalidate = true;
+		dentry = NULL;
 	}
 	mutex_unlock(&eventfs_mutex);
 
-	if (invalidate)
-		d_invalidate(dentry);
-
-	if (lookup || invalidate)
+	if (lookup)
 		dput(dentry);
 
-	return invalidate ? NULL : dentry;
+	return dentry;
 }
 
 /**
@@ -439,7 +435,6 @@ static struct dentry *
 create_dir_dentry(struct eventfs_inode *pei, struct eventfs_inode *ei,
 		  struct dentry *parent, bool lookup)
 {
-	bool invalidate = false;
 	struct dentry *dentry = NULL;
 
 	mutex_lock(&eventfs_mutex);
@@ -495,16 +490,14 @@ create_dir_dentry(struct eventfs_inode *
 		 * Otherwise it means two dentries exist with the same name.
 		 */
 		WARN_ON_ONCE(!ei->is_freed);
-		invalidate = true;
+		dentry = NULL;
 	}
 	mutex_unlock(&eventfs_mutex);
-	if (invalidate)
-		d_invalidate(dentry);
 
-	if (lookup || invalidate)
+	if (lookup)
 		dput(dentry);
 
-	return invalidate ? NULL : dentry;
+	return dentry;
 }
 
 /**


