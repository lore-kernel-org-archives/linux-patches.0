Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7BA51A0B13;
	Tue, 27 Aug 2024 14:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770411; cv=none; b=eEYni6P+hR1lDUq1XWrBqKbszp08Rx5ZQowUbm7p9m2Lrt2ZZBOY6BM87On0Jlj+S/fKrW9FZJCqtxFfg1Ue5x1hlMYavrXxd/0q7TY+FMtosj4Ch3G9qnv/6iQJwU05bRfVuU2PX7+kRU8R4T8jwOrrq5zTrlEN88SFODDrofo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770411; c=relaxed/simple;
	bh=ND2C0f+2tE6RUiFf+cHlhxWgknctT9ziN8NFuzvIu98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S2odohkO3QNSpmPG1hbAOEbD6+7yEGldC+FQnMBQlzFcVTq/qud79CEWKfo0I8v8e6ZRHVC0mDYDVudfq/4yQYdNht7tGTh+wUY41gRQlpWT4GPBiUgNtKdZlW924EP30VYl0Het6OH8FHRQQdWn7/z/l6IZgjDFgdopk2SR1wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EzMqhnKq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EzMqhnKq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2167C61056;
	Tue, 27 Aug 2024 14:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770409;
	bh=ND2C0f+2tE6RUiFf+cHlhxWgknctT9ziN8NFuzvIu98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EzMqhnKqYNoHFwQ/6yI0eHbCsLZxK1e2Bmt4r7018eFSRBJQHybVrvRFEiNU89tmP
	 aKUNgHGJbJ79lktKo1jbAtzRZ2IHL+SaMm7edbqqH3l0cPqEJHVmms+455XGqplRDE
	 HvtE5M7O+G4f+Fj74wcl/mLZCJImw2kaCk7+oHuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 189/341] btrfs: handle invalid root reference found in may_destroy_subvol()
Date: Tue, 27 Aug 2024 16:37:00 +0200
Message-ID: <20240827143850.604011609@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: David Sterba <dsterba@suse.com>

[ Upstream commit 6fbc6f4ac1f4907da4fc674251527e7dc79ffbf6 ]

The may_destroy_subvol() looks up a root by a key, allowing to do an
inexact search when key->offset is -1.  It's never expected to find such
item, as it would break the allowed range of a root id.

Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index dff47ba858a0a..7071a58e5b9d4 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4374,7 +4374,14 @@ static noinline int may_destroy_subvol(struct btrfs_root *root)
 	ret = btrfs_search_slot(NULL, fs_info->tree_root, &key, path, 0, 0);
 	if (ret < 0)
 		goto out;
-	BUG_ON(ret == 0);
+	if (ret == 0) {
+		/*
+		 * Key with offset -1 found, there would have to exist a root
+		 * with such id, but this is out of valid range.
+		 */
+		ret = -EUCLEAN;
+		goto out;
+	}
 
 	ret = 0;
 	if (path->slots[0] > 0) {
-- 
2.43.0



