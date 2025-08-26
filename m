Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772FC1A256B;
	Tue, 26 Aug 2025 11:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208545; cv=none; b=fSxP8lsjKhJRU/hGKs7XUVf+0akZ9G2gLODBnUbcDHLCZmXhppA42EhF5rKRs4VT4G/zzhU9331HYbI+Xd2X5XsBbEfosP4v+0DLEUxinoswxyOw5cDbfaJj5jHTzvb8Ut2fy3YNopW221VW97FwnkwQ6fhoNc99PHQco8c70jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208545; c=relaxed/simple;
	bh=n8YpGWAbR0LXBq2JW8p/1IDDiS3lwEQx/pst3nrg0ks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UWUbKYvHZZ3vQ+lXwzPrDrSaiXDWRLf2dVSBhjSln4eDemxKbTuFImulciB5PvlJCUoVtKw0PqMu9dhFJCu5wBZJCdX3zRfiDbRWld+cd/8rGV6Pu53V/w6i8v6aXhVNAWbG0WeGCpNum0RbJSpYubPml+0qmC9GeCtyxN2wR0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VC6z673n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VC6z673n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0899CC4CEF1;
	Tue, 26 Aug 2025 11:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208545;
	bh=n8YpGWAbR0LXBq2JW8p/1IDDiS3lwEQx/pst3nrg0ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VC6z673nyYVgD9FX6xVnrIQAputWbR0uiTpDG62m6mrZ+Ya582x6xKsLYZzmsWzib
	 yLP91w/iR8wv/hQeXsARwQImqRRdyY0F9XQBmWAg1+xnEc8k4KrDB0teZxImVd9qEM
	 iC7wHj68l2Q1HpkPKWNZM0C1ZOS5mQ0bejCJPysg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 153/322] btrfs: send: add and use helper to rename current inode when processing refs
Date: Tue, 26 Aug 2025 13:09:28 +0200
Message-ID: <20250826110919.594694100@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit ec666c84deba56f714505b53556a97565f72db86 ]

Extract the logic to rename the current inode at process_recorded_refs()
into a helper function and use it, therefore removing duplicated logic
and making it easier for an upcoming patch by avoiding yet more duplicated
logic.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 005b0a0c24e1 ("btrfs: send: use fallocate for hole punching with send stream v2")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/send.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4165,6 +4165,19 @@ out:
 	return ret;
 }
 
+static int rename_current_inode(struct send_ctx *sctx,
+				struct fs_path *current_path,
+				struct fs_path *new_path)
+{
+	int ret;
+
+	ret = send_rename(sctx, current_path, new_path);
+	if (ret < 0)
+		return ret;
+
+	return fs_path_copy(current_path, new_path);
+}
+
 /*
  * This does all the move/link/unlink/rmdir magic.
  */
@@ -4450,13 +4463,10 @@ static int process_recorded_refs(struct
 		 * it depending on the inode mode.
 		 */
 		if (is_orphan && can_rename) {
-			ret = send_rename(sctx, valid_path, cur->full_path);
+			ret = rename_current_inode(sctx, valid_path, cur->full_path);
 			if (ret < 0)
 				goto out;
 			is_orphan = false;
-			ret = fs_path_copy(valid_path, cur->full_path);
-			if (ret < 0)
-				goto out;
 		} else if (can_rename) {
 			if (S_ISDIR(sctx->cur_inode_mode)) {
 				/*
@@ -4464,10 +4474,7 @@ static int process_recorded_refs(struct
 				 * dirs, we always have one new and one deleted
 				 * ref. The deleted ref is ignored later.
 				 */
-				ret = send_rename(sctx, valid_path,
-						  cur->full_path);
-				if (!ret)
-					ret = fs_path_copy(valid_path,
+				ret = rename_current_inode(sctx, valid_path,
 							   cur->full_path);
 				if (ret < 0)
 					goto out;


