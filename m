Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01D420B3E;
	Tue, 23 Apr 2024 21:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908452; cv=none; b=am2Fk5mSo1oi6qDr+arlHqdpDfZuH4nkVCIlMHEZV6WGMfHHJwCWfkT9dXTHnxyfFJMqpOz+hMoxo9GmbPnHyVCBrrgxzsDKjPqn2BSF2aQufMvbtdVoXVYvBBC4Ex7GKngwAXh6htIl5gAfMm0Xy24weKCjdFhjR6GTUkO2Je0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908452; c=relaxed/simple;
	bh=MZ0ZAJOeqlH8IP+aT3pxC9J+B4ljNoixJhgDtKsVjX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YHP/aJWJJhkC46HIDvZ2L3wwQnAkWMbz+CPJ9N8TeC6RpExl1upPI2b6gvw32kdCsRHnRl/Hxp7kO6uyAcs/6EVkvt5PeTx+AaDtZ052mGS4RikLKvK7Gb2Tgfb00J59dKIaPa27kohlCpATJh6hVOO6qTFhZELWljro2imJAlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=trZ2WjDQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="trZ2WjDQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59371C3277B;
	Tue, 23 Apr 2024 21:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908452;
	bh=MZ0ZAJOeqlH8IP+aT3pxC9J+B4ljNoixJhgDtKsVjX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=trZ2WjDQKOTcVYzuuB+QdRPzxw/UPb9C2HzF7o7ejwvrtfi6BnYmwr7fGcWST2vby
	 AsAObDKZRvztceR9uLvK2yhkpxtiugai4Gqmlp+eaU7gyh4oRNF1al+4Jkyf6sGMZy
	 dkUyP1Ua0q0BuWlPQTSlusu7X5ldW4vOghK8cFVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.8 010/158] btrfs: zoned: do not flag ZEROOUT on non-dirty extent buffer
Date: Tue, 23 Apr 2024 14:37:12 -0700
Message-ID: <20240423213856.183046285@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naohiro Aota <naohiro.aota@wdc.com>

commit 68879386180c0efd5a11e800b0525a01068c9457 upstream.

Btrfs clears the content of an extent buffer marked as
EXTENT_BUFFER_ZONED_ZEROOUT before the bio submission. This mechanism is
introduced to prevent a write hole of an extent buffer, which is once
allocated, marked dirty, but turns out unnecessary and cleaned up within
one transaction operation.

Currently, btrfs_clear_buffer_dirty() marks the extent buffer as
EXTENT_BUFFER_ZONED_ZEROOUT, and skips the entry function. If this call
happens while the buffer is under IO (with the WRITEBACK flag set,
without the DIRTY flag), we can add the ZEROOUT flag and clear the
buffer's content just before a bio submission. As a result:

1) it can lead to adding faulty delayed reference item which leads to a
   FS corrupted (EUCLEAN) error, and

2) it writes out cleared tree node on disk

The former issue is previously discussed in [1]. The corruption happens
when it runs a delayed reference update. So, on-disk data is safe.

[1] https://lore.kernel.org/linux-btrfs/3f4f2a0ff1a6c818050434288925bdcf3cd719e5.1709124777.git.naohiro.aota@wdc.com/

The latter one can reach on-disk data. But, as that node is already
processed by btrfs_clear_buffer_dirty(), that will be invalidated in the
next transaction commit anyway. So, the chance of hitting the corruption
is relatively small.

Anyway, we should skip flagging ZEROOUT on a non-DIRTY extent buffer, to
keep the content under IO intact.

Fixes: aa6313e6ff2b ("btrfs: zoned: don't clear dirty flag of extent buffer")
CC: stable@vger.kernel.org # 6.8
Link: https://lore.kernel.org/linux-btrfs/oadvdekkturysgfgi4qzuemd57zudeasynswurjxw3ocdfsef6@sjyufeugh63f/
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4130,7 +4130,7 @@ void btrfs_clear_buffer_dirty(struct btr
 	 * The actual zeroout of the buffer will happen later in
 	 * btree_csum_one_bio.
 	 */
-	if (btrfs_is_zoned(fs_info)) {
+	if (btrfs_is_zoned(fs_info) && test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags)) {
 		set_bit(EXTENT_BUFFER_ZONED_ZEROOUT, &eb->bflags);
 		return;
 	}


