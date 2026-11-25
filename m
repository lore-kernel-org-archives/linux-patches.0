Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618893;
	b=3RTvoLdwM5vwEOWaoGOgGfYHW4nUp0EF5zb5tXtqG/xXVO7c8l4tLIccgptLtoZ/XD6O
	 3VWBlO0NFQodsmsD+yZARJv3jsXlyBgkiT3F81nVgCcAKQWniK/HCD1CJu9hfGCPbCIgH
	 IWgxJ0VXZ5hpvnA23D6FiAZGDbZ4QcIKUPfW15plfSjait4xyofEW0rHpihc6ucoYUCtm
	 YwQM6/A7/KfrWt7qv7KDTniysgCKyNPSZIgX3WbzKliId5uD8GAXtUKdYfTR/1BXpienG
	 1eK8Q+D9AtnaTKwTlA9AkPwJcLOzKNwIjyyeQ264W1vIpfhHtIivMJxXccaa66lyhhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618893;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w+EhF85qjp3PkqV7N/SQWIdwCpTDYZ36He8PmK7Uwjc=;
	b=H2S57WplfUrOsF/rT6xgbzPKduZHKfVZprUouvwY1ZC6drA9UJmVktjVh37TmtzosyW+
	 G3kI1J5NCs4yEsHfw0T2FahqRIRtwjvIi0px7hkT/dyaac3sVQ0MoYbKlnrVaSRDINpSR
	 NhhKpIMhxiZJoqZNy0UWs4uEXLyeaepvYnbIze0u57dad1eoa6nU7xAYfBynvKblBxeYS
	 24NNkpS6Jfnli75TWaT2iuna77OBJKtWuno6x3YgjTM8rxIce/s562ir+8Pgf8/KbYzDC
	 L+TUWtn7/+TzblUtYY3gKhUMEhktN82J+3Miu4MVis6AYGkhxC1Z6uAWqvhILM183qA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j6Om+Sif;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD60A606A33A;
	Wed, 25 Nov 2026 15:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j6Om+Sif
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F991F000EC;
	Wed, 25 Nov 2026 15:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618893;
	bh=w+EhF85qjp3PkqV7N/SQWIdwCpTDYZ36He8PmK7Uwjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j6Om+SifgbJK52ZPAr6gTMUqthK+DtWR+VCSCnhEqdXVsCVNd/S55psPuz2BG8eiR
	 T/TFM6sJGN1jXyVAHWaMMnI760HEUYwQ8nfm5Nhk+RfOf4UCmnVCyjlwz8QvTqJp23
	 CGRBa5Mu+jEMnvxaHA5FHDAVq/BdWfgWW43hoMZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0423/1005] btrfs: zstd: prevent leak of workspace below maximum level
Date: Wed, 25 Nov 2026 15:29:21 +0100
Message-ID: <20261125143831.663543599@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 58d9ff76fe07b..082f653464c8e 100644
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



