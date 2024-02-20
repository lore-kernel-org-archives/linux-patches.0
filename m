Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4DCF2DF9F;
	Tue, 20 Feb 2024 21:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464071; cv=none; b=byd6DDzc3nZd9tqJp03g4Weqq3phL3xcF2UQMsDiOJAHI/LCmzt++FR0TovHEl45sc4wF9JVvoWE420GWAE1yS8QD2K1hqKyJSlanKA3R6OIKbi1Bq87K0sqgCfAaO1K74C9GolqqhA0kVirT33/uVSTOQCZsb7h1UCBOUJNdjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464071; c=relaxed/simple;
	bh=fG9PqUHKfm2lV0LqR2AtpQ71jgkNTmZRqZxuZl3mLAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CZ15GZB+XMvMcfMH+CFRxQO0uTGnum/Rfja4bSH/XNmxtRNwOvWREAn9KPRJr44URKbEsGz88vqPxP6yOjbyWDn+YAxJvnX4lt1TUaUAtFo+oRlKdlw2NyWtAXj5HSEqzPOf6stoA9pXdTbvayq+fEIU9sGto+B29SM3qWEhfOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RTPF9yv0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RTPF9yv0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D579C433F1;
	Tue, 20 Feb 2024 21:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464071;
	bh=fG9PqUHKfm2lV0LqR2AtpQ71jgkNTmZRqZxuZl3mLAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RTPF9yv0avxgq5fzapqM2xEckSgcQDziv2h+AT6bW9uVeuZc4XI25gOpO4XwzhDiH
	 tn3y8UWH5lwm4wcVXnNw9a0A6Ke8eb/+315n/oA/rLe1COi1fi7tJk0cgiVVzDLx45
	 nJyZo9uyb3NmLMgmqVmaNFfNOuh92dRzJn5TMxAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shane Nehring <snehring@iastate.edu>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 214/331] smb: client: set correct id, uid and cruid for multiuser automounts
Date: Tue, 20 Feb 2024 21:55:30 +0100
Message-ID: <20240220205644.447297545@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.com>

commit 4508ec17357094e2075f334948393ddedbb75157 upstream.

When uid, gid and cruid are not specified, we need to dynamically
set them into the filesystem context used for automounting otherwise
they'll end up reusing the values from the parent mount.

Fixes: 9fd29a5bae6e ("cifs: use fs_context for automounts")
Reported-by: Shane Nehring <snehring@iastate.edu>
Closes: https://bugzilla.redhat.com/show_bug.cgi?id=2259257
Cc: stable@vger.kernel.org # 6.2+
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/namespace.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/fs/smb/client/namespace.c
+++ b/fs/smb/client/namespace.c
@@ -168,6 +168,21 @@ static char *automount_fullpath(struct d
 	return s;
 }
 
+static void fs_context_set_ids(struct smb3_fs_context *ctx)
+{
+	kuid_t uid = current_fsuid();
+	kgid_t gid = current_fsgid();
+
+	if (ctx->multiuser) {
+		if (!ctx->uid_specified)
+			ctx->linux_uid = uid;
+		if (!ctx->gid_specified)
+			ctx->linux_gid = gid;
+	}
+	if (!ctx->cruid_specified)
+		ctx->cred_uid = uid;
+}
+
 /*
  * Create a vfsmount that we can automount
  */
@@ -205,6 +220,7 @@ static struct vfsmount *cifs_do_automoun
 	tmp.leaf_fullpath = NULL;
 	tmp.UNC = tmp.prepath = NULL;
 	tmp.dfs_root_ses = NULL;
+	fs_context_set_ids(&tmp);
 
 	rc = smb3_fs_context_dup(ctx, &tmp);
 	if (rc) {


