Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909A569950;
	Tue, 14 May 2024 10:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683735; cv=none; b=Z6trJ3Op30XxFWU2v+7MojaCcTzAyPi16lL8h5pG91/vMqXVteK6Q6Zv2rrkhBe0ERG0sUyhkuXSdV6g5sbvHAAsDtVe7ZJsFaRWSAN94cE5J5m0cJmfnVhO0HjO4lozmAOj0n+iLqIrbAhTnpEZWvTBA8VDjEyUY0uRz8Hxe5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683735; c=relaxed/simple;
	bh=IdVy/4jvA3d27MkQD7iuUWfbXNtmbMTv5WnYAYvZe/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e/e6zQQl5sVWLn0nIlWp3bQO6O5pTTYRapQiKr5JnJmtbS2yjFWjl7SEfEkKFoudSneuATgrK2FFG0F4dZFSn+tGu3UU6GQPWA292krympWxiMNoFpl8usvBKKSN6af2BWkwmJUynOd+03XI3iM6W6NOWiKpx7dYB7ZJizB1Kqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1kRSlWHW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1kRSlWHW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F37FBC32781;
	Tue, 14 May 2024 10:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683735;
	bh=IdVy/4jvA3d27MkQD7iuUWfbXNtmbMTv5WnYAYvZe/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1kRSlWHWQcfCcxoW5j0bPXxZgc/lufQ31bRJfzl8maS805HZcliqTupEPhgOJI/jL
	 NrDQSFW31na3ZH1ocLW3M/WCqmt70WrBdQhlLvdbWYzCAcUhLRlPA2NBAhoaypnRk4
	 JEryrgRAuB0RJ4U5TR8i3B1MfJ8SXYy+qscwOxv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.8 264/336] btrfs: set correct ram_bytes when splitting ordered extent
Date: Tue, 14 May 2024 12:17:48 +0200
Message-ID: <20240514101048.580967325@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

From: Qu Wenruo <wqu@suse.com>

commit 63a6ce5a1a6261e4c70bad2b55c4e0de8da4762e upstream.

[BUG]
When running generic/287, the following file extent items can be
generated:

        item 16 key (258 EXTENT_DATA 2682880) itemoff 15305 itemsize 53
                generation 9 type 1 (regular)
                extent data disk byte 1378414592 nr 462848
                extent data offset 0 nr 462848 ram 2097152
                extent compression 0 (none)

Note that file extent item is not a compressed one, but its ram_bytes is
way larger than its disk_num_bytes.

According to btrfs on-disk scheme, ram_bytes should match disk_num_bytes
if it's not a compressed one.

[CAUSE]
Since commit b73a6fd1b1ef ("btrfs: split partial dio bios before
submit"), for partial dio writes, we would split the ordered extent.

However the function btrfs_split_ordered_extent() doesn't update the
ram_bytes even it has already shrunk the disk_num_bytes.

Originally the function btrfs_split_ordered_extent() is only introduced
for zoned devices in commit d22002fd37bd ("btrfs: zoned: split ordered
extent when bio is sent"), but later commit b73a6fd1b1ef ("btrfs: split
partial dio bios before submit") makes non-zoned btrfs affected.

Thankfully for un-compressed file extent, we do not really utilize the
ram_bytes member, thus it won't cause any real problem.

[FIX]
Also update btrfs_ordered_extent::ram_bytes inside
btrfs_split_ordered_extent().

Fixes: d22002fd37bd ("btrfs: zoned: split ordered extent when bio is sent")
CC: stable@vger.kernel.org # 5.15+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ordered-data.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -1189,6 +1189,7 @@ struct btrfs_ordered_extent *btrfs_split
 	ordered->disk_bytenr += len;
 	ordered->num_bytes -= len;
 	ordered->disk_num_bytes -= len;
+	ordered->ram_bytes -= len;
 
 	if (test_bit(BTRFS_ORDERED_IO_DONE, &ordered->flags)) {
 		ASSERT(ordered->bytes_left == 0);


