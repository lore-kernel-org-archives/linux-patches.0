Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621902;
	b=5N/GN8cE57AryEa/J1Sq4argIfNS3djmSKCrxtMDf3rDg3P4zAYkCRrRuIu7cR5hl3+e
	 huwWFPjdwX50aPcXe4qvMVoyszsP6h4Sve9sAoDYFP4P1p+gWGNpcRyKcj9z8i304de6t
	 ukI0Pcq8uBUhFMnMnVf2tDnm753oqiOEC/OT46AlzsHgcSkDqYZEcZcvSYfsNI+B3ra9+
	 VTRMJbqNKsgUFdtTqnD6TiGmROuORgadZoxVxRNAESq4sns5RrIDkopk70FRyf4kRRDca
	 J64JwT4PP37qq0rNEAoss9E3EAferrRiHYnunu1V+/Zs/miR6dol4IceFr4ha/SJ6fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621902;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3n2iLOfWHorNFpetukHSpAI0GXTNCHylwzMk1aK92Lg=;
	b=W8MDF8CEeo/aN8YifToXblogra/aCS5jixB5EQkRwzzmb4z2zQR5OMjdL9KpD7xNphdK
	 XZmTxc7QhrAECLUdEcHiMmK0NnXFZ/84RjbV5BnbRFzszG94nkys8QNILc1ByiSC6NxBz
	 i83OYPnDJw3/2gYxccuZbTxPPAy6lx7Fc2HxeOt6Di9E0WJO3UHNJ/03BCu3LimJXXZiI
	 2aC/fr4wA8/kTvyPOsNtx9lxTggued7yGaIJJmxMoXLhmIpfcF7T7XzZCiMRejvSeXwPR
	 i+k8IkZk1phiTBv9JwpIUbwfqQcxkZmaIrRPNe2qvJb5bu/liYnzbTqD3hpng2w8Y/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PqW6h3aR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E5C606A321;
	Wed, 25 Nov 2026 15:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PqW6h3aR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4BA61F000EF;
	Wed, 25 Nov 2026 15:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621901;
	bh=3n2iLOfWHorNFpetukHSpAI0GXTNCHylwzMk1aK92Lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PqW6h3aR7F9vdQloEwzEAiHrrOhSx2sw8sJqQfUHXhuYFsYYxhqSRHVIAs/5jzqAD
	 RCXoL5iW6VhhGqye4n4gSFgi3Cf1B+z/AX77rKq+LMmvnPAk+B7P5L1eanHRioSO/K
	 PEBHrfUECvWkXGkkNlKDZIoLLs6p5o0jVzgbd5mY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 370/990] btrfs: zstd: prevent leak of workspace below maximum level
Date: Wed, 25 Nov 2026 15:28:57 +0100
Message-ID: <20261125143830.759652025@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit bb66a38f5812f2c04abd4eb6e586a12b5a95172a ]

When putting a workspace we always protect the workspace for the maximum
level from reclaim, since it can be used not just for that level but as
well for any level below it. However the logic is flawed because if we do
the put for a workspace at level 10 for example (maximum is level 15) and
there is currently no idle workspace for the maximum level because all
are currently being used, we don't add the workspace to the LRU list and
that can result in leaking it if we don't get more compression or
decompression requests for level 10 or any level below 10.

Fix this by skipping the addition to the LRU list only if the level of
the workspace matches the maximum level too (besides the list of idle
workspaces for the maximum level being empty).

Fixes: 3f93aef535c8 ("btrfs: add zstd compression level support")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/zstd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
index baaf3c1436323..ced6406425f9d 100644
--- a/fs/btrfs/zstd.c
+++ b/fs/btrfs/zstd.c
@@ -347,7 +347,8 @@ void zstd_put_workspace(struct btrfs_fs_info *fs_info, struct list_head *ws)
 	/* A node is only taken off the lru if we are the corresponding level */
 	if (clip_level(workspace->req_level) == workspace->level) {
 		/* Hide a max level workspace from reclaim */
-		if (list_empty(&zwsm->idle_ws[ZSTD_BTRFS_MAX_LEVEL - 1])) {
+		if (workspace->level == ZSTD_BTRFS_MAX_LEVEL - 1 &&
+		    list_empty(&zwsm->idle_ws[ZSTD_BTRFS_MAX_LEVEL - 1])) {
 			INIT_LIST_HEAD(&workspace->lru_list);
 		} else {
 			workspace->last_used = jiffies;
-- 
2.53.0



