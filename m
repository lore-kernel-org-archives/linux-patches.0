Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216466;
	b=pX4VBV72c3zovgAr7k/KeyMit+ZcnJcUZWet+nbfGjGneLQHEKYDmbsjdM3wHl38AdjC
	 KQzjerlx3UNdP0PDODlglnRIeEMt/1zUqI364dGSBC7e/dIEW15BDXkhuvclVeN51WEyf
	 MptsRAw/b5/1oT8npO1GkME6ekh2Zs/keXBIyIzXoSPxMzM/ZYF2TAaIr2/PIgkPetpsX
	 LfpqOQF/VvPtKlMXaBQGtFGXxJp+JW9F7ZDCTc1vdL2YvsEEHIsBNU0SBjZXirbzVPxOn
	 Lmmhb/G1No8NSAkQyJ0i68XxYgcSA0Y5S22v6OCg/OgD3KTloFHC1LceBDv3vd2+ptw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216466;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YfaizDnQkKn1EZpJfr4phO6UJO7eNOHMw3XbpNts7B4=;
	b=tO/OzxmCo8rDpnhc0mTm5dW7vFk8z2Um1maWcURtvTsSLF9VfeDObqT1m//phgvpLR5p
	 qNyPJWvE/LmsMzRu4EpEf1km6JUhVFfy4wfyYs/VdAw8Cp4PSYZET8A9pLkH2sW1M6+Vd
	 u8ZQODG5YUpPIkLJtbaK9qBLIoLJ7LuJq95ZjfUsQ1WKfSfA5j/N5uHTie2fNv6TI+21N
	 wI51XliujYo7MDrFhUlyA/4iY2yO4M287nPtm4lwyuutepiiwWdYNMI7Si49VGv+ObZfb
	 F+9U2aZ0y/WQx1SZhsDYTXB//ed+LrLfidL/XGLtp41xc8adedmIXQRInPee1g2VJtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="nK6rJO2/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF41606A32E;
	Wed, 28 Oct 2026 19:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nK6rJO2/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED2E21F01828;
	Wed, 28 Oct 2026 19:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216466;
	bh=YfaizDnQkKn1EZpJfr4phO6UJO7eNOHMw3XbpNts7B4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nK6rJO2/WobE/cOx2jwbNzdS/l6iB1eGWOiw0aJyNmTo7aCxcmOWrLHMeDrXkamye
	 hOG6olXHY6HAr+FmtJfuubLo0Vk+NwGUJeu/4wrAdZxBHzKR38ava1RhoMkBVRDhzw
	 fQlOFNSd4KVI9/9oUTTzZLt3tuDsG7/EjsP1bXsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1567/1887] btrfs: qgroup: fix a wrong length calculation in qgroup_free_reserved_data()
Date: Wed, 28 Oct 2026 18:01:03 +0100
Message-ID: <20261028170535.126377193@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 9102b179512e11644fb0489ae62010a09afa199c ]

In that function, we round down the start position and round up the
ending position.

But during the calculation of @len, we use "round_up(start + len,
sectorsize)", which is the rounded up end position, not the rounded up
length.

Which results a much larger length, and later we are still using
"start + len", which is completely incorrect.

Fix it by declaring a local @aligned_start and @aligned_len and use them
instead.

Fixes: bc42bda22345 ("btrfs: qgroup: Fix qgroup reserved space underflow by only freeing reserved ranges")
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/qgroup.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index e927111567fa2..ff3cced9eff02 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3878,12 +3878,13 @@ static int qgroup_free_reserved_data(struct btrfs_inode *inode,
 	struct ulist_node *unode;
 	struct ulist_iterator uiter;
 	struct extent_changeset changeset;
+	const u32 sectorsize = root->fs_info->sectorsize;
+	const u64 aligned_start = round_down(start, sectorsize);
+	const u64 aligned_len = round_up(start + len, sectorsize) - aligned_start;
 	u64 freed = 0;
 	int ret;
 
 	extent_changeset_init(&changeset);
-	len = round_up(start + len, root->fs_info->sectorsize);
-	start = round_down(start, root->fs_info->sectorsize);
 
 	ULIST_ITER_INIT(&uiter);
 	while ((unode = ulist_next(&reserved->range_changed, &uiter))) {
@@ -3895,12 +3896,15 @@ static int qgroup_free_reserved_data(struct btrfs_inode *inode,
 
 		extent_changeset_release(&changeset);
 
-		/* Only free range in range [start, start + len) */
-		if (range_start >= start + len ||
-		    range_start + range_len <= start)
+		/*
+		 * Only free the range within
+		 * [aligned_start, aligned_start + aligned_len).
+		 */
+		if (range_start >= aligned_start + aligned_len ||
+		    range_start + range_len <= aligned_start)
 			continue;
-		free_start = max(range_start, start);
-		free_len = min(start + len, range_start + range_len) -
+		free_start = max(range_start, aligned_start);
+		free_len = min(aligned_start + aligned_len, range_start + range_len) -
 			   free_start;
 		/*
 		 * TODO: To also modify reserved->ranges_reserved to reflect
-- 
2.53.0



