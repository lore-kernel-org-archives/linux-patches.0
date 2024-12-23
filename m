Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6052019E98B;
	Mon, 23 Dec 2024 16:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970454; cv=none; b=iScyQiRYPgeixDGhGb2vSC3Sg9V3aqWJUMdjWhQy1u11yVk17CjvDwCf33RTBaWn5Rtr7kafaERLvvN46V1Wyn7NTfy++6+jJgQKcqp5vndrRuXsrdVzdTSrbD1GjM+NlZpMOurf/gmIF5SVOWT2A8eYixknU/vsKpFeYYS1oJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970454; c=relaxed/simple;
	bh=Jlc0m7H3kwhidzTP2//NXQXu3OMXePg8k1giyMXMqes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DVPsMMcNAkiVfRnObwJtORTrsgEgGuuNLMz+6PdwggxUqfIQB+3w3MztZb9nQOBnzrzRjP5lk7hPEh3j21veFbaDn+/fsJT2/91hpukSAUof4VZ8+nq4Kgw81g+kdoZZfiAW77WITjxs1n41CKzWysp9z3HPhYwMCTTKwEfZvQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FXRZNGCP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FXRZNGCP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4661C4CED3;
	Mon, 23 Dec 2024 16:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970454;
	bh=Jlc0m7H3kwhidzTP2//NXQXu3OMXePg8k1giyMXMqes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FXRZNGCPwvDSlg/q8U++L89beFjEWBv/13WMPp+RwauPHyl4cERlL+cKRuukI6uTM
	 TEVBM6Z3amNt2UTT6sW/kYizbT0NwqR6paE1q3EWPvGSb8QzY3V8jiTITknr4isbDa
	 VXziLt5fg01SHZ0QgbrC7oFmIxPbA4AGo8P8Rcik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frankie Fisher <frankie@terrorise.me.uk>,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 088/116] btrfs: tree-checker: reject inline extent items with 0 ref count
Date: Mon, 23 Dec 2024 16:59:18 +0100
Message-ID: <20241223155402.983205079@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1503,6 +1503,11 @@ static int check_extent_item(struct exte
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
@@ -1515,6 +1520,11 @@ static int check_extent_item(struct exte
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
@@ -1584,8 +1594,18 @@ static int check_simple_keyed_refs(struc
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
 
 	if (unlikely(btrfs_item_size(leaf, slot) != expect_item_size)) {
 		generic_err(leaf, slot,
@@ -1662,6 +1682,11 @@ static int check_extent_data_ref(struct
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


