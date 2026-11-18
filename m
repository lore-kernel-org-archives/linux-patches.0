Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057514;
	b=obcayn+f8DghsAq39TgmsL/tI5ZjzeXOOxz/Jdil8aar+RfVpIVtW9wERAoqeLUjjNzZ
	 QOAPfFK4NYoaTLdzJbhQXS0c/C0rNLqME63SA0zKdF33w7Y0pUxVKg/dcG14/Nyh1Rnq0
	 39XTAKeki/yKxn7jWDWXSJM0k5kRM0j2fIS1YNcDmWl9FwKjYJqUlBdSW9kF30/H1M7kO
	 rfcMseY3aUF/1/1hWUo39A8nJQvO9ClAKwgULDkYoODt/hgKRdCqHaxiyhn9XRWdH4Hi+
	 PIISmzQiWTzMJrw+IBMRtKAeFcYCrGT7/FKTB3E6bZfcGEhgnRLtE/0Lq6edov8mBPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057514;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F/2/JMltiNPHM+wFawX1GvVCH7I7coSLSrY6tQybaQY=;
	b=z2vYTKEz2WIXfsHvJTvkCojqAAN8/0hhmV25nG76vyQq80W1kmivGCTIw63939BaGBAn
	 uLEq/GUuoZuZt7+Z6K3BSxQhLYFa8PvnqYRCtC3dZE+RjkWvnU9+pYFt5W+ZsyBQzWv+2
	 bsczeQ/IzmX1s6YpDQ2lglqI3Vgvbnwygy0B5jlDEQ2IJaX5AccrNbhAuVURm85NIZm+S
	 jdV1A7b4Cj/mPEZNOvvyfX8JZb2krdI1r1rs9JRfgbRihvLacEms5qJL/WxMZl/PqV3lR
	 1cssuNml5tP5Q/nJe2sbwPplPH842/1e/Egq4s6irT3pfifiUSLdmViz7JUcchc80wA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g1jIX6Y0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACC3606A335;
	Thu, 19 Nov 2026 03:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g1jIX6Y0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F5F21F000C5;
	Thu, 19 Nov 2026 03:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057514;
	bh=F/2/JMltiNPHM+wFawX1GvVCH7I7coSLSrY6tQybaQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g1jIX6Y0NF5WXjYMnax00EJmpjvsCKEf/9Siw077IJdXce2F4VWDZuH8YLNtl5ZJ5
	 VUyk4/t0ZPE/KFVOoUyHQ2Bm85zUwrqUz65SPSr2QTa3QY6zhT23KlODcDfQZnofoj
	 geYdiwv8YMkmmoSjQo/JnPRdUYmskyc17+503NmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0157/1848] btrfs: fix memory barrier order in reloc_root_is_dead()
Date: Wed, 18 Nov 2026 15:36:35 +0100
Message-ID: <20261118145917.996709524@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 34be7160cc9ce..5bae3e9a32e6e 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -289,14 +289,15 @@ static int update_backref_cache(struct btrfs_trans_handle *trans,
 
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



