Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD62221F29;
	Mon,  2 Jun 2025 14:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875361; cv=none; b=Za75pCjaQkzeDJuRSvlUSAwIFjnRjDNVD717DjKeAePKgnzuN24MomXRvc2E7bTw8kxcx+Uj14o/49nNYiRaHqd8VHt32GSPGgU6qw8LwJUBUBwwnO8sAFaZb+WDY1SNcTf+bkHOSuvX2EPagISOg5HRzEY1QEUkPLlsEuNLKFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875361; c=relaxed/simple;
	bh=gam3nf8fhoKkyz8dEycfFVDMMf0JSGoGLg4nDdlOzVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V1UDQJc31XFhqMfh3PW5RjjqTH2xGVWEoHmuPLWVA7vGMuE7EczJ+qlNmrwsy8U2MELiZdg/uXuDGDqnyy88FWJ2m3SszG/gCQ7fH29cL19gNCp7Kb0L91JEZCrjMpBByNZsE+xcK6Pa2m30wSvBlcVgi5mPyx9iGXQffcuwMoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pvLVrjku; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pvLVrjku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 484E9C4CEEE;
	Mon,  2 Jun 2025 14:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875361;
	bh=gam3nf8fhoKkyz8dEycfFVDMMf0JSGoGLg4nDdlOzVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pvLVrjkuHMYunWK2mYLmneAEm4WVBbkSONCCgbi0rVGBDQm6HG6+NTCNVVGzwBIhY
	 8RIvYKeMLWcc74hO95kxh2JBKevmqA2Z6BIfGNLaWdviEC1SplMD0DfmpEguv8efhq
	 trmAqJpCQDRJeAip/0hu3gAk4si1umI6rO2haJpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Jianqi Ren <jianqi.ren.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 5.10 111/270] btrfs: dont BUG_ON() when 0 reference count at btrfs_lookup_extent_info()
Date: Mon,  2 Jun 2025 15:46:36 +0200
Message-ID: <20250602134311.771231334@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -174,6 +174,14 @@ search_again:
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
@@ -185,8 +193,6 @@ search_again:
 
 			goto out_free;
 		}
-
-		BUG_ON(num_refs == 0);
 	} else {
 		num_refs = 0;
 		extent_flags = 0;
@@ -216,10 +222,19 @@ search_again:
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


