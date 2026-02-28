Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279D836C9E3
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302300; cv=none; b=brAgbU6S7ziiyRLh2qupCk31XDqf8BEgbYKuT8xUM18mKpwHsj2XAaLzMs9aAJGPE4RHHc6dJZApUKG29m3tAo47kW3n8hC/dJl3/XBiDImJBl2eqlt/wEml1UqvAW9nkm5+aZvkemFwxy+bKMSIfslnc0NakTDEucxZJ6k3foY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302300; c=relaxed/simple;
	bh=E7jQ1cmHilSN//wnTmDTtLZUoofKbRBI3MHNirvBe30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C6Rw6P5OfWpPyR7OY5bUqL03mYODWFR4/0yDiKTXj0EYfZGV9tRyOKxyCF5btvxVs5+3vNS1n55hAwZhy0I9wVQ6sK2bxP8kyB7tVWTBd2iTVePDeWKrOUf/6cXO7/zU/nwjG0n0ILN3WLamRASaWRFFKCwQxFDEiclKUlcHpDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EGi+EUnU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EGi+EUnU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 711CEC19424;
	Sat, 28 Feb 2026 18:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302300;
	bh=E7jQ1cmHilSN//wnTmDTtLZUoofKbRBI3MHNirvBe30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EGi+EUnU3SNd+MO1+yjPvhXJsQxZF1cIK4EpsaYvFTAmEu/GMtUxvNA/KCTr8TNGa
	 UEAXwgiyoxqEuo2Tdra+n3RRdb8XjbXhivTdlubiKiiGgK9A+VSf4MEFtgyrok1q6Y
	 vPH8wVLlBHnXZvHpyzDfJxmmWE/Qz0LGmkRsRru8DXOfbzcvMBDvzrshiaZQXucveS
	 crkpmh8aLO9fr0mg2eNIc0ei0ZeZXq84nYmNAGr2+n85L4E5s38GJJ6WlF+1WEcwjd
	 lCIqoIlXjhn4ZJm/aJmtB4JY+zO+kJ1vKyrrJwsN0g97bjawl4BagTAuwf0LaUf5l6
	 27o8JGTJJupkg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 014/232] btrfs: qgroup: return correct error when deleting qgroup relation item
Date: Sat, 28 Feb 2026 13:07:47 -0500
Message-ID: <20260228181127.1592657-14-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 51b1fcf71c88c3c89e7dcf07869c5de837b1f428 ]

If we fail to delete the second qgroup relation item, we end up returning
success or -ENOENT in case the first item does not exist, instead of
returning the error from the second item deletion.

Fixes: 73798c465b66 ("btrfs: qgroup: Try our best to delete qgroup relations")
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/qgroup.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index c95902bf6144d..b175d0a4b3826 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1575,8 +1575,10 @@ static int __del_qgroup_relation(struct btrfs_trans_handle *trans, u64 src,
 	if (ret < 0 && ret != -ENOENT)
 		goto out;
 	ret2 = del_qgroup_relation_item(trans, dst, src);
-	if (ret2 < 0 && ret2 != -ENOENT)
+	if (ret2 < 0 && ret2 != -ENOENT) {
+		ret = ret2;
 		goto out;
+	}
 
 	/* At least one deletion succeeded, return 0 */
 	if (!ret || !ret2)
-- 
2.51.0

