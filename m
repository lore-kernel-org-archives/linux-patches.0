Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA1E8F5B;
	Tue,  8 Jul 2025 16:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992262; cv=none; b=VgjUWHdppvpXP4Fs9+JQvxxZzKMfxsX5L5i2ejpvFwPKAu32ZrGUR1uidn3abygfBfmryNJVIFIIejgjxAX+TJSIFN83xzoX/+QOs47ltXOfKhZTffrQBzQQo7vbYmzBO9ms9PZ7QGZVVobLy7CqAHLawHWr+n6ORvF7HpvuxjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992262; c=relaxed/simple;
	bh=55ptjGYls/GvxHNHRYC9zXs8g5QohoZoOVC7A2oHGII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AvEaf4Pbmle8ZWWMLilaZEgDHorWIByJj2zC/uqiwvq4/vP6ZCSceLoaEhWY0NMOnrOKrIvDXOIbuAWaqkPxwfB7UglaUQfwxebg3Fx3q0ewNWogzqLHf41FociHdqSXrkO+smE7LjnYkhjg5mA7LtjT5fOFFTpuv+GoqEbw+Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=teGo6lhZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="teGo6lhZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB64DC4CEED;
	Tue,  8 Jul 2025 16:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992262;
	bh=55ptjGYls/GvxHNHRYC9zXs8g5QohoZoOVC7A2oHGII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=teGo6lhZpLzjq6hrWaZkwK5GepqztJAglpDJuD0NoOxg30D2wyNjPEO0+XbOfEyBT
	 WcWeY4IUxn/dIEWQcVL2R2m0Y4ZD4SRuTg5jQse8t97wthcavJynW79m9Wg37EMOfb
	 OSC6hLWnQqbKHQ+1nBKzXEZwSLJHkkX44jTfHt/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 032/132] btrfs: fix iteration of extrefs during log replay
Date: Tue,  8 Jul 2025 18:22:23 +0200
Message-ID: <20250708162231.645566400@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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

[ Upstream commit 54a7081ed168b72a8a2d6ef4ba3a1259705a2926 ]

At __inode_add_ref() when processing extrefs, if we jump into the next
label we have an undefined value of victim_name.len, since we haven't
initialized it before we did the goto. This results in an invalid memory
access in the next iteration of the loop since victim_name.len was not
initialized to the length of the name of the current extref.

Fix this by initializing victim_name.len with the current extref's name
length.

Fixes: e43eec81c516 ("btrfs: use struct qstr instead of name and namelen pairs")
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-log.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 6dbb62f83f8c8..13377c3b22897 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1162,13 +1162,13 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
 			struct fscrypt_str victim_name;
 
 			extref = (struct btrfs_inode_extref *)(base + cur_offset);
+			victim_name.len = btrfs_inode_extref_name_len(leaf, extref);
 
 			if (btrfs_inode_extref_parent(leaf, extref) != parent_objectid)
 				goto next;
 
 			ret = read_alloc_one_name(leaf, &extref->name,
-				 btrfs_inode_extref_name_len(leaf, extref),
-				 &victim_name);
+						  victim_name.len, &victim_name);
 			if (ret)
 				return ret;
 
-- 
2.39.5



