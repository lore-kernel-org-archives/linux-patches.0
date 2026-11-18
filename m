Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051372;
	b=FEIQV2phtjeFt9xNl8qJXeh2r08U/b9KsjM3h+nkLNsAvOYLr3A8F/nQzYNV+nT3S/3l
	 b0Vt0YXKcecDAzvPJ6IvAIO7c11YnVGTCqDvjBkGjxgAxD/c/eIHh8OoLccYsDgnbzfhZ
	 tVh4DGMkHWG+LRSp8ycwqtOy2CeG+YZLPI/RpBsCH636+jf2oWhrVLrh3ZBLACs2xFooc
	 eusY9vWKMpvDvvw8/Kve3yuwfkmZmIYrbWdH1hc1rxClPo/RJEMl34bWf1G5Rgv0I6dZB
	 Cjv6ueXe1wDfZittOsrSSdDPN9Z8QhU6j8qjMoMJcXImq5fcHOK5JF+Htnq2zvG5vfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051372;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f/kHypn4O0xT8S41KRdV9JPqdCA9RPzoemYrRSYyB8k=;
	b=dk077HWvPJ085Za7tA+Ny5iuiE8pU3bjzfasnkrs0Znh5F34YyjYv0Lw126GOP9SVY2K
	 4jnVb1VwiE9U9MR/R0jhmzkhkMz+2GOpCobQsepIMLwIi6e2CLvb8b0N7QBNxtv+eNGcn
	 TkQPotwGXILfgEx5jVC7+kFocrq5+83cYj8kR67qCXPdUEHuYAX9ycJSes9iAjNnVn6nZ
	 pmBOi9JW9Uz4GYgmnWnrV3muo4Tx4lFtBBUHdAQdmxrG4LZxn/yCWLKGK+deHW4XO5dV6
	 6oAL1WwTiv+CBAAzd8U1ZqVF0XVfywOO/tzOwK2DbRsHiK60ypWqas2Z2z7y4esEFaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ifzU5obs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D91606A32A;
	Thu, 19 Nov 2026 01:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ifzU5obs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A799D1F000C4;
	Thu, 19 Nov 2026 01:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051372;
	bh=f/kHypn4O0xT8S41KRdV9JPqdCA9RPzoemYrRSYyB8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ifzU5obsLwdzRDrRmHiC7pZZ+Zv4Q7qZvoak43bEVJS5qRTldSIJDbJvK2r9DjIpk
	 e/qamB2ZV75esLMyXaqbkWQV4OCddaP3qdjO3mcHvBKAxiyvnFWDBX00awOfjA0s5o
	 9BqPbPhwQ31wtQGTXnzl1jyyNpmiuMDevdqyUVhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0186/2214] btrfs: fix memory barrier order in reloc_root_is_dead()
Date: Wed, 18 Nov 2026 15:31:02 +0100
Message-ID: <20261118150017.461589004@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a95cab1433613..2eada18cbf2f7 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -290,14 +290,15 @@ static int update_backref_cache(struct btrfs_trans_handle *trans,
 
 static bool reloc_root_is_dead(struct btrfs_root *root)
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



