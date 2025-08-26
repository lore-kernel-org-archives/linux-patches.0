Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35901E51E1;
	Tue, 26 Aug 2025 13:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215030; cv=none; b=E8JNYTwMymAVe5E4WDxcKV0DnpHzPBIQc2tsFUUndDqldgmfzrpwQIAF5Un2XZjmfyMDwLdfw3JYBBix5oTrR23Zp/4KXbX3RYtudILdyYcm1y8IahgDGrC9nUc9xz/GY8Je+8Mgo5aYI62oNEQxCgzaHTIPs0sTJn5vaAl6iso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215030; c=relaxed/simple;
	bh=MnbyQDFnk+kTuNXHstk7Iya+/EE5KgdZnzAWTOj2DVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uLmC/iEfsWDXpwf+J6TbhDRnu735OgpZIScNJ7qpSlHPnBV4VGp6dycDlga3hFN8DP8NG1mZE1epJ40lK9ifvVvFqoc+e+kyH59ojVjfVjw2A03fxxmaRV+4fIZaMfGlW+k6eVr++Opj1sNLAx9zF3DsM6+JpQHRQ//OqkBsr28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BWwcfUv0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BWwcfUv0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72FDDC4CEF1;
	Tue, 26 Aug 2025 13:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215029;
	bh=MnbyQDFnk+kTuNXHstk7Iya+/EE5KgdZnzAWTOj2DVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BWwcfUv0qN78bR3+2YFt3Qo/qLn/j5KFysfhWtAArP9Yu2s7FW2HxFAGyOs6VDquw
	 a5+BTIJzhwCsIZ15IIoUIwpesbtcx0oYPupVdrJdDLc2ihraxynMyPq7OGESim+rnY
	 v34EISzfkg9Cffi/qSwvF78vyNhMt6yicoPzVO8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Vacek <neelx@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 361/482] btrfs: abort transaction on unexpected eb generation at btrfs_copy_root()
Date: Tue, 26 Aug 2025 13:10:14 +0200
Message-ID: <20250826110939.753957954@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 33e8f24b52d2796b8cfb28c19a1a7dd6476323a8 ]

If we find an unexpected generation for the extent buffer we are cloning
at btrfs_copy_root(), we just WARN_ON() and don't error out and abort the
transaction, meaning we allow to persist metadata with an unexpected
generation. Instead of warning only, abort the transaction and return
-EUCLEAN.

CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Daniel Vacek <neelx@suse.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ctree.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -237,7 +237,14 @@ int btrfs_copy_root(struct btrfs_trans_h
 
 	write_extent_buffer_fsid(cow, fs_info->fs_devices->metadata_uuid);
 
-	WARN_ON(btrfs_header_generation(buf) > trans->transid);
+	if (unlikely(btrfs_header_generation(buf) > trans->transid)) {
+		btrfs_tree_unlock(cow);
+		free_extent_buffer(cow);
+		ret = -EUCLEAN;
+		btrfs_abort_transaction(trans, ret);
+		return ret;
+	}
+
 	if (new_root_objectid == BTRFS_TREE_RELOC_OBJECTID)
 		ret = btrfs_inc_ref(trans, root, cow, 1);
 	else


