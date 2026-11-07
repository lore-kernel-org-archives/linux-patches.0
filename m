Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060922;
	b=5tlNUJcwSa00F6bp5Ehg/klba8+QDJk/X3/kvDF2AeFrVlRjUWlxuKTbZ8oO9hAn5zSD
	 mmgxeKCag5keA6fQtzT5S1Y1yr6NdeWiYSRvf/bmU3ldV+y6ruEV+sQy1nJE6mPh8/t0f
	 RZR6fzcTEbgxh8iriCsZ/bd9Zj2Ki18t2E4Yc3b15wtFJr09e7EFG1Azsv47x8FdY8bmX
	 emwgNhtXTBWjCMkKUvCQJRxaNR2JGvMF2jpUdEVDi03l5ldEn6HpeBZ+OB90THgTrfd8T
	 Ll9XCjo+BgXUivTNuuqVdCi+dd1CW2vre31NxQLnkN4gPr52r5PDpA932vh3cadpEVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060922;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KB7Tr4InIJbQ9niXEKBl68M9RwHfau25/09eI/3w+Ls=;
	b=KgKxynG/rA88b/IUFkV3+qdH6KXinoKoivZMRfn4cUNwrOwuFpHnKRcQEBEPX4DCzS0F
	 g4ZsEglMebVOyGfMnAIasH2NYejXFE5paJeJ5UyLMopbPefwwgJAt7ggD5pOq7C3cESyc
	 dRbPPVbeBREQIbweQ6rDPl2STRnnr8KDyIHMZBj7MjHSem7DsoxOtTkYKWJ+v8Z+2b9UJ
	 E4tA9U90AjxenRGQBeg8wTMdT//cX0t58zIR15r7z+iPKNHh1tJ8Tu1UXhKN0SxeRgDs+
	 eXs9r01Kpizcxbvtz4ykEobE7QQUletlUdOpj9+oamZPYVculZWq/uBu2zdfXiC495w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jIK36e9g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D061606A33A;
	Sat,  7 Nov 2026 14:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jIK36e9g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272EB1F0089F;
	Sat,  7 Nov 2026 14:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060922;
	bh=KB7Tr4InIJbQ9niXEKBl68M9RwHfau25/09eI/3w+Ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jIK36e9g/JYWCYhSuy0GiE1jSR2Ltk7dbUbixdPkEGBVnZnO3kH8bXR4InYcaAN7K
	 3jSSd8hlR3W2OVf6QRM1N/Hg1xf/cVX455y5L+ss8r3YAGsmpn8ywTdmGcJ8AuB4Vy
	 RqyHiL31qh/ouwUPgWU4w6QMwF+RMk55KwbnFl1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0288/1536] btrfs: fix memory barrier order in reloc_root_is_dead()
Date: Sat,  7 Nov 2026 08:38:24 -0500
Message-ID: <20261107135005.746540600@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 6f1c97695a6e230ee15c9e052e1933bdccfd5fa3 ]

When we set a root's reloc_root to NULL, we do it like this:

   static void clear_reloc_root(struct btrfs_root *root)
   {
       root->reloc_root = NULL;
       /*
        * Need barrier to ensure clear_bit() only happens after
        * root->reloc_root = NULL. Pairs with have_reloc_root().
        */
        smp_wmb();
        clear_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state);
   }

So that a NULL reloc_root is always seen before seeing that the bit
BTRFS_ROOT_DEAD_RELOC_TREE was cleared.

But on the read side we have:

   static bool reloc_root_is_dead(const struct btrfs_root *root)
   {
        smp_rmb();
        if (test_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state))
            return true;
        return false;
   }

And then callers of reloc_root_is_dead() access root->reloc_root.

Because the read memory barrier is placed before testing the bit, the CPU
is completely free to speculatively reorder those two loads. It can read
root->reloc_root before it actually checks the dead tree bit.

Sashiko reported this as an existing problem in another patch review, see
the link in the Link tag below.

Fix this by moving the read memory barrier to happen after testing the bit
and update the comment to reflect current reality.

Link: https://sashiko.dev/#/patchset/cf84f1a217c719e25b6b69e4298dd7afd36c9427.1781194426.git.fdmanana%40suse.com
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/relocation.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 785cb167b7b9d..7d0d3279231e2 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -234,14 +234,15 @@ static struct btrfs_backref_node *walk_down_backref(
 
 static bool reloc_root_is_dead(const struct btrfs_root *root)
 {
+	if (test_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state))
+		return true;
 	/*
-	 * Pair with set_bit/clear_bit in clean_dirty_subvols and
-	 * btrfs_update_reloc_root. We need to see the updated bit before
-	 * trying to access reloc_root
+	 * Pairs with set_bit/clear_bit in clear_reloc_root() and
+	 * btrfs_update_reloc_root(). We need to see the updated bit before
+	 * trying to access root->reloc_root in our callers.
 	 */
 	smp_rmb();
-	if (test_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state))
-		return true;
+
 	return false;
 }
 
-- 
2.53.0



