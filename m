Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830889;
	b=v9uzj6B9pUFx1POHiehkPF8pZctxS0+Ppszg8IzwjFwXjaqTG9sAVUlmH6BpAT5ZNXgW
	 Tp0cvjJNRn3jpe09kX06CVlm/Xy/VoVc3IUO5Avyx4W9dVrvxdMhIRuKqS390BFI6kbCB
	 f87VYJ7yCyQZA5SDRM+ESq2mgyXaY7NLSRG1qsTJSWFqR/5z18wR58j8cvkJt5wL8EXsb
	 MRbXfgoLVd0OXSi5Ab/qEf7r8ENyzTPhokwF8YIPjduzzFOfwmkrP29mBhmlFH3Sr40B8
	 xizrgNLtP0tDj6eellHFT13iIzEWoE61XBR8JNLlW5J1IBsrUPJ1OGTQTT1Y+TRIhiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830889;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vSwb9PUwk9qnGMKa5uTP+bPmJunDj5n5CyockVUb6MA=;
	b=orKgOo98N6AMSmO/U3m2ekJfIwO7wYKL7UgazevlZGGC4v4eGIUW8XluW1DddZVJreRL
	 y8ATlEu6cTwcYEJF4hmYKGCME4TxGOAwk2kiNeyvyZGh9dqnIggk5bvRZAt5nAQ0qTdVy
	 NocANjGtxxaCxLyytLnprSu8a6LzYT5VTlBcooKx5A4bC8S67qT3QkPegKMLjyjkYiqBT
	 uS0eUqzrUq3UgaVpirlorgDnfC3dumdY8nj00qaqwM9OE44hBHkyFn3yKiVqUVS/AvbXC
	 kUeKyEVc+HdhIBh1RojCyYK0uX3/QKS0yzmGB3h1F385RT/hh19aLgNThHIc1ZK3jXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OHfwBY6K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13737606A33F;
	Wed,  4 Nov 2026 22:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OHfwBY6K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 758071F000C1;
	Wed,  4 Nov 2026 22:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830888;
	bh=vSwb9PUwk9qnGMKa5uTP+bPmJunDj5n5CyockVUb6MA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OHfwBY6KoIE9qi2uAPfhUKIX8En6uEIN3ndvcpj738XH1iOnzbrm0E7Ai+4X5ebFH
	 vGvR7yLIn58vmqGI9vIeqMJVVaEreICitCIV0KjEQrF8KM1rULAH+sGguAcx5jCpD7
	 LWc1HJe4UePKxpXtoZddQ2vfaiim5xXjedRjzwI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0350/1005] btrfs: fix memory barrier order in reloc_root_is_dead()
Date: Wed,  4 Nov 2026 16:01:23 -0500
Message-ID: <20261104211053.785280232@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index eab9686b1bcdf..fcb0ab937de5c 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -245,14 +245,15 @@ static struct btrfs_backref_node *walk_down_backref(
 
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



