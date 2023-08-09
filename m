Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB416131
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:48:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E7D3C433C9;
	Wed,  9 Aug 2023 10:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578139;
	bh=dk81vCqohTaPvaOOFtcRier1qAN6MN2cQtCUgo6yIpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bJtpJekLGr0/1R/l9y8XOUzspYr1cuQG16oWKoHhaO1EyekeH+cGy8tnoYCwSGjtq
	 iVL40QuYNd0adh2qJ97FC2MnD1mXzfTWlttFZc7isp6NMtLAXOrl5tgGyI+plSWZ2q
	 f14mZzuNR1CyiBvK32RsELZufQEN73JiMZIZsoGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.4 119/165] smb: client: fix dfs link mount against w2k8
Date: Wed,  9 Aug 2023 12:40:50 +0200
Message-ID: <20230809103646.698628413@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paulo Alcantara <pc@manguebit.com>

commit 11260c3d608b59231f4c228147a795ab21a10b33 upstream.

Customer reported that they couldn't mount their DFS link that was
seen by the client as a DFS interlink -- special form of DFS link
where its single target may point to a different DFS namespace -- and
it turned out that it was just a regular DFS link where its referral
header flags missed the StorageServers bit thus making the client
think it couldn't tree connect to target directly without requiring
further referrals.

When the DFS link referral header flags misses the StoraServers bit
and its target doesn't respond to any referrals, then tree connect to
it.

Fixes: a1c0d00572fc ("cifs: share dfs connections and supers")
Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/dfs.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/smb/client/dfs.c
+++ b/fs/smb/client/dfs.c
@@ -178,8 +178,12 @@ static int __dfs_mount_share(struct cifs
 		struct dfs_cache_tgt_list tl = DFS_CACHE_TGT_LIST_INIT(tl);
 
 		rc = dfs_get_referral(mnt_ctx, ref_path + 1, NULL, &tl);
-		if (rc)
+		if (rc) {
+			rc = cifs_mount_get_tcon(mnt_ctx);
+			if (!rc)
+				rc = cifs_is_path_remote(mnt_ctx);
 			break;
+		}
 
 		tit = dfs_cache_get_tgt_iterator(&tl);
 		if (!tit) {


