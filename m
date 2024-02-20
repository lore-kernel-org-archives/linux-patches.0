Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202002DF9F;
	Tue, 20 Feb 2024 21:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464210; cv=none; b=SJFmIRItrT/DtuAjy9qg7UneFoBaAUuzLbCbZCrQF6mrEfyrG33xnI+jR3Av1iAHOEUrBDNAC7PH6e9ZHFTSQ2L72U9/bP5cl0eY1PyIzOOraf7x3qrlm+j1ucqMWsQjqrvCkeSpLZS9opUNxljwV6PuNpep85W2s5CkwyVwTB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464210; c=relaxed/simple;
	bh=mcJ/FuwyIno3oVxQql+450MGuNKDSpHWOBcr47a91Lw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FO9TYlx8SDe5Z13LJv07ga4OpKIHQ07c5ED1Re9Lsz2eqdbtmGp1H8EU/GWx/WmMeyz7W4FxMw+pN2eZwA9YryWmuTXEchnAcyV2/gNfbyH/7qiijUqRAG9cfvggfEfgXfnyzDdoEQaX9EWRZ3KMDUs1oferAj2dYFddChZQWCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q4kbsvWv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q4kbsvWv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92ED2C433F1;
	Tue, 20 Feb 2024 21:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464210;
	bh=mcJ/FuwyIno3oVxQql+450MGuNKDSpHWOBcr47a91Lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q4kbsvWvjqk9G02qIf05znN6QtH7ivUnycou9NCbxxu1TTuPMsiV+eqvelvmpNH6e
	 AAEHpFBlT3I8mNNotzSZXJQjL51wpKXvm1/C+U4vF8LYoI+WC8NYwZhziR8vCUltwa
	 MJi+ZDH2RLHTVL+jVNrM3o4SoLiQWeEfnwy8uu5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Josef Bacik <josef@toxicpanda.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 286/331] eventfs: Make sure that parent->d_inode is locked in creating files/dirs
Date: Tue, 20 Feb 2024 21:56:42 +0100
Message-ID: <20240220205646.968906653@linuxfoundation.org>
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

commit f49f950c217bfb40f11662bab39cb388d41e4cfb upstream.

Since the locking of the parent->d_inode has been moved outside the
creation of the files and directories (as it use to be locked via a
conditional), add a WARN_ON_ONCE() to the case that it's not locked.

Link: https://lkml.kernel.org/r/20231121231112.853962542@goodmis.org

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -327,6 +327,8 @@ create_file_dentry(struct eventfs_inode
 	struct dentry **e_dentry = &ei->d_children[idx];
 	struct dentry *dentry;
 
+	WARN_ON_ONCE(!inode_is_locked(parent->d_inode));
+
 	mutex_lock(&eventfs_mutex);
 	if (ei->is_freed) {
 		mutex_unlock(&eventfs_mutex);
@@ -430,6 +432,8 @@ create_dir_dentry(struct eventfs_inode *
 {
 	struct dentry *dentry = NULL;
 
+	WARN_ON_ONCE(!inode_is_locked(parent->d_inode));
+
 	mutex_lock(&eventfs_mutex);
 	if (pei->is_freed || ei->is_freed) {
 		mutex_unlock(&eventfs_mutex);


