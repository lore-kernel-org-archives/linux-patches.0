Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2173E325726;
	Sat, 12 Sep 2026 17:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232821; cv=none; b=RRbhdwEcX0x2HmzAQdaq7M670l6ptDhCOSY+OVcnrmkT4EwlbiW2giy2eG8OI8y2I0kTJFKOS7Qh7NTRFTX6Dbtj4SYcdyMpJxWzGbfDRMWXZnHIUM1ykof2XN3GCzfB89kToVYXpTGIBdho2hFdLgTBWGTp1xYak9kQEwLyBek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232821; c=relaxed/simple;
	bh=wGBm09uRhEqgsBNUudf7SGPH9HCkBT41qks8XTNRkx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dLcaMYavtj7eA7YVhxaVeMNlmIudscwd9eBaWddvV4/DT5Jy0vtv12PFKtVgp/FrncvEe1QEXdUPKfKMZPuUx/DZIYNSIJqhABweJ25zvZvUO9m0Mp3w1VZmuLzp5LtrIuhYG61LP7CgLMWY9cyg5ykqQy1R6PjiHnzhOydgJIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lKDmcZym; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lKDmcZym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D39C51F000FF;
	Sat, 12 Sep 2026 17:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232820;
	bh=ki9dBE+S+3ZkpdedhxlnBXhr6ZlWCULE8d6S6wYaU3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lKDmcZymKVIKOYERjbNfNzIcFwQiJsi0g485Zu1ZB3QnU9aj+ohu8W1ifYx+sLvrH
	 tbKsQ7NNS/MXVDu5/qkXkeGC/BnJ0WJ+WKGO1j1RMOHEWv9YPNaSjW6WZNcDLb+GbZ
	 oyfdDxlryfXpp6qVrs0FQo+vjIfCCa+rQV0Ks6vs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	liyouhong <liyouhong@kylinos.cn>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.15 089/935] dm-era: fix shadowed superblock leak on take-snap failure
Date: Sat, 12 Sep 2026 08:51:59 +0200
Message-ID: <20260912065528.867082785@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1019,6 +1019,7 @@ static int metadata_checkpoint(struct er
 static int metadata_take_snap(struct era_metadata *md)
 {
 	int r, inc;
+	dm_block_t location;
 	struct dm_block *clone;
 
 	if (md->metadata_snap != SUPERBLOCK_LOCATION) {
@@ -1056,7 +1057,9 @@ static int metadata_take_snap(struct era
 	r = dm_sm_inc_block(md->sm, md->writeset_tree_root);
 	if (r) {
 		DMERR("%s: couldn't inc writeset tree root", __func__);
+		location = dm_block_location(clone);
 		dm_tm_unlock(md->tm, clone);
+		dm_sm_dec_block(md->sm, location);
 		return r;
 	}
 
@@ -1064,7 +1067,9 @@ static int metadata_take_snap(struct era
 	if (r) {
 		DMERR("%s: couldn't inc era tree root", __func__);
 		dm_sm_dec_block(md->sm, md->writeset_tree_root);
+		location = dm_block_location(clone);
 		dm_tm_unlock(md->tm, clone);
+		dm_sm_dec_block(md->sm, location);
 		return r;
 	}
 


