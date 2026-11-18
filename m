Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027268;
	b=pPMcrTumxRclpzqbwRxYbsHpR6giGe151kPMd7JZAioQD/bPyMlFHdX6gBOVObasraw0
	 JCU5pUUdzkGK2fGRG5U/GCg9GUBlylTGCjHacMG1O7jrpYFjMDzgzgsjqom1HO66Q+e7a
	 gyFiQ+jF0pDKB03o/fLaSc7yDBOSgU/ggSCNqJ7JK33BA1oU1+z+Ge+KvDnQOjfHmFwsB
	 LdzgiAOQ1tMG+56sIWW1Ez4O9tL+x3RcVu1OOHY/EhRpQGakM1Nr17cw0KZeVIFPEIMMX
	 +L3TecNZksrNQ2skrdj6rq3WzoytcYUF3s48FbfBIEISQIKcsJUkg8VeNbgNk6g8v8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027268;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bU8Ty57/QQerv5C21ffHOE+Qk0V9vVUa8q2vEwM88Vk=;
	b=OdVpVvkp3N2WsaLRHOLZWmjEIuo0NbF7smEfFko39s207SimVenALX8rjMqGLEzveZn3
	 Br00fCEl8sNqLTpfN4F+YTLzOAQT/04SyBmSn2PnOO4E9memyURP+3C5UjtJQSd7sDJJ7
	 sQmPKPHOyOKsc27498kIX8fzk+XOa5VeXQvLqJnon0obG8aByoDkQ8kMl6iSfR3jaI61/
	 HQkSU7Ia2fkO4l6FKw8VTKm3WjFnDkL5anx688HmuCK97jnvRc+u/y+/gXb8AORZfs0Hr
	 d+El1tt/iZfquDArQxVanG/+rIOpLgA8ryvDGUl6Mtm1n3tV1ZgHzdzw8PFiZ8C1S7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Vbt2mOq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC27606A31C;
	Wed, 18 Nov 2026 18:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Vbt2mOq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 672B11F000C4;
	Wed, 18 Nov 2026 18:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027267;
	bh=bU8Ty57/QQerv5C21ffHOE+Qk0V9vVUa8q2vEwM88Vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Vbt2mOqk5UZ6RWM/BT+eU4yn1TEMVTfBK+nlw0ojBo+r2VRQvh537Bh0Z4664t+S
	 k5vuD5uH8rDLJK6BbUqYYGRd4XdZ+hrgQ2jn2KPiMg42HRWZNe5ecDozdhhEkShlzX
	 R6GXlPQ2IMKXWz/5d+hoJjOGwDikKS/ZALan2c7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tal Zussman <tz2294@columbia.edu>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1692/2151] btrfs: drop the extent maps of the written part of a failed ordered extent
Date: Wed, 18 Nov 2026 15:57:07 +0100
Message-ID: <20261118150223.464909465@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Tal Zussman <tz2294@columbia.edu>

[ Upstream commit bca2cf55a7331e6b0ff95ad47fc2a7e8ecc7dc74 ]

If a truncated ordered extent fails to complete, the extent maps for the
part that was written are kept while the extent itself is freed below.
A later read can follow them to blocks that have been reallocated.
Drop the maps for the whole range on error.

Fixes: 77cef2ec5484 ("Btrfs: allow partial ordered extent completion")
Assisted-by: LLM
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 6287e15bce110..c58bf3cbd41d0 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3316,6 +3316,8 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_extent *ordered_extent)
 
 		/*
 		 * Drop extent maps for the part of the extent we didn't write.
+		 * On error the written part is freed below as well, so drop
+		 * its maps too.
 		 *
 		 * We have an exception here for the free_space_inode, this is
 		 * because when we do btrfs_get_extent() on the free space inode
@@ -3331,7 +3333,7 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_extent *ordered_extent)
 		if (!btrfs_is_free_space_inode(inode)) {
 			u64 unwritten_start = start;
 
-			if (truncated)
+			if (truncated && !ret)
 				unwritten_start += logical_len;
 
 			btrfs_drop_extent_map_range(inode, unwritten_start,
-- 
2.53.0



