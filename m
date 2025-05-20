Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A541245012;
	Tue, 20 May 2025 13:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749285; cv=none; b=ckei8cjfeFPzno9uBA8FLrOtQchq/5VNIk7JUel0jvlLHn3xCoxEt7dYAmcbYewlT69uxL3MGScRl0Ondi+hBawOMcn13XCclZgiln2Ux5WqNbr8jMR1GehWyZ0J/pfV5BDp0ALTSI8JwIs9K5AF3W8iTJMIMXcHv5YaiCE+NmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749285; c=relaxed/simple;
	bh=Ck0fvk3Mk7DdRfg0uENpsowPo4kEG36ZfR96EilDYcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HMsUWNuJHb25PNr9mzpchtEcAGfp1gaCWruYrize4vXUnE0pnpAuYHOj8TGnvTJi6I5ybuWAigKrRJiu8VLP7ioVVzIKFcgD458Dy3AHb8WMqoRG34InPAlmh19R3PramUd8RScdjB+QQhPFNlgATSSIFGOtCS1ZcawJhrU07iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gs2Nmunl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gs2Nmunl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8313C4CEE9;
	Tue, 20 May 2025 13:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749285;
	bh=Ck0fvk3Mk7DdRfg0uENpsowPo4kEG36ZfR96EilDYcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gs2Nmunlb8SjRQ+GBNpiZlTSsP+QO0wCTWUQLW7ByKNJiYVslrb4aZTMFon87eKrt
	 Y7d8YCAeLYdlbGnAfwWDYvBoKVURzKmYs95NKEMBpdBEfLLhiX0F8u2Sm1YNW+u7yN
	 X6CskNM9wuGUHBOy/l/fP8HJ8bhi/klREEU5vIhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Jianqi Ren <jianqi.ren.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 5.15 54/59] btrfs: dont BUG_ON() when 0 reference count at btrfs_lookup_extent_info()
Date: Tue, 20 May 2025 15:50:45 +0200
Message-ID: <20250520125755.992719538@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125753.836407405@linuxfoundation.org>
References: <20250520125753.836407405@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

commit 28cb13f29faf6290597b24b728dc3100c019356f upstream.

Instead of doing a BUG_ON() handle the error by returning -EUCLEAN,
aborting the transaction and logging an error message.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[Minor conflict resolved due to code context change.]
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent-tree.c |   25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -176,6 +176,14 @@ search_again:
 			ei = btrfs_item_ptr(leaf, path->slots[0],
 					    struct btrfs_extent_item);
 			num_refs = btrfs_extent_refs(leaf, ei);
+			if (unlikely(num_refs == 0)) {
+				ret = -EUCLEAN;
+				btrfs_err(fs_info,
+			"unexpected zero reference count for extent item (%llu %u %llu)",
+					  key.objectid, key.type, key.offset);
+				btrfs_abort_transaction(trans, ret);
+				goto out_free;
+			}
 			extent_flags = btrfs_extent_flags(leaf, ei);
 		} else {
 			ret = -EINVAL;
@@ -187,8 +195,6 @@ search_again:
 
 			goto out_free;
 		}
-
-		BUG_ON(num_refs == 0);
 	} else {
 		num_refs = 0;
 		extent_flags = 0;
@@ -218,10 +224,19 @@ search_again:
 			goto search_again;
 		}
 		spin_lock(&head->lock);
-		if (head->extent_op && head->extent_op->update_flags)
+		if (head->extent_op && head->extent_op->update_flags) {
 			extent_flags |= head->extent_op->flags_to_set;
-		else
-			BUG_ON(num_refs == 0);
+		} else if (unlikely(num_refs == 0)) {
+			spin_unlock(&head->lock);
+			mutex_unlock(&head->mutex);
+			spin_unlock(&delayed_refs->lock);
+			ret = -EUCLEAN;
+			btrfs_err(fs_info,
+			  "unexpected zero reference count for extent %llu (%s)",
+				  bytenr, metadata ? "metadata" : "data");
+			btrfs_abort_transaction(trans, ret);
+			goto out_free;
+		}
 
 		num_refs += head->ref_mod;
 		spin_unlock(&head->lock);


