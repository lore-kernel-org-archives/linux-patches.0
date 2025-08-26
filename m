Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E67427EFE7;
	Tue, 26 Aug 2025 13:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213722; cv=none; b=mixv7gZf5yatm0LJwcr1GALql18jYoLfFZgGZSi27fepniVcL4UHdSUu/qAlMEEs8S7DfgxpTHug9RtZxHjC1RmEgX0It1u6YLTkwXmuxIceai6nWZcvfsev8sClDO+HodL05UlzmbEunHO5kL6MRN9YIxyVB8bJm8ci33wnTxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213722; c=relaxed/simple;
	bh=foVhemS0ESquAHrYGZEhRhHcX2CGc86G99anwlNPyAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UjuO+VkWsEkb8DHtH1hv5M+Q3SiWLYldVEIL3x8Sqsb+LPSofDECoFWXO8KTTUCNb0XPd2zT1iluYAlyicte96HtT3e2sryJAt8hIt9aGJ/I0sEsm0fK4qXBi+F/sgFtsYV+JgOqxSMQTk7DyKFE77nN9v4gg/wXj7DmLW4+Tik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SBs6dYPK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SBs6dYPK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7E9AC4CEF1;
	Tue, 26 Aug 2025 13:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213721;
	bh=foVhemS0ESquAHrYGZEhRhHcX2CGc86G99anwlNPyAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SBs6dYPKSN2ABFo0q3jI1Nh6x0J3ZoqEhMyIIdJwm0zhE19gYmMzb8kRST85sTDs6
	 /NLHnsMnG6MvOffiIuLnI0UJIcUsL9HPkHfKY8BObGsLhJPQ/tsOk13OgKPfqOxqez
	 9ouuKbmKlmOMD6SxmOnweJmWB9gUV641nrDLMdSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 455/587] btrfs: send: only use boolean variables at process_recorded_refs()
Date: Tue, 26 Aug 2025 13:10:04 +0200
Message-ID: <20250826111004.538391338@linuxfoundation.org>
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

[ Upstream commit 9453fe329789073d9a971de01da5902c32c1a01a ]

We have several local variables at process_recorded_refs() that are used
as booleans, with some of them having a 'bool' type while two of them
having an 'int' type. Change this to make them all use the 'bool' type
which is more clear and to make everything more consistent.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 005b0a0c24e1 ("btrfs: send: use fallocate for hole punching with send stream v2")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/send.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4180,9 +4180,9 @@ static int process_recorded_refs(struct
 	u64 ow_inode = 0;
 	u64 ow_gen;
 	u64 ow_mode;
-	int did_overwrite = 0;
-	int is_orphan = 0;
 	u64 last_dir_ino_rm = 0;
+	bool did_overwrite = false;
+	bool is_orphan = false;
 	bool can_rename = true;
 	bool orphanized_dir = false;
 	bool orphanized_ancestor = false;
@@ -4224,14 +4224,14 @@ static int process_recorded_refs(struct
 		if (ret < 0)
 			goto out;
 		if (ret)
-			did_overwrite = 1;
+			did_overwrite = true;
 	}
 	if (sctx->cur_inode_new || did_overwrite) {
 		ret = gen_unique_name(sctx, sctx->cur_ino,
 				sctx->cur_inode_gen, valid_path);
 		if (ret < 0)
 			goto out;
-		is_orphan = 1;
+		is_orphan = true;
 	} else {
 		ret = get_cur_path(sctx, sctx->cur_ino, sctx->cur_inode_gen,
 				valid_path);
@@ -4454,7 +4454,7 @@ static int process_recorded_refs(struct
 			ret = send_rename(sctx, valid_path, cur->full_path);
 			if (ret < 0)
 				goto out;
-			is_orphan = 0;
+			is_orphan = false;
 			ret = fs_path_copy(valid_path, cur->full_path);
 			if (ret < 0)
 				goto out;
@@ -4515,7 +4515,7 @@ static int process_recorded_refs(struct
 					sctx->cur_inode_gen, valid_path);
 			if (ret < 0)
 				goto out;
-			is_orphan = 1;
+			is_orphan = true;
 		}
 
 		list_for_each_entry(cur, &sctx->deleted_refs, list) {


