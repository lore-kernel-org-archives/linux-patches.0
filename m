Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E1C23315A;
	Tue, 26 Aug 2025 13:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213457; cv=none; b=JpF8jYXwke8rrj1beh4qbRcqgfv/E2whvq+lLgWGWjJXTUyAP2LlKwJzJLOvEjwk/Ohcg6eZZO/gsZKuwwA9PVdbMTeu4fBRmwW8UbT6UXWD1aYK40p2fTmyQY0AEGoCJd38nH7hrxJNvhTvHb3n3eMVWBJBw0bfCivx5xcPxXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213457; c=relaxed/simple;
	bh=T3stmt5J9kfkVW7FPSi/olDD5zFHMinDHTXHQ+TNrdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i87tZ8bL8aomAjj7UwHY8BAHshSDwdNOZ7reE0na+N+N0UW9j3/ltUu2bYRa5XHmwJrF7o5j7lKPFXpSGxP6xpsOFd6qsQ789pC4S+sGryLYs+tSMX60viZs2Ubzs9B7dxK71UW1VzECpOptqpOG4gtHJ8MgPzSPETa3K6TReJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oSovgYq8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oSovgYq8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCB6DC4CEF1;
	Tue, 26 Aug 2025 13:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213456;
	bh=T3stmt5J9kfkVW7FPSi/olDD5zFHMinDHTXHQ+TNrdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oSovgYq8CWjduiSiBxGTzZRGuJHdyfUyyXpbCQf17uh3+NpeVumpamtOyyIZhjFg+
	 FlOia4DJvQ2dQwur2eBEzX9nPuJwOYfN2ys8UrGWdm+7DF1xcoknSE8/3ooL/4Q6XC
	 GixtPP8Owckz7PooliBU0KInxI/d29CHExYqr2FQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 354/587] btrfs: zoned: fix write time activation failure for metadata block group
Date: Tue, 26 Aug 2025 13:08:23 +0200
Message-ID: <20250826111001.917493613@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naohiro Aota <naohiro.aota@wdc.com>

commit 5c4b93f4c8e5c53574c1a48d66a27a2c68b414af upstream.

Since commit 13bb483d32ab ("btrfs: zoned: activate metadata block group on
write time"), we activate a metadata block group at the write time. If the
zone capacity is small enough, we can allocate the entire region before the
first write. Then, we hit the btrfs_zoned_bg_is_full() in
btrfs_zone_activate() and the activation fails.

For a data block group, we activate it at the allocation time and we should
check the fullness condition in the caller side. Add, a WARN to check the
fullness condition.

For a metadata block group, we don't need the fullness check because we
activate it at the write time. Instead, activating it once it is written
should be invalid. Catch that with a WARN too.

Fixes: 13bb483d32ab ("btrfs: zoned: activate metadata block group on write time")
CC: stable@vger.kernel.org # 6.6+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/zoned.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1992,10 +1992,15 @@ bool btrfs_zone_activate(struct btrfs_bl
 		goto out_unlock;
 	}
 
-	/* No space left */
-	if (btrfs_zoned_bg_is_full(block_group)) {
-		ret = false;
-		goto out_unlock;
+	if (block_group->flags & BTRFS_BLOCK_GROUP_DATA) {
+		/* The caller should check if the block group is full. */
+		if (WARN_ON_ONCE(btrfs_zoned_bg_is_full(block_group))) {
+			ret = false;
+			goto out_unlock;
+		}
+	} else {
+		/* Since it is already written, it should have been active. */
+		WARN_ON_ONCE(block_group->meta_write_pointer != block_group->start);
 	}
 
 	for (i = 0; i < map->num_stripes; i++) {


