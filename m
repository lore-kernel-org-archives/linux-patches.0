Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E3986332;
	Mon,  6 Jan 2025 15:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179097; cv=none; b=MRaB+1bY7eHZusVDOIyUfoZVZwosMsyAaxWdMPq8L0PCe6+SpVp2KTaWum3P0SNWOhXvFbVjdYImCrmcbZZ9XaFmyOOQD9BUt6wu9YpBhOh8CCe2o8vIxBkLioC8XmVErqnUxv7Hh+XG6cGBi5AuAk0iAxQWKZZ18dPLfLeb1Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179097; c=relaxed/simple;
	bh=5goWiEKjOpymaK/LuXNhRo46El5EYrj7INzxYnn7/kI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fG//KCgUB0s7Ny7q665NXJGFM1An887o0qP45kk1mwYkr9AAJU/fnwqIUYIqeZ70vVgL4fVVgo6uoApd4KdCtHf+Qgo5ja7/BHNdP4WPWJursoYV6oul08w0zEOoMqLeUaCT71ZKR83i9Edz6TEBM8PcwmoxKtbV5UX/y71s68E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d8FIHdEf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d8FIHdEf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAA33C4CED2;
	Mon,  6 Jan 2025 15:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179096;
	bh=5goWiEKjOpymaK/LuXNhRo46El5EYrj7INzxYnn7/kI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d8FIHdEfMR2qgyhzo35WKnXrcDfbp/lIosS7VbC0Y710zCuau2WZfeJVq7v/3p45j
	 iA9LYMp08rIh2IbjcA08oar2KbZxi+20zxOalV5HgnJi/4esJe7Ma3Dmfq87ebxWsi
	 0JkD/hyTRRYw5v0vfzjADEjPNP5JEksqE7r+bgEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frankie Fisher <frankie@terrorise.me.uk>,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 26/93] btrfs: tree-checker: reject inline extent items with 0 ref count
Date: Mon,  6 Jan 2025 16:17:02 +0100
Message-ID: <20250106151129.691640811@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

commit dfb92681a19e1d5172420baa242806414b3eff6f upstream.

[BUG]
There is a bug report in the mailing list where btrfs_run_delayed_refs()
failed to drop the ref count for logical 25870311358464 num_bytes
2113536.

The involved leaf dump looks like this:

  item 166 key (25870311358464 168 2113536) itemoff 10091 itemsize 50
    extent refs 1 gen 84178 flags 1
    ref#0: shared data backref parent 32399126528000 count 0 <<<
    ref#1: shared data backref parent 31808973717504 count 1

Notice the count number is 0.

[CAUSE]
There is no concrete evidence yet, but considering 0 -> 1 is also a
single bit flipped, it's possible that hardware memory bitflip is
involved, causing the on-disk extent tree to be corrupted.

[FIX]
To prevent us reading such corrupted extent item, or writing such
damaged extent item back to disk, enhance the handling of
BTRFS_EXTENT_DATA_REF_KEY and BTRFS_SHARED_DATA_REF_KEY keys for both
inlined and key items, to detect such 0 ref count and reject them.

CC: stable@vger.kernel.org # 5.4+
Link: https://lore.kernel.org/linux-btrfs/7c69dd49-c346-4806-86e7-e6f863a66f48@app.fastmail.com/
Reported-by: Frankie Fisher <frankie@terrorise.me.uk>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-checker.c |   27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1197,6 +1197,11 @@ static int check_extent_item(struct exte
 					   dref_offset, fs_info->sectorsize);
 				return -EUCLEAN;
 			}
+			if (unlikely(btrfs_extent_data_ref_count(leaf, dref) == 0)) {
+				extent_err(leaf, slot,
+			"invalid data ref count, should have non-zero value");
+				return -EUCLEAN;
+			}
 			inline_refs += btrfs_extent_data_ref_count(leaf, dref);
 			break;
 		/* Contains parent bytenr and ref count */
@@ -1208,6 +1213,11 @@ static int check_extent_item(struct exte
 					   inline_offset, fs_info->sectorsize);
 				return -EUCLEAN;
 			}
+			if (unlikely(btrfs_shared_data_ref_count(leaf, sref) == 0)) {
+				extent_err(leaf, slot,
+			"invalid shared data ref count, should have non-zero value");
+				return -EUCLEAN;
+			}
 			inline_refs += btrfs_shared_data_ref_count(leaf, sref);
 			break;
 		default:
@@ -1259,8 +1269,18 @@ static int check_simple_keyed_refs(struc
 {
 	u32 expect_item_size = 0;
 
-	if (key->type == BTRFS_SHARED_DATA_REF_KEY)
+	if (key->type == BTRFS_SHARED_DATA_REF_KEY) {
+		struct btrfs_shared_data_ref *sref;
+
+		sref = btrfs_item_ptr(leaf, slot, struct btrfs_shared_data_ref);
+		if (unlikely(btrfs_shared_data_ref_count(leaf, sref) == 0)) {
+			extent_err(leaf, slot,
+		"invalid shared data backref count, should have non-zero value");
+			return -EUCLEAN;
+		}
+
 		expect_item_size = sizeof(struct btrfs_shared_data_ref);
+	}
 
 	if (btrfs_item_size_nr(leaf, slot) != expect_item_size) {
 		generic_err(leaf, slot,
@@ -1320,6 +1340,11 @@ static int check_extent_data_ref(struct
 				   offset, leaf->fs_info->sectorsize);
 			return -EUCLEAN;
 		}
+		if (unlikely(btrfs_extent_data_ref_count(leaf, dref) == 0)) {
+			extent_err(leaf, slot,
+	"invalid extent data backref count, should have non-zero value");
+			return -EUCLEAN;
+		}
 	}
 	return 0;
 }


