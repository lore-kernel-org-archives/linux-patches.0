Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39799283FDF;
	Tue, 26 Aug 2025 11:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208610; cv=none; b=F8QJYd/9ds12ComQ/EZZYzXeseA4rNk7pPak8POZxTIiZM40U96jGf+apEp2Z5/w3iYExKNMrdteoKyKY9jzp6NjajpT9tEI+meZJBHAC6cnMO3kC0IFDfh6sLLL1txV+7TvaItI/346nEV1HohIauv03mV0OW/tqP2r69LWiVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208610; c=relaxed/simple;
	bh=AJa/63EnNvZeKtMUmM5hl5SgJQTiW7LNH9GgBOLCihU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MGAUtXBxDrk7Gzw+2cG2wTAqlf7RrAApX7/nRAWk1UfbinMKUbHZFz1PW/Ol+1tHIBSyMiyOgIyK6i9RtufNLM80BbVPa2IIfhUeCu5O86SEvSUW+c8ApLgx2VoJWw7r0ofpc/ubGOFnvENtuOVasnvO/jxtnaeEWUw8Dwzb93k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0PedGTlI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0PedGTlI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5774C4CEF1;
	Tue, 26 Aug 2025 11:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208610;
	bh=AJa/63EnNvZeKtMUmM5hl5SgJQTiW7LNH9GgBOLCihU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0PedGTlIQhzN54fUxqpQ4lAyF2xU7GUSKdXxCjzJYoC5TmrBhUO/qCtZNer4tCgB/
	 eKxfTmgr9ma8C2qDeGOkRuAmGFxg4yIwxXEdnF4rDudflcGReSjLE8UHwxn+ucbD26
	 W1T7cQx1W+bNuR8o3r1ryumR9gVcJlh3uLJ1yl0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Vacek <neelx@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 146/322] btrfs: abort transaction on unexpected eb generation at btrfs_copy_root()
Date: Tue, 26 Aug 2025 13:09:21 +0200
Message-ID: <20250826110919.410230324@linuxfoundation.org>
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
@@ -350,7 +350,14 @@ int btrfs_copy_root(struct btrfs_trans_h
 
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


