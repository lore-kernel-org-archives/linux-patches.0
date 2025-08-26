Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E0F17332C;
	Tue, 26 Aug 2025 11:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207540; cv=none; b=R6u9ukq8vQLEFmJ1omAbdfVHMkBjVs+65bR3nA/Jvd7fhT6EbQKUT9nJAy0u6ywdM6+nVFL6R9PPNsgCENO2k30OQ5h29pOgwSNNpeFGggvMhuN4u4pPYDd3eJQzn1GDJbRztezAGC/ZzEjWlbUeV4L2vhX7wU1mDFqTzVeHMrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207540; c=relaxed/simple;
	bh=t4lzVz4WuJBNiDjFP+HlD9XtZS57a0X4rOTKau76KYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cpc7ut8wMcTai/jv6xHH+HU+pdZplVZyKax9nVWubH/TDZU3S0eG1fOkLR3EMFW26A/g4tueNXbKc9FVQuWzEs373vcR3xgsDrpbK00qqxy2WglkRaO5jlEL3aWkkKY8EwbbmRv4SqG/dMsAcE0cjEd/pyH4iBkeemq/FQtfA+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cN2MYphr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cN2MYphr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07895C4CEF1;
	Tue, 26 Aug 2025 11:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207540;
	bh=t4lzVz4WuJBNiDjFP+HlD9XtZS57a0X4rOTKau76KYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cN2MYphrWwHo9Vvf/3qZWtRT2oa/P8hBJAJiyusjlUX5luAmlCe/w9WUgmekTzhIC
	 cCxMfZzpzdxjcLmph5PVmyy+L+VVUEetAnOdpEjJlDzWieME4w35MT3IKma75MaUiC
	 KNa8oJWQbOmxeG/LscdaEFwOc2o9TgfiL7n4qbJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Vacek <neelx@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 214/457] btrfs: abort transaction on unexpected eb generation at btrfs_copy_root()
Date: Tue, 26 Aug 2025 13:08:18 +0200
Message-ID: <20250826110942.653075162@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -283,7 +283,14 @@ int btrfs_copy_root(struct btrfs_trans_h
 
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


