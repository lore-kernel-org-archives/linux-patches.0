Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019724;
	b=rIlkLssxFnzUT8r/iq+5BvGKoXJXZp8DqxcKI7NXrADA0oafd9kbOXiJaG5Zk/8qEc3F
	 SYNw/3puP+uk5CoaIrgQi5fvEXldPG8sOdqdZZ/2yk4toPqfQQmCwwh3P+hMQOMJdKGMO
	 iUYs3JfGnqAvJbJz2/AmvZk3eiWWTosp94UU94IOkNUdzmo0xDNldO8D4dur7nOGW+kIc
	 IRpUWhWvrTwa5ay6ZkrSVBNImrZFov4y+mgc0TiNyNImcceIa90Kwm3i4kg6Wn/SB+RsG
	 e9wdHeQ8MjvF2ljFOL+8GY1Qy9PzCWdtYopI5Hk5O/9gX6Xe4tJzZlcg2Dxr3f/obcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019724;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tSfSppPSpGeN2g5ABPeed74bC7S+jOVYAaLT7aXhOYU=;
	b=csJEzI4l0ScUK9N76oWuje84YXYxXfPEhtEpD+ezl8tullMKECanvdyo6urttxFeDg4P
	 KVhQZFoOIKozP2U+1yYbOcEWaVn+wSJBfYzSHNIuoaUiQhh0RuR1oLiQzLkybR7CDFtVo
	 0oqCuPVY3DylZ5+v8wA/8duQVLb4eP13TTGYj2X37R6/c4ryPhxaEvHDSTXpVY0cawstn
	 f2F5ASkgwDvB2BntfS/DhmWAsOltql2QRBjGu1sTG+gp0IGVdoeYAJzlTew2voAbT3jg5
	 DdI0F2cuh0GW32Kpy1kCUjE/BA8aJ/dkpEkGRv+y5PsCs3JRyw3t9jm0KT9yjpvakmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="lY0/Lq5K";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2212606A31C;
	Wed, 18 Nov 2026 16:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lY0/Lq5K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 145AB1F000C4;
	Wed, 18 Nov 2026 16:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019724;
	bh=tSfSppPSpGeN2g5ABPeed74bC7S+jOVYAaLT7aXhOYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lY0/Lq5KT38yjNvgD5vOQXDkQS1MeZsUE8HHIGm+njMDQKJRgCxP2ReVYnOOwiOUY
	 GxfhztoJ5mOwaSEaxdoa/7Lv/F6vyfbfkB83F8P+X/jN3CCVOpO9PR/VxCP5wfYPAZ
	 Nj1GmH4Ik+eTlfo5mudBQyMmjW9PXYfuiq1Np5SE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1661/2651] btrfs: fix lost error return value in btrfs_alloc_logged_file_extent()
Date: Wed, 18 Nov 2026 15:48:21 +0100
Message-ID: <20261118150347.534703531@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

[ Upstream commit 784cd5a83476c6c720521f21350fb823928555ff ]

If we fail to allocate a reserved file extent we then call
btrfs_record_squota_delta() and assign its return value to 'ret',
discarding the error from the failed allocation attempt and allowing
log replay to proceed as if no errors happened, resulting in some
replayed file extent item to point to an unallocated extent. At the
moment btrfs_record_squota_delta() always returns 0 (success).

Fixes: cecbb533b5fc ("btrfs: record simple quota deltas in delayed refs")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent-tree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index d6a4390ee34ac..aa423c690af2a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5227,7 +5227,8 @@ int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
 					 offset, ins, 1, root_objectid);
 	if (ret)
 		btrfs_pin_extent(trans, ins->objectid, ins->offset);
-	ret = btrfs_record_squota_delta(fs_info, &delta);
+	else
+		ret = btrfs_record_squota_delta(fs_info, &delta);
 	btrfs_put_block_group(block_group);
 	return ret;
 }
-- 
2.53.0



