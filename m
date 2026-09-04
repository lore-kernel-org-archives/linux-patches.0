Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234263DAAC8;
	Fri,  4 Sep 2026 05:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499178; cv=none; b=ITRctj/PMO09s2/PCtFiun1qJXPkoyjlwI+DDM6/eZwps/k9XCYfR9AKpFM+uORdNisZsAaTNqNWHcelNDfyNQGHqG7AZW0ISBK3ynjXITBgiQkIJvO2P6UCmfnfuIR/iYWn7mjmrPdmJuJKHl8pFfs6lTWm302vCBTPeS9f4zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499178; c=relaxed/simple;
	bh=48djMVNErc1BFq97h3zG8eQeeQb9GqkNFoGTK+zGFAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j9535D+VkiUQLPoSkfxRq7koiRSAogln5htQR6aFjF6zIcY7ED/KlIUK7L8s2JaPegsrzJmLnb3O3qubDxOMF6lZVsqUbk8kX7T5jlGq2m9di2KGeA+dd244vWHxcMeFvF4gKJttBP4Q8MyDkHLPLTOxgPFrLtZFOiTPgSdeSLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X+RvFQ8t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X+RvFQ8t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F5CC1F00A3D;
	Fri,  4 Sep 2026 05:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499177;
	bh=yMvIlkGlshd+a/xR8FmUlQT2xmJKe+u9haS1zgND/o4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X+RvFQ8t5jP4gvvQ3tqj5CyrJBxojv8MK44Z0PGXQnH1a4fhWMc+hJ8qVkAuGeWyZ
	 ZwAPi67UtjrfhOIrOtL1X0WQ9Ms5gRqweZNVfADVQ7s85Hhg5oyfm54bpTONhMamiR
	 aLvhR+ZfclTQ4lxszDUuuHKeX6NlVDxkejDdlK5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	liyouhong <liyouhong@kylinos.cn>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.2 326/713] dm-era: fix shadowed superblock leak on take-snap failure
Date: Fri,  4 Sep 2026 06:54:54 +0200
Message-ID: <20260904045811.138162015@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: liyouhong <liyouhong@kylinos.cn>

commit 39c5aa3bd8ec3912d2cd0b3fe092642b0d2b0713 upstream.

metadata_take_snap() bumps the live superblock refcount and then
dm_tm_shadow_block() allocates a new block for the metadata snapshot.
If the subsequent dm_sm_inc_block() of writeset_tree_root or
era_array_root fails, the function only unlocks the clone and
returns.  The newly allocated shadow block is never returned to the
metadata space map, so each failed take-snap permanently leaks one
metadata block.

Free the clone with dm_sm_dec_block() on those error paths, matching
the final step of metadata_drop_snap().

Fixes: eec40579d848 ("dm: add era target")
Cc: stable@vger.kernel.org
Signed-off-by: liyouhong <liyouhong@kylinos.cn>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-era-target.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -1034,6 +1034,7 @@ static int metadata_checkpoint(struct er
 static int metadata_take_snap(struct era_metadata *md)
 {
 	int r, inc;
+	dm_block_t location;
 	struct dm_block *clone;
 
 	if (md->metadata_snap != SUPERBLOCK_LOCATION) {
@@ -1071,7 +1072,9 @@ static int metadata_take_snap(struct era
 	r = dm_sm_inc_block(md->sm, md->writeset_tree_root);
 	if (r) {
 		DMERR("%s: couldn't inc writeset tree root", __func__);
+		location = dm_block_location(clone);
 		dm_tm_unlock(md->tm, clone);
+		dm_sm_dec_block(md->sm, location);
 		return r;
 	}
 
@@ -1079,7 +1082,9 @@ static int metadata_take_snap(struct era
 	if (r) {
 		DMERR("%s: couldn't inc era tree root", __func__);
 		dm_sm_dec_block(md->sm, md->writeset_tree_root);
+		location = dm_block_location(clone);
 		dm_tm_unlock(md->tm, clone);
+		dm_sm_dec_block(md->sm, location);
 		return r;
 	}
 


