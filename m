Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C273A2AEA
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302669; cv=none; b=F3ToDZ47wtyEstANUB1USHY/q3pSicbEouXUAzVUp2RCZKwfW0n8JhiYQ3Z8spsp1B2VNn9ajd+VFkwJub1aOinKLJ7UWi22JlciwKU64S8X5Lr/cYkXTVcY8Pqc/7j5UZFjWzD5S1stBAXja07k0mqMku+1Ny7Yaq15VaTq1DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302669; c=relaxed/simple;
	bh=OPuRuTdrJOuT51mCbrQ8fDMppnrxu8hLZ606kutHE4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JZWFBAP0J00MROyihDqcRZbctbaHECLNpKBxBKKBpueer0nPMyo+hgIgAC0XOm1fTj9WYhrQitssyDJUXwygkZg+pqIHw9Z050EJecSy1/oKJZG6kRCRgarcOvEzLv8nCVaEPiRzHARzmjOG1bw9iMYw7Jyc69+z0/Q+MWBv65I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pG+dgIyT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pG+dgIyT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14997C116D0;
	Sat, 28 Feb 2026 18:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302669;
	bh=OPuRuTdrJOuT51mCbrQ8fDMppnrxu8hLZ606kutHE4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pG+dgIyT7E7GJ3lW33klpH41omHlPDDvRzpHTJ6pznLTF3LCzyYvGE5Aawy/44z1J
	 Ybc2Sn4+QLiuf0tlvq609koJBe5mXURWMTnKMxPL83tPJp+/v3cggD/ORO6pHjZMEu
	 ytsW1DucpRQz+92YiEftzHhEpE1ffIVoi/hx9GSaE9K4D2hUX/4bvv8Lc/xPA4J2rD
	 p5TSU15lJjx4p43ES57ngI3UxfHhptslxkc9nvIoqAeo1QNYoynAfdrOWOidH9k4zG
	 +0E0ELLaxYpmrZ1d/Gc6X+hp1uR3H0SFlfQJ98XHw+u+2rrvnEgyrwnzkDHYVwTCe+
	 48FH5zfsieS2g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 017/147] btrfs: qgroup: return correct error when deleting qgroup relation item
Date: Sat, 28 Feb 2026 13:15:25 -0500
Message-ID: <20260228181736.1605592-17-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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
index bc1feb97698c9..647feb72c8b0a 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1540,8 +1540,10 @@ static int __del_qgroup_relation(struct btrfs_trans_handle *trans, u64 src,
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

