Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032247;
	b=O0uBa4Z0JBCwXNka8ZiTuTI2/LO6U9Kh6eVweQeOyOJJbMAXp9SBIfBriFOI9iC4hBSb
	 JTUzrwXMUuW7VjWAVpwVbZRxEblni+7iwx3TT2ysTofUsNrfgNryGdoKizpgL9dEhntAv
	 lyflrA3wgR2pMfmihInHTeDYIN5a1c0LABDNgMN1b3oO1APoFpE74Kwr13uZCL0DmN4EM
	 wYoq9TofMmnf+Ikjov/+Q4sTmnE0THyd43arV+Fu4WgnPCsS7Jzw99ZdgZ+hXXSVZYdSC
	 WvzO6YTlphFcyPC46cv5i5F6BZtxiBi2il0HsynKnYBlzdsdUYcw0ANp1mpvVi3FXPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032247;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sskD7x/i6CAPEtkSj4M2uuqxGqDyln5dE2NYFPB+Hd0=;
	b=VzP28Kd+6Po9xu6sWEmn9qLzIItTjmrlJDq4tO0ngnsKQ0MgY8cB3XCwGxY9FElmhclO
	 KC5SGW2PXUqb3lYdLO6PFcIHlGT1Dqqc+OeDmHn8qmb8bgWNbd1LaANph5q1edrXmTUE3
	 lIYxnX2e6c6EBKAzFFSjMIgI6SzMD5AS10rvnQPRpD9QhiH8yZm2ciMe4kXNUr20581i4
	 /JGQSqEtn+pMg+fmWpqwZMm/CO9F+dORCQaXn/j5BWXYzyZjA88Yp3wy0TbmdNTzh1zRF
	 w4aw3En/rb3yz4KQm3YjZ2w4IpwHy2jHVBu8S8ZPC8D7YBMp99mmKmY2B9BXB01nNCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2k48LoJH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8747606A330;
	Wed, 18 Nov 2026 20:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2k48LoJH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0948A1F000C4;
	Wed, 18 Nov 2026 20:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032246;
	bh=sskD7x/i6CAPEtkSj4M2uuqxGqDyln5dE2NYFPB+Hd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2k48LoJH6yOrBY/sczUckvpTBlyCd0hnei+lKDAs5BPqDnxwxzdB5wcWcG4aL/aDN
	 TcStNN4jf4ThwSpPzJDZI4kMoM1cKbOh0Nj8YlOpPQvTzCKkuCE1ossPz0e1RcLn4b
	 Yore4lqHGeMTq56HDnCM8XNXkETvc9Fu8WKJAgLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tal Zussman <tz2294@columbia.edu>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1344/1756] btrfs: drop the extent maps of the written part of a failed ordered extent
Date: Wed, 18 Nov 2026 15:57:51 +0100
Message-ID: <20261118150102.843915160@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ff7dd3f16f4fc..dc9c1ad9b6ac3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3190,6 +3190,8 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_extent *ordered_extent)
 
 		/*
 		 * Drop extent maps for the part of the extent we didn't write.
+		 * On error the written part is freed below as well, so drop
+		 * its maps too.
 		 *
 		 * We have an exception here for the free_space_inode, this is
 		 * because when we do btrfs_get_extent() on the free space inode
@@ -3205,7 +3207,7 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_extent *ordered_extent)
 		if (!btrfs_is_free_space_inode(inode)) {
 			u64 unwritten_start = start;
 
-			if (truncated)
+			if (truncated && !ret)
 				unwritten_start += logical_len;
 
 			btrfs_drop_extent_map_range(inode, unwritten_start,
-- 
2.53.0



