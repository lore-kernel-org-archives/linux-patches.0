Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D418854654;
	Tue, 26 Aug 2025 13:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213723; cv=none; b=hURNsldpLrsH25u3JiEEQcmQFXzoCYXcNylLR7iTaPskykIpB6KAm85y5EhvO7A5Vws0ymTwjUDc3p7/yDqMwcmxfL8XT+Kr1FxxZ4iG/Isu3V13E/qWgCg2fKiiSkoHAraYr3hwDPnBIEAunsnpmOa3wKOLwNuu/Pxtczm+UCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213723; c=relaxed/simple;
	bh=C1LoKWqCIwJwwb1734QQSspGraFP3V9lKyJh62Wmw0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KSRNEx49t9R3C6KVBCH1IP0D2JHlF9X3+twB3Pfg3G+YHJdwcho7wtx/tfLa8tOP5cQJ27xJcQphRwYf6Hch4riyKX3we2gi04J0yolIyLXk/2cFwXUQxCGCLYsJ4U/clokezbtVYf15IYgS5uMn+xGTY7duGxAjOVx8Ol5LtSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IJWeYf/6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IJWeYf/6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C643C4CEF1;
	Tue, 26 Aug 2025 13:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213723;
	bh=C1LoKWqCIwJwwb1734QQSspGraFP3V9lKyJh62Wmw0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IJWeYf/6qZFSe5s9WvOjX9DY8wPhjDBG9KI4LAa1OAUNsivxFQlKCKAE3ud/m4Wpj
	 qYHx/dvppDnyc/6R7xx/ZwS8E5Eux/J7JWtlsT5iA+i+8hyqldaGQIq2HvoduxfsBz
	 ItFkExrQT0dh3JBqs4P0dWdU/KMM74QTknFHGqXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 456/587] btrfs: send: add and use helper to rename current inode when processing refs
Date: Tue, 26 Aug 2025 13:10:05 +0200
Message-ID: <20250826111004.567606393@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4166,6 +4166,19 @@ out:
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
@@ -4451,13 +4464,10 @@ static int process_recorded_refs(struct
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
@@ -4465,10 +4475,7 @@ static int process_recorded_refs(struct
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


