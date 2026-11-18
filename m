Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034090;
	b=ZT8VhkTaW71F966CVOxRRZgGRC8DxFNtfMosc4gP0xUvwAWbrAzRSmX+zcxhigE/Nt3T
	 1VKFEYxB0lQJXZFKtVMs43mIz97zCxyrW/FN7d9l9hxQldtON18QnYzGksmMra4QCil6E
	 yAgyeiWTxFd0tVKQDMp4+yazgELH3MOCizdyNid9ewbjVWTw4DzzIB4Z3nsWxTdfBf8yd
	 H1LK/XnSmxGFwacS8dOlifYdRyG5k14vKnV8NK7NnaEnNMCfuV9XRLKK1Z5cowGusdITl
	 GAXZi0EqrZFQD/UJENphR8mHtd9+Bk1NHsXE24EqIGG3ypa9h7pEffX+zb3tYqN4V5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034090;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3wIsyv9b5GI+dQLAXviTrNbtOvfV5A/NYfy9qw0doSA=;
	b=uEKu+BNE7T4EvJT11ZiSo2qKTHo7jlIu/hq2L1laggeo3KWk+X+pVyf56wS16bi1rM0K
	 4xkA4bSp67qU40EPQkJvDw3ByPKBfcXsYFjGfpxOVCk8ZwS+gGalicTKdgCiVpuUwC/qk
	 Wt/RgmcR3vzWwJUUu93yiDcYvoomcrdLFoPAyO/NsN7IaFyJ3vQTiwufv0FNHeLJJu3EE
	 SpXzfDimKBaU8u4OIO0dckpwEmWMHpdyqe3xfJRAJ2lLuZcMut3+ZBVnu9pn6gu4wd6m3
	 fkKmm3hU3Ah18xH8VO0PFbbAeSVAfGUWpqlga9L9Q/F56YVHNEuxomY88JJ2e/7yMVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l8Oj1ctU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA295606A320;
	Wed, 18 Nov 2026 20:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l8Oj1ctU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E573B1F000C4;
	Wed, 18 Nov 2026 20:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034090;
	bh=3wIsyv9b5GI+dQLAXviTrNbtOvfV5A/NYfy9qw0doSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l8Oj1ctU5JWYSWefQGZDLXgv2mkH2h3RX1J7/D2sf7cDJYj9xv+s3LOYoSiNowzh7
	 Re/LCE7GKa81rCuhYj/MhPJQAIu3WJNDisUY193Cbr5rf5g29f/6xWw92CB7T2OYWJ
	 TFreXRf9Z5V9vdkaLGuwmcmh5Q7JKZHyG1d/cK3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0244/3318] btrfs: fix memory barrier order in reloc_root_is_dead()
Date: Wed, 18 Nov 2026 15:14:26 +0100
Message-ID: <20261118150322.474031271@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d5efca405085c..cf0c77f0e31fa 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -237,14 +237,15 @@ static struct btrfs_backref_node *walk_down_backref(
 
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



