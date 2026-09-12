Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B746931F9B1;
	Sat, 12 Sep 2026 19:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241160; cv=none; b=If254Jr5y65os/epWAq3d7iH28KbnpwYpuDQh8hh2cqbDrmUsevBmrPXDVgwqmT7IWQcpauEpRcsWx2NJyozPdpKK+7LhcK1PWDoijEwdZnsqoj7ylZZ8/SYlY5veg2lv0bdupKGsbUw7GpJ1Qfljucvfbk5F3evV4jqIyK/wA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241160; c=relaxed/simple;
	bh=Mv9/yPqlQaRCHS7vRcVcfTlH6077/bgjKCtSVold4UI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=txOYeRGtjSrT9qtCuV/ujmihfdIoVZOZse3BSs/0uZepBExKMeMHKbrXVEbQKTEUQG7g5iZSvfxxw7nkIaKLKXCzoyYS3Yw5fnlBPaV7SaYSh9f7y580hVQ/qIE1Wav8hQ0tC2alnHA7Z/wqGcPYSyoEIdbLrOnA8ft9szK3Dic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lKbykD6p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lKbykD6p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A1751F000FF;
	Sat, 12 Sep 2026 19:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241159;
	bh=V2t13yHZdNIgtwSMR8ihk97CPBQxwLykE5lZz/88EIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lKbykD6pPCbmRzD4+Iyq+lneOX1PDoQV4NYAaKwAOEh/006eQWbQ+taBdV/tIac27
	 8kC20mCcGUx7BFhWnZKF0tnEw0R+DH1xz4enQytI9nEztPKmdVcqXWD7O/vVhqsJf9
	 UOu0nGXctlfuDYYLAQkbx8qyeL6aoCISjWdtNnb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	liyouhong <liyouhong@kylinos.cn>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.10 079/798] dm-era: fix shadowed superblock leak on take-snap failure
Date: Sat, 12 Sep 2026 08:55:07 +0200
Message-ID: <20260912065518.774980692@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1015,6 +1015,7 @@ static int metadata_checkpoint(struct er
 static int metadata_take_snap(struct era_metadata *md)
 {
 	int r, inc;
+	dm_block_t location;
 	struct dm_block *clone;
 
 	if (md->metadata_snap != SUPERBLOCK_LOCATION) {
@@ -1052,7 +1053,9 @@ static int metadata_take_snap(struct era
 	r = dm_sm_inc_block(md->sm, md->writeset_tree_root);
 	if (r) {
 		DMERR("%s: couldn't inc writeset tree root", __func__);
+		location = dm_block_location(clone);
 		dm_tm_unlock(md->tm, clone);
+		dm_sm_dec_block(md->sm, location);
 		return r;
 	}
 
@@ -1060,7 +1063,9 @@ static int metadata_take_snap(struct era
 	if (r) {
 		DMERR("%s: couldn't inc era tree root", __func__);
 		dm_sm_dec_block(md->sm, md->writeset_tree_root);
+		location = dm_block_location(clone);
 		dm_tm_unlock(md->tm, clone);
+		dm_sm_dec_block(md->sm, location);
 		return r;
 	}
 


