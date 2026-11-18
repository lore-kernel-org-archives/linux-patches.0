Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043436;
	b=RLwHAqzsnV94tOHakqUfpClIHxtwf1sgGh9mQ3dWnUV+J9NO+qCJyt3OuCxy09LmlSbY
	 FvpiDBgvUJhM8OjL13y2ox0alfey0RU4dim5b1kDcTvBrGnr2xHl5N4asKO/Bs0NZFnHW
	 MKa2Z4NHlpiKwDScgAm3yk8oFBolX7G+GMPT8K4EZnAzjRBXbyzlWfP8A3Nvkga0a5H2L
	 YsPK4Id2G9Iv+StwH0uddudfd1AwJ/96PX39j1U4F82aiz6Qq9/1cipYeaSQ7cy9AE+9U
	 fb81HTsh0T1gfU3rrdn6wXzPcr0pbrUjOgyxgAak7kVTbg9lIM4GdoV9jBueKkRtNGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043436;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2fukq3xVJk0mjOHFdxkEewMb2S7P5MSJrxsUKbGkh2I=;
	b=v0rjrIlrAZqx+uiPnHvtDOS6fBsZCjGOZPG2h6LQHJUs/+hOcjtYb5+2RY0yxManHFPf
	 lySo9B43f7qmSUCBn3gSBSJpCzqhzxlrA7qoTAVbyLtu1SKqbmwlct4IcCdmPVtGNGUOp
	 n2X4fDqY7jUaurpYQuYcEoGsW0R5eNGqKnu1z9sIkv17v2Ucqa8Eo8d3GTwlBNlWnQ/0I
	 23xkOEuE2U2JdDdj29wLF/ZRjcFapRy0cFhU0qKsnfszW0vfibzDkVMtSFdMaSJ19ixxp
	 GyxTyYfH4Ymg46eGX/z7uRapG2X8crtCNNADVYET0IoGV1MIqdbLFM6juwrEWfXIoFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eTKz5com;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B03860A2622;
	Wed, 18 Nov 2026 23:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eTKz5com
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC1391F000C5;
	Wed, 18 Nov 2026 23:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043436;
	bh=2fukq3xVJk0mjOHFdxkEewMb2S7P5MSJrxsUKbGkh2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eTKz5comzjivk3cd9AlHHSMFVIypfArbQSZRtwoRYcKBJLIXqh0n66sUQZ7+1YgMh
	 URATxmKSqe5PMmDQMTo1YqBRhgbO4uAnQjgSbI1Y/A5ezLmps6W9v0YIDojF/NhN5B
	 S23ThupFy3kupmYV4dCtqzsv9RGxeayW1A2yELyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0211/2857] btrfs: fix memory barrier order in reloc_root_is_dead()
Date: Wed, 18 Nov 2026 15:20:45 +0100
Message-ID: <20261118150208.963599346@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 6b81a41c4a532..faf9bacfde916 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -293,14 +293,15 @@ static int update_backref_cache(struct btrfs_trans_handle *trans,
 
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



